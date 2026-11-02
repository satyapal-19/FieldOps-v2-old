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
