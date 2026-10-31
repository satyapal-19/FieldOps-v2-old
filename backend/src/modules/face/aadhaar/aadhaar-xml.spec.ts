import { buildAsaUrl, buildAuthXml, buildPidOptionsXml, escapeXmlAttr, type PidData } from './aadhaar-xml';

const pid: PidData = {
  errCode: '0',
  deviceInfo: { rdsId: 'FACE.RD', rdsVer: '1.0.1', dpId: 'UIDAI.UIDAI', dc: 'dc-1', mi: 'FACE', mc: 'cert' },
  skey: { ci: '20250923', value: 'ENCRYPTED_SESSION_KEY' },
  hmac: 'HMAC_VALUE',
  data: { type: 'X', value: 'ENCRYPTED_PID' },
  txn: 'txn-1',
};

describe('Aadhaar XML builders', () => {
  it('builds PidOptions with env, pidVer, txn and language', () => {
    const xml = buildPidOptionsXml({ env: 'PP', pidVersion: '2.0', txn: 'txn-1', language: 'mr' });
    expect(xml).toContain('<PidOptions ver="1.0" env="PP">');
    expect(xml).toContain('format="0"');
    expect(xml).toContain('pidVer="2.0"');
    expect(xml).toContain('<Param name="txn" value="txn-1"/>');
    expect(xml).toContain('<Param name="lang" value="mr"/>');
  });

  it('omits the language when not given', () => {
    expect(buildPidOptionsXml({ env: 'P', pidVersion: '2.0', txn: 't' })).not.toContain('lang');
  });

  it('builds a face Auth XML from the PidData without touching the encrypted parts', () => {
    const xml = buildAuthXml({
      uid: 'UIDTOKEN123',
      auaCode: 'SMKC',
      subAuaCode: 'SMKC',
      apiVersion: '2.5',
      txn: 'txn-1',
      licenseKey: 'LK',
      pid,
    });
    expect(xml).toContain('rc="Y"');
    expect(xml).toContain('tid="registered"');
    expect(xml).toContain('bio="y" bt="FID"');
    expect(xml).toContain('rdsId="FACE.RD"');
    expect(xml).toContain('<Skey ci="20250923">ENCRYPTED_SESSION_KEY</Skey>');
    expect(xml).toContain('<Data type="X">ENCRYPTED_PID</Data>');
    expect(xml).not.toContain('udc=');
  });

  it('escapes attribute values', () => {
    expect(escapeXmlAttr(`a"b<c>&'`)).toBe('a&quot;b&lt;c&gt;&amp;&apos;');
  });

  it('fills the ASA URL, using 0/0 for tokens and VIDs', () => {
    const template = 'https://asa.example/{ver}/{ac}/{uid0}/{uid1}/{asalk}';
    expect(buildAsaUrl(template, { ver: '2.5', ac: 'SMKC', uid: '999941057058', asaLicenseKey: 'ASA' })).toBe(
      'https://asa.example/2.5/SMKC/9/9/ASA',
    );
    expect(buildAsaUrl(template, { ver: '2.5', ac: 'SMKC', uid: 'TOKEN', asaLicenseKey: 'ASA' })).toBe(
      'https://asa.example/2.5/SMKC/0/0/ASA',
    );
  });
});
