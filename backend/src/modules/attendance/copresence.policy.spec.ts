import {
  copresenceOutcome,
  presenceCode,
  presenceKey,
  verifyPresenceCode,
  windowAt,
} from './copresence.policy';

describe('presenceCode (TOTP, RFC 6238 SHA-1 test vectors)', () => {
  // RFC 6238 appendix B: key "12345678901234567890", 8 digits; our 6 digits are the last six.
  const key = Buffer.from('12345678901234567890');
  it.each([
    [59, '287082'],
    [1111111109, '081804'],
    [1111111111, '050471'],
    [1234567890, '005924'],
    [2000000000, '279037'],
  ])('at %i s is %s', (seconds, code) => {
    expect(presenceCode(key, Math.floor(seconds / 30))).toBe(code);
  });
});

describe('verifyPresenceCode', () => {
  const key = presenceKey('server-secret', 'worker-1');
  const now = new Date('2026-11-02T03:00:15Z');
  const code = (offset: number) => presenceCode(key, windowAt(now) + offset);
  it.each([
    ['the current code', code(0), true],
    ['the previous window (slow scan)', code(-1), true],
    ['the next window (clock drift)', code(1), true],
    ['two windows old', code(-2), false],
    [
      'another worker’s code',
      presenceCode(presenceKey('server-secret', 'worker-2'), windowAt(now)),
      false,
    ],
    ['not six digits', '12345', false],
  ])('%s: %s', (_case, c, expected) => {
    expect(verifyPresenceCode(key, c, now)).toBe(expected);
  });
});

describe('copresenceOutcome', () => {
  it.each([
    ['self punch', false, true, undefined, false, 'NOT_NEEDED'],
    ['proxy, not required, no code', true, false, undefined, false, 'NOT_NEEDED'],
    ['proxy, required, no code', true, true, undefined, false, 'MISSING'],
    ['proxy with a good code', true, false, '123456', true, 'CONFIRMED'],
    ['proxy with a wrong code', true, false, '123456', false, 'WRONG'],
  ] as const)('%s', (_case, proxy, required, code, valid, expected) => {
    expect(copresenceOutcome(proxy, required, code, valid)).toBe(expected);
  });
});
