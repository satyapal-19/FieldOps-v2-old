import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { TaskStatus } from './entities/task.entity';
import {
  AssigneeAction,
  canSeeTask,
  canSupervise,
  checkCanAssign,
  checkReassignable,
  nextStatus,
  PersonFacts,
  SupervisorAction,
  TaskFacts,
  TaskRuleError,
  taskScope,
} from './tasks.policy';

const user = (role: StaffRole, homeWardId: string | null = 'w1', staffId = 'me'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});
const person = (
  role: StaffRole,
  homeWardId: string | null = 'w1',
  reportsToId: string | null = null,
  id = 'p',
  isActive = true,
): PersonFacts => ({ id, role, homeWardId, reportsToId, isActive });
const task = (fields: Partial<TaskFacts> = {}): TaskFacts => ({
  wardId: 'w1',
  assignedToId: 'p',
  createdById: 'creator',
  status: 'OPEN',
  ...fields,
});

describe('tasks.policy', () => {
  describe('checkCanAssign', () => {
    it.each<[string, AuthUser, PersonFacts, boolean]>([
      ['admin -> ward inspector', user(Role.ADMIN, null), person(Role.WARD_INSPECTOR), true],
      ['admin -> office staff', user(Role.ADMIN, null), person(Role.OFFICE_STAFF, null), true],
      ['admin -> another admin', user(Role.ADMIN, null), person(Role.ADMIN, null), false],
      ['ward inspector -> worker in ward', user(Role.WARD_INSPECTOR), person(Role.WORKER), true],
      [
        'ward inspector -> inspector in ward',
        user(Role.WARD_INSPECTOR),
        person(Role.INSPECTOR),
        true,
      ],
      [
        'ward inspector -> worker of another ward',
        user(Role.WARD_INSPECTOR),
        person(Role.WORKER, 'w2'),
        false,
      ],
      ['inspector -> own team worker', user(Role.INSPECTOR), person(Role.WORKER, 'w1', 'me'), true],
      [
        'inspector -> another team worker',
        user(Role.INSPECTOR),
        person(Role.WORKER, 'w1', 'x'),
        false,
      ],
      ['inspector -> inspector', user(Role.INSPECTOR), person(Role.INSPECTOR, 'w1', 'me'), false],
      ['worker -> worker', user(Role.WORKER), person(Role.WORKER), false],
      [
        'deactivated assignee',
        user(Role.ADMIN, null),
        person(Role.WORKER, 'w1', null, 'p', false),
        false,
      ],
      [
        'self',
        user(Role.WARD_INSPECTOR, 'w1', 'p'),
        person(Role.WARD_INSPECTOR, 'w1', null, 'p'),
        false,
      ],
    ])('%s -> %s', (_label, actor, assignee, ok) => {
      const check = () => checkCanAssign(actor, assignee);
      if (ok) expect(check).not.toThrow();
      else expect(check).toThrow(TaskRuleError);
    });
  });

  describe('canSupervise / canSeeTask', () => {
    const worker = person(Role.WORKER, 'w1', 'in1');
    it.each<[string, AuthUser, TaskFacts, boolean, boolean]>([
      ['admin', user(Role.ADMIN, null), task(), true, true],
      ['ward inspector of the ward', user(Role.WARD_INSPECTOR), task(), true, true],
      ['ward inspector of another ward', user(Role.WARD_INSPECTOR, 'w2'), task(), false, false],
      ['inspector who created it', user(Role.INSPECTOR, 'w1', 'creator'), task(), true, true],
      ["the assignee's inspector", user(Role.INSPECTOR, 'w1', 'in1'), task(), true, true],
      ['another inspector', user(Role.INSPECTOR, 'w1', 'in2'), task(), false, false],
      ['the assignee', user(Role.WORKER, 'w1', 'p'), task(), false, true],
      ['another worker', user(Role.WORKER, 'w1', 'w9'), task(), false, false],
    ])('%s -> supervise %s, see %s', (_label, actor, t, supervise, see) => {
      expect(canSupervise(actor, t, worker)).toBe(supervise);
      expect(canSeeTask(actor, t, worker)).toBe(see);
    });
  });

  describe('nextStatus', () => {
    it.each<[AssigneeAction | SupervisorAction, TaskStatus, TaskStatus | null]>([
      ['START', 'OPEN', 'IN_PROGRESS'],
      ['START', 'REJECTED', 'IN_PROGRESS'],
      ['START', 'SUBMITTED', null],
      ['SUBMIT', 'IN_PROGRESS', 'SUBMITTED'],
      ['SUBMIT', 'OPEN', null],
      ['APPROVE', 'SUBMITTED', 'APPROVED'],
      ['APPROVE', 'IN_PROGRESS', null],
      ['REJECT', 'SUBMITTED', 'REJECTED'],
      ['ESCALATE', 'IN_PROGRESS', 'ESCALATED'],
      ['ESCALATE', 'APPROVED', null],
      ['CLOSE', 'APPROVED', 'CLOSED'],
      ['CLOSE', 'OPEN', 'CLOSED'],
      ['CLOSE', 'SUBMITTED', null],
      ['CLOSE', 'CLOSED', null],
    ])('%s from %s -> %s', (action, from, to) => {
      if (to) expect(nextStatus(action, from)).toBe(to);
      else expect(() => nextStatus(action, from)).toThrow(TaskRuleError);
    });
  });

  it.each<[TaskStatus, boolean]>([
    ['OPEN', true],
    ['IN_PROGRESS', true],
    ['REJECTED', true],
    ['ESCALATED', true],
    ['SUBMITTED', false],
    ['APPROVED', false],
    ['CLOSED', false],
  ])('reassign a %s task -> %s', (status, ok) => {
    const check = () => checkReassignable(status);
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(TaskRuleError);
  });

  it.each<[StaffRole, string]>([
    [Role.ADMIN, 'ALL'],
    [Role.WARD_INSPECTOR, 'WARD'],
    [Role.INSPECTOR, 'TEAM'],
    [Role.WORKER, 'MINE'],
    [Role.OFFICE_STAFF, 'MINE'],
  ])('taskScope %s -> %s', (role, kind) => {
    expect(taskScope(user(role)).kind).toBe(kind);
  });
});
