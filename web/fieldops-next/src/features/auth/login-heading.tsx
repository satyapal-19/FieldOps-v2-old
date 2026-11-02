'use client';

import { useLocale } from '@/shared/i18n/locale';

export function LoginHeading() {
  const { t } = useLocale();
  return (
    <header className="mb-6">
      <p className="text-sm text-slate-500">{t('corporation')}</p>
      <h1 className="mt-1 text-xl font-semibold text-smkc">{t('staffSignIn')}</h1>
      <p className="mt-2 text-sm text-slate-600">{t('staffSignInHint')}</p>
    </header>
  );
}
