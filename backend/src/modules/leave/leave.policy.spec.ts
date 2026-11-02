import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import type { LeaveType, ReviewStatus } from './entities/leave-request.entity';
import {
  canReview,
  checkCancellable,
  checkLeaveDates,
  checkRegularizationDate,
  checkReviewable,
  LeaveRuleError,
  rangesOverlap,
  RequesterFacts,
  requestScope,
} from './leave.policy';

const TODAY = '2026-11-02';
const user = (role: StaffRole, homeWardId: string | null = 'w1', staffId = 'me'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});
const requester = (
  role: StaffRole,
  homeWardId: string | null = 'w1',
  reportsToId: string | null = null,
  id = 'r',
): RequesterFacts => ({
  id,
  role,
  homeWardId,
  reportsToId,
});

describe('leave.policy', () => {
  describe('checkLeaveDates (today 2026-11-02)', () => {
    it.each<[LeaveType, string, string, number | null]>([
      ['CASUAL', '2026-11-02', '2026-11-02', 1],
      ['CASUAL', '2026-11-05', '2026-11-07', 3],
      ['EARNED', '2026-11-10', '2026-12-10', 31],
      ['EARNED', '2026-11-10', '2026-12-11', null],
      ['CASUAL', '2026-11-01', '2026-11-03', null],
      ['SICK', '2026-10-26', '2026-10-27', 2],
      ['SICK', '2026-10-25', '2026-10-27', null],
      ['CASUAL', '2026-11-07', '2026-11-05', null],
      ['CASUAL', '2026-02-30', '2026-03-01', null],
    ])('%s %s..%s -> %s days', (type, from, to, days) => {
      const check = () => checkLeaveDates(type, from, to, TODAY);
      if (days === null) expect(check).toThrow(LeaveRuleError);
      else expect(check()).toBe(days);
    });
  });

  it.each<[string, string, string, string, boolean]>([
    ['2026-11-05', '2026-11-07', '2026-11-07', '2026-11-09', true],
    ['2026-11-05', '2026-11-07', '2026-11-08', '2026-11-09', false],
    ['2026-11-05', '2026-11-30', '2026-11-10', '2026-11-11', true],
  ])('rangesOverlap %s..%s with %s..%s -> %s', (af, at, bf, bt, expected) => {
    expect(rangesOverlap({ from: af, to: at }, { from: bf, to: bt })).toBe(expected);
  });

  it.each<[string, boolean]>([
    ['2026-11-01', true],
    ['2026-10-26', true],
    ['2026-10-25', false],
    ['2026-11-02', false],
    ['2026-11-03', false],
  ])('checkRegularizationDate %s -> ok %s', (date, ok) => {
    const check = () => checkRegularizationDate(date, TODAY);
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(LeaveRuleError);
  });

  describe('canReview', () => {
    it.each<[string, AuthUser, RequesterFacts, boolean]>([
      ['admin, anyone', user(Role.ADMIN, null), requester(Role.WARD_INSPECTOR), true],
      ['admin, themselves', user(Role.ADMIN, null, 'r'), requester(Role.ADMIN, null), false],
      ['ward inspector, worker in ward', user(Role.WARD_INSPECTOR), requester(Role.WORKER), true],
      [
        'ward inspector, inspector in ward',
        user(Role.WARD_INSPECTOR),
        requester(Role.INSPECTOR),
        true,
      ],
      [
        'ward inspector, worker of another ward',
        user(Role.WARD_INSPECTOR),
        requester(Role.WORKER, 'w2'),
        false,
      ],
      [
        'ward inspector, office staff',
        user(Role.WARD_INSPECTOR),
        requester(Role.OFFICE_STAFF, null),
        false,
      ],
      [
        'inspector, own direct report',
        user(Role.INSPECTOR),
        requester(Role.WORKER, 'w1', 'me'),
        true,
      ],
      [
        'inspector, worker of another inspector',
        user(Role.INSPECTOR),
        requester(Role.WORKER, 'w1', 'x'),
        false,
      ],
      [
        'inspector, another inspector',
        user(Role.INSPECTOR),
        requester(Role.INSPECTOR, 'w1', 'me'),
        false,
      ],
      ['worker, anyone', user(Role.WORKER), requester(Role.WORKER), false],
    ])('%s -> %s', (_label, actor, req, expected) => {
      expect(canReview(actor, req)).toBe(expected);
    });
  });

  it.each<[StaffRole, string]>([
    [Role.ADMIN, 'ALL'],
    [Role.WARD_INSPECTOR, 'WARD'],
    [Role.INSPECTOR, 'REPORTS'],
    [Role.WORKER, 'SELF'],
    [Role.OFFICE_STAFF, 'SELF'],
  ])('requestScope %s -> %s', (role, kind) => {
    expect(requestScope(user(role)).kind).toBe(kind);
  });

  it.each<ReviewStatus>(['APPROVED', 'REJECTED', 'CANCELLED'])(
    'a %s request cannot be reviewed again',
    (status) => {
      expect(() => checkReviewable(status)).toThrow(LeaveRuleError);
      expect(() => checkReviewable('PENDING')).not.toThrow();
    },
  );

  it.each<[ReviewStatus, string | null, boolean]>([
    ['PENDING', '2026-11-01', true],
    ['APPROVED', '2026-11-03', true],
    ['APPROVED', '2026-11-02', false],
    ['REJECTED', '2026-11-10', false],
    ['APPROVED', null, false],
  ])('checkCancellable %s from %s -> ok %s', (status, from, ok) => {
    const check = () => checkCancellable(status, from, TODAY);
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(LeaveRuleError);
  });
});
