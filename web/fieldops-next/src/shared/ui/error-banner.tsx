'use client';

import { ApiError } from '@/api/client';
import { errorText } from '@/shared/i18n/error-text';
import { useLocale } from '@/shared/i18n/locale';

/** An API failure in the user's language, with the request ID to quote when reporting it. */
export function ErrorBanner({ error, onRetry }: { error: unknown; onRetry?: () => void }) {
  const { lang, t } = useLocale();
  const problem = error instanceof ApiError ? error.problem : null;
  const code = problem?.code ?? 'INTERNAL_ERROR';
  return (
    <div role="alert" className="rounded-md border border-red-200 bg-red-50 p-4 text-sm text-red-800">
      <p className="font-medium">{errorText(code, lang, problem?.title)}</p>
      {problem?.requestId ? (
        <p className="mt-1 font-mono text-xs text-red-700">
          {t('requestId')}: {problem.requestId}
        </p>
      ) : null}
      {onRetry ? (
        <button type="button" onClick={onRetry} className="mt-2 font-medium underline">
          {t('retry')}
        </button>
      ) : null}
    </div>
  );
}
