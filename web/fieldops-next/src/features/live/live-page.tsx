'use client';

import { useQuery } from '@tanstack/react-query';
import dynamic from 'next/dynamic';
import Link from 'next/link';
import { useMemo, useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { useMe } from '@/features/shell/use-me';
import { useLocale, type Bilingual } from '@/shared/i18n/locale';
import { istTime } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import type { LiveMarker, WardShape } from '@/shared/map/live-map';
import { polygonRing } from '@/shared/map/tiles';
import { Badge, type Tone } from '@/shared/ui/badge';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';

const LiveMap = dynamic(() => import('@/shared/map/live-map'), {
  ssr: false,
  loading: () => <div className="h-[520px] animate-pulse rounded-lg bg-slate-200" />,
});

type Position = Schemas['LivePositionDto'];
type State = Position['state'];

const STATE: Record<State, Bilingual & { color: string; tone: Tone }> = {
  ACTIVE: { en: 'Active', mr: 'सक्रिय', color: '#16a34a', tone: 'green' },
  STALE: { en: 'No update 15+ min', mr: '१५+ मि. नोंद नाही', color: '#d97706', tone: 'amber' },
  SILENT: { en: 'Silent 30+ min', mr: '३०+ मि. संपर्क नाही', color: '#b91c1c', tone: 'red' },
  NO_SIGNAL: { en: 'No location since check-in', mr: 'हजेरीनंतर ठिकाण नाही', color: '#64748b', tone: 'slate' },
};
const ORDER: State[] = ['SILENT', 'STALE', 'NO_SIGNAL', 'ACTIVE'];

/** Who is on duty where, refreshed every 30 seconds (polling; push updates can replace it later). */
export function LivePage() {
  const { t, pick } = useLocale();
  const role = useRole();
  const me = useMe();
  const { wards, wardName } = useWards();
  const [wardId, setWardId] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const live = useQuery({
    queryKey: ['live', wardId],
    refetchInterval: 30_000,
    queryFn: () =>
      unwrap(api.GET('/api/v1/live/positions', { params: { query: { wardId: wardId || undefined } } })),
  });
  const items = useMemo(() => live.data?.items ?? [], [live.data]);
  const names = useStaffNames(items.map((p) => p.staffId));

  const shownWard = role === 'ADMIN' ? wardId : (me.data?.homeWardId ?? '');
  const shapes: WardShape[] = useMemo(
    () =>
      wards
        .filter((w) => !shownWard || w.id === shownWard)
        .flatMap((w) => {
          const ring = polygonRing(w.boundary);
          return ring ? [{ id: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}`, ring }] : [];
        }),
    [wards, shownWard, pick],
  );
  const markers: LiveMarker[] = items
    .filter((p) => p.latitude !== null && p.longitude !== null)
    .map((p) => ({
      id: p.attendanceId,
      latitude: p.latitude!,
      longitude: p.longitude!,
      label: names.name(p.staffId),
      detail: `${pick(STATE[p.state])} · ${L('last seen', 'शेवटची नोंद')} ${istTime(p.lastSeenAt ?? p.checkinAt)}${
        p.isMocked ? ` · ${L('fake location', 'बनावट ठिकाण')}` : ''
      }${p.inWard === false ? ` · ${L('outside ward', 'प्रभागाबाहेर')}` : ''}`,
      color: p.isMocked ? STATE.SILENT.color : STATE[p.state].color,
      href: `/attendance/route?staffId=${p.staffId}&date=${p.date}`,
    }));
  const counts = ORDER.map((s) => [s, items.filter((p) => p.state === s).length] as const);

  return (
    <div className="space-y-4">
      <PageHeader
        title={L('Live map', 'थेट नकाशा')}
        subtitle={live.data ? `${L('Updated', 'अद्ययावत')} ${istTime(live.data.at)} · ${items.length} ${L('on duty', 'कामावर')}` : undefined}
      />
      {role === 'ADMIN' ? (
        <div className="max-w-xs">
          <Field label={t('ward')}>
            <Select
              value={wardId}
              onChange={(e) => setWardId(e.target.value)}
              placeholder={t('all')}
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        </div>
      ) : null}
      {live.isError ? <ErrorBanner error={live.error} onRetry={() => live.refetch()} /> : null}
      <div className="flex flex-wrap gap-2 text-sm">
        {counts.map(([s, n]) => (
          <Badge key={s} tone={STATE[s].tone}>
            {pick(STATE[s])}: {n}
          </Badge>
        ))}
      </div>
      <div className="grid gap-4 lg:grid-cols-[1fr_320px]">
        <LiveMap markers={markers} wards={shapes} />
        <section className="max-h-[520px] overflow-y-auto rounded-lg border border-slate-200 bg-white">
          <h2 className="sticky top-0 border-b border-slate-200 bg-white px-3 py-2 font-medium">{L('On duty', 'कामावर')}</h2>
          {items.length === 0 ? (
            <p className="px-3 py-4 text-sm text-slate-500">{live.isPending ? t('loading') : L('Nobody is checked in right now.', 'सध्या कोणीही हजर नाही.')}</p>
          ) : (
            <ul className="divide-y divide-slate-100 text-sm">
              {[...items]
                .sort((a, b) => ORDER.indexOf(a.state) - ORDER.indexOf(b.state))
                .map((p) => (
                  <li key={p.attendanceId} className="px-3 py-2">
                    <div className="flex items-start justify-between gap-2">
                      <Link href={`/attendance/route?staffId=${p.staffId}&date=${p.date}`} className="font-medium hover:underline">
                        {names.name(p.staffId)}
                      </Link>
                      <Badge tone={p.isMocked ? 'red' : STATE[p.state].tone}>{pick(STATE[p.state])}</Badge>
                    </div>
                    <p className="text-xs text-slate-500">
                      {wardName(p.wardId)} · {L('in', 'आगमन')} {istTime(p.checkinAt)} · {L('seen', 'नोंद')} {istTime(p.lastSeenAt)}
                      {p.inWard === false ? ` · ${L('outside ward', 'प्रभागाबाहेर')}` : ''}
                    </p>
                  </li>
                ))}
            </ul>
          )}
        </section>
      </div>
    </div>
  );
}
