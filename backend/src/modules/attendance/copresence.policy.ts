/**
 * Co-presence for proxy punches (action plan Phase 4, rolling QR): the worker's phone shows a
 * 6-digit code that changes every 30 seconds (the TOTP algorithm, RFC 6238), computed offline
 * from a key the server gave that phone. The inspector scans it while marking the worker, so a
 * proxy punch shows the worker's own phone was there. Pure functions: callers pass the key and
 * the time.
 */
import { createHmac } from 'node:crypto';

export const PRESENCE_PERIOD_SECONDS = 30;
export const PRESENCE_DIGITS = 6;
/** Accept the code of the previous and next window too (clock drift, slow scan). */
export const PRESENCE_SKEW_WINDOWS = 1;

/** The per-person key: derived from the server secret, so nothing new is stored. */
export function presenceKey(serverSecret: string, staffId: string): Buffer {
  return createHmac('sha256', serverSecret).update(`copresence:${staffId}`).digest();
}

/** The code for one 30-second window (TOTP: HMAC-SHA1 of the counter, dynamic truncation). */
export function presenceCode(key: Buffer, window: number): string {
  const counter = Buffer.alloc(8);
  counter.writeBigUInt64BE(BigInt(window));
  const mac = createHmac('sha1', key).update(counter).digest();
  const offset = mac[mac.length - 1] & 0x0f;
  const value = (mac.readUInt32BE(offset) & 0x7fffffff) % 10 ** PRESENCE_DIGITS;
  return String(value).padStart(PRESENCE_DIGITS, '0');
}

export function windowAt(at: Date): number {
  return Math.floor(at.getTime() / 1000 / PRESENCE_PERIOD_SECONDS);
}

/** Whether a scanned code is the person's code for now (± one window). */
export function verifyPresenceCode(key: Buffer, code: string, now: Date): boolean {
  if (!/^\d{6}$/.test(code)) return false;
  const current = windowAt(now);
  for (let d = -PRESENCE_SKEW_WINDOWS; d <= PRESENCE_SKEW_WINDOWS; d++) {
    if (presenceCode(key, current + d) === code) return true;
  }
  return false;
}

/** For a proxy punch: what to do about the scanned code. */
export function copresenceOutcome(
  isProxy: boolean,
  required: boolean,
  code: string | undefined,
  valid: boolean,
): 'NOT_NEEDED' | 'CONFIRMED' | 'MISSING' | 'WRONG' {
  if (!isProxy) return 'NOT_NEEDED';
  if (!code) return required ? 'MISSING' : 'NOT_NEEDED';
  return valid ? 'CONFIRMED' : 'WRONG';
}
