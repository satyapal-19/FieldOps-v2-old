/**
 * India Standard Time helpers. IST is a fixed UTC+05:30 offset with no daylight saving,
 * so conversions are exact. Store UTC; use these only for shift dates and display.
 */
export const IST_TIME_ZONE = 'Asia/Kolkata';
const IST_OFFSET = '+05:30';

const dateFormatter = new Intl.DateTimeFormat('en-CA', {
  timeZone: IST_TIME_ZONE,
  year: 'numeric',
  month: '2-digit',
  day: '2-digit',
});

/** The IST calendar date of an instant, as YYYY-MM-DD. */
export function istDate(instant: Date): string {
  return dateFormatter.format(instant);
}

/** The UTC instant of an IST wall-clock time, e.g. ('2026-10-28', '06:00') -> 00:30Z. */
export function istWallClockToUtc(date: string, time: string): Date {
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || !/^\d{2}:\d{2}(:\d{2})?$/.test(time)) {
    throw new Error(`Invalid IST date/time: ${date} ${time}`);
  }
  const withSeconds = time.length === 5 ? `${time}:00` : time;
  const result = new Date(`${date}T${withSeconds}${IST_OFFSET}`);
  if (Number.isNaN(result.getTime())) {
    throw new Error(`Invalid IST date/time: ${date} ${time}`);
  }
  return result;
}

/** A calendar date `days` later (or earlier when negative), as YYYY-MM-DD. */
export function addDays(date: string, days: number): string {
  const d = new Date(`${date}T00:00:00Z`);
  if (!/^\d{4}-\d{2}-\d{2}$/.test(date) || Number.isNaN(d.getTime())) {
    throw new Error(`Invalid date: ${date}`);
  }
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}
