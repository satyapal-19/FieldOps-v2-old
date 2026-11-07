'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { useLocale, type Bilingual } from '@/shared/i18n/locale';
import { addDays, istToday } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';

type Holiday = Schemas['HolidayDto'];
type Shift = Schemas['ShiftDto'];
type ShiftType = Shift['shiftType'];

const HOLIDAY_TYPE: Record<Holiday['holidayType'], Bilingual> = {
  GAZETTE: { en: 'Gazetted', mr: 'राजपत्रित' },
  OPTIONAL: { en: 'Optional', mr: 'ऐच्छिक' },
};
const SHIFT_TYPE: Record<ShiftType, Bilingual & { start: string; end: string }> = {
  MORNING: { en: 'Morning', mr: 'सकाळ', start: '06:00', end: '14:00' },
  EVENING: { en: 'Evening', mr: 'संध्याकाळ', start: '14:00', end: '22:00' },
  NIGHT: { en: 'Night', mr: 'रात्र', start: '22:00', end: '06:00' },
  GENERAL_OFFICE: { en: 'Office hours', mr: 'कार्यालयीन वेळ', start: '10:00', end: '18:00' },
};

/** Holidays (admin) and one-day shift changes for a person (admin, ward inspector for their ward). */
export function CalendarPage() {
  const { pick } = useLocale();
  const role = useRole();
  const [tab, setTab] = useState<'holidays' | 'shifts'>(role === 'ADMIN' ? 'holidays' : 'shifts');
  const L = (en: string, mr: string) => pick({ en, mr });
  return (
    <div>
      <PageHeader title={L('Calendar', 'दिनदर्शिका')} />
      <div className="mb-4 flex gap-2" role="tablist">
        {(
          [
            ['holidays', L('Holidays', 'सुट्ट्या')],
            ['shifts', L('Shift changes', 'शिफ्ट बदल')],
          ] as const
        ).map(([value, label]) => (
          <button
            key={value}
            type="button"
            role="tab"
            aria-selected={tab === value}
            onClick={() => setTab(value)}
            className={tab === value ? 'btn-primary' : 'btn-secondary'}
          >
            {label}
          </button>
        ))}
      </div>
      {tab === 'holidays' ? <Holidays canEdit={role === 'ADMIN'} /> : <ShiftChanges />}
    </div>
  );
}

function Holidays({ canEdit }: { canEdit: boolean }) {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const thisYear = Number(istToday().slice(0, 4));
  const [year, setYear] = useState(thisYear);
  const [editing, setEditing] = useState<Holiday | 'new' | null>(null);
  const L = (en: string, mr: string) => pick({ en, mr });
  const list = useQuery({
    queryKey: ['holidays', year],
    queryFn: () => unwrap(api.GET('/api/v1/holidays', { params: { query: { year } } })),
  });
  const remove = useMutation({
    mutationFn: (h: Holiday) => unwrap(api.DELETE('/api/v1/holidays/{id}', { params: { path: { id: h.id } } })),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['holidays'] }),
  });
  const today = istToday();
  const columns: Column<Holiday>[] = [
    { key: 'date', header: t('date'), cell: (h) => h.date },
    { key: 'name', header: t('name'), cell: (h) => pick({ en: h.name, mr: h.nameMr }) },
    { key: 'type', header: L('Type', 'प्रकार'), cell: (h) => <Badge tone={h.holidayType === 'GAZETTE' ? 'blue' : 'slate'}>{pick(HOLIDAY_TYPE[h.holidayType])}</Badge> },
    {
      key: 'actions',
      header: '',
      cell: (h) =>
        canEdit && h.date >= today ? (
          <span className="flex gap-2">
            <button type="button" className="btn-secondary" onClick={() => setEditing(h)}>
              {L('Edit', 'बदला')}
            </button>
            <button type="button" className="btn-secondary" disabled={remove.isPending} onClick={() => remove.mutate(h)}>
              {L('Remove', 'काढा')}
            </button>
          </span>
        ) : null,
    },
  ];
  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-end justify-between gap-2">
        <Field label={L('Year', 'वर्ष')}>
          <Select
            value={String(year)}
            onChange={(e) => setYear(Number(e.target.value))}
            options={[thisYear - 1, thisYear, thisYear + 1].map((y) => ({ value: String(y), label: String(y) }))}
          />
        </Field>
        {canEdit ? (
          <button type="button" className="btn-primary" onClick={() => setEditing('new')}>
            {L('Add holiday', 'सुट्टी जोडा')}
          </button>
        ) : null}
      </div>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      {remove.isError ? <ErrorBanner error={remove.error} /> : null}
      <DataTable columns={columns} rows={list.data} rowKey={(h) => h.id} loading={list.isPending} empty={t('noRecords')} />
      <p className="text-xs text-slate-500">
        {L('Office staff are off on holidays; field staff work if they are placed that day.', 'सुट्टीच्या दिवशी कार्यालयीन कर्मचाऱ्यांना सुट्टी; क्षेत्रीय कर्मचारी नेमणूक असल्यास काम करतात.')}
      </p>
      <Dialog open={editing !== null} title={editing === 'new' ? L('Add holiday', 'सुट्टी जोडा') : L('Edit holiday', 'सुट्टी बदला')} onClose={() => setEditing(null)}>
        {editing !== null ? <HolidayForm key={editing === 'new' ? 'new' : editing.id} holiday={editing === 'new' ? null : editing} onDone={() => setEditing(null)} /> : null}
      </Dialog>
    </div>
  );
}

