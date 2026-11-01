import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import { StaffRuleError } from '../staff/staff.policy';
import {
  canSeeFullPhone,
  canViewStaff,
  changesNeedSignOut,
  checkPasswordAllowed,
  checkReportsTo,
  StaffFacts,
  staffListScope,
} from './staff-admin.policy';

const user = (role: StaffRole, homeWardId: string | null = 'w1', staffId = 'me'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});

const staff = (
  role: StaffRole,
  homeWardId: string | null = 'w1',
  id = 'other',
  isActive = true,
): StaffFacts => ({
  id,
  role,
  homeWardId,
  reportsToId: null,
  isActive,
});

describe('staff-admin.policy', () => {
  describe('staffListScope', () => {
    it.each<[string, AuthUser, ReturnType<typeof staffListScope>]>([
      ['admin sees all', user(Role.ADMIN, null), { kind: 'ALL' }],
      ['ward inspector sees their ward', user(Role.WARD_INSPECTOR), { kind: 'WARD', wardId: 'w1' }],
      [
        'inspector sees ward workers and self',
        user(Role.INSPECTOR),
        { kind: 'WARD', wardId: 'w1', roles: [Role.WORKER], alsoStaffId: 'me' },
      ],
      ['inspector without a ward sees nobody', user(Role.INSPECTOR, null), { kind: 'NONE' }],
      ['worker sees nobody', user(Role.WORKER), { kind: 'NONE' }],
      ['office staff see nobody', user(Role.OFFICE_STAFF, null), { kind: 'NONE' }],
    ])('%s', (_label, actor, expected) => {
      expect(staffListScope(actor)).toEqual(expected);
    });
  });

  describe('canViewStaff', () => {
    it.each<[string, AuthUser, StaffFacts, boolean]>([
      ['admin, anyone', user(Role.ADMIN, null), staff(Role.WARD_INSPECTOR, 'w9'), true],
      ['ward inspector, worker in own ward', user(Role.WARD_INSPECTOR), staff(Role.WORKER), true],
      [
        'ward inspector, inspector in own ward',
        user(Role.WARD_INSPECTOR),
        staff(Role.INSPECTOR),
        true,
      ],
      [
        'ward inspector, worker in another ward',
        user(Role.WARD_INSPECTOR),
        staff(Role.WORKER, 'w2'),
        false,
      ],
      ['inspector, worker in own ward', user(Role.INSPECTOR), staff(Role.WORKER), true],
      ['inspector, another inspector', user(Role.INSPECTOR), staff(Role.INSPECTOR), false],
      ['inspector, worker in another ward', user(Role.INSPECTOR), staff(Role.WORKER, 'w2'), false],
      ['worker, another worker', user(Role.WORKER), staff(Role.WORKER), false],
      ['worker, themselves', user(Role.WORKER), staff(Role.WORKER, 'w1', 'me'), true],
      [
        'office staff, themselves',
        user(Role.OFFICE_STAFF, null),
        staff(Role.OFFICE_STAFF, null, 'me'),
        true,
      ],
    ])('%s -> %s', (_label, actor, target, expected) => {
      expect(canViewStaff(actor, target)).toBe(expected);
    });
  });

  it.each<[StaffRole, string, boolean]>([
    [Role.ADMIN, 'other', true],
    [Role.WARD_INSPECTOR, 'other', false],
    [Role.WORKER, 'me', true],
  ])('full phone for %s viewing %s -> %s', (role, targetId, expected) => {
    expect(canSeeFullPhone(user(role), targetId)).toBe(expected);
  });

  describe('checkReportsTo', () => {
    const person = (role: StaffRole, homeWardId: string | null = 'w1') => ({
      id: 'p',
      role,
      homeWardId,
    });
    it.each<[string, ReturnType<typeof person>, StaffFacts | null, boolean]>([
      ['worker -> inspector, same ward', person(Role.WORKER), staff(Role.INSPECTOR), true],
      ['worker -> inspector, other ward', person(Role.WORKER), staff(Role.INSPECTOR, 'w2'), false],
      [
        'worker -> ward inspector (skips a rank)',
        person(Role.WORKER),
        staff(Role.WARD_INSPECTOR),
        false,
      ],
      ['inspector -> ward inspector', person(Role.INSPECTOR), staff(Role.WARD_INSPECTOR), true],
      ['ward inspector -> admin', person(Role.WARD_INSPECTOR), staff(Role.ADMIN, null), true],
      ['office staff -> admin', person(Role.OFFICE_STAFF, null), staff(Role.ADMIN, null), true],
      [
        'office staff -> ward inspector',
        person(Role.OFFICE_STAFF, null),
        staff(Role.WARD_INSPECTOR),
        false,
      ],
      ['admin -> anyone', person(Role.ADMIN, null), staff(Role.ADMIN, null), false],
      ['deactivated manager', person(Role.WORKER), staff(Role.INSPECTOR, 'w1', 'm', false), false],
      ['self as manager', person(Role.INSPECTOR), staff(Role.WARD_INSPECTOR, 'w1', 'p'), false],
      ['no manager yet', person(Role.WORKER), null, true],
    ])('%s', (_label, p, manager, ok) => {
      const check = () => checkReportsTo(p, manager);
      if (ok) expect(check).not.toThrow();
      else expect(check).toThrow(StaffRuleError);
    });
  });

  it.each<[StaffRole, boolean, boolean]>([
    [Role.ADMIN, true, true],
    [Role.WARD_INSPECTOR, true, true],
    [Role.OFFICE_STAFF, true, true],
    [Role.WORKER, true, false],
    [Role.INSPECTOR, true, false],
    [Role.WORKER, false, true],
  ])('password for %s (given: %s) allowed -> %s', (role, hasPassword, ok) => {
    const check = () => checkPasswordAllowed(role, hasPassword);
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(StaffRuleError);
  });

  describe('changesNeedSignOut', () => {
    const before = {
      role: Role.WORKER as StaffRole,
      homeWardId: 'w1',
      officeId: null,
      phone: '9812345678',
    };
    it.each<[string, Partial<typeof before & { isActive: boolean }>, boolean]>([
      ['name-only change', {}, false],
      ['deactivated', { isActive: false }, true],
      ['role changed', { role: Role.INSPECTOR }, true],
      ['ward changed', { homeWardId: 'w2' }, true],
      ['phone changed', { phone: '9812345679' }, true],
    ])('%s -> %s', (_label, change, expected) => {
      expect(changesNeedSignOut(before, { ...before, isActive: true, ...change })).toBe(expected);
    });
  });
});
