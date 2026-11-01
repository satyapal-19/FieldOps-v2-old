import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { AssignableRole } from './roster-types';
import {
  AssignmentFacts,
  assignedMode,
  assignmentScope,
  canApprove,
  canManageWard,
  checkAssignmentDate,
  checkInspectorPlacement,
  checkStandingRoster,
  checkWorkerPlacement,
  PersonFacts,
  planFromStandingRosters,
  RosterRuleError,
  selfServiceMode,
} from './rosters.policy';

const user = (role: StaffRole, homeWardId: string | null = 'w1', staffId = 'me'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});
const person = (
  id: string,
  role: StaffRole,
  homeWardId: string | null = 'w1',
  isActive = true,
): PersonFacts => ({
  id,
  role,
  homeWardId,
  isActive,
});
const row = (fields: Partial<AssignmentFacts> = {}): AssignmentFacts => ({
  id: 'a1',
  staffId: 'wk',
  staffRole: 'WORKER',
  wardId: 'w1',
  wardInspectorId: 'wi',
  inspectorId: 'in',
  isApproved: false,
  ...fields,
});

describe('rosters.policy', () => {
  describe('checkAssignmentDate (today 2026-11-02 IST)', () => {
    it.each<[string, boolean, boolean]>([
      ['2026-11-02', false, true],
      ['2026-12-03', false, true],
      ['2026-12-04', false, false],
      ['2026-11-01', false, false],
      ['2026-11-03', true, true],
      ['2026-11-04', true, false],
      ['2026-11-01', true, false],
      ['02-11-2026', false, false],
      ['2026-02-30', false, false],
    ])('%s (self: %s) -> %s', (date, self, ok) => {
      const check = () => checkAssignmentDate(date, '2026-11-02', self);
      if (ok) expect(check).not.toThrow();
      else expect(check).toThrow(RosterRuleError);
    });
  });

  it.each<[AuthUser, string, boolean]>([
    [user(Role.ADMIN, null), 'w9', true],
    [user(Role.WARD_INSPECTOR), 'w1', true],
    [user(Role.WARD_INSPECTOR), 'w2', false],
    [user(Role.INSPECTOR), 'w1', false],
  ])('canManageWard %#', (actor, wardId, expected) => {
    expect(canManageWard(actor, wardId)).toBe(expected);
  });

  describe('checkStandingRoster', () => {
    it.each<[string, PersonFacts, PersonFacts, string | null]>([
      ['same-ward pair', person('wk', Role.WORKER), person('in', Role.INSPECTOR), 'w1'],
      ['different wards', person('wk', Role.WORKER, 'w2'), person('in', Role.INSPECTOR), null],
      ['worker is an inspector', person('wk', Role.INSPECTOR), person('in', Role.INSPECTOR), null],
      [
        'lead is a ward inspector',
        person('wk', Role.WORKER),
        person('in', Role.WARD_INSPECTOR),
        null,
      ],
      [
        'deactivated worker',
        person('wk', Role.WORKER, 'w1', false),
        person('in', Role.INSPECTOR),
        null,
      ],
      [
        'inspector without a ward',
        person('wk', Role.WORKER, null),
        person('in', Role.INSPECTOR, null),
        null,
      ],
    ])('%s', (_label, worker, inspector, ward) => {
      if (ward) expect(checkStandingRoster(worker, inspector)).toBe(ward);
      else expect(() => checkStandingRoster(worker, inspector)).toThrow(RosterRuleError);
    });
  });

  it('places only active inspectors', () => {
    expect(() => checkInspectorPlacement(person('in', Role.INSPECTOR))).not.toThrow();
    expect(() => checkInspectorPlacement(person('in', Role.WORKER))).toThrow(RosterRuleError);
    expect(() => checkInspectorPlacement(person('in', Role.INSPECTOR, 'w1', false))).toThrow(
      RosterRuleError,
    );
  });

  it('places a worker only under an inspector placed that day', () => {
    const lead = row({ staffId: 'in', staffRole: 'INSPECTOR', inspectorId: 'in' });
    expect(checkWorkerPlacement(person('wk', Role.WORKER), lead)).toBe(lead);
    expect(() => checkWorkerPlacement(person('wk', Role.WORKER), null)).toThrow(RosterRuleError);
    expect(() => checkWorkerPlacement(person('wk', Role.WORKER), row())).toThrow(RosterRuleError);
    expect(() => checkWorkerPlacement(person('wk', Role.INSPECTOR), lead)).toThrow(RosterRuleError);
  });

  it.each<[AuthUser, string, string | null]>([
    [user(Role.ADMIN, null), 'w5', 'ADMIN_ASSIGNED'],
    [user(Role.WARD_INSPECTOR), 'w1', 'WARD_INSPECTOR_ASSIGNED'],
    [user(Role.WARD_INSPECTOR), 'w2', null],
    [user(Role.INSPECTOR), 'w1', null],
  ])('assignedMode %#', (actor, wardId, mode) => {
    if (mode) expect(assignedMode(actor, wardId)).toBe(mode);
    else expect(() => assignedMode(actor, wardId)).toThrow(RosterRuleError);
  });

  it.each<[StaffRole, string | null]>([
    [Role.INSPECTOR, 'INSPECTOR_SELF_PICK'],
    [Role.WORKER, 'WORKER_SELF_JOIN'],
    [Role.WARD_INSPECTOR, null],
    [Role.ADMIN, null],
    [Role.OFFICE_STAFF, null],
  ])('selfServiceMode %s', (role, mode) => {
    if (mode) expect(selfServiceMode(user(role))).toBe(mode);
    else expect(() => selfServiceMode(user(role))).toThrow(RosterRuleError);
  });

  describe('canApprove', () => {
    it.each<[string, AuthUser, AssignmentFacts, boolean]>([
      ['admin, anything', user(Role.ADMIN, null), row({ wardId: 'w9' }), true],
      ['ward inspector, own ward', user(Role.WARD_INSPECTOR), row(), true],
      ['ward inspector, other ward', user(Role.WARD_INSPECTOR), row({ wardId: 'w2' }), false],
      ['inspector, worker joining own team', user(Role.INSPECTOR, 'w1', 'in'), row(), true],
      ['inspector, worker joining another team', user(Role.INSPECTOR, 'w1', 'in2'), row(), false],
      [
        'inspector, an inspector row',
        user(Role.INSPECTOR, 'w1', 'in'),
        row({ staffRole: 'INSPECTOR' }),
        false,
      ],
      ['worker, anything', user(Role.WORKER), row(), false],
      ['own row, even as admin', user(Role.ADMIN, null, 'wk'), row(), false],
    ])('%s -> %s', (_label, actor, r, expected) => {
      expect(canApprove(actor, r)).toBe(expected);
    });
  });

  it.each<[StaffRole, string]>([
    [Role.ADMIN, 'ALL'],
    [Role.WARD_INSPECTOR, 'WARD'],
    [Role.INSPECTOR, 'TEAM'],
    [Role.WORKER, 'SELF'],
    [Role.OFFICE_STAFF, 'NONE'],
  ])('assignmentScope %s -> %s', (role, kind) => {
    expect(assignmentScope(user(role)).kind).toBe(kind);
  });

  describe('planFromStandingRosters', () => {
    const squad = (inspectorId: string, workerId: string, wardId = 'w1') => ({
      wardId,
      wardInspectorId: 'wi',
      inspectorId,
      workerId,
    });
    const active = new Set(['in1', 'in2', 'wk1', 'wk2', 'wk3']);
    const none = new Map<string, { wardId: string; staffRole: AssignableRole }>();

    it('creates one inspector row per squad lead and one row per worker', () => {
      const plan = planFromStandingRosters(
        [squad('in1', 'wk1'), squad('in1', 'wk2'), squad('in2', 'wk3', 'w2')],
        none,
        active,
      );
      expect(plan.map((p) => `${p.staffRole}:${p.staffId}:${p.wardId}`)).toEqual([
        'INSPECTOR:in1:w1',
        'INSPECTOR:in2:w2',
        'WORKER:wk1:w1',
        'WORKER:wk2:w1',
        'WORKER:wk3:w2',
      ]);
    });

    it('keeps existing placements and skips inactive people', () => {
      const placed = new Map<string, { wardId: string; staffRole: AssignableRole }>([
        ['wk1', { wardId: 'w3', staffRole: 'WORKER' }],
      ]);
      const plan = planFromStandingRosters(
        [squad('in1', 'wk1'), squad('in1', 'wk2'), squad('in1', 'gone')],
        placed,
        active,
      );
      expect(plan.map((p) => p.staffId)).toEqual(['in1', 'wk2']);
    });

    it('leaves workers alone when their inspector was moved to another ward that day', () => {
      const placed = new Map<string, { wardId: string; staffRole: AssignableRole }>([
        ['in1', { wardId: 'w7', staffRole: 'INSPECTOR' }],
      ]);
      expect(planFromStandingRosters([squad('in1', 'wk1')], placed, active)).toEqual([]);
    });
  });
});
