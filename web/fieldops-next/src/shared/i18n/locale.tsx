'use client';

import { createContext, useCallback, useContext, useMemo, useState, type ReactNode } from 'react';
import { LANG_COOKIE, type Lang } from './lang';
import { UI_TEXT, type UiKey } from './ui-text';

export type { Lang } from './lang';

export type Bilingual = { en: string; mr: string };

interface LocaleValue {
  lang: Lang;
  setLang(lang: Lang): void;
  /** A fixed UI string in the current language. */
  t(key: UiKey): string;
  /** Picks the current language from a pair (Marathi falls back to English when empty). */
  pick(text: { en: string; mr?: string | null }): string;
}

const LocaleContext = createContext<LocaleValue | null>(null);

/** Marathi / English for every page. The choice is a plain cookie so the server renders it too. */
export function LocaleProvider({ initial, children }: { initial: Lang; children: ReactNode }) {
  const [lang, setLangState] = useState<Lang>(initial);
  const setLang = useCallback((next: Lang) => {
    document.cookie = `${LANG_COOKIE}=${next}; path=/; max-age=31536000; samesite=lax`;
    document.documentElement.lang = next;
    setLangState(next);
  }, []);
  const value = useMemo<LocaleValue>(
    () => ({
      lang,
      setLang,
      t: (key) => UI_TEXT[key][lang],
      pick: (text) => (lang === 'mr' && text.mr ? text.mr : text.en),
    }),
    [lang, setLang],
  );
  return <LocaleContext.Provider value={value}>{children}</LocaleContext.Provider>;
}

export function useLocale(): LocaleValue {
  const value = useContext(LocaleContext);
  if (!value) throw new Error('useLocale needs <LocaleProvider>');
  return value;
}
