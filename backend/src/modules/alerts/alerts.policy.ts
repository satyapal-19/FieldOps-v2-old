/**
 * Pure alert rules: who sees and resolves an alert. No database, no clock.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';

export class AlertRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

/** The facts about an alert these rules need. */
export interface AlertFacts {
  wardId: string | null;
  staffId: string | null;
  /** The line manager of the person the alert is about, if any. */
  staffManagerId: string | null;
}

/** Supervisors see alerts: ADMIN all; WARD_INSPECTOR their ward; INSPECTOR their direct reports. */
export type AlertScope =
  | { kind: 'ALL' }
  | { kind: 'WARD'; wardId: string }
  | { kind: 'REPORTS'; managerId: string }
  | { kind: 'NONE' };

export function alertScope(actor: AuthUser): AlertScope {
  if (actor.role === Role.ADMIN) return { kind: 'ALL' };
  if (actor.role === Role.WARD_INSPECTOR && actor.homeWardId)
    return { kind: 'WARD', wardId: actor.homeWardId };
  if (actor.role === Role.INSPECTOR) return { kind: 'REPORTS', managerId: actor.staffId };
  return { kind: 'NONE' };
}

/** Seeing an alert and resolving it go together: whoever is shown it acts on it. */
export function canHandleAlert(actor: AuthUser, alert: AlertFacts): boolean {
  if (alert.staffId !== null && alert.staffId === actor.staffId) return false;
  const scope = alertScope(actor);
  switch (scope.kind) {
    case 'ALL':
      return true;
    case 'WARD':
      return alert.wardId === scope.wardId;
    case 'REPORTS':
      return alert.staffManagerId === scope.managerId;
    default:
      return false;
  }
}

export function checkResolvable(isResolved: boolean): void {
  if (isResolved) throw new AlertRuleError('isResolved', 'This alert is already resolved');
}

/** Stable keys so a job or a retried punch raises an alert once: "TYPE:staff:date". */
export function dedupeKey(alertType: string, staffId: string | null, date: string): string {
  return `${alertType}:${staffId ?? 'none'}:${date}`;
}
