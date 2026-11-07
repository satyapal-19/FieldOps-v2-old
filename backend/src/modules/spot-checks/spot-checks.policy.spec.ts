import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, type StaffRole } from '../../shared/auth/roles';
import {
  canCheck,
  fractionsFromDigest,
  planRandomCheck,
  spotTransition,
  SpotRuleError,
  type SpotTarget,
} from './spot-checks.policy';

const at = (iso: string) => new Date(iso);

describe('fractionsFromDigest', () => {
  it('reads two fractions in [0, 1) from the first eight bytes', () => {
    expect(fractionsFromDigest(Uint8Array.from([0, 0, 0, 0, 0x80, 0, 0, 0]))).toEqual([0, 0.5]);
    const [a, b] = fractionsFromDigest(Uint8Array.from([255, 255, 255, 255, 255, 255, 255, 255]));
    expect(a).toBeLessThan(1);
    expect(b).toBeLessThan(1);
  });
});

describe('planRandomCheck', () => {
  // Shift 06:00-14:00 IST = 00:30Z-08:30Z, checked in at 00:30Z: window 01:00Z-08:00Z (7 h).
  const checkin = at('2026-11-02T00:30:00Z');
  const end = at('2026-11-02T08:30:00Z');
  const early = at('2026-11-02T00:40:00Z');
  it.each([
    ['not picked (pick >= rate)', 0.5, 0.5, 0.3, early, null],
    ['picked, start of the window', 0.1, 0, 0.3, early, '2026-11-02T01:00:00.000Z'],
    ['picked, middle of the window', 0.1, 0.5, 0.3, early, '2026-11-02T04:30:00.000Z'],
    ['rate 0 is off', 0, 0.5, 0, early, null],
    [
      'planned time already past: now',
      0.1,
      0,
      0.3,
      at('2026-11-02T03:00:00Z'),
      '2026-11-02T03:00:00.000Z',
    ],
    ['window already over', 0.1, 0.5, 0.3, at('2026-11-02T08:10:00Z'), null],
  ] as const)('%s', (_case, pick, frac, rate, now, expected) => {
    expect(planRandomCheck(pick, frac, rate, checkin, end, now)?.toISOString() ?? null).toBe(
      expected,
    );
  });

  it('gives no check in a shift shorter than the two margins', () => {
    expect(planRandomCheck(0, 0.5, 1, checkin, at('2026-11-02T01:20:00Z'), early)).toBeNull();
  });
});

describe('spotTransition', () => {
  const now = at('2026-11-02T05:00:00Z');
  const due = (min: number) => new Date(now.getTime() + min * 60_000);
  const check = (
    status: Parameters<typeof spotTransition>[0]['status'],
    snoozeCount = 0,
    dueAt: Date | null = due(5),
  ) => ({
    status,
    snoozeCount,
    dueAt,
  });
  it.each([
    ['notify a scheduled check', check('SCHEDULED', 0, null), 'NOTIFY', 'NOTIFIED'],
    ['snooze once', check('NOTIFIED'), 'SNOOZE', 'SNOOZED'],
    ['answer in time', check('SNOOZED', 1), 'RESPOND', 'SNOOZED'],
    ['expire after the deadline', check('NOTIFIED', 0, due(-1)), 'EXPIRE', 'MISSED'],
    ['cancel a scheduled one (person left)', check('SCHEDULED', 0, null), 'CANCEL', 'CANCELLED'],
  ] as const)('%s', (_case, c, action, expected) => {
    expect(spotTransition(c, action, now)).toBe(expected);
  });

  it.each([
    ['snooze twice', check('SNOOZED', 1), 'SNOOZE', 'SNOOZE_USED'],
    ['answer too late', check('NOTIFIED', 0, due(-1)), 'RESPOND', 'CLOSED'],
    ['answer before being notified', check('SCHEDULED', 0, null), 'RESPOND', 'TOO_EARLY'],
    ['answer a verified check again', check('VERIFIED'), 'RESPOND', 'CLOSED'],
    ['expire one still in time', check('NOTIFIED'), 'EXPIRE', 'CLOSED'],
    ['notify twice', check('NOTIFIED'), 'NOTIFY', 'CLOSED'],
  ] as const)('refuses: %s', (_case, c, action, reason) => {
    expect(() => spotTransition(c, action, now)).toThrow(new SpotRuleError(reason));
  });
});

describe('canCheck', () => {
  const user = (role: StaffRole, staffId = 'me', homeWardId: string | null = 'w1'): AuthUser => ({
    staffId,
    role,
    sessionId: 's',
    homeWardId,
    officeId: null,
  });
  const target = (fields: Partial<SpotTarget> = {}): SpotTarget => ({
    id: 'wk',
    homeWardId: 'w1',
    reportsToId: 'in1',
    dayWardId: 'w1',
    dayInspectorId: 'in1',
    ...fields,
  });
  it.each([
    ['admin', user(Role.ADMIN, 'adm', null), target(), true],
    [
      'ward inspector of the ward they work in today',
      user(Role.WARD_INSPECTOR, 'wi'),
      target({ homeWardId: 'w9' }),
      true,
    ],
    [
      'ward inspector of their home ward, working elsewhere today',
      user(Role.WARD_INSPECTOR, 'wi'),
      target({ dayWardId: 'w2' }),
      false,
    ],
    ['their inspector', user(Role.INSPECTOR, 'in1'), target(), true],
    [
      'inspector they are placed under today',
      user(Role.INSPECTOR, 'in2'),
      target({ dayInspectorId: 'in2' }),
      true,
    ],
    ['another inspector', user(Role.INSPECTOR, 'in3'), target(), false],
    ['a worker', user(Role.WORKER, 'wk2'), target(), false],
    ['nobody checks themselves', user(Role.ADMIN, 'wk', null), target(), false],
  ])('%s: %s', (_case, actor, t, expected) => {
    expect(canCheck(actor, t)).toBe(expected);
  });
});
