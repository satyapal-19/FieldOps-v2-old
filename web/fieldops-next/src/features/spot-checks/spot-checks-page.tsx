'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useLocale, type Bilingual } from '@/shared/i18n/locale';
import { istDateTime, istToday } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge, type Tone } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextArea, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Check = Schemas['SpotCheckDto'];
type Status = Check['status'];
const PAGE_SIZE = 50;

export const SPOT_STATUS_TEXT: Record<Status, Bilingual & { tone: Tone }> = {
  SCHEDULED: { en: 'Scheduled', mr: 'नियोजित', tone: 'slate' },
  NOTIFIED: { en: 'Waiting for answer', mr: 'उत्तराच्या प्रतीक्षेत', tone: 'amber' },
  SNOOZED: { en: 'Snoozed', mr: 'पुढे ढकलले', tone: 'amber' },
  VERIFIED: { en: 'Verified', mr: 'खात्री झाली', tone: 'green' },
  MISSED: { en: 'Missed', mr: 'उत्तर नाही', tone: 'red' },
  FACE_MISMATCH: { en: 'Face mismatch', mr: 'चेहरा जुळला नाही', tone: 'red' },
  OUT_OF_GEOFENCE: { en: 'Outside the ward', mr: 'प्रभागाबाहेर', tone: 'red' },
  UNREACHABLE: { en: 'Unreachable', mr: 'संपर्क नाही', tone: 'red' },
  CANCELLED: { en: 'Cancelled (left duty)', mr: 'रद्द (कामावरून गेले)', tone: 'slate' },
};

/** Spot checks in the caller's scope; a senior can order one now for someone on duty. */
export function SpotChecksPage() {
  const { t, pick, lang } = useLocale();
  const queryClient = useQueryClient();
  const { wardName } = useWards();
  const [date, setDate] = useState(istToday());
  const [status, setStatus] = useState<Status | ''>('');
  const [page, setPage] = useState(1);
  const [ordering, setOrdering] = useState(false);
  const [staffId, setStaffId] = useState('');
  const [reason, setReason] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: ['spot-checks', { date, status, page }],
    placeholderData: keepPreviousData,
    refetchInterval: 30_000,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/spot-checks', {
          params: { query: { date, status: status || undefined, page, pageSize: PAGE_SIZE } },
        }),
      ),
  });
  const names = useStaffNames([...(list.data?.items.flatMap((c) => [c.staffId, c.initiatedById]) ?? [])]);
  const order = useMutation({
    mutationFn: () =>
      unwrap(api.POST('/api/v1/spot-checks', { body: { staffId, reason: reason.trim() || undefined } })),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['spot-checks'] });
      setOrdering(false);
      setStaffId('');
      setReason('');
    },
  });

  const columns: Column<Check>[] = [
    { key: 'who', header: t('staffMember'), cell: (c) => names.name(c.staffId) },
    { key: 'ward', header: t('ward'), cell: (c) => wardName(c.wardId) },
    {
      key: 'how',
      header: L('Why', 'का'),
      cell: (c) =>
        c.trigger === 'RANDOM'
          ? L('Random', 'यादृच्छिक')
          : `${L('Ordered by', 'मागणी:')} ${names.name(c.initiatedById)}${c.reason ? ` — ${c.reason}` : ''}`,
    },
    {
      key: 'when',
      header: L('Sent', 'पाठवले'),
      cell: (c) => <span className="whitespace-nowrap">{c.notifiedAt ? istDateTime(c.notifiedAt, lang) : '—'}</span>,
    },
    {
      key: 'status',
      header: t('status'),
      cell: (c) => (
        <span className="flex flex-wrap gap-1">
          <Badge tone={SPOT_STATUS_TEXT[c.status].tone}>{pick(SPOT_STATUS_TEXT[c.status])}</Badge>
          {c.snoozed ? <Badge>{L('snoozed once', 'एकदा पुढे ढकलले')}</Badge> : null}
        </span>
      ),
    },
    {
      key: 'answer',
      header: L('Answered', 'उत्तर'),
      cell: (c) =>
        c.respondedAt ? (
          <span className="whitespace-nowrap">
            {istDateTime(c.respondedAt, lang)}
            {c.faceScore !== null ? ` · ${L('face', 'चेहरा')} ${c.faceScore.toFixed(2)}` : ''}
          </span>
        ) : (
          '—'
        ),
    },
  ];

  return (
    <div>
      <PageHeader
        title={L('Spot checks', 'अचानक तपासण्या')}
        subtitle={L(
          'Random checks go out on their own during shifts; order one when someone needs checking now.',
          'शिफ्टमध्ये यादृच्छिक तपासण्या आपोआप जातात; गरज असल्यास आत्ता तपासणी मागवा.',
        )}
        actions={
          <button type="button" className="btn-primary" onClick={() => setOrdering(true)}>
            {L('Check someone now', 'आत्ता तपासणी मागवा')}
          </button>
        }
      />
      <FilterBar>
        <Field label={t('date')}>
          <TextInput type="date" max={istToday()} value={date} onChange={(e) => e.target.value && (setDate(e.target.value), setPage(1))} />
        </Field>
        <Field label={t('status')}>
          <Select
            value={status}
            onChange={(e) => {
              setStatus(e.target.value as Status | '');
              setPage(1);
            }}
            placeholder={t('all')}
            options={(Object.keys(SPOT_STATUS_TEXT) as Status[]).map((s) => ({ value: s, label: pick(SPOT_STATUS_TEXT[s]) }))}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable columns={columns} rows={list.data?.items} rowKey={(c) => c.id} loading={list.isPending} empty={t('noRecords')} />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog open={ordering} title={L('Check someone now', 'आत्ता तपासणी मागवा')} onClose={() => setOrdering(false)}>
        {ordering ? (
          <div className="space-y-3 text-sm">
            <p className="text-slate-600">
              {L(
                'Their phone alerts them at once; they have 10 minutes (one 10-minute snooze) to prove they are at work with their face and location.',
                'त्यांच्या फोनवर लगेच सूचना जाते; चेहरा व ठिकाणाने कामावर असल्याचे सिद्ध करण्यास १० मिनिटे (एकदा १० मिनिटे वाढ) असतात.',
              )}
            </p>
            <StaffPicker label={t('staffMember')} value={staffId} onChange={setStaffId} roles={['INSPECTOR', 'WORKER']} />
            <Field label={L('Reason (optional, seen by the employee)', 'कारण (ऐच्छिक, कर्मचाऱ्याला दिसेल)')}>
              <TextArea maxLength={500} value={reason} onChange={(e) => setReason(e.target.value)} />
            </Field>
            {order.isError ? <ErrorBanner error={order.error} /> : null}
            <div className="flex justify-end gap-2">
              <button type="button" className="btn-secondary" onClick={() => setOrdering(false)}>
                {t('cancel')}
              </button>
              <button type="button" className="btn-primary" disabled={!staffId || order.isPending} onClick={() => order.mutate()}>
                {L('Send the check', 'तपासणी पाठवा')}
              </button>
            </div>
          </div>
        ) : null}
      </Dialog>
    </div>
  );
}
