import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { TaskStatus } from '../tasks/entities/task.entity';
import type { ComplaintStatus } from './entities/citizen-complaint.entity';
import {
  canManageComplaint,
  canSeeCitizenPhone,
  canSeeComplaint,
  ComplaintAction,
  ComplaintRuleError,
  complaintScope,
  formatTrackingId,
  nextComplaintStatus,
  normalizeTrackingId,
  publicStatus,
} from './complaints.policy';

const user = (role: StaffRole, homeWardId: string | null = 'w1'): AuthUser => ({
  staffId: 'me',
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});

describe('complaints.policy', () => {
  it('formats tracking IDs without confusable characters', () => {
    expect(formatTrackingId(2026, [0, 1, 2, 29, 30, 31])).toBe('SMK-2026-ABC789');
    expect(formatTrackingId(2026, [32, 33, 0, 0, 0, 0])).toBe('SMK-2026-ABAAAA');
    expect(() => formatTrackingId(2026, [1, 2])).toThrow();
  });

  it.each<[string, string | null]>([
    ['SMK-2026-ABC789', 'SMK-2026-ABC789'],
    ['  smk-2026-abc789 ', 'SMK-2026-ABC789'],
    ['SMK-2026-ABC0O1', null],
    ['SMK-26-ABC789', null],
    ["SMK-2026-ABC789' OR 1=1", null],
  ])('normalizeTrackingId(%s) -> %s', (input, expected) => {
    expect(normalizeTrackingId(input)).toBe(expected);
  });

  it.each<[StaffRole, string]>([
    [Role.ADMIN, 'ALL'],
    [Role.OFFICE_STAFF, 'ALL'],
    [Role.WARD_INSPECTOR, 'WARD'],
    [Role.INSPECTOR, 'WARD'],
    [Role.WORKER, 'NONE'],
  ])('complaintScope %s -> %s', (role, kind) => {
    expect(complaintScope(user(role)).kind).toBe(kind);
  });

  it.each<[StaffRole, string | null, boolean, boolean]>([
    [Role.ADMIN, null, true, true],
    [Role.OFFICE_STAFF, 'w1', true, false],
    [Role.WARD_INSPECTOR, 'w1', true, true],
    [Role.WARD_INSPECTOR, 'w2', false, false],
    [Role.WARD_INSPECTOR, null, false, false],
    [Role.INSPECTOR, 'w1', true, false],
    [Role.WORKER, 'w1', false, false],
  ])('%s on a complaint in %s -> see %s, manage %s', (role, wardId, see, manage) => {
    expect(canSeeComplaint(user(role), wardId)).toBe(see);
    expect(canManageComplaint(user(role), wardId)).toBe(manage);
  });

  it.each<[StaffRole, boolean]>([
    [Role.ADMIN, true],
    [Role.WARD_INSPECTOR, true],
    [Role.OFFICE_STAFF, true],
    [Role.INSPECTOR, false],
  ])('citizen phone visible to %s -> %s', (role, expected) => {
    expect(canSeeCitizenPhone(user(role))).toBe(expected);
  });

  describe('nextComplaintStatus', () => {
    it.each<[ComplaintAction, ComplaintStatus, TaskStatus[], ComplaintStatus | null]>([
      ['ASSIGN', 'RECEIVED', [], 'ASSIGNED'],
      ['ASSIGN', 'ASSIGNED', ['OPEN'], 'ASSIGNED'],
      ['ASSIGN', 'RESOLVED', [], null],
      ['RESOLVE', 'ASSIGNED', ['APPROVED'], 'RESOLVED'],
      ['RESOLVE', 'ASSIGNED', ['OPEN', 'CLOSED'], 'RESOLVED'],
      ['RESOLVE', 'ASSIGNED', ['SUBMITTED'], null],
      ['RESOLVE', 'RECEIVED', ['APPROVED'], null],
      ['REJECT', 'RECEIVED', [], 'REJECTED'],
      ['REJECT', 'ASSIGNED', [], null],
      ['CLOSE', 'RESOLVED', [], 'CLOSED'],
      ['CLOSE', 'REJECTED', [], 'CLOSED'],
      ['CLOSE', 'ASSIGNED', [], null],
    ])('%s from %s with tasks %j -> %s', (action, from, tasks, to) => {
      if (to) expect(nextComplaintStatus(action, from, tasks)).toBe(to);
      else expect(() => nextComplaintStatus(action, from, tasks)).toThrow(ComplaintRuleError);
    });
  });

  it.each<[ComplaintStatus, TaskStatus[], ComplaintStatus]>([
    ['RECEIVED', [], 'RECEIVED'],
    ['ASSIGNED', ['OPEN'], 'ASSIGNED'],
    ['ASSIGNED', ['IN_PROGRESS'], 'IN_PROGRESS'],
    ['ASSIGNED', ['OPEN', 'SUBMITTED'], 'IN_PROGRESS'],
    ['RESOLVED', ['CLOSED'], 'RESOLVED'],
  ])('public status of %s with tasks %j -> %s', (status, tasks, expected) => {
    expect(publicStatus(status, tasks)).toBe(expected);
  });
});
