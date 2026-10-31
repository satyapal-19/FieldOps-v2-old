import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { SequenceIdGenerator } from '../../shared/ids/id-generator';
import { AadhaarFaceVerifier, type AadhaarSettings } from './aadhaar/aadhaar-face.verifier';
import { AadhaarIdentityResolver, AsaClient, AuthXmlSigner } from './aadhaar/aadhaar-gateways';
import type { Embedding } from './face.policy';
import { FaceAnalysis, FaceEngine, FaceTemplateStore, LocalFaceVerifier } from './local/local-face.verifier';

class FakeEngine extends FaceEngine {
  constructor(public next: FaceAnalysis) {
    super();
  }
  async analyse(): Promise<FaceAnalysis> {
    return this.next;
  }
}

class FakeTemplates extends FaceTemplateStore {
  constructor(private readonly byStaff: Record<string, Embedding[]>) {
    super();
  }
  async embeddingsFor(staffId: string): Promise<Embedding[]> {
    return this.byStaff[staffId] ?? [];
  }
}

const image = { kind: 'image' as const, staffId: 'ramesh', image: Buffer.from('jpeg'), challengeId: 'c1' };

describe('LocalFaceVerifier', () => {
  const templates = new FakeTemplates({ ramesh: [[1, 0, 0]] });
  const settings = { matchThreshold: 0.6, livenessThreshold: 0.5 };

  it('matches a live face against the enrolled embeddings', async () => {
    const engine = new FakeEngine({ faceCount: 1, livenessScore: 0.9, embedding: [0.95, 0.1, 0] });
    const result = await new LocalFaceVerifier(engine, templates, settings).verify(image);
    expect(result).toMatchObject({ provider: 'local', matched: true, threshold: 0.6 });
  });

  it('rejects a different person', async () => {
    const engine = new FakeEngine({ faceCount: 1, livenessScore: 0.9, embedding: [0, 1, 0] });
    const result = await new LocalFaceVerifier(engine, templates, settings).verify(image);
    expect(result).toMatchObject({ matched: false, reasonCode: 'FACE_MISMATCH' });
  });

  it.each([
    [{ faceCount: 0, livenessScore: 0.9, embedding: [] }, 'NO_FACE'],
    [{ faceCount: 2, livenessScore: 0.9, embedding: [] }, 'MULTIPLE_FACES'],
    [{ faceCount: 1, livenessScore: 0.2, embedding: [1, 0, 0] }, 'SPOOF_SUSPECTED'],
  ])('rejects bad captures (%j -> %s)', async (analysis, reason) => {
    const result = await new LocalFaceVerifier(new FakeEngine(analysis), templates, settings).verify(image);
    expect(result).toMatchObject({ matched: false, reasonCode: reason });
  });

  it('requires enrolment', async () => {
    const engine = new FakeEngine({ faceCount: 1, livenessScore: 0.9, embedding: [1, 0, 0] });
    const verifier = new LocalFaceVerifier(engine, templates, settings);
    await expect(verifier.verify({ ...image, staffId: 'nobody' })).rejects.toMatchObject({
      code: ErrorCode.FACE_NOT_ENROLLED,
    });
  });

  it('tells the app to run ML Kit liveness', async () => {
    const engine = new FakeEngine({ faceCount: 1, livenessScore: 1, embedding: [1] });
    expect(await new LocalFaceVerifier(engine, templates, settings).captureOptions()).toEqual({
      provider: 'local',
      instructions: 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP',
    });
  });
});

class FakeResolver extends AadhaarIdentityResolver {
  async resolve(staffId: string): Promise<string | null> {
    return staffId === 'ramesh' ? 'UIDTOKEN-RAMESH' : null;
  }
}

class FakeSigner extends AuthXmlSigner {
  sign(xml: string): string {
    return xml.replace('</Auth>', '<Signature/></Auth>');
  }
}

class FakeAsa extends AsaClient {
  sent: { url: string; body: string }[] = [];
  constructor(private readonly reply: string) {
    super();
  }
  async send(url: string, body: string): Promise<string> {
    this.sent.push({ url, body });
    return this.reply;
  }
}

