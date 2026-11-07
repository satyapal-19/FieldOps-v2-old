/**
 * Rules for the live map and the attendance reports (action plan Phase 3) as pure functions:
 * how fresh a phone's last position is, which dates a report may cover, and whose data a
 * caller may read. No database, clock or network: callers pass `now` / `today`.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import { addDays } from '../../shared/clock/ist';
import { SILENT_GAP_MINUTES } from './jobs.policy';

const MINUTE = 60_000;

// ------------------------------------------------------------------ Live map

/** A position older than this is shown as stale (phones ping about every 10 minutes). */
export const LIVE_STALE_MINUTES = 15;

export type LiveState = 'ACTIVE' | 'STALE' | 'SILENT' | 'NO_SIGNAL';

/**
 * How to show someone on duty: ACTIVE (seen in the last 15 min), STALE (15-30 min), SILENT
 * (30+ min, or an open server silent gap), NO_SIGNAL (no ping since check-in).
 */
export function liveState(lastSeenAt: Date | null, now: Date, silentGapOpen: boolean): LiveState {
  if (silentGapOpen) return 'SILENT';
  if (!lastSeenAt) return 'NO_SIGNAL';
  const age = now.getTime() - lastSeenAt.getTime();
  if (age < LIVE_STALE_MINUTES * MINUTE) return 'ACTIVE';
  if (age < SILENT_GAP_MINUTES * MINUTE) return 'STALE';
  return 'SILENT';
}

// ------------------------------------------------------------------ Reports

/** The longest range one report may cover (a quarter), to keep queries and pages bounded. */
export const REPORT_MAX_DAYS = 92;

export type RangeProblem = 'FROM_AFTER_TO' | 'IN_FUTURE' | 'TOO_LONG' | null;

/** Checks an inclusive IST date range for a report. */
export function checkReportRange(from: string, to: string, today: string): RangeProblem {
  if (from > to) return 'FROM_AFTER_TO';
  if (to > today) return 'IN_FUTURE';
  if (addDays(from, REPORT_MAX_DAYS - 1) < to) return 'TOO_LONG';
  return null;
}

/**
 * Whose ward data a caller may read in reports and on the live map: ADMIN every ward (or the
 * one asked for); WARD_INSPECTOR only their own ward (asking for another is refused); others
 * nothing ('FORBIDDEN'). Inspectors see their team on the live map through the team rules.
 */
export function reportWard(
  actor: Pick<AuthUser, 'role' | 'homeWardId'>,
  asked: string | undefined,
): { wardId: string | null } | 'FORBIDDEN' {
  if (actor.role === Role.ADMIN) return { wardId: asked ?? null };
  if (actor.role === Role.WARD_INSPECTOR && actor.homeWardId) {
    return !asked || asked === actor.homeWardId ? { wardId: actor.homeWardId } : 'FORBIDDEN';
  }
  return 'FORBIDDEN';
}