function HolidayForm({ holiday, onDone }: { holiday: Holiday | null; onDone(): void }) {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const [f, setF] = useState({
    date: holiday?.date ?? istToday(),
    name: holiday?.name ?? '',
    nameMr: holiday?.nameMr ?? '',
    holidayType: holiday?.holidayType ?? ('GAZETTE' as Holiday['holidayType']),
  });
  const L = (en: string, mr: string) => pick({ en, mr });
  const save = useMutation({
    mutationFn: () => {
      const body = { date: f.date, name: f.name.trim(), nameMr: f.nameMr.trim() || undefined, holidayType: f.holidayType };
      return holiday
        ? unwrap(api.PATCH('/api/v1/holidays/{id}', { params: { path: { id: holiday.id } }, body: { ...body, expectedVersion: holiday.version } }))
        : unwrap(api.POST('/api/v1/holidays', { body }));
    },
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['holidays'] });
      onDone();
    },
  });
  return (
    <div className="space-y-3">
      <Field label={t('date')}>
        <TextInput type="date" min={istToday()} value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
      </Field>
      <Field label={L('Name (English)', 'नाव (इंग्रजी)')}>
        <TextInput required maxLength={100} value={f.name} onChange={(e) => setF({ ...f, name: e.target.value })} />
      </Field>
      <Field label={L('Name (Marathi)', 'नाव (मराठी)')}>
        <TextInput maxLength={100} value={f.nameMr} onChange={(e) => setF({ ...f, nameMr: e.target.value })} />
      </Field>
      <Field label={L('Type', 'प्रकार')}>
        <Select
          value={f.holidayType}
          onChange={(e) => setF({ ...f, holidayType: e.target.value as Holiday['holidayType'] })}
          options={(Object.keys(HOLIDAY_TYPE) as Holiday['holidayType'][]).map((k) => ({ value: k, label: pick(HOLIDAY_TYPE[k]) }))}
        />
      </Field>
      {save.isError ? <ErrorBanner error={save.error} /> : null}
      <div className="flex justify-end gap-2">
        <button type="button" className="btn-secondary" onClick={onDone}>
          {t('cancel')}
        </button>
        <button type="button" className="btn-primary" disabled={!f.name.trim() || save.isPending} onClick={() => save.mutate()}>
          {t('save')}
        </button>
      </div>
    </div>
  );
}

