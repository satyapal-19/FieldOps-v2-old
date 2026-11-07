import 'server-only';
import { cookies } from 'next/headers';
import { DEFAULT_LANG, isLang, LANG_COOKIE, type Lang } from '@/shared/i18n/lang';

/** The reader's language on the server (same cookie the client switch writes). */
export async function serverLocale(): Promise<{
  lang: Lang;
  pick(text: { en: string; mr?: string | null }): string;
}> {
  const saved = (await cookies()).get(LANG_COOKIE)?.value;
  const lang = isLang(saved) ? saved : DEFAULT_LANG;
  return { lang, pick: (text) => (lang === 'mr' && text.mr ? text.mr : text.en) };
}
