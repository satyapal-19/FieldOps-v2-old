'use client';

import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useState, type ReactNode } from 'react';
import { ApiError } from '@/api/client';
import { LocaleProvider, type Lang } from '@/shared/i18n/locale';

export function Providers({ lang, children }: { lang: Lang; children: ReactNode }) {
  const [queryClient] = useState(
    () =>
      new QueryClient({
        defaultOptions: {
          queries: {
            staleTime: 15_000,
            refetchOnWindowFocus: false,
            // Retry only failures that may pass on a second try (network, 5xx, 429).
            retry: (count, error) =>
              count < 2 && (!(error instanceof ApiError) || error.problem.status >= 500 || error.problem.status === 429),
          },
        },
      }),
  );
  return (
    <LocaleProvider initial={lang}>
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    </LocaleProvider>
  );
}
