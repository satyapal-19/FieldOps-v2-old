/** Today's date in IST (Asia/Kolkata) as YYYY-MM-DD, matching the API's attendance dates. */
export function istToday(now = new Date()): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Kolkata' }).format(now);
}

/** A UTC timestamp shown in IST. */
export function istDateTime(iso: string, lang: 'en' | 'mr'): string {
  return new Intl.DateTimeFormat(lang === 'mr' ? 'mr-IN' : 'en-IN', {
    timeZone: 'Asia/Kolkata',
    dateStyle: 'medium',
    timeStyle: 'short',
  }).format(new Date(iso));
}

/** The IST clock time (HH:MM) of a UTC timestamp; '—' when missing. */
export function istTime(iso: string | null | undefined): string {
  if (!iso) return '—';
  return new Intl.DateTimeFormat('en-GB', {
    timeZone: 'Asia/Kolkata',
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  }).format(new Date(iso));
}

/** Minutes as h:mm (e.g. 485 -> 8:05); '—' when missing. */
export function hoursMinutes(minutes: number | null | undefined): string {
  if (minutes === null || minutes === undefined) return '—';
  return `${Math.floor(minutes / 60)}:${String(minutes % 60).padStart(2, '0')}`;
}

/** YYYY-MM-DD shifted by whole days (calendar arithmetic, no time zone involved). */
export function addDays(date: string, days: number): string {
  const d = new Date(`${date}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + days);
  return d.toISOString().slice(0, 10);
}
