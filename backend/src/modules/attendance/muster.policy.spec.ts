import { buildMuster, monthDays, musterCsv } from './muster.policy';

describe('monthDays', () => {
  it.each([
    ['2026-11', 30],
    ['2026-02', 28],
    ['2028-02', 29],
    ['2026-12', 31],
  ])('%s has %i days', (month, n) => {
    const days = monthDays(month)!;
    expect(days).toHaveLength(n);
    expect(days[0]).toBe(`${month}-01`);
  });

  it.each(['2026-13', '2026-1', 'nov', ''])('refuses %p', (month) => {
    expect(monthDays(month)).toBeNull();
  });
});

describe('buildMuster', () => {
  const days = ['2026-11-01', '2026-11-02', '2026-11-03', '2026-11-04'];
  const people = [
    { staffId: 'b', employeeCode: 'SMK-WK-02', name: 'Worker Two', role: 'WORKER' },
    { staffId: 'a', employeeCode: 'SMK-WK-01', name: 'Worker, One', role: 'WORKER' },
  ];
  const rows = buildMuster(days, people, [
    { staffId: 'a', date: '2026-11-01', status: 'PRESENT' },
    { staffId: 'a', date: '2026-11-02', status: 'LATE' },
    { staffId: 'a', date: '2026-11-03', status: 'HALF_DAY' },
    { staffId: 'a', date: '2026-11-04', status: 'ABSENT' },
    { staffId: 'b', date: '2026-11-02', status: 'ON_LEAVE' },
    { staffId: 'b', date: '2026-11-03', status: 'REGULARIZED' },
  ]);

  it('sorts by employee code and codes every day', () => {
    expect(rows.map((r) => r.staffId)).toEqual(['a', 'b']);
    expect(rows[0].cells).toEqual(['P', 'L', 'H', 'A']);
    expect(rows[1].cells).toEqual(['-', 'LV', 'R', '-']);
  });

  it('totals present (a half day is half), absent, leave and late days', () => {
    expect(rows[0]).toMatchObject({ presentDays: 2.5, absentDays: 1, leaveDays: 0, lateDays: 1 });
    expect(rows[1]).toMatchObject({ presentDays: 1, absentDays: 0, leaveDays: 1, lateDays: 0 });
  });

  it('writes CSV with quoted names and the legend', () => {
    const csv = musterCsv('Ward 4 · November 2026', days, rows).split('\r\n');
    expect(csv[1]).toBe('Code,Name,Role,01,02,03,04,Present,Absent,Leave,Late');
    expect(csv[2]).toBe('SMK-WK-01,"Worker, One",WORKER,P,L,H,A,2.5,1,0,1');
    expect(csv[csv.length - 1]).toContain('LV = On leave');
  });
});
