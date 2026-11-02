/** Language settings shared by server and client code. */
export const LANGS = ['en', 'mr'] as const;
export type Lang = (typeof LANGS)[number];
export const LANG_COOKIE = 'fo_lang';
/** Marathi first: SMKMC's working language (users switch to English in the header). */
export const DEFAULT_LANG: Lang = 'mr';

export function isLang(value: string | undefined): value is Lang {
  return value === 'en' || value === 'mr';
}
