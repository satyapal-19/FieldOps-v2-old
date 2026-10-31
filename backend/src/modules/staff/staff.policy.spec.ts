import { Role } from '../../shared/auth/roles';
import {
  checkStaffLinks,
  maskPhone,
  normalizeEmployeeCode,
  normalizePhone,
  parseShiftTime,
  StaffRuleError,
} from './staff.policy';

describe('staff.policy', () => {
  it.each([
    ['9812345678', '9812345678'],
    ['+91 98123 45678', '9812345678'],
    ['919812345678', '9812345678'],
    ['09812345678', '9812345678'],
    ['(981) 234-5678', '9812345678'],
  ])('normalizes phone %s', (input, expected) => {
    expect(normalizePhone(input)).toBe(expected);
  });

  it.each(['12345', '5812345678', '98123456789', 'abcdefghij', ''])('rejects phone %s', (input) => {
    expect(() => normalizePhone(input)).toThrow(StaffRuleError);
  });

  it('masks phones', () => {
    expect(maskPhone('9812345678')).toBe('******5678');
  });

  it('normalizes employee codes', () => {
    expect(normalizeEmployeeCode(' smk-w-0042 ')).toBe('SMK-W-0042');
    expect(() => normalizeEmployeeCode('a')).toThrow(StaffRuleError);
    expect(() => normalizeEmployeeCode('bad code')).toThrow(StaffRuleError);
  });

  it('validates shift times', () => {
    expect(parseShiftTime('shiftStart', '06:00')).toBe('06:00');
    expect(() => parseShiftTime('shiftStart', '6:00')).toThrow(StaffRuleError);
    expect(() => parseShiftTime('shiftStart', '24:00')).toThrow(StaffRuleError);
  });

  it.each([
    [Role.ADMIN, null, null, true],
    [Role.ADMIN, 'w1', null, false],
    [Role.WARD_INSPECTOR, 'w1', null, true],
    [Role.WARD_INSPECTOR, null, null, false],
    [Role.INSPECTOR, 'w1', null, true],
    [Role.WORKER, 'w1', 'o1', false],
    [Role.WORKER, null, null, false],
    [Role.OFFICE_STAFF, null, 'o1', true],
    [Role.OFFICE_STAFF, 'w1', 'o1', false],
    [Role.OFFICE_STAFF, null, null, false],
  ] as const)('links for %s ward=%s office=%s ok=%s', (role, homeWardId, officeId, ok) => {
    const check = () => checkStaffLinks({ role, homeWardId, officeId });
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(StaffRuleError);
  });
});
