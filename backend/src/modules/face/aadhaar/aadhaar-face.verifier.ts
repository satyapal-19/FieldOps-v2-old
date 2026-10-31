import { AppError } from '../../../shared/errors/app-error';
import { ErrorCode } from '../../../shared/errors/error-codes';
import { IdGenerator } from '../../../shared/ids/id-generator';
import {
  FaceCaptureOptions,
  FaceVerificationInput,
  FaceVerificationResult,
  FaceVerifier,
} from '../face-verifier';
import { AadhaarIdentityResolver, AsaClient, AuthXmlSigner } from './aadhaar-gateways';
import { parseAuthResponse, parsePidData } from './aadhaar-parsers';
import { buildAsaUrl, buildAuthXml, buildPidOptionsXml, FACERD_CAPTURE_ACTION } from './aadhaar-xml';

export interface AadhaarSettings {
  env: string;
  apiVersion: string;
  pidVersion: string;
  auaCode: string;
  subAuaCode: string;
  licenseKey: string;
  asaLicenseKey: string;
  asaUrlTemplate: string;
  language: string;
  udc?: string;
}

/**
 * Aadhaar face authentication: FaceRD captures and encrypts on the phone; we wrap the
 * encrypted PID into a signed Auth request and send it through SMKC's ASA. We never see or
 * store biometrics; the signed UIDAI response is returned for the audit trail.
 */
export class AadhaarFaceVerifier extends FaceVerifier {
  readonly provider = 'aadhaar' as const;

  constructor(
    private readonly settings: AadhaarSettings,
    private readonly identities: AadhaarIdentityResolver,
    private readonly signer: AuthXmlSigner,
    private readonly asa: AsaClient,
    private readonly ids: IdGenerator,
  ) {
    super();
  }

  async captureOptions(): Promise<FaceCaptureOptions> {
    const txn = this.ids.next();
    return {
      provider: 'aadhaar',
      instructions: 'LAUNCH_FACERD',
      txn,
      intentAction: FACERD_CAPTURE_ACTION,
      pidOptionsXml: buildPidOptionsXml({
        env: this.settings.env,
        pidVersion: this.settings.pidVersion,
        txn,
        language: this.settings.language,
      }),
    };
  }

  async verify(input: FaceVerificationInput): Promise<FaceVerificationResult> {
    if (input.kind !== 'aadhaar-pid') {
      throw new AppError(ErrorCode.VALIDATION_FAILED, 'The Aadhaar face provider expects FaceRD PidData', {
        expected: 'aadhaar-pid',
        received: input.kind,
      });
    }

    const pid = parsePidData(input.pidDataXml);
    if (pid.errCode !== '0') {
      return { provider: 'aadhaar', matched: false, reasonCode: `FACERD_${pid.errCode || 'UNKNOWN'}` };
    }
    if (pid.txn && pid.txn !== input.txn) {
      throw new AppError(ErrorCode.AADHAAR_CAPTURE_FAILED, 'Capture does not belong to this request', {
        expectedTxn: input.txn,
      });
    }

    const uid = await this.identities.resolve(input.staffId);
    if (!uid) {
      throw new AppError(ErrorCode.AADHAAR_IDENTITY_MISSING, undefined, { staffId: input.staffId });
    }

    const authXml = buildAuthXml({
      uid,
      auaCode: this.settings.auaCode,
      subAuaCode: this.settings.subAuaCode,
      apiVersion: this.settings.apiVersion,
      txn: input.txn,
      licenseKey: this.settings.licenseKey,
      udc: this.settings.udc,
      pid,
    });
    const url = buildAsaUrl(this.settings.asaUrlTemplate, {
      ver: this.settings.apiVersion,
      ac: this.settings.auaCode,
      uid,
      asaLicenseKey: this.settings.asaLicenseKey,
    });

    const responseXml = await this.asa.send(url, this.signer.sign(authXml));
    const result = parseAuthResponse(responseXml);

    return {
      provider: 'aadhaar',
      matched: result.ret === 'y',
      reasonCode: result.ret === 'y' ? undefined : `UIDAI_${result.err ?? 'UNKNOWN'}`,
      reference: result.code,
      auditPayload: responseXml,
    };
  }
}
