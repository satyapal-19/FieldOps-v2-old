/**
 * Pure holiday rules. No database, no clock - "today" is passed in.
 */
export class HolidayRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

const DATE = /^\d{4}-\d{2}-\d{2}$/;

export function isValidDate(date: string): boolean {
  if (!DATE.test(date)) return false;
  const d = new Date(`${date}T00:00:00Z`);
  return !Number.isNaN(d.getTime()) && d.toISOString().slice(0, 10) === date;
}

/**
 * Holidays are set for today or later: a past holiday already decided that day's attendance
 * (HOLIDAY_OFF), so changing it would rewrite history.
 */
export function checkHolidayDate(date: string, todayIst: string): void {
  if (!isValidDate(date)) throw new HolidayRuleError('date', 'Date must be a real YYYY-MM-DD date');
  if (date < todayIst)
    throw new HolidayRuleError('date', 'Past holidays cannot be added, changed or removed');
}

/** A calendar year as the list filter: [YYYY-01-01, YYYY-12-31]. */
export function yearRange(year: number): { from: string; to: string } {
  return { from: `${year}-01-01`, to: `${year}-12-31` };
}
