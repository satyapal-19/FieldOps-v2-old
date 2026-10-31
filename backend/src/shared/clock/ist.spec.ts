import { FixedClock } from './clock';
import { istDate, istWallClockToUtc } from './ist';

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
