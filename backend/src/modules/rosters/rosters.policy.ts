/**
 * Pure roster rules (v4 §3): standing squads, daily assignments, self-pick / self-join and
 * approvals. No database, no clock - "today" is passed in. Test with plain tables of inputs.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { AssignableRole, AssignmentMode } from './roster-types';

export class RosterRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

/** The facts about a staff member these rules need. */
export interface PersonFacts {
  id: string;
  role: StaffRole;
  homeWardId: string | null;
  isActive: boolean;
}

/** The facts about an existing daily assignment these rules need. */
export interface AssignmentFacts {
  id: string;
  staffId: string;
  staffRole: AssignableRole;
  wardId: string;
  wardInspectorId: string;
  inspectorId: string;
  isApproved: boolean;
}

/** The furthest ahead (days) anyone may plan; self-service is today or tomorrow only. */
export const MAX_PLAN_AHEAD_DAYS = 31;
export const MAX_SELF_AHEAD_DAYS = 1;

/** Whole days from `from` to `to` (both YYYY-MM-DD). */
export function daysBetween(from: string, to: string): number {
  return Math.round((Date.parse(`${to}T00:00:00Z`) - Date.parse(`${from}T00:00:00Z`)) / 86_400_000);
}

/** Assignments are for today or a coming day: the past is attendance history, not a plan. */
export function checkAssignmentDate(date: string, todayIst: string, selfService: boolean): void {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || Number.isNaN(Date.parse(`${date}T00:00:00Z`))) {
    throw new RosterRuleError('date', 'Date must be YYYY-MM-DD');
  }
  const ahead = daysBetween(todayIst, date);
  if (ahead < 0) throw new RosterRuleError('date', 'Cannot assign for a past date');
  const limit = selfService ? MAX_SELF_AHEAD_DAYS : MAX_PLAN_AHEAD_DAYS;
  if (ahead > limit) throw new RosterRuleError('date', `Can assign at most ${limit} day(s) ahead`);
}

/** ADMIN manages every ward; a WARD_INSPECTOR only their own. */
export function canManageWard(actor: AuthUser, wardId: string): boolean {
  return (
    actor.role === Role.ADMIN || (actor.role === Role.WARD_INSPECTOR && actor.homeWardId === wardId)
  );
}

function requireActive(field: string, person: PersonFacts, role: StaffRole): void {
  if (person.role !== role)
    throw new RosterRuleError(field, `Must be a ${role}, not a ${person.role}`);
  if (!person.isActive) throw new RosterRuleError(field, 'This person is deactivated');
}

/**
 * A standing squad row: an active worker under an active inspector of the same home ward.
 * Returns the ward the squad belongs to.
 */
export function checkStandingRoster(worker: PersonFacts, inspector: PersonFacts): string {
  requireActive('workerId', worker, Role.WORKER);
  requireActive('inspectorId', inspector, Role.INSPECTOR);
  if (!inspector.homeWardId)
    throw new RosterRuleError('inspectorId', 'The inspector has no home ward');
  if (worker.homeWardId !== inspector.homeWardId) {
    throw new RosterRuleError('workerId', "The worker's home ward differs from the inspector's");
  }
  return inspector.homeWardId;
}

/** Placing an inspector in a ward for a day (assigned by a senior, or a self-pick). */
export function checkInspectorPlacement(inspector: PersonFacts): void {
  requireActive('staffId', inspector, Role.INSPECTOR);
}

/**
 * Placing a worker in an inspector's team for a day. The inspector must already be placed in a
 * ward that day; the worker follows that ward.
 */
export function checkWorkerPlacement(
  worker: PersonFacts,
  inspectorRow: AssignmentFacts | null,
): AssignmentFacts {
  requireActive('staffId', worker, Role.WORKER);
  if (!inspectorRow || inspectorRow.staffRole !== 'INSPECTOR') {
    throw new RosterRuleError('inspectorId', 'The inspector has no ward assignment for that day');
  }
  return inspectorRow;
}

/** Who may place someone else: ADMIN anywhere, WARD_INSPECTOR in their own ward. */
export function assignedMode(actor: AuthUser, wardId: string): AssignmentMode {
  if (!canManageWard(actor, wardId)) {
    throw new RosterRuleError('wardId', 'You can only assign within your own ward');
  }
  return actor.role === Role.ADMIN ? 'ADMIN_ASSIGNED' : 'WARD_INSPECTOR_ASSIGNED';
}

