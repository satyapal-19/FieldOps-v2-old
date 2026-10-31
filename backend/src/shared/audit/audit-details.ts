/** Pure helpers for audit rows. */
const SECRET_KEYS = /password|otp|token|secret|embedding|aadhaar|pid/i;

/** Drops keys that look secret, so a careless caller cannot put them in the audit log. */
export function sanitizeAuditDetails(details: Record<string, unknown> | undefined): string | null {
  if (!details) return null;
  const safe = Object.fromEntries(Object.entries(details).filter(([k]) => !SECRET_KEYS.test(k)));
  return Object.keys(safe).length > 0 ? JSON.stringify(safe) : null;
}
