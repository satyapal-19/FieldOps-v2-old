'use client';

import { useQuery } from '@tanstack/react-query';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import { useRouter, useSearchParams } from 'next/navigation';
import { useMemo, useState } from 'react';
import { api, unwrap } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';
import { addDays, hoursMinutes, istTime, istToday } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import type { MapPoint } from '@/shared/map/route-map';
import { polygonRing } from '@/shared/map/tiles';
import { Badge } from '@/shared/ui/badge';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';

const RouteMap = dynamic(() => import('@/shared/map/route-map'), {
  ssr: false,
  loading: () => <div className="h-[420px] animate-pulse rounded-lg bg-slate-200" />,
});

const MAX_ACCURACY_M = 50;

/** One person's route on a day: map with playback, the day's summary and tamper events. */
export function RouteView() {
  const { t, pick } = useLocale();
  const router = useRouter();
  const params = useSearchParams();
  const staffId = params.get('staffId') ?? '';
  const date = params.get('date') ?? istToday();
  const [cursor, setCursor] = useState<number | null>(null);
  const names = useStaffNames([staffId]);
  const L = (en: string, mr: string) => pick({ en, mr });

  const route = useQuery({
    queryKey: ['route', staffId, date],
    enabled: !!staffId,
    queryFn: () => unwrap(api.GET('/api/v1/staff/{id}/route', { params: { path: { id: staffId }, query: { date } } })),
  });
  const wardId = route.data?.shift?.wardId;
  const ward = useQuery({
    queryKey: ['wards', 'one', wardId],
    enabled: !!wardId,
    staleTime: 30 * 60_000,
    queryFn: () => unwrap(api.GET('/api/v1/wards/{id}', { params: { path: { id: wardId! } } })),
  });

  const points: MapPoint[] = useMemo(
    () =>
      (route.data?.points ?? []).map((p) => ({
        latitude: p.latitude,
        longitude: p.longitude,
        label: `${istTime(p.recordedAt)}${p.accuracyM !== null ? ` ±${Math.round(p.accuracyM)} m` : ''}`,
        isMocked: p.isMocked,
        inWard: p.inWard,
      })),
    [route.data],
  );
  const pathPoints = useMemo(
    () =>
      points.filter((_, i) => {
        const p = route.data!.points[i];
        return !p.isMocked && (p.accuracyM === null || p.accuracyM <= MAX_ACCURACY_M);
      }),
    [points, route.data],
  );
  const boundary = useMemo(() => polygonRing(ward.data?.boundary), [ward.data]);

  const go = (nextDate: string) => {
    setCursor(null);
    router.replace(`/attendance/route?staffId=${staffId}&date=${nextDate}`);
  };

  if (!staffId) {
    return <p className="text-sm text-slate-500">{L('Open a route from the attendance list.', 'हजेरी यादीतून मार्ग उघडा.')}</p>;
  }
  const s = route.data?.summary;

  return (
    <div className="space-y-4">
      <PageHeader
        title={L('Route', 'मार्ग')}
        subtitle={`${names.name(staffId)} · ${date}`}
        actions={
          <Link href="/attendance" className="btn-secondary">
            {L('Back to attendance', 'हजेरीकडे परत')}
          </Link>
        }
      />
      <div className="flex flex-wrap items-end gap-2">
        <button type="button" className="btn-secondary" onClick={() => go(addDays(date, -1))}>
          ‹ {t('previous')}
        </button>
        <Field label={t('date')}>
          <TextInput type="date" value={date} max={istToday()} onChange={(e) => e.target.value && go(e.target.value)} />
        </Field>
        <button type="button" className="btn-secondary" disabled={date >= istToday()} onClick={() => go(addDays(date, 1))}>
          {t('next')} ›
        </button>
      </div>
      {route.isError ? <ErrorBanner error={route.error} onRetry={() => route.refetch()} /> : null}
      {route.data?.pointsPurged ? (
        <p className="rounded-md bg-amber-50 p-3 text-sm text-amber-900">
          {L(
            'The raw location points for this day are past the retention period and were deleted; the nightly summary is shown.',
            'या दिवसाचे मूळ ठिकाण-बिंदू साठवण मुदतीनंतर हटवले आहेत; रात्रीचा सारांश दाखवला आहे.',
          )}
        </p>
      ) : null}
      {s ? (
        <dl className="grid grid-cols-2 gap-3 text-sm sm:grid-cols-4">
          {[
            [L('Distance', 'अंतर'), `${(s.distanceM / 1000).toFixed(2)} km`],
            [L('Location updates', 'ठिकाण नोंदी'), String(s.pingCount)],
            [
              L('Inside ward', 'प्रभागात'),
              s.inWardPings + s.outWardPings === 0 ? '—' : `${s.inWardPings} / ${s.inWardPings + s.outWardPings}`,
            ],
            [L('Longest gap', 'सर्वात मोठा खंड'), s.maxGapMinutes === null ? '—' : hoursMinutes(s.maxGapMinutes)],
            [L('First seen', 'पहिली नोंद'), istTime(s.firstPingAt)],
            [L('Last seen', 'शेवटची नोंद'), istTime(s.lastPingAt)],
            [L('Fake-location points', 'बनावट ठिकाण'), String(s.mockedPings)],
            [L('Tamper events', 'छेडछाड घटना'), String(s.tamperEvents)],
          ].map(([label, value]) => (
            <div key={label} className="rounded-lg border border-slate-200 bg-white p-3">
              <dt className="text-slate-500">{label}</dt>
              <dd className="mt-1 text-lg font-semibold">{value}</dd>
            </div>
          ))}
        </dl>
      ) : null}
      <RouteMap points={points} pathPoints={pathPoints} boundary={boundary} cursor={cursor} />
      {points.length > 1 ? (
        <Field label={L('Playback', 'मार्ग पुन्हा पाहा')} hint={cursor !== null ? points[cursor].label : undefined}>
          <input
            type="range"
            min={0}
            max={points.length - 1}
            value={cursor ?? 0}
            onChange={(e) => setCursor(Number(e.target.value))}
            className="mt-2 w-full accent-smkc"
          />
        </Field>
      ) : null}
      <p className="flex flex-wrap gap-3 text-xs text-slate-600">
        <span>● <span className="text-smkc">{L('Inside ward', 'प्रभागात')}</span></span>
        <span>● <span className="text-amber-600">{L('Outside ward', 'प्रभागाबाहेर')}</span></span>
        <span>● <span className="text-red-700">{L('Fake location', 'बनावट ठिकाण')}</span></span>
      </p>
      {route.data && route.data.tamperEvents.length > 0 ? (
        <section className="rounded-lg border border-slate-200 bg-white p-4 text-sm">
          <h2 className="font-medium">{L('Tamper events', 'छेडछाड घटना')}</h2>
          <ul className="mt-2 divide-y divide-slate-100">
            {route.data.tamperEvents.map((e, i) => (
              <li key={i} className="flex flex-wrap items-center gap-2 py-1.5">
                <Badge tone="red">{e.eventType}</Badge>
                <span>
                  {istTime(e.startedAt)} – {e.resolvedAt ? istTime(e.resolvedAt) : L('ongoing', 'सुरू')}
                </span>
                <span className="text-slate-500">{e.source === 'SERVER' ? L('detected by server', 'सर्व्हरने ओळखले') : L('reported by phone', 'फोनने कळवले')}</span>
              </li>
            ))}
          </ul>
        </section>
      ) : null}
    </div>
  );
}
