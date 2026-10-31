import { AppError } from '../../../shared/errors/app-error';
import { parseAuthResponse, parsePidData } from './aadhaar-parsers';

const pidDataXml = `<?xml version="1.0" encoding="UTF-8"?>
<PidData>
  <Resp errCode="0" errInfo="Success" fCount="0" fType="0" iCount="0" pCount="1" pType="0" nmPoints="0" qScore="0"/>
  <DeviceInfo rdsId="FACE.RD" rdsVer="1.0.1" dpId="UIDAI.UIDAI" dc="dc-123" mi="FACE" mc="MIIcert"/>
  <Skey ci="20250923">ENC_SKEY</Skey>
  <Hmac>ENC_HMAC</Hmac>
  <Data type="X">ENC_DATA</Data>
  <CustOpts><Param name="txn" value="txn-42"/><Param name="txnStatus" value="PID_CREATED"/></CustOpts>
</PidData>`;

describe('parsePidData', () => {
  it('extracts device info, encrypted parts and the echoed txn', () => {
    const pid = parsePidData(pidDataXml);
    expect(pid.errCode).toBe('0');
    expect(pid.deviceInfo).toEqual({
      rdsId: 'FACE.RD',
      rdsVer: '1.0.1',
      dpId: 'UIDAI.UIDAI',
      dc: 'dc-123',
      mi: 'FACE',
      mc: 'MIIcert',
    });
    expect(pid.skey).toEqual({ ci: '20250923', value: 'ENC_SKEY' });
    expect(pid.hmac).toBe('ENC_HMAC');
    expect(pid.data).toEqual({ type: 'X', value: 'ENC_DATA' });
    expect(pid.txn).toBe('txn-42');
  });

  it('reports FaceRD error codes', () => {
    const pid = parsePidData('<PidData><Resp errCode="730" errInfo="Capture timed out"/></PidData>');
    expect(pid.errCode).toBe('730');
    expect(pid.errInfo).toBe('Capture timed out');
  });
});

describe('parseAuthResponse', () => {
  it('reads a successful authentication', () => {
    expect(parseAuthResponse('<AuthRes ret="y" code="abc" txn="txn-42" ts="2026-10-31T10:00:00"/>')).toMatchObject({
      ret: 'y',
      code: 'abc',
      txn: 'txn-42',
    });
  });

  it('reads a biometric mismatch', () => {
    expect(parseAuthResponse('<AuthRes ret="n" err="300" code="x" txn="t"/>')).toMatchObject({ ret: 'n', err: '300' });
  });

  it('rejects a response without a result', () => {
    expect(() => parseAuthResponse('<Other/>')).toThrow(AppError);
  });
});