/** One person's shift changes over the next two weeks; set or remove a day's override. */
function ShiftChanges() {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const today = istToday();
  const [staffId, setStaffId] = useState('');
  const [f, setF] = useState({ date: today, shiftType: 'MORNING' as ShiftType, startTime: '06:00', endTime: '14:00' });
  const L = (en: string, mr: string) => pick({ en, mr });
  const list = useQuery({
    queryKey: ['shifts', staffId],
    enabled: !!staffId,
    queryFn: () => unwrap(api.GET('/api/v1/shifts', { params: { query: { staffId, from: addDays(today, -7), to: addDays(today, 14) } } })),
  });
  const refresh = () => queryClient.invalidateQueries({ queryKey: ['shifts', staffId] });
  const put = useMutation({
    mutationFn: () => {
      const existing = list.data?.find((s) => s.date === f.date);
      return unwrap(api.PUT('/api/v1/shifts', { body: { staffId, ...f, expectedVersion: existing?.version } }));
    },
    onSuccess: refresh,
  });
  const remove = useMutation({
    mutationFn: (s: Shift) => unwrap(api.DELETE('/api/v1/shifts/{id}', { params: { path: { id: s.id } } })),
    onSuccess: refresh,
  });
  const columns: Column<Shift>[] = [
    { key: 'date', header: t('date'), cell: (s) => s.date },
    { key: 'type', header: L('Shift', 'शिफ्ट'), cell: (s) => pick(SHIFT_TYPE[s.shiftType]) },
    { key: 'time', header: L('Time (IST)', 'वेळ (IST)'), cell: (s) => `${s.startTime}–${s.endTime}` },
    {
      key: 'actions',
      header: '',
      cell: (s) =>
        s.date >= today ? (
          <button type="button" className="btn-secondary" disabled={remove.isPending} onClick={() => remove.mutate(s)}>
            {L('Back to usual shift', 'नेहमीची शिफ्ट')}
          </button>
        ) : null,
    },
  ];
  return (
    <div className="space-y-4">
      <StaffPicker label={t('staffMember')} value={staffId} onChange={setStaffId} roles={['WARD_INSPECTOR', 'INSPECTOR', 'WORKER', 'OFFICE_STAFF']} />
      {staffId ? (
        <>
          <section className="grid grid-cols-1 gap-3 rounded-lg border border-slate-200 bg-white p-4 sm:grid-cols-5">
            <Field label={t('date')}>
              <TextInput type="date" min={today} value={f.date} onChange={(e) => setF({ ...f, date: e.target.value })} />
            </Field>
            <Field label={L('Shift', 'शिफ्ट')}>
              <Select
                value={f.shiftType}
                onChange={(e) => {
                  const type = e.target.value as ShiftType;
                  setF({ ...f, shiftType: type, startTime: SHIFT_TYPE[type].start, endTime: SHIFT_TYPE[type].end });
                }}
                options={(Object.keys(SHIFT_TYPE) as ShiftType[]).map((k) => ({ value: k, label: pick(SHIFT_TYPE[k]) }))}
              />
            </Field>
            <Field label={L('Start', 'सुरू')}>
              <TextInput type="time" value={f.startTime} onChange={(e) => setF({ ...f, startTime: e.target.value })} />
            </Field>
            <Field label={L('End', 'संपते')}>
              <TextInput type="time" value={f.endTime} onChange={(e) => setF({ ...f, endTime: e.target.value })} />
            </Field>
            <div className="flex items-end">
              <button type="button" className="btn-primary w-full" disabled={put.isPending} onClick={() => put.mutate()}>
                {L('Set for that day', 'त्या दिवसासाठी ठरवा')}
              </button>
            </div>
          </section>
          {[list, put, remove].map((q, i) => (q.isError ? <ErrorBanner key={i} error={q.error} /> : null))}
          <DataTable columns={columns} rows={list.data} rowKey={(s) => s.id} loading={list.isPending} empty={L('No changes: the usual shift applies.', 'बदल नाही: नेहमीची शिफ्ट लागू.')} />
        </>
      ) : null}
    </div>
  );
}
