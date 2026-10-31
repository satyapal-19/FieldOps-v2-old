import { XMLParser } from 'fast-xml-parser';
import { AppError } from '../../../shared/errors/app-error';
import { ErrorCode } from '../../../shared/errors/error-codes';
import type { PidData } from './aadhaar-xml';

const parser = new XMLParser({
  ignoreAttributes: false,
  attributeNamePrefix: '@_',
  textNodeName: '#text',
  parseAttributeValue: false,
  parseTagValue: false,
  trimValues: true,
});

type Node = Record<string, unknown>;

function asNode(value: unknown): Node {
  return typeof value === 'object' && value !== null ? (value as Node) : {};
}

function attr(node: Node, name: string): string | undefined {
  const value = node[`@_${name}`];
  return value === undefined ? undefined : String(value);
}

function text(value: unknown): string {
  if (typeof value === 'string' || typeof value === 'number') return String(value);
  return String(asNode(value)['#text'] ?? '');
}

/** Parses FaceRD's PidData. Never logs or stores the encrypted biometric payload. */
export function parsePidData(xml: string): PidData {
  let root: Node;
  try {
    root = asNode(asNode(parser.parse(xml)).PidData);
  } catch {
    throw new AppError(ErrorCode.AADHAAR_CAPTURE_FAILED, 'FaceRD response is not valid XML');
  }
  const resp = asNode(root.Resp);
  const errCode = attr(resp, 'errCode') ?? '';
  const device = asNode(root.DeviceInfo);
  const skey = asNode(root.Skey);
  const data = asNode(root.Data);

  let txn: string | undefined;
  const params = asNode(root.CustOpts).Param;
  for (const p of Array.isArray(params) ? params : params ? [params] : []) {
    const node = asNode(p);
    if (attr(node, 'name') === 'txn') txn = attr(node, 'value');
  }

  return {
    errCode,
    errInfo: attr(resp, 'errInfo'),
    deviceInfo: {
      rdsId: attr(device, 'rdsId') ?? '',
      rdsVer: attr(device, 'rdsVer') ?? '',
      dpId: attr(device, 'dpId') ?? '',
      dc: attr(device, 'dc') ?? '',
      mi: attr(device, 'mi') ?? '',
      mc: attr(device, 'mc') ?? '',
    },
    skey: { ci: attr(skey, 'ci') ?? '', value: text(root.Skey) },
    hmac: text(root.Hmac),
    data: { type: attr(data, 'type') ?? 'X', value: text(root.Data) },
    txn,
  };
}

export interface AuthResponse {
  ret: 'y' | 'n';
  err?: string;
  code?: string;
  txn?: string;
  ts?: string;
}

/** Parses UIDAI's AuthRes ("y" = authenticated). */
export function parseAuthResponse(xml: string): AuthResponse {
  let root: Node;
  try {
    root = asNode(asNode(parser.parse(xml)).AuthRes);
  } catch {
    throw new AppError(ErrorCode.FACE_PROVIDER_UNAVAILABLE, 'UIDAI response is not valid XML', {
      provider: 'aadhaar',
    });
  }
  const ret = attr(root, 'ret');
  if (ret !== 'y' && ret !== 'n') {
    throw new AppError(ErrorCode.FACE_PROVIDER_UNAVAILABLE, 'UIDAI response has no result', {
      provider: 'aadhaar',
    });
  }
  return {
    ret,
    err: attr(root, 'err'),
    code: attr(root, 'code'),
    txn: attr(root, 'txn'),
    ts: attr(root, 'ts'),
  };
}
