import {
  checkOtpUsable,
  formatRefreshToken,
  generateOtp,
  hashSecret,
  newRefreshSecret,
  parseRefreshToken,
  passwordProblems,
  sameHash,
  sessionsToEvict,
} from './auth.policy';

const SID = '3f2a9c1e-5b7d-4e8a-9c21-7d4e5f6a8b90';

describe('auth.policy', () => {
  it('generates 6-digit codes', () => {
    for (let i = 0; i < 200; i++) expect(generateOtp()).toMatch(/^\d{6}$/);
  });

  it('hashes with a key and purpose, compares in constant time', () => {
    const a = hashSecret('k', 'otp', '9812345678:123456');
    expect(a).toMatch(/^[0-9a-f]{64}$/);
    expect(sameHash(a, hashSecret('k', 'otp', '9812345678:123456'))).toBe(true);
    expect(sameHash(a, hashSecret('k2', 'otp', '9812345678:123456'))).toBe(false);
    expect(sameHash(a, hashSecret('k', 'refresh', '9812345678:123456'))).toBe(false);
    expect(sameHash(a, 'abc')).toBe(false);
  });

  it('round-trips refresh tokens', () => {
    const secret = newRefreshSecret();
    expect(parseRefreshToken(formatRefreshToken(SID, secret))).toEqual({ sessionId: SID, secret });
  });

  it.each(['', 'abc', `${SID}`, `${SID}.short`, `not-a-uuid.${'a'.repeat(43)}`, `${SID}.${'a'.repeat(43)}.x`])(
    'rejects malformed refresh token %s',
    (token) => {
      expect(parseRefreshToken(token)).toBeNull();
    },
  );

  const now = new Date('2026-11-01T00:30:00Z');
  const later = new Date('2026-11-01T00:35:00Z');
  it.each([
    [{ expiresAt: later, attempts: 0, consumedAt: null }, 'usable'],
    [{ expiresAt: later, attempts: 4, consumedAt: null }, 'usable'],
    [{ expiresAt: later, attempts: 5, consumedAt: null }, 'too_many_attempts'],
    [{ expiresAt: now, attempts: 0, consumedAt: null }, 'expired'],
    [{ expiresAt: later, attempts: 0, consumedAt: now }, 'consumed'],
  ] as const)('otp %o is %s', (otp, expected) => {
    expect(checkOtpUsable(otp, now, 5)).toBe(expected);
  });

  it.each([
    [0, 5, 0],
    [4, 5, 0],
    [5, 5, 1],
    [7, 5, 3],
  ])('with %i active sessions and max %i, evict %i', (active, max, evict) => {
    expect(sessionsToEvict(active, max)).toBe(evict);
  });

  const identity = { employeeCode: 'SMK-A-0001', phone: '9812345678' };
  it.each([
    ['Sangli2026Miraj', 0],
    ['short1', 1],
    ['onlyletterslong', 1],
    ['12345678901', 1],
    ['smk-a-0001xyz9', 1],
    ['pass9812345678', 1],
    ['a1' + 'x'.repeat(80), 1],
  ])('password %s has %i problem(s)', (pw, count) => {
    expect(passwordProblems(pw, identity)).toHaveLength(count);
  });
});