/** Self-service: an inspector picks a ward, a worker joins an inspector's team. Starts unapproved. */
export function selfServiceMode(actor: AuthUser): AssignmentMode {
  if (actor.role === Role.INSPECTOR) return 'INSPECTOR_SELF_PICK';
  if (actor.role === Role.WORKER) return 'WORKER_SELF_JOIN';
  throw new RosterRuleError('role', 'Only inspectors and workers use self-service assignment');
}

/**
 * Approvals: ADMIN any; WARD_INSPECTOR anything in their ward; INSPECTOR workers joining their
 * own team. Nobody approves their own row.
 */
export function canApprove(actor: AuthUser, row: AssignmentFacts): boolean {
  if (row.staffId === actor.staffId) return false;
  if (actor.role === Role.ADMIN) return true;
  if (actor.role === Role.WARD_INSPECTOR) return actor.homeWardId === row.wardId;
  if (actor.role === Role.INSPECTOR)
    return row.staffRole === 'WORKER' && row.inspectorId === actor.staffId;
  return false;
}

/** What a caller may list. */
export type AssignmentScope =
  | { kind: 'ALL' }
  | { kind: 'WARD'; wardId: string }
  | { kind: 'TEAM'; inspectorId: string }
  | { kind: 'SELF'; staffId: string }
  | { kind: 'NONE' };

export function assignmentScope(actor: AuthUser): AssignmentScope {
  switch (actor.role) {
    case Role.ADMIN:
      return { kind: 'ALL' };
    case Role.WARD_INSPECTOR:
      return actor.homeWardId ? { kind: 'WARD', wardId: actor.homeWardId } : { kind: 'NONE' };
    case Role.INSPECTOR:
      return { kind: 'TEAM', inspectorId: actor.staffId };
    case Role.WORKER:
      return { kind: 'SELF', staffId: actor.staffId };
    default:
      return { kind: 'NONE' };
  }
}

/** A standing squad row as the generator reads it. */
export interface StandingRow {
  wardId: string;
  wardInspectorId: string;
  inspectorId: string;
  workerId: string;
}

export interface PlannedAssignment {
  staffId: string;
  staffRole: AssignableRole;
  wardId: string;
  wardInspectorId: string;
  inspectorId: string;
}

/**
 * Turns active standing squads into the day's rows: one INSPECTOR row per inspector (in the
 * squad's ward) and one WORKER row per worker. Anyone already placed that day keeps their
 * placement; inactive people are left out. A worker whose inspector is already placed in
 * another ward is left for a supervisor to place by hand.
 */
export function planFromStandingRosters(
  rosters: readonly StandingRow[],
  alreadyPlaced: ReadonlyMap<string, { wardId: string; staffRole: AssignableRole }>,
  activeStaffIds: ReadonlySet<string>,
): PlannedAssignment[] {
  const planned: PlannedAssignment[] = [];
  const placed = new Map(alreadyPlaced);
  for (const r of rosters) {
    if (!activeStaffIds.has(r.inspectorId) || placed.has(r.inspectorId)) continue;
    planned.push({
      staffId: r.inspectorId,
      staffRole: 'INSPECTOR',
      wardId: r.wardId,
      wardInspectorId: r.wardInspectorId,
      inspectorId: r.inspectorId,
    });
    placed.set(r.inspectorId, { wardId: r.wardId, staffRole: 'INSPECTOR' });
  }
  for (const r of rosters) {
    if (!activeStaffIds.has(r.workerId) || placed.has(r.workerId)) continue;
    const lead = placed.get(r.inspectorId);
    if (!lead || lead.staffRole !== 'INSPECTOR' || lead.wardId !== r.wardId) continue;
    planned.push({
      staffId: r.workerId,
      staffRole: 'WORKER',
      wardId: r.wardId,
      wardInspectorId: r.wardInspectorId,
      inspectorId: r.inspectorId,
    });
    placed.set(r.workerId, { wardId: r.wardId, staffRole: 'WORKER' });
  }
  return planned;
}
