import { checkHolidayDate, HolidayRuleError, isValidDate, yearRange } from './holidays.policy';

describe('holidays.policy', () => {
  it.each<[string, boolean]>([
    ['2026-11-08', true],
    ['2028-02-29', true],
    ['2026-02-29', false],
    ['2026-13-01', false],
    ['08-11-2026', false],
  ])('isValidDate(%s) -> %s', (date, ok) => {
    expect(isValidDate(date)).toBe(ok);
  });

  it.each<[string, boolean]>([
    ['2026-11-02', true],
    ['2027-01-26', true],
    ['2026-11-01', false],
    ['2026-02-30', false],
  ])('checkHolidayDate(%s) with today 2026-11-02 -> ok %s', (date, ok) => {
    const check = () => checkHolidayDate(date, '2026-11-02');
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(HolidayRuleError);
  });

  it('builds a year range', () => {
    expect(yearRange(2027)).toEqual({ from: '2027-01-01', to: '2027-12-31' });
  });
});