const settings: AadhaarSettings = {
  env: 'PP',
  apiVersion: '2.5',
  pidVersion: '2.0',
  auaCode: 'SMKC',
  subAuaCode: 'SMKC',
  licenseKey: 'LK',
  asaLicenseKey: 'ASALK',
  asaUrlTemplate: 'https://asa.example/{ver}/{ac}/{uid0}/{uid1}/{asalk}',
  language: 'mr',
};

const pidData = (errCode = '0', txn = 'id-0001') =>
  `<PidData><Resp errCode="${errCode}"/><DeviceInfo rdsId="FACE.RD" rdsVer="1" dpId="UIDAI.UIDAI" dc="dc" mi="FACE" mc="mc"/>` +
  `<Skey ci="2025">SK</Skey><Hmac>HM</Hmac><Data type="X">DATA</Data>` +
  `<CustOpts><Param name="txn" value="${txn}"/></CustOpts></PidData>`;

describe('AadhaarFaceVerifier', () => {
  function make(reply = '<AuthRes ret="y" code="RC1" txn="id-0001"/>') {
    const asa = new FakeAsa(reply);
    const verifier = new AadhaarFaceVerifier(
      settings,
      new FakeResolver(),
      new FakeSigner(),
      asa,
      new SequenceIdGenerator('id'),
    );
    return { asa, verifier };
  }

  it('issues FaceRD capture options with a fresh txn', async () => {
    const { verifier } = make();
    const options = await verifier.captureOptions();
    expect(options).toMatchObject({
      provider: 'aadhaar',
      instructions: 'LAUNCH_FACERD',
      txn: 'id-0001',
      intentAction: 'in.gov.uidai.rdservice.face.CAPTURE',
    });
    expect(options.provider === 'aadhaar' && options.pidOptionsXml).toContain('value="id-0001"');
  });

  it('sends a signed Auth request through the ASA and accepts ret="y"', async () => {
    const { asa, verifier } = make();
    const result = await verifier.verify({ kind: 'aadhaar-pid', staffId: 'ramesh', pidDataXml: pidData(), txn: 'id-0001' });
    expect(result).toMatchObject({ provider: 'aadhaar', matched: true, reference: 'RC1' });
    expect(result.auditPayload).toContain('AuthRes');
    expect(asa.sent[0].url).toBe('https://asa.example/2.5/SMKC/0/0/ASALK');
    expect(asa.sent[0].body).toContain('uid="UIDTOKEN-RAMESH"');
    expect(asa.sent[0].body).toContain('<Signature/>');
  });

  it('reports a UIDAI mismatch as not matched', async () => {
    const { verifier } = make('<AuthRes ret="n" err="300" code="RC2" txn="id-0001"/>');
    const result = await verifier.verify({ kind: 'aadhaar-pid', staffId: 'ramesh', pidDataXml: pidData(), txn: 'id-0001' });
    expect(result).toMatchObject({ matched: false, reasonCode: 'UIDAI_300' });
  });

  it('reports a FaceRD capture error without calling UIDAI', async () => {
    const { asa, verifier } = make();
    const result = await verifier.verify({
      kind: 'aadhaar-pid',
      staffId: 'ramesh',
      pidDataXml: pidData('730'),
      txn: 'id-0001',
    });
    expect(result).toMatchObject({ matched: false, reasonCode: 'FACERD_730' });
    expect(asa.sent).toHaveLength(0);
  });

  it('refuses a capture from another transaction', async () => {
    const { verifier } = make();
    await expect(
      verifier.verify({ kind: 'aadhaar-pid', staffId: 'ramesh', pidDataXml: pidData('0', 'other'), txn: 'id-0001' }),
    ).rejects.toMatchObject({ code: ErrorCode.AADHAAR_CAPTURE_FAILED });
  });

  it('requires an Aadhaar link for the staff member', async () => {
    const { verifier } = make();
    await expect(
      verifier.verify({ kind: 'aadhaar-pid', staffId: 'unlinked', pidDataXml: pidData(), txn: 'id-0001' }),
    ).rejects.toBeInstanceOf(AppError);
  });

  it('rejects a face image (wrong input for this provider)', async () => {
    const { verifier } = make();
    await expect(verifier.verify(image)).rejects.toMatchObject({ code: ErrorCode.VALIDATION_FAILED });
  });
});
