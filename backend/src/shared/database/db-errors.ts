/** True when the error is a unique-constraint violation on PostgreSQL or Oracle. */
export function isUniqueViolation(error: unknown): boolean {
  if (typeof error !== 'object' || error === null) return false;
  const e = error as { code?: unknown; errorNum?: unknown; driverError?: unknown; message?: unknown };
  if (e.code === '23505') return true; // PostgreSQL unique_violation
  if (e.errorNum === 1) return true; // ORA-00001 unique constraint violated
  if (typeof e.message === 'string' && e.message.includes('ORA-00001')) return true;
  return e.driverError !== undefined && e.driverError !== error && isUniqueViolation(e.driverError);
}
