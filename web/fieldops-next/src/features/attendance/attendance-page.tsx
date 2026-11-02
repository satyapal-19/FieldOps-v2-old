'use client';

import { keepPreviousData, useQuery } from '@tanstack/react-query';
import Link from 'next/link';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { ATTENDANCE_STATUS_TEXT, CHECKOUT_TYPE_TEXT, enumOptions, PUNCH_MODE_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { hoursMinutes, istDateTime, istTime, istToday } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useOffices, useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Log = Schemas['AttendanceLogDto'];
type Status = Log['status'];
const PAGE_SIZE = 50;

/** Attendance in the caller's scope for a date range, with each punch's details and route. */
export function AttendancePage() {
  const { t, pick, lang } = useLocale();
  const today = istToday();
  const [from, setFrom] = useState(today);
  const [to, setTo] = useState(today);
  const [status, setStatus] = useState<Status | ''>('');
  const [page, setPage] = useState(1);
  const [open, setOpen] = useState<Log | null>(null);
  const { wardName } = useWards();
  const { officeName } = useOffices();

  const list = useQuery({
    queryKey: ['attendance', 'list', { from, to, status, page }],
    placeholderData: keepPreviousData,
    refetchInterval: 60_000,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/attendance', {
          params: { query: { from, to, status: status || undefined, page, pageSize: PAGE_SIZE } },
        }),
      ),
  });
  const names = useStaffNames([
    ...(list.data?.items.map((l) => l.staffId) ?? []),
    ...(list.data?.items.map((l) => l.checkin?.markedById) ?? []),
  ]);
  const L = (en: string, mr: string) => pick({ en, mr });
  const reset = <T,>(fn: (v: T) => void) => (v: T) => {
    fn(v);
    setPage(1);
  };

  const columns: Column<Log>[] = [
    { key: 'date', header: t('date'), cell: (l) => l.date },
    { key: 'staff', header: t('staffMember'), cell: (l) => names.name(l.staffId) },
    { key: 'place', header: L('Ward / office', 'प्रभाग / कार्यालय'), cell: (l) => (l.officeId ? officeName(l.officeId) : wardName(l.wardId)) },
    {
      key: 'status',
      header: t('status'),
      cell: (l) => (
        <span className="flex flex-wrap gap-1">
          <Badge tone={ATTENDANCE_STATUS_TEXT[l.status].tone}>{pick(ATTENDANCE_STATUS_TEXT[l.status])}</Badge>
          {l.isSuspicious ? <Badge tone="red">{L('Suspicious', 'संशयास्पद')}</Badge> : null}
        </span>
      ),
    },
    {
      key: 'in',
      header: L('In', 'आगमन'),
      cell: (l) => (
        <span className="whitespace-nowrap">
          {istTime(l.checkin?.at)}
          {l.checkin?.mode && l.checkin.mode !== 'SELF' ? (
            <span className="ml-1">
              <Badge tone="blue">{pick(PUNCH_MODE_TEXT[l.checkin.mode])}</Badge>
            </span>
          ) : null}
        </span>
      ),
    },
    {
      key: 'out',
      header: L('Out', 'निर्गमन'),
      cell: (l) => (
        <span className="whitespace-nowrap">
          {istTime(l.checkout?.at)}
          {l.checkoutType && l.checkoutType !== 'MANUAL' ? (
            <span className="ml-1">
              <Badge tone={CHECKOUT_TYPE_TEXT[l.checkoutType].tone}>{pick(CHECKOUT_TYPE_TEXT[l.checkoutType])}</Badge>
            </span>
          ) : null}
        </span>
      ),
    },
    { key: 'late', header: L('Late (min)', 'उशीर (मि.)'), cell: (l) => (l.isLate ? l.lateMinutes : '—') },
    { key: 'worked', header: L('Worked', 'काम केले'), cell: (l) => hoursMinutes(l.workedMinutes) },
  ];

  return (
    <div>
      <PageHeader title={L('Attendance', 'हजेरी')} subtitle={list.data ? `${list.data.total}` : undefined} />
      <FilterBar>
        <Field label={t('from')}>
          <TextInput type="date" value={from} max={to} onChange={(e) => reset(setFrom)(e.target.value)} />
        </Field>
        <Field label={t('to')}>
          <TextInput type="date" value={to} min={from} max={today} onChange={(e) => reset(setTo)(e.target.value)} />
        </Field>
        <Field label={t('status')}>
          <Select
            value={status}
            onChange={(e) => reset(setStatus)(e.target.value as Status | '')}
            placeholder={t('all')}
            options={enumOptions(ATTENDANCE_STATUS_TEXT, pick)}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(l) => l.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={(l) => setOpen(l)}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog open={!!open} title={open ? `${names.name(open.staffId)} · ${open.date}` : ''} onClose={() => setOpen(null)} wide>
        {open ? (
          <div className="space-y-4 text-sm">
            {(['checkin', 'checkout'] as const).map((which) => {
              const p = open[which];
              return (
                <section key={which}>
                  <h3 className="font-medium">{which === 'checkin' ? L('Check-in', 'आगमन') : L('Check-out', 'निर्गमन')}</h3>
                  {p ? (
                    <dl className="mt-1 grid grid-cols-2 gap-x-4 gap-y-1 sm:grid-cols-3">
                      <dt className="text-slate-500">{L('Server time (IST)', 'सर्व्हर वेळ (IST)')}</dt>
                      <dd className="sm:col-span-2">{istDateTime(p.at, lang)}</dd>
                      <dt className="text-slate-500">{L('Location', 'ठिकाण')}</dt>
                      <dd className="font-mono sm:col-span-2">
                        {p.latitude.toFixed(5)}, {p.longitude.toFixed(5)} {p.accuracyM !== null ? `(±${Math.round(p.accuracyM)} m)` : ''}
                      </dd>
                      <dt className="text-slate-500">{L('Inside ward / office', 'प्रभाग / कार्यालयात')}</dt>
                      <dd className="sm:col-span-2">
                        {p.inGeofence === null ? '—' : p.inGeofence ? t('yes') : t('no')}
                        {which === 'checkin' && open.checkinDistanceM ? ` (${Math.round(open.checkinDistanceM)} m)` : ''}
                      </dd>
                      <dt className="text-slate-500">{L('Marked by', 'नोंद केली')}</dt>
                      <dd className="sm:col-span-2">
                        {p.mode ? pick(PUNCH_MODE_TEXT[p.mode]) : '—'}
                        {p.markedById && p.mode !== 'SELF' ? ` · ${names.name(p.markedById)}` : ''}
                      </dd>
                      {which === 'checkin' && open.checkinFaceScore !== null ? (
                        <>
                          <dt className="text-slate-500">{L('Face match score', 'चेहरा जुळणी गुण')}</dt>
                          <dd className="sm:col-span-2">{open.checkinFaceScore.toFixed(3)}</dd>
                        </>
                      ) : null}
                    </dl>
                  ) : (
                    <p className="mt-1 text-slate-500">—</p>
                  )}
                </section>
              );
            })}
            <Link href={`/attendance/route?staffId=${open.staffId}&date=${open.date}`} className="btn-primary inline-block">
              {L('Show route on map', 'नकाशावर मार्ग दाखवा')}
            </Link>
          </div>
        ) : null}
      </Dialog>
    </div>
  );
}
