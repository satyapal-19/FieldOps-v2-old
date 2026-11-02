import { FixedClock } from './clock';
import { addDays, istDate, istWallClockToUtc } from './ist';

describe('IST helpers', () => {
  it.each([
    // [utc instant, expected IST date]
    ['2026-10-27T18:29:59Z', '2026-10-27'], // 23:59:59 IST
    ['2026-10-27T18:30:00Z', '2026-10-28'], // 00:00 IST next day
    ['2026-10-28T00:30:00Z', '2026-10-28'], // 06:00 IST
  ])('istDate(%s) = %s', (utc, expected) => {
    expect(istDate(new Date(utc))).toBe(expected);
  });

  it('converts IST wall-clock time to the UTC instant', () => {
    expect(istWallClockToUtc('2026-10-28', '06:00').toISOString()).toBe('2026-10-28T00:30:00.000Z');
    expect(istWallClockToUtc('2026-10-28', '06:15:59').toISOString()).toBe(
      '2026-10-28T00:45:59.000Z',
    );
  });

  it('rejects malformed input', () => {
    expect(() => istWallClockToUtc('28-10-2026', '06:00')).toThrow();
    expect(() => istWallClockToUtc('2026-10-28', '6am')).toThrow();
  });
});

describe('FixedClock', () => {
  it('returns the frozen time and can move forward', () => {
    const clock = new FixedClock('2026-10-28T00:30:00Z');
    expect(clock.now().toISOString()).toBe('2026-10-28T00:30:00.000Z');
    clock.advanceMinutes(16);
    expect(clock.now().toISOString()).toBe('2026-10-28T00:46:00.000Z');
  });

  it('hands out copies, so callers cannot change its time', () => {
    const clock = new FixedClock('2026-10-28T00:30:00Z');
    const t = clock.now();
    t.setUTCFullYear(2000);
    expect(clock.now().getUTCFullYear()).toBe(2026);
  });
});

describe('addDays', () => {
  it.each([
    ['2026-11-02', 1, '2026-11-03'],
    ['2026-11-02', -1, '2026-11-01'],
    ['2026-03-01', -1, '2026-02-28'],
    ['2028-03-01', -1, '2028-02-29'],
    ['2026-12-31', 1, '2027-01-01'],
    ['2026-11-02', -90, '2026-08-04'],
  ])('%s %+d = %s', (date, days, expected) => {
    expect(addDays(date, days)).toBe(expected);
  });

  it('rejects a malformed date', () => {
    expect(() => addDays('2026-13-40', 1)).toThrow(/Invalid date/);
  });
});
