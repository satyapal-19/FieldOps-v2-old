/**
 * Pure builders for the two XML documents Aadhaar face authentication needs.
 * References (UIDAI): "App Initiated Capture Journey" (PidOptions / PidData) and
 * "Aadhaar Authentication API 2.5" (Auth XML). Re-check both against the specs current at
 * SMKC's onboarding; versions are configurable for that reason.
 */

/** Intent action of the UIDAI AadhaarFaceRD app (Android). */
export const FACERD_CAPTURE_ACTION = 'in.gov.uidai.rdservice.face.CAPTURE';

export function escapeXmlAttr(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&apos;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}

function attrs(values: Record<string, string | undefined>): string {
  return Object.entries(values)
    .filter(([, v]) => v !== undefined)
    .map(([k, v]) => `${k}="${escapeXmlAttr(v as string)}"`)
    .join(' ');
}

export interface PidOptionsInput {
  /** 'P' production, 'PP' pre-production. */
  env: string;
  pidVersion: string;
  /** Unique per capture; correlates the capture with our Auth request. */
  txn: string;
  /** App language, e.g. 'mr', 'hi', 'en'. */
  language?: string;
}

/** PidOptions passed to FaceRD in the intent extra "request". */
export function buildPidOptionsXml(input: PidOptionsInput): string {
  const custParams = [
    `<Param ${attrs({ name: 'txn', value: input.txn })}/>`,
    input.language ? `<Param ${attrs({ name: 'lang', value: input.language })}/>` : '',
  ].join('');
  return (
    `<?xml version="1.0" encoding="UTF-8"?>` +
    `<PidOptions ${attrs({ ver: '1.0', env: input.env })}>` +
    `<Opts ${attrs({ format: '0', pidVer: input.pidVersion, otp: '', wadh: '' })}/>` +
    `<CustOpts>${custParams}</CustOpts>` +
    `</PidOptions>`
  );
}

/** The parts of FaceRD's PidData that go into the Auth request (biometrics stay encrypted). */
export interface PidData {
  errCode: string;
  errInfo?: string;
  deviceInfo: {
    rdsId: string;
    rdsVer: string;
    dpId: string;
    dc: string;
    mi: string;
    mc: string;
  };
  skey: { ci: string; value: string };
  hmac: string;
  data: { type: string; value: string };
  txn?: string;
}

export interface AuthXmlInput {
  /** UID token, VID or Aadhaar number as permitted for the AUA. */
  uid: string;
  auaCode: string;
  subAuaCode: string;
  apiVersion: string;
  txn: string;
  licenseKey: string;
  /** Unique device code of the capturing phone, if the AUA uses one. */
  udc?: string;
  pid: PidData;
}

/** Unsigned Auth XML for face (bio="y", bt="FID", registered device). Sign before sending. */
export function buildAuthXml(input: AuthXmlInput): string {
  const { pid } = input;
  return (
    `<Auth ${attrs({
      uid: input.uid,
      rc: 'Y',
      tid: 'registered',
      ac: input.auaCode,
      sa: input.subAuaCode,
      ver: input.apiVersion,
      txn: input.txn,
      lk: input.licenseKey,
    })}>` +
    `<Uses ${attrs({ pi: 'n', pa: 'n', pfa: 'n', bio: 'y', bt: 'FID', pin: 'n', otp: 'n' })}/>` +
    `<Meta ${attrs({
      udc: input.udc,
      rdsId: pid.deviceInfo.rdsId,
      rdsVer: pid.deviceInfo.rdsVer,
      dpId: pid.deviceInfo.dpId,
      dc: pid.deviceInfo.dc,
      mi: pid.deviceInfo.mi,
      mc: pid.deviceInfo.mc,
    })}/>` +
    `<Skey ${attrs({ ci: pid.skey.ci })}>${pid.skey.value}</Skey>` +
    `<Hmac>${pid.hmac}</Hmac>` +
    `<Data ${attrs({ type: pid.data.type })}>${pid.data.value}</Data>` +
    `</Auth>`
  );
}

/** ASA endpoint from a template, e.g. https://asa.example/{ver}/{ac}/{uid0}/{uid1}/{asalk}. */
export function buildAsaUrl(
  template: string,
  values: { ver: string; ac: string; uid: string; asaLicenseKey: string },
): string {
  // For VID / UID token, UIDAI expects "0" in both uid positions.
  const isAadhaarNumber = /^\d{12}$/.test(values.uid);
  const uid0 = isAadhaarNumber ? values.uid[0] : '0';
  const uid1 = isAadhaarNumber ? values.uid[1] : '0';
  return template
    .replace('{ver}', encodeURIComponent(values.ver))
    .replace('{ac}', encodeURIComponent(values.ac))
    .replace('{uid0}', uid0)
    .replace('{uid1}', uid1)
    .replace('{asalk}', encodeURIComponent(values.asaLicenseKey));
}
