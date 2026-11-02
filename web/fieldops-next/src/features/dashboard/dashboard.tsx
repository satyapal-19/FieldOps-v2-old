'use client';

import { useQueries, useQuery } from '@tanstack/react-query';
import { api, unwrap } from '@/api/client';
import type { WebRole } from '@/shared/auth/route-table';
import type { UiKey } from '@/shared/i18n/ui-text';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime, istToday } from '@/shared/ist';
import { ErrorBanner } from '@/shared/ui/error-banner';

const STATUS_TILES = [
  { status: 'PRESENT', label: 'present' },
  { status: 'LATE', label: 'late' },
  { status: 'HALF_DAY', label: 'halfDay' },
  { status: 'ABSENT', label: 'absent' },
] as const satisfies readonly { status: string; label: UiKey }[];

const ALERT_ROLES: readonly WebRole[] = ['ADMIN', 'WARD_INSPECTOR'];

/** Today in the user's scope: attendance counts by status and the open alert queue. */
export function Dashboard({ role }: { role: WebRole }) {
  const { t, lang, pick } = useLocale();
  const today = istToday();

  const counts = useQueries({
    queries: STATUS_TILES.map((tile) => ({
      queryKey: ['attendance', 'count', today, tile.status],
      queryFn: () =>
        unwrap(
          api.GET('/api/v1/attendance', {
            params: { query: { from: today, to: today, status: tile.status, pageSize: 1 } },
          }),
        ).then((page) => page.total),
      refetchInterval: 60_000,
    })),
  });

  const alerts = useQuery({
    queryKey: ['alerts', 'open', 'latest'],
    queryFn: () => unwrap(api.GET('/api/v1/alerts', { params: { query: { isResolved: false, pageSize: 5 } } })),
    enabled: ALERT_ROLES.includes(role),
    refetchInterval: 60_000,
  });

  const failed = counts.find((c) => c.isError);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-xl font-semibold text-smkc">{t('today')}</h1>
        <p className="text-sm text-slate-500">{today}</p>
      </div>
      {failed ? <ErrorBanner error={failed.error} onRetry={() => counts.forEach((c) => c.refetch())} /> : null}
      <section className="grid grid-cols-2 gap-3 md:grid-cols-4">
        {STATUS_TILES.map((tile, i) => (
          <div key={tile.status} className="rounded-lg border border-slate-200 bg-white p-4">
            <p className="text-sm text-slate-500">{t(tile.label)}</p>
            <p className="mt-1 text-2xl font-semibold">{counts[i].data ?? (counts[i].isPending ? '…' : '–')}</p>
          </div>
        ))}
      </section>
      {ALERT_ROLES.includes(role) ? (
        <section className="rounded-lg border border-slate-200 bg-white p-4">
          <h2 className="font-medium">
            {t('latestAlerts')}
            {alerts.data ? <span className="ml-2 text-sm text-slate-500">({alerts.data.total})</span> : null}
          </h2>
          {alerts.isError ? <ErrorBanner error={alerts.error} onRetry={() => alerts.refetch()} /> : null}
          {alerts.isPending ? <p className="mt-2 text-sm text-slate-500">{t('loading')}</p> : null}
          {alerts.data && alerts.data.items.length === 0 ? (
            <p className="mt-2 text-sm text-slate-500">{t('noOpenAlerts')}</p>
          ) : null}
          <ul className="mt-2 divide-y divide-slate-100">
            {alerts.data?.items.map((a) => (
              <li key={a.id} className="flex items-start justify-between gap-3 py-2 text-sm">
                <span>
                  <span className="mr-2 rounded bg-slate-100 px-1.5 py-0.5 text-xs font-medium">{a.severity}</span>
                  {pick({ en: a.message, mr: a.messageMr })}
                </span>
                <span className="whitespace-nowrap text-xs text-slate-500">{istDateTime(a.triggeredAt, lang)}</span>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </div>
  );
}
