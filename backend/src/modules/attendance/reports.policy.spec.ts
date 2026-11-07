import { Role } from '../../shared/auth/roles';
import { checkReportRange, liveState, reportWard } from './reports.policy';

const at = (iso: string) => new Date(iso);

describe('liveState', () => {
  const now = at('2026-11-02T05:00:00Z');
  it.each([
    ['seen 5 minutes ago', '2026-11-02T04:55:00Z', false, 'ACTIVE'],
    ['seen 14:59 ago', '2026-11-02T04:45:01Z', false, 'ACTIVE'],
    ['seen 15 minutes ago', '2026-11-02T04:45:00Z', false, 'STALE'],
    ['seen 29 minutes ago', '2026-11-02T04:31:00Z', false, 'STALE'],
    ['seen 30 minutes ago', '2026-11-02T04:30:00Z', false, 'SILENT'],
    ['fresh, but a silent gap is open', '2026-11-02T04:59:00Z', true, 'SILENT'],
    ['no ping since check-in', null, false, 'NO_SIGNAL'],
  ])('%s -> %s', (_case, seen, gap, expected) => {
    expect(liveState(seen ? at(seen) : null, now, gap)).toBe(expected);
  });
});

describe('checkReportRange', () => {
  const today = '2026-11-02';
  it.each([
    ['one day', '2026-11-01', '2026-11-01', null],
    ['up to today', '2026-10-01', today, null],
    ['exactly 92 days', '2026-08-03', today, null],
    ['93 days', '2026-08-02', today, 'TOO_LONG'],
    ['reversed', '2026-11-02', '2026-11-01', 'FROM_AFTER_TO'],
    ['ends tomorrow', '2026-11-01', '2026-11-03', 'IN_FUTURE'],
  ])('%s', (_case, from, to, expected) => {
    expect(checkReportRange(from, to, today)).toBe(expected);
  });
});

describe('reportWard', () => {
  it.each([
    ['admin, all wards', Role.ADMIN, null, undefined, { wardId: null }],
    ['admin, one ward', Role.ADMIN, null, 'w2', { wardId: 'w2' }],
    ['ward inspector, own ward by default', Role.WARD_INSPECTOR, 'w1', undefined, { wardId: 'w1' }],
    ['ward inspector, asks own ward', Role.WARD_INSPECTOR, 'w1', 'w1', { wardId: 'w1' }],
    ['ward inspector, asks another ward', Role.WARD_INSPECTOR, 'w1', 'w2', 'FORBIDDEN'],
    ['ward inspector without a ward', Role.WARD_INSPECTOR, null, undefined, 'FORBIDDEN'],
    ['inspector', Role.INSPECTOR, 'w1', undefined, 'FORBIDDEN'],
    ['office staff', Role.OFFICE_STAFF, null, undefined, 'FORBIDDEN'],
  ] as const)('%s', (_case, role, home, asked, expected) => {
    expect(reportWard({ role, homeWardId: home }, asked)).toEqual(expected);
  });
});
