/**
 * Pure task rules (v4 §8): who may assign to whom, who may see and act on a task, and the
 * status machine. No database, no clock. Test with plain tables of inputs.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { outranks, Role, StaffRole } from '../../shared/auth/roles';
import type { TaskStatus } from './entities/task.entity';

export class TaskRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

export interface PersonFacts {
  id: string;
  role: StaffRole;
  homeWardId: string | null;
  reportsToId: string | null;
  isActive: boolean;
}

/** The facts about a task these rules need. */
export interface TaskFacts {
  wardId: string | null;
  assignedToId: string | null;
  createdById: string;
  status: TaskStatus;
}

/**
 * Work flows down the hierarchy:
 * - ADMIN: anyone below them
 * - WARD_INSPECTOR: inspectors and workers of their own ward
 * - INSPECTOR: workers who report to them
 * The assignee must be active.
 */
export function checkCanAssign(actor: AuthUser, assignee: PersonFacts): void {
  if (!assignee.isActive) throw new TaskRuleError('assignedToId', 'This person is deactivated');
  if (assignee.id === actor.staffId)
    throw new TaskRuleError('assignedToId', 'Assign the task to someone in your team');
  if (!outranks(actor.role, assignee.role)) {
    throw new TaskRuleError(
      'assignedToId',
      `A ${actor.role} cannot assign work to a ${assignee.role}`,
    );
  }
  if (actor.role === Role.ADMIN) return;
  if (actor.role === Role.WARD_INSPECTOR) {
    if (!actor.homeWardId || assignee.homeWardId !== actor.homeWardId) {
      throw new TaskRuleError('assignedToId', 'You can only assign work within your ward');
    }
    return;
  }
  if (actor.role === Role.INSPECTOR) {
    if (assignee.reportsToId !== actor.staffId) {
      throw new TaskRuleError('assignedToId', 'You can only assign work to your own team');
    }
    return;
  }
  throw new TaskRuleError('assignedToId', `A ${actor.role} does not assign tasks`);
}

/**
 * Supervisors of a task (review, reassign, close): ADMIN; the ward inspector of the task's ward;
 * the inspector who created it or whose team member holds it. Never the assignee themself.
 */
export function canSupervise(
  actor: AuthUser,
  task: TaskFacts,
  assignee: PersonFacts | null,
): boolean {
  if (task.assignedToId === actor.staffId) return false;
  if (actor.role === Role.ADMIN) return true;
  if (actor.role === Role.WARD_INSPECTOR)
    return actor.homeWardId !== null && task.wardId === actor.homeWardId;
  if (actor.role === Role.INSPECTOR) {
    return (
      task.createdById === actor.staffId ||
      (assignee !== null && assignee.reportsToId === actor.staffId)
    );
  }
  return false;
}

/** The assignee and the supervisors can see a task. */
export function canSeeTask(
  actor: AuthUser,
  task: TaskFacts,
  assignee: PersonFacts | null,
): boolean {
  return task.assignedToId === actor.staffId || canSupervise(actor, task, assignee);
}

export type AssigneeAction = 'START' | 'SUBMIT';
export type SupervisorAction = 'APPROVE' | 'REJECT' | 'ESCALATE' | 'CLOSE';

/**
 * The status machine.
 *   assignee:   START  OPEN | REJECTED -> IN_PROGRESS      SUBMIT  IN_PROGRESS -> SUBMITTED
 *   supervisor: APPROVE  SUBMITTED -> APPROVED             REJECT  SUBMITTED -> REJECTED (reason)
 *               ESCALATE OPEN | IN_PROGRESS | REJECTED -> ESCALATED
 *               CLOSE    OPEN | APPROVED | ESCALATED -> CLOSED (closing OPEN = cancel)
 */
const TRANSITIONS: Record<
  AssigneeAction | SupervisorAction,
  { from: readonly TaskStatus[]; to: TaskStatus }
> = {
  START: { from: ['OPEN', 'REJECTED'], to: 'IN_PROGRESS' },
  SUBMIT: { from: ['IN_PROGRESS'], to: 'SUBMITTED' },
  APPROVE: { from: ['SUBMITTED'], to: 'APPROVED' },
  REJECT: { from: ['SUBMITTED'], to: 'REJECTED' },
  ESCALATE: { from: ['OPEN', 'IN_PROGRESS', 'REJECTED'], to: 'ESCALATED' },
  CLOSE: { from: ['OPEN', 'APPROVED', 'ESCALATED'], to: 'CLOSED' },
};

export function nextStatus(
  action: AssigneeAction | SupervisorAction,
  current: TaskStatus,
): TaskStatus {
  const t = TRANSITIONS[action];
  if (!t.from.includes(current)) {
    throw new TaskRuleError('status', `Cannot ${action.toLowerCase()} a task that is ${current}`);
  }
  return t.to;
}

/** Reassigning puts the task back to OPEN; finished tasks stay with whoever did them. */
export function checkReassignable(current: TaskStatus): void {
  if (current === 'SUBMITTED' || current === 'APPROVED' || current === 'CLOSED') {
    throw new TaskRuleError('status', `A ${current} task cannot be reassigned`);
  }
}

/** What a caller may list. */
export type TaskScope =
  | { kind: 'ALL' }
  | { kind: 'WARD'; wardId: string }
  | { kind: 'TEAM'; inspectorId: string }
  | { kind: 'MINE' };

export function taskScope(actor: AuthUser): TaskScope {
  if (actor.role === Role.ADMIN) return { kind: 'ALL' };
  if (actor.role === Role.WARD_INSPECTOR && actor.homeWardId)
    return { kind: 'WARD', wardId: actor.homeWardId };
  if (actor.role === Role.INSPECTOR) return { kind: 'TEAM', inspectorId: actor.staffId };
  return { kind: 'MINE' };
}
