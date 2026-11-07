import { Role, type StaffRole } from '../../shared/auth/roles';
import {
  canMessageDirectly,
  canPost,
  channelsFor,
  CITY_KEY,
  directKey,
  type ChatFacts,
  type DirectTarget,
} from './chat.policy';

const today = '2026-11-02';
const facts = (role: StaffRole, fields: Partial<ChatFacts> = {}): ChatFacts => ({
  staffId: 'me',
  role,
  homeWardId: 'w1',
  dayWardId: null,
  dayInspectorId: null,
  ...fields,
});

describe('channelsFor', () => {
  it.each([
    [
      'inspector placed today: own squad + ward',
      facts(Role.INSPECTOR, { dayWardId: 'w2' }),
      ['S:me:2026-11-02', 'W:w2'],
    ],
    ['inspector not placed: home ward broadcast', facts(Role.INSPECTOR), ['W:w1']],
    [
      'worker in a team today',
      facts(Role.WORKER, { dayWardId: 'w1', dayInspectorId: 'in1' }),
      ['S:in1:2026-11-02'],
    ],
    ['worker not placed today', facts(Role.WORKER), []],
    ['ward inspector', facts(Role.WARD_INSPECTOR), ['W:w1', CITY_KEY]],
    ['admin', facts(Role.ADMIN, { homeWardId: null }), [CITY_KEY]],
    ['office staff', facts(Role.OFFICE_STAFF, { homeWardId: null }), []],
  ])('%s', (_case, f, keys) => {
    expect(channelsFor(f, today).map((c) => c.key)).toEqual(keys);
  });
});

describe('canPost', () => {
  it.each([
    ['SQUAD_TEAM', Role.WORKER, true],
    ['DIRECT', Role.WORKER, true],
    ['WARD_BROADCAST', Role.WARD_INSPECTOR, true],
    ['WARD_BROADCAST', Role.INSPECTOR, false],
    ['CITY_BROADCAST', Role.WARD_INSPECTOR, false],
    ['CITY_BROADCAST', Role.ADMIN, true],
  ] as const)('%s by %s: %s', (type, role, expected) => {
    expect(canPost(type, role)).toBe(expected);
  });
});

describe('canMessageDirectly', () => {
  const me = (
    role: StaffRole,
    reportsToId: string | null = null,
    homeWardId: string | null = 'w1',
  ) => ({
    staffId: 'me',
    role,
    homeWardId,
    reportsToId,
  });
  const target = (role: StaffRole, fields: Partial<DirectTarget> = {}): DirectTarget => ({
    id: 'them',
    role,
    homeWardId: 'w1',
    reportsToId: null,
    ...fields,
  });
  it.each([
    ['worker to own inspector', me(Role.WORKER, 'them'), target(Role.INSPECTOR), true],
    [
      'inspector to own worker',
      me(Role.INSPECTOR),
      target(Role.WORKER, { reportsToId: 'me' }),
      true,
    ],
    [
      'worker to the ward inspector of the ward',
      me(Role.WORKER),
      target(Role.WARD_INSPECTOR),
      true,
    ],
    ['worker to another worker', me(Role.WORKER), target(Role.WORKER), false],
    [
      'inspector to an inspector of another ward',
      me(Role.INSPECTOR),
      target(Role.WORKER, { homeWardId: 'w2' }),
      false,
    ],
    [
      'ward inspector to the admin',
      me(Role.WARD_INSPECTOR),
      target(Role.ADMIN, { homeWardId: null }),
      true,
    ],
    [
      'worker straight to the admin',
      me(Role.WORKER),
      target(Role.ADMIN, { homeWardId: null }),
      false,
    ],
    [
      'admin to anyone',
      me(Role.ADMIN, null, null),
      target(Role.WORKER, { homeWardId: 'w9' }),
      true,
    ],
  ])('%s: %s', (_case, actor, t, expected) => {
    expect(canMessageDirectly(actor, t)).toBe(expected);
  });

  it('builds one key for a pair, whoever starts', () => {
    expect(directKey('b', 'a')).toBe(directKey('a', 'b'));
  });
});
