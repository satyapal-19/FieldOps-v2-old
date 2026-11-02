/**
 * Pure rules for managing staff: who may see whom, and the v4 reporting lines.
 * No database, no Nest - test with plain tables of inputs.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { PASSWORD_LOGIN_ROLES, Role, StaffRole } from '../../shared/auth/roles';
import { StaffRuleError } from '../staff/staff.policy';

/** The facts about a staff member these rules need. */
export interface StaffFacts {
  id: string;
  role: StaffRole;
  homeWardId: string | null;
  reportsToId: string | null;
  isActive: boolean;
}

/** What a caller may list: everything, part of one ward, or nothing. */
export type StaffScope =
  | { kind: 'ALL' }
  | { kind: 'WARD'; wardId: string; roles?: readonly StaffRole[]; alsoStaffId?: string }
  | { kind: 'NONE' };

/**
 * - ADMIN: everyone
 * - WARD_INSPECTOR: everyone whose home ward is their ward
 * - INSPECTOR: the workers of their home ward, and themselves
 * - WORKER / OFFICE_STAFF: nobody (they read their own profile through /auth/me)
 */
export function staffListScope(actor: AuthUser): StaffScope {
  switch (actor.role) {
    case Role.ADMIN:
      return { kind: 'ALL' };
    case Role.WARD_INSPECTOR:
      return actor.homeWardId ? { kind: 'WARD', wardId: actor.homeWardId } : { kind: 'NONE' };
    case Role.INSPECTOR:
      return actor.homeWardId
        ? {
            kind: 'WARD',
            wardId: actor.homeWardId,
            roles: [Role.WORKER],
            alsoStaffId: actor.staffId,
          }
        : { kind: 'NONE' };
    default:
      return { kind: 'NONE' };
  }
}

/** Same scope as the list, applied to one record. Everyone may see themselves. */
export function canViewStaff(actor: AuthUser, target: StaffFacts): boolean {
  if (actor.staffId === target.id) return true;
  const scope = staffListScope(actor);
  if (scope.kind === 'ALL') return true;
  if (scope.kind === 'NONE') return false;
  if (target.homeWardId !== scope.wardId) return false;
  return !scope.roles || scope.roles.includes(target.role);
}

/** Full phone numbers are for admins and the person themselves; others see the last 4 digits. */
export function canSeeFullPhone(actor: AuthUser, targetId: string): boolean {
  return actor.role === Role.ADMIN || actor.staffId === targetId;
}

/** v4 reporting lines: each role reports to exactly the next rank up. */
export const MANAGER_ROLE: Record<StaffRole, StaffRole | null> = {
  [Role.ADMIN]: null,
  [Role.WARD_INSPECTOR]: Role.ADMIN,
  [Role.INSPECTOR]: Role.WARD_INSPECTOR,
  [Role.WORKER]: Role.INSPECTOR,
  [Role.OFFICE_STAFF]: Role.ADMIN,
};

/**
 * Checks a reporting line. `manager` is null when no manager is set (allowed while a
 * squad is being built; rosters still decide the day's team).
 * - the manager must hold the next rank up, be active, and not be the person
 * - inspectors and workers report within their own home ward
 */
export function checkReportsTo(
  person: { id: string | null; role: StaffRole; homeWardId: string | null },
  manager: StaffFacts | null,
): void {
  const expected = MANAGER_ROLE[person.role];
  if (!manager) return;
  if (expected === null) {
    throw new StaffRuleError('reportsToId', `${person.role} reports to nobody`);
  }
  if (manager.id === person.id) {
    throw new StaffRuleError('reportsToId', 'A person cannot report to themselves');
  }
  if (!manager.isActive) {
    throw new StaffRuleError('reportsToId', 'The manager is deactivated');
  }
  if (manager.role !== expected) {
    throw new StaffRuleError(
      'reportsToId',
      `${person.role} must report to a ${expected}, not a ${manager.role}`,
    );
  }
  const sameWardRequired = person.role === Role.WORKER || person.role === Role.INSPECTOR;
  if (sameWardRequired && manager.homeWardId !== person.homeWardId) {
    throw new StaffRuleError(
      'reportsToId',
      `${person.role} must report to someone in the same ward`,
    );
  }
}

/**
 * Whether changing a manager would break their direct reports' lines (see checkReportsTo):
 * deactivating them, changing their role, or moving a ward inspector / inspector (whose reports
 * must share their ward) to another ward. Returns what is wrong, or null when reports are safe.
 */
export function changeBreaksReports(
  before: { role: StaffRole; homeWardId: string | null; isActive: boolean },
  after: { role: StaffRole; homeWardId: string | null; isActive: boolean },
): 'DEACTIVATED' | 'ROLE_CHANGED' | 'WARD_CHANGED' | null {
  if (before.isActive && !after.isActive) return 'DEACTIVATED';
  if (after.role !== before.role) return 'ROLE_CHANGED';
  const reportsShareWard = before.role === Role.WARD_INSPECTOR || before.role === Role.INSPECTOR;
  if (reportsShareWard && after.homeWardId !== before.homeWardId) return 'WARD_CHANGED';
  return null;
}

/** Only web-dashboard roles sign in with a password; field roles use OTP (D3). */
export function checkPasswordAllowed(role: StaffRole, hasPassword: boolean): void {
  if (hasPassword && !PASSWORD_LOGIN_ROLES.includes(role)) {
    throw new StaffRuleError('initialPassword', `${role} signs in with OTP and has no password`);
  }
}

/**
 * Changes that alter what a signed-in session may do. Existing sessions are revoked so the
 * person signs in again with the new role / ward / phone.
 */
export function changesNeedSignOut(
  before: { role: StaffRole; homeWardId: string | null; officeId: string | null; phone: string },
  after: {
    role: StaffRole;
    homeWardId: string | null;
    officeId: string | null;
    phone: string;
    isActive: boolean;
  },
): boolean {
  return (
    !after.isActive ||
    before.role !== after.role ||
    before.homeWardId !== after.homeWardId ||
    before.officeId !== after.officeId ||
    before.phone !== after.phone
  );
}
