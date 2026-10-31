import { sanitizeAuditDetails } from './audit-details';

describe('sanitizeAuditDetails', () => {
  it('keeps plain fields', () => {
    expect(sanitizeAuditDetails({ fields: ['name'], reason: 'transfer' })).toBe(
      '{"fields":["name"],"reason":"transfer"}',
    );
  });

  it.each(['password', 'otp', 'otpCode', 'refreshToken', 'faceEmbedding', 'aadhaarNumber', 'jwtSecret'])(
    'drops %s',
    (key) => {
      expect(sanitizeAuditDetails({ [key]: 'x', ok: 1 })).toBe('{"ok":1}');
    },
  );

  it('returns null when nothing is left', () => {
    expect(sanitizeAuditDetails(undefined)).toBeNull();
    expect(sanitizeAuditDetails({ password: 'x' })).toBeNull();
  });
});
