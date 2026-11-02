/**
 * Pure rules for leave and attendance-regularization requests: date windows, overlaps and who
 * may review. No database, no clock - "today" is passed in. Test with plain tables of inputs.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { LeaveType, ReviewStatus } from './entities/leave-request.entity';

export class LeaveRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

/** The facts about the person who asked that these rules need. */
export interface RequesterFacts {
  id: string;
  role: StaffRole;
  homeWardId: string | null;
  reportsToId: string | null;
}

export const SICK_LEAVE_BACKDATE_DAYS = 7;
export const MAX_LEAVE_DAYS = 31;
export const REGULARIZE_WITHIN_DAYS = 7;

const DATE = /^\d{4}-\d{2}-\d{2}$/;

function isRealDate(date: string): boolean {
  if (!DATE.test(date)) return false;
  const d = new Date(`${date}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === date;
}

/** Whole days from `from` to `to` (both YYYY-MM-DD). */
export function daysBetween(from: string, to: string): number {
  return Math.round((Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / 86_400_000);
}

/**
 * A leave request: real dates, to >= from, at most 31 calendar days (both ends counted).
 * Leave starts today or later; only sick leave may start up to 7 days back.
 * Returns the number of calendar days requested.
 */
export function checkLeaveDates(
  leaveType: LeaveType,
  fromDate: string,
  toDate: string,
  todayIst: string,
): number {
  if (!isRealDate(fromDate))
    throw new LeaveRuleError('fromDate', 'fromDate must be a real YYYY-MM-DD date');
  if (!isRealDate(toDate))
    throw new LeaveRuleError('toDate', 'toDate must be a real YYYY-MM-DD date');
  const days = daysBetween(fromDate, toDate) + 1;
  if (days < 1) throw new LeaveRuleError('toDate', 'toDate cannot be before fromDate');
  if (days > MAX_LEAVE_DAYS)
    throw new LeaveRuleError('toDate', `At most ${MAX_LEAVE_DAYS} days per request`);
  const earliest = leaveType === 'SICK' ? -SICK_LEAVE_BACKDATE_DAYS : 0;
  if (daysBetween(todayIst, fromDate) < earliest) {
    throw new LeaveRuleError(
      'fromDate',
      leaveType === 'SICK'
        ? `Sick leave can start at most ${SICK_LEAVE_BACKDATE_DAYS} days back`
        : 'Leave cannot start in the past',
    );
  }
  return days;
}

/** Two inclusive date ranges overlap. */
export function rangesOverlap(
  a: { from: string; to: string },
  b: { from: string; to: string },
): boolean {
  return a.from <= b.to && b.from <= a.to;
}

/** Regularization is for one of the last 7 days (not today's open shift, not the future). */
export function checkRegularizationDate(date: string, todayIst: string): void {
  if (!isRealDate(date))
    throw new LeaveRuleError('attendanceDate', 'attendanceDate must be a real YYYY-MM-DD date');
  const back = daysBetween(date, todayIst);
  if (back < 1) throw new LeaveRuleError('attendanceDate', 'Only past days can be regularized');
  if (back > REGULARIZE_WITHIN_DAYS) {
    throw new LeaveRuleError(
      'attendanceDate',
      `Only the last ${REGULARIZE_WITHIN_DAYS} days can be regularized`,
    );
  }
}

/**
 * Who reviews a request (v4 hierarchy):
 * - ADMIN: anyone
 * - WARD_INSPECTOR: inspectors and workers of their own ward
 * - INSPECTOR: workers who report to them
 * Nobody reviews their own request.
 */
export function canReview(actor: AuthUser, requester: RequesterFacts): boolean {
  if (actor.staffId === requester.id) return false;
  switch (actor.role) {
    case Role.ADMIN:
      return true;
    case Role.WARD_INSPECTOR:
      return (
        actor.homeWardId !== null &&
        requester.homeWardId === actor.homeWardId &&
        (requester.role === Role.INSPECTOR || requester.role === Role.WORKER)
      );
    case Role.INSPECTOR:
      return requester.role === Role.WORKER && requester.reportsToId === actor.staffId;
    default:
      return false;
  }
}

/** Whose requests a caller may list: everyone, a ward, their direct reports, or only their own. */
export type RequestScope =
  | { kind: 'ALL' }
  | { kind: 'WARD'; wardId: string }
  | { kind: 'REPORTS'; managerId: string }
  | { kind: 'SELF' };

export function requestScope(actor: AuthUser): RequestScope {
  if (actor.role === Role.ADMIN) return { kind: 'ALL' };
  if (actor.role === Role.WARD_INSPECTOR && actor.homeWardId)
    return { kind: 'WARD', wardId: actor.homeWardId };
  if (actor.role === Role.INSPECTOR) return { kind: 'REPORTS', managerId: actor.staffId };
  return { kind: 'SELF' };
}

/** A decision is made once, on a pending request. */
export function checkReviewable(status: ReviewStatus): void {
  if (status !== 'PENDING') throw new LeaveRuleError('status', `This request is already ${status}`);
}

/**
 * The requester may cancel while pending, or an approved leave that has not started yet.
 * Returns nothing; throws when not allowed.
 */
export function checkCancellable(
  status: ReviewStatus,
  fromDate: string | null,
  todayIst: string,
): void {
  if (status === 'PENDING') return;
  if (status === 'APPROVED' && fromDate !== null && fromDate > todayIst) return;
  throw new LeaveRuleError('status', `A ${status} request cannot be cancelled`);
}
