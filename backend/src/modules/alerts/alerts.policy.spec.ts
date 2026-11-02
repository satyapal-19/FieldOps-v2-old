import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, StaffRole } from '../../shared/auth/roles';
import {
  AlertFacts,
  alertScope,
  AlertRuleError,
  canHandleAlert,
  checkResolvable,
  dedupeKey,
} from './alerts.policy';

const user = (role: StaffRole, homeWardId: string | null = 'w1', staffId = 'me'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});
const alert = (fields: Partial<AlertFacts> = {}): AlertFacts => ({
  wardId: 'w1',
  staffId: 'wk',
  staffManagerId: 'in1',
  ...fields,
});

describe('alerts.policy', () => {
  it.each<[StaffRole, string]>([
    [Role.ADMIN, 'ALL'],
    [Role.WARD_INSPECTOR, 'WARD'],
    [Role.INSPECTOR, 'REPORTS'],
    [Role.WORKER, 'NONE'],
    [Role.OFFICE_STAFF, 'NONE'],
  ])('alertScope %s -> %s', (role, kind) => {
    expect(alertScope(user(role)).kind).toBe(kind);
  });

  it.each<[string, AuthUser, AlertFacts, boolean]>([
    ['admin', user(Role.ADMIN, null), alert({ wardId: 'w9' }), true],
    ['ward inspector, own ward', user(Role.WARD_INSPECTOR), alert(), true],
    ['ward inspector, other ward', user(Role.WARD_INSPECTOR, 'w2'), alert(), false],
    ["the worker's inspector", user(Role.INSPECTOR, 'w1', 'in1'), alert(), true],
    ['another inspector', user(Role.INSPECTOR, 'w1', 'in2'), alert(), false],
    [
      'the person the alert is about',
      user(Role.INSPECTOR, 'w1', 'wk'),
      alert({ staffManagerId: 'wk' }),
      false,
    ],
    ['a worker', user(Role.WORKER), alert(), false],
  ])('%s -> %s', (_label, actor, a, expected) => {
    expect(canHandleAlert(actor, a)).toBe(expected);
  });

  it('refuses to resolve twice', () => {
    expect(() => checkResolvable(true)).toThrow(AlertRuleError);
    expect(() => checkResolvable(false)).not.toThrow();
  });

  it('builds stable dedupe keys', () => {
    expect(dedupeKey('LATE_CHECKIN', 'abc', '2026-11-02')).toBe('LATE_CHECKIN:abc:2026-11-02');
    expect(dedupeKey('OUT_OF_ZONE', null, '2026-11-02')).toBe('OUT_OF_ZONE:none:2026-11-02');
  });
});
