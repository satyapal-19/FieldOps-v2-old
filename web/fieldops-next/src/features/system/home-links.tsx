'use client';

import Link from 'next/link';
import { useLocale } from '@/shared/i18n/locale';
import { LanguageSwitch } from '@/shared/ui/language-switch';

export function HomeLinks() {
  const { t } = useLocale();
  return (
    <header>
      <div className="flex items-start justify-between gap-4">
        <div>
          <p className="text-sm text-slate-500">{t('corporation')}</p>
          <h1 className="mt-1 text-2xl font-semibold text-smkc">{t('appName')}</h1>
        </div>
        <LanguageSwitch />
      </div>
      <div className="mt-6 flex flex-wrap gap-3">
        <Link href="/login" className="rounded-md bg-smkc px-4 py-2 font-medium text-white hover:bg-smkc-light">
          {t('staffSignIn')}
        </Link>
        <Link href="/citizen" className="btn-secondary px-4 py-2 text-base">
          {t('citizenPortal')}
        </Link>
      </div>
    </header>
  );
}
