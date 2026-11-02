'use client';

import { useLocale } from '@/shared/i18n/locale';

export function LanguageSwitch({ className = '' }: { className?: string }) {
  const { lang, setLang, t } = useLocale();
  return (
    <button
      type="button"
      onClick={() => setLang(lang === 'mr' ? 'en' : 'mr')}
      className={`rounded-md border border-slate-300 px-2 py-1 text-sm hover:bg-slate-100 ${className}`}
    >
      {t('language')}
    </button>
  );
}
