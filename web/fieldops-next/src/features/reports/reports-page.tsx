'use client';

import { keepPreviousData, useQuery } from '@tanstack/react-query';
import { useMemo, useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { MusterDownload } from './muster-download';
import { downloadCsv } from '@/shared/csv';
import { useLocale } from '@/shared/i18n/locale';
import { addDays, hoursMinutes, istToday } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type WardDay = Schemas['WardDayReportDto'];
type StaffRow = Schemas['StaffReportRowDto'];
const PAGE_SIZE = 100;
const pct = (part: number, whole: number) => (whole > 0 ? Math.round((part / whole) * 100) : null);

/**
 * Attendance reports over a date range: per ward and day from the nightly summaries, and per
 * person (late marks, absences, leave, corrections). Today is not in the summaries yet.
 */
export function ReportsPage() {
  const { t, pick } = useLocale();
  const role = useRole();
  const { wards, wardName } = useWards();
  const yesterday = addDays(istToday(), -1);
  const [from, setFrom] = useState(addDays(yesterday, -6));
  const [to, setTo] = useState(yesterday);
  const [wardId, setWardId] = useState('');
  const [tab, setTab] = useState<'wards' | 'staff'>('wards');
  const [page, setPage] = useState(1);
  const L = (en: string, mr: string) => pick({ en, mr });
  const range = { from, to, wardId: wardId || undefined };

  const wardDays = useQuery({
    queryKey: ['reports', 'ward-days', range],
    enabled: tab === 'wards',
    placeholderData: keepPreviousData,
    queryFn: () => unwrap(api.GET('/api/v1/reports/ward-days', { params: { query: range } })),
  });
  const staff = useQuery({
    queryKey: ['reports', 'staff-days', range, page],
    enabled: tab === 'staff',
    placeholderData: keepPreviousData,
    queryFn: () =>
      unwrap(api.GET('/api/v1/reports/staff-days', { params: { query: { ...range, page, pageSize: PAGE_SIZE } } })),
  });
  const names = useStaffNames(staff.data?.items.map((r) => r.staffId) ?? []);

  // Attendance rate per ward over the whole range.
  const perWard = useMemo(() => {
    const totals = new Map<string, { assigned: number; present: number; late: number }>();
    for (const d of wardDays.data?.items ?? []) {
      const x = totals.get(d.wardId) ?? { assigned: 0, present: 0, late: 0 };
      x.assigned += d.assignedCount;
      x.present += d.presentCount;
      x.late += d.lateCount;
      totals.set(d.wardId, x);
    }
    return [...totals.entries()].map(([id, x]) => ({ id, ...x, rate: pct(x.present, x.assigned) ?? 0 })).sort((a, b) => a.rate - b.rate);
  }, [wardDays.data]);

  const wardColumns: Column<WardDay>[] = [
    { key: 'date', header: t('date'), cell: (d) => d.date },
    { key: 'ward', header: t('ward'), cell: (d) => wardName(d.wardId) },
    { key: 'assigned', header: L('Placed', 'नेमलेले'), cell: (d) => d.assignedCount },
    { key: 'present', header: L('Present', 'उपस्थित'), cell: (d) => `${d.presentCount} (${pct(d.presentCount, d.assignedCount) ?? '—'}%)` },
    { key: 'late', header: L('Late', 'उशिरा'), cell: (d) => d.lateCount },
    { key: 'half', header: L('Half day', 'अर्धा दिवस'), cell: (d) => d.halfDayCount },
    { key: 'absent', header: L('Absent', 'अनुपस्थित'), cell: (d) => d.absentCount },
    { key: 'leave', header: L('Leave', 'रजा'), cell: (d) => d.onLeaveCount },
    { key: 'proxy', header: L('By inspector', 'निरीक्षकाकडून'), cell: (d) => d.proxyCount },
    { key: 'auto', header: L('Auto check-out', 'आपोआप निर्गमन'), cell: (d) => d.autoCheckoutCount },
    { key: 'susp', header: L('Suspicious', 'संशयास्पद'), cell: (d) => d.suspiciousCount },
    { key: 'km', header: 'km', cell: (d) => (d.distanceM / 1000).toFixed(1) },
  ];
  const staffColumns: Column<StaffRow>[] = [
    { key: 'name', header: t('staffMember'), cell: (r) => names.name(r.staffId) },
    { key: 'days', header: L('Days', 'दिवस'), cell: (r) => r.days },
    { key: 'present', header: L('Present', 'उपस्थित'), cell: (r) => r.present },
    { key: 'late', header: L('Late days', 'उशिरा दिवस'), cell: (r) => r.late },
    { key: 'lateMin', header: L('Late (h:mm)', 'उशीर (ता:मि)'), cell: (r) => hoursMinutes(r.lateMinutes) },
    { key: 'half', header: L('Half day', 'अर्धा दिवस'), cell: (r) => r.halfDay },
    { key: 'absent', header: L('Absent', 'अनुपस्थित'), cell: (r) => r.absent },
    { key: 'leave', header: L('Leave', 'रजा'), cell: (r) => r.onLeave },
    { key: 'reg', header: L('Corrected', 'दुरुस्त'), cell: (r) => r.regularized },
    { key: 'auto', header: L('Auto check-out', 'आपोआप निर्गमन'), cell: (r) => r.autoCheckout },
    { key: 'susp', header: L('Suspicious', 'संशयास्पद'), cell: (r) => r.suspicious },
  ];

  const exportCsv = () => {
    if (tab === 'wards') {
      downloadCsv(
        `ward-attendance_${from}_${to}.csv`,
        wardColumns.map((c) => c.header),
        (wardDays.data?.items ?? []).map((d) => [
          d.date,
          wardName(d.wardId),
          d.assignedCount,
          d.presentCount,
          d.lateCount,
          d.halfDayCount,
          d.absentCount,
          d.onLeaveCount,
          d.proxyCount,
          d.autoCheckoutCount,
          d.suspiciousCount,
          (d.distanceM / 1000).toFixed(1),
        ]),
      );
    } else {
      downloadCsv(
        `staff-attendance_${from}_${to}.csv`,
        staffColumns.map((c) => c.header),
        (staff.data?.items ?? []).map((r) => [
          names.name(r.staffId),
          r.days,
          r.present,
          r.late,
          r.lateMinutes,
          r.halfDay,
          r.absent,
          r.onLeave,
          r.regularized,
          r.autoCheckout,
          r.suspicious,
        ]),
      );
    }
  };

  const active = tab === 'wards' ? wardDays : staff;
  return (
    <div>
      <PageHeader
        title={L('Reports', 'अहवाल')}
        subtitle={L('From the nightly summaries: yesterday and earlier', 'रात्रीच्या सारांशातून: काल व त्यापूर्वीचे')}
        actions={
          <button type="button" className="btn-secondary" onClick={exportCsv} disabled={!active.data}>
            {L('Download CSV', 'CSV डाउनलोड')}
          </button>
        }
      />
      <MusterDownload />
      <div className="mb-4 flex gap-2" role="tablist">
        {(
          [
            ['wards', L('Wards by day', 'प्रभागनिहाय दैनिक')],
            ['staff', L('Staff', 'कर्मचारीनिहाय')],
          ] as const
        ).map(([value, label]) => (
          <button
            key={value}
            type="button"
            role="tab"
            aria-selected={tab === value}
            onClick={() => {
              setTab(value);
              setPage(1);
            }}
            className={tab === value ? 'btn-primary' : 'btn-secondary'}
          >
            {label}
          </button>
        ))}
      </div>
      <FilterBar>
        <Field label={t('from')}>
          <TextInput type="date" value={from} max={to} onChange={(e) => e.target.value && (setFrom(e.target.value), setPage(1))} />
        </Field>
        <Field label={t('to')}>
          <TextInput type="date" value={to} min={from} max={istToday()} onChange={(e) => e.target.value && (setTo(e.target.value), setPage(1))} />
        </Field>
        {role === 'ADMIN' ? (
          <Field label={t('ward')}>
            <Select
              value={wardId}
              onChange={(e) => {
                setWardId(e.target.value);
                setPage(1);
              }}
              placeholder={t('all')}
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        ) : null}
      </FilterBar>
      {active.isError ? <ErrorBanner error={active.error} onRetry={() => active.refetch()} /> : null}
      {tab === 'wards' ? (
        <div className="space-y-4">
          {perWard.length > 1 ? (
            <section className="rounded-lg border border-slate-200 bg-white p-4">
              <h2 className="mb-2 font-medium">{L('Attendance rate by ward (lowest first)', 'प्रभागनिहाय उपस्थिती दर (कमी आधी)')}</h2>
              <ul className="space-y-1.5 text-sm">
                {perWard.map((w) => (
                  <li key={w.id} className="grid grid-cols-[minmax(0,12rem)_1fr_3rem] items-center gap-2">
                    <span className="truncate">{wardName(w.id)}</span>
                    <span className="h-3 rounded bg-slate-100">
                      <span className="block h-3 rounded bg-smkc" style={{ width: `${w.rate}%` }} />
                    </span>
                    <span className="text-right tabular-nums">{w.rate}%</span>
                  </li>
                ))}
              </ul>
            </section>
          ) : null}
          <DataTable
            columns={wardColumns}
            rows={wardDays.data?.items}
            rowKey={(d) => `${d.date}:${d.wardId}`}
            loading={wardDays.isPending}
            empty={t('noRecords')}
          />
        </div>
      ) : (
        <>
          <DataTable
            columns={staffColumns}
            rows={staff.data?.items}
            rowKey={(r) => r.staffId}
            loading={staff.isPending}
            empty={t('noRecords')}
          />
          <Pager page={page} pageSize={PAGE_SIZE} total={staff.data?.total} onPage={setPage} />
        </>
      )}
    </div>
  );
}
