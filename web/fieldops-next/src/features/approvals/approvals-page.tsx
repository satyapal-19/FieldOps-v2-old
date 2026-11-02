'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useMe } from '@/features/shell/use-me';
import {
  enumOptions,
  LEAVE_TYPE_TEXT,
  REGULARIZATION_REASON_TEXT,
  REQUEST_STATUS_TEXT,
} from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextArea } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Leave = Schemas['LeaveRequestDto'];
type Regularization = Schemas['RegularizationRequestDto'];
type Status = Leave['status'];
type Kind = 'leave' | 'regularization';
type Request = (Leave & { kind: 'leave' }) | (Regularization & { kind: 'regularization' });
const PAGE_SIZE = 50;

/** Leave and attendance-correction requests the caller reviews (their reports), with decisions. */
export function ApprovalsPage() {
  const { t, pick, lang } = useLocale();
  const queryClient = useQueryClient();
  const me = useMe();
  const [kind, setKind] = useState<Kind>('leave');
  const [status, setStatus] = useState<Status | ''>('PENDING');
  const [page, setPage] = useState(1);
  const [open, setOpen] = useState<Request | null>(null);
  const [note, setNote] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: [kind, 'list', { status, page }],
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<{ items: Request[]; total: number }> => {
      const query = { status: status || undefined, page, pageSize: PAGE_SIZE };
      if (kind === 'leave') {
        const r = await unwrap(api.GET('/api/v1/leave', { params: { query } }));
        return { total: r.total, items: r.items.map((x) => ({ ...x, kind: 'leave' as const })) };
      }
      const r = await unwrap(api.GET('/api/v1/regularizations', { params: { query } }));
      return { total: r.total, items: r.items.map((x) => ({ ...x, kind: 'regularization' as const })) };
    },
  });
  const names = useStaffNames([
    ...(list.data?.items.map((r) => r.staffId) ?? []),
    ...(list.data?.items.map((r) => r.reviewedById) ?? []),
  ]);

  const review = useMutation({
    mutationFn: ({
      request,
      decision,
    }: {
      request: Request;
      decision: 'APPROVED' | 'REJECTED';
    }): Promise<Leave | Regularization> => {
      const body = { expectedVersion: request.version, decision, note: note.trim() || undefined };
      const path = { id: request.id };
      return request.kind === 'leave'
        ? unwrap(api.POST('/api/v1/leave/{id}/review', { params: { path }, body }))
        : unwrap(api.POST('/api/v1/regularizations/{id}/review', { params: { path }, body }));
    },
    onSuccess: async () => {
      // A decision changes attendance too (leave days, corrected punches).
      await Promise.all([
        queryClient.invalidateQueries({ queryKey: [open?.kind ?? kind] }),
        queryClient.invalidateQueries({ queryKey: ['attendance'] }),
      ]);
      setOpen(null);
    },
  });

  const show = (r: Request) => {
    review.reset();
    setNote('');
    setOpen(r);
  };

  const what = (r: Request) =>
    r.kind === 'leave'
      ? `${pick(LEAVE_TYPE_TEXT[r.leaveType])}: ${r.fromDate} → ${r.toDate} (${r.daysCount} ${L('days', 'दिवस')})`
      : `${r.attendanceDate}: ${pick(REGULARIZATION_REASON_TEXT[r.reasonType])}`;

  const columns: Column<Request>[] = [
    { key: 'staff', header: t('staffMember'), cell: (r) => names.name(r.staffId) },
    { key: 'what', header: t('details'), cell: what },
    {
      key: 'reason',
      header: L('Reason', 'कारण'),
      cell: (r) => <span className="line-clamp-2 max-w-xs">{(r.kind === 'leave' ? r.reason : r.explanation) ?? '—'}</span>,
    },
    { key: 'asked', header: L('Asked on', 'विनंती दिनांक'), cell: (r) => <span className="whitespace-nowrap">{istDateTime(r.createdAt, lang)}</span> },
    {
      key: 'status',
      header: t('status'),
      cell: (r) => <Badge tone={REQUEST_STATUS_TEXT[r.status].tone}>{pick(REQUEST_STATUS_TEXT[r.status])}</Badge>,
    },
  ];

  const canDecide = open && open.status === 'PENDING' && open.staffId !== me.data?.id;

  return (
    <div>
      <PageHeader title={L('Leave & corrections', 'रजा व दुरुस्ती')} />
      <div className="mb-4 flex gap-2" role="tablist">
        {(
          [
            ['leave', L('Leave', 'रजा')],
            ['regularization', L('Attendance corrections', 'हजेरी दुरुस्ती')],
          ] as const
        ).map(([value, label]) => (
          <button
            key={value}
            type="button"
            role="tab"
            aria-selected={kind === value}
            onClick={() => {
              setKind(value);
              setPage(1);
            }}
            className={kind === value ? 'btn-primary' : 'btn-secondary'}
          >
            {label}
          </button>
        ))}
      </div>
      <FilterBar>
        <Field label={t('status')}>
          <Select
            value={status}
            onChange={(e) => {
              setStatus(e.target.value as Status | '');
              setPage(1);
            }}
            placeholder={t('all')}
            options={enumOptions(REQUEST_STATUS_TEXT, pick)}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(r) => r.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={(r) => show(r)}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog
        open={!!open}
        title={open ? (open.kind === 'leave' ? L('Leave request', 'रजा विनंती') : L('Attendance correction', 'हजेरी दुरुस्ती विनंती')) : ''}
        onClose={() => setOpen(null)}
      >
        {open ? (
          <div className="space-y-3 text-sm">
            <p className="font-medium">{names.name(open.staffId)}</p>
            <p>{what(open)}</p>
            <p className="whitespace-pre-wrap text-slate-700">{(open.kind === 'leave' ? open.reason : open.explanation) ?? '—'}</p>
            {open.status !== 'PENDING' ? (
              <p className="rounded-md bg-slate-50 p-3">
                <Badge tone={REQUEST_STATUS_TEXT[open.status].tone}>{pick(REQUEST_STATUS_TEXT[open.status])}</Badge>{' '}
                {open.reviewedById ? names.name(open.reviewedById) : ''}
                {open.reviewedAt ? ` · ${istDateTime(open.reviewedAt, lang)}` : ''}
                {open.reviewNote ? <span className="mt-1 block">{open.reviewNote}</span> : null}
              </p>
            ) : null}
            {canDecide ? (
              <>
                <Field label={L('Note to the employee (optional)', 'कर्मचाऱ्यासाठी टीप (ऐच्छिक)')}>
                  <TextArea value={note} maxLength={500} onChange={(e) => setNote(e.target.value)} />
                </Field>
                {review.isError ? <ErrorBanner error={review.error} /> : null}
                <div className="flex justify-end gap-2">
                  <button
                    type="button"
                    className="btn-danger"
                    disabled={review.isPending}
                    onClick={() => review.mutate({ request: open, decision: 'REJECTED' })}
                  >
                    {t('reject')}
                  </button>
                  <button
                    type="button"
                    className="btn-primary"
                    disabled={review.isPending}
                    onClick={() => review.mutate({ request: open, decision: 'APPROVED' })}
                  >
                    {t('approve')}
                  </button>
                </div>
              </>
            ) : null}
          </div>
        ) : null}
      </Dialog>
    </div>
  );
}
