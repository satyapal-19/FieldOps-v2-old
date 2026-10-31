/**
 * Pure sign-in rules: OTP codes, secret hashing, refresh-token format, OTP attempt
 * decisions and password strength. No database, no Nest.
 */
import { createHmac, randomBytes, randomInt, timingSafeEqual } from 'node:crypto';

export const OTP_LENGTH = 6;

/** A uniformly random 6-digit code from the OS CSPRNG. */
export function generateOtp(): string {
  return String(randomInt(0, 10 ** OTP_LENGTH)).padStart(OTP_LENGTH, '0');
}

/** Keyed hash (HMAC-SHA256, hex). OTPs and refresh secrets are stored only as this. */
export function hashSecret(key: string, purpose: string, value: string): string {
  return createHmac('sha256', key).update(`${purpose}:${value}`).digest('hex');
}

/** Constant-time comparison of two hex digests. */
export function sameHash(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  return timingSafeEqual(Buffer.from(a, 'hex'), Buffer.from(b, 'hex'));
}

/** Refresh token = "<sessionId>.<random secret>". Only the secret's hash is stored. */
export function newRefreshSecret(): string {
  return randomBytes(32).toString('base64url');
}

export function formatRefreshToken(sessionId: string, secret: string): string {
  return `${sessionId}.${secret}`;
}

export function parseRefreshToken(token: string): { sessionId: string; secret: string } | null {
  const match = /^([0-9a-f-]{36})\.([A-Za-z0-9_-]{32,64})$/i.exec(token.trim());
  return match ? { sessionId: match[1], secret: match[2] } : null;
}

export interface OtpState {
  expiresAt: Date;
  attempts: number;
  consumedAt: Date | null;
}

export type OtpCheck = 'usable' | 'expired' | 'too_many_attempts' | 'consumed';

export function checkOtpUsable(otp: OtpState, now: Date, maxAttempts: number): OtpCheck {
  if (otp.consumedAt) return 'consumed';
  if (otp.attempts >= maxAttempts) return 'too_many_attempts';
  if (now.getTime() >= otp.expiresAt.getTime()) return 'expired';
  return 'usable';
}

/** How many sessions to revoke (oldest first) so a new one fits under the limit. */
export function sessionsToEvict(activeCount: number, maxSessions: number): number {
  return Math.max(0, activeCount - maxSessions + 1);
}

/**
 * Web dashboard passwords: 10-72 characters (bcrypt reads at most 72 bytes),
 * at least one letter and one digit, and not the employee code or phone.
 * Returns problems; empty means acceptable.
 */
export function passwordProblems(password: string, identity: { employeeCode: string; phone: string }): string[] {
  const problems: string[] = [];
  if (password.length < 10) problems.push('Use at least 10 characters');
  if (Buffer.byteLength(password, 'utf8') > 72) problems.push('Use at most 72 bytes');
  if (!/[A-Za-z]/.test(password) || !/\d/.test(password)) problems.push('Use letters and digits');
  const lower = password.toLowerCase();
  if (lower.includes(identity.employeeCode.toLowerCase()) || lower.includes(identity.phone)) {
    problems.push('Do not use your employee code or phone number');
  }
  return problems;
}
