/**
 * Rules for spot checks (action plan Phase 4) as pure functions: whether and when a random
 * check happens in a shift, how a check moves between states, and who may order one.
 * No database, clock or network: callers pass `now` and the random fractions.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import type { SpotCheckStatus } from './entities/spot-check.entity';

const MINUTE = 60_000;

/** Time to answer once notified. */
export const SPOT_WINDOW_MINUTES = 10;
/** One snooze adds this much. */
export const SNOOZE_MINUTES = 10;
/** No random check in the first or last half hour of a shift. */
export const SPOT_MARGIN_MINUTES = 30;

/** Two fractions in [0, 1) from a keyed digest, so one shift always gets the same decision. */
export function fractionsFromDigest(digest: Uint8Array): [number, number] {
  const read = (offset: number) =>
    ((digest[offset] << 24) |
      (digest[offset + 1] << 16) |
      (digest[offset + 2] << 8) |
      digest[offset + 3]) >>>
    0;
  return [read(0) / 2 ** 32, read(4) / 2 ** 32];
}

/**
 * When this shift's random check happens, or null for none. `pick` (decides whether, against
 * `rate`) and `at` (where in the window) come from fractionsFromDigest. The window is the shift
 * minus half an hour at each end; a time already past (the job was down) becomes now.
 */
export function planRandomCheck(
  pick: number,
  at: number,
  rate: number,
  checkinAt: Date,
  shiftEndsAt: Date,
  now: Date,
): Date | null {
  if (pick >= rate) return null;
  const from = checkinAt.getTime() + SPOT_MARGIN_MINUTES * MINUTE;
  const to = shiftEndsAt.getTime() - SPOT_MARGIN_MINUTES * MINUTE;
  if (to <= from || now.getTime() >= to) return null;
  return new Date(Math.max(now.getTime(), from + at * (to - from)));
}

export type SpotAction = 'NOTIFY' | 'SNOOZE' | 'RESPOND' | 'EXPIRE' | 'CANCEL';

export class SpotRuleError extends Error {
  constructor(readonly reason: 'CLOSED' | 'SNOOZE_USED' | 'TOO_EARLY') {
    super(reason);
  }
}

const OPEN: readonly SpotCheckStatus[] = ['NOTIFIED', 'SNOOZED'];

/**
 * The state a check moves to. SCHEDULED -> NOTIFIED (or CANCELLED if the person left);
 * NOTIFIED -> SNOOZED once; NOTIFIED / SNOOZED -> answered (VERIFIED / OUT_OF_GEOFENCE) before
 * the deadline, else MISSED. RESPOND's final status is decided by the caller from the proof.
 */
export function spotTransition(
  check: { status: SpotCheckStatus; snoozeCount: number; dueAt: Date | null },
  action: SpotAction,
  now: Date,
): SpotCheckStatus {
  const open = OPEN.includes(check.status);
  const inTime = !!check.dueAt && now.getTime() <= check.dueAt.getTime();
  switch (action) {
    case 'NOTIFY':
      if (check.status !== 'SCHEDULED') throw new SpotRuleError('CLOSED');
      return 'NOTIFIED';
    case 'CANCEL':
      if (check.status !== 'SCHEDULED' && !open) throw new SpotRuleError('CLOSED');
      return 'CANCELLED';
    case 'SNOOZE':
      if (check.status === 'SCHEDULED') throw new SpotRuleError('TOO_EARLY');
      if (!open || !inTime) throw new SpotRuleError('CLOSED');
      if (check.snoozeCount >= 1) throw new SpotRuleError('SNOOZE_USED');
      return 'SNOOZED';
    case 'RESPOND':
      if (check.status === 'SCHEDULED') throw new SpotRuleError('TOO_EARLY');
      if (!open || !inTime) throw new SpotRuleError('CLOSED');
      return check.status; // the caller sets VERIFIED or OUT_OF_GEOFENCE
    case 'EXPIRE':
      if (!open || inTime) throw new SpotRuleError('CLOSED');
      return 'MISSED';
  }
}

/** The facts about the person a senior wants to check. */
export interface SpotTarget {
  id: string;
  homeWardId: string | null;
  reportsToId: string | null;
  /** The ward they are working in today (their open shift). */
  dayWardId: string;
  /** The inspector today's assignment placed them under, if any. */
  dayInspectorId: string | null;
}

/**
 * Who may order a check or see someone's checks: ADMIN anyone; WARD_INSPECTOR anyone working
 * in their ward today; INSPECTOR their reports and the workers placed under them today.
 */
export function canCheck(
  actor: Pick<AuthUser, 'staffId' | 'role' | 'homeWardId'>,
  target: SpotTarget,
): boolean {
  if (actor.staffId === target.id) return false;
  switch (actor.role) {
    case Role.ADMIN:
      return true;
    case Role.WARD_INSPECTOR:
      return !!actor.homeWardId && actor.homeWardId === target.dayWardId;
    case Role.INSPECTOR:
      return target.reportsToId === actor.staffId || target.dayInspectorId === actor.staffId;
    default:
      return false;
  }
}
