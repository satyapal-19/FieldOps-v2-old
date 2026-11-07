'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { CATEGORY_TEXT, COMPLAINT_STATUS_TEXT } from '@/features/citizen/citizen-text';
import { useRole } from '@/features/shell/role-context';
import { enumOptions, PRIORITY_TEXT, TASK_STATUS_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge, type Tone } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Complaint = Schemas['ComplaintDto'];
type Status = Complaint['status'];
type Action = Schemas['ComplaintStatusDto']['action'];
type Role = Schemas['StaffProfileDto']['role'];
const PAGE_SIZE = 50;

const TONE: Record<Status, Tone> = {
  RECEIVED: 'amber',
  ASSIGNED: 'blue',
  IN_PROGRESS: 'blue',
  RESOLVED: 'green',
  CLOSED: 'slate',
  REJECTED: 'red',
};
/** complaints.policy: RESOLVE (from ASSIGNED) after an approved task, REJECT only while new, CLOSE once handled. */
const ACTIONS: Record<Status, readonly Action[]> = {
  RECEIVED: ['REJECT'],
  ASSIGNED: ['RESOLVE'],
  IN_PROGRESS: [],
  RESOLVED: ['CLOSE'],
  CLOSED: [],
  REJECTED: ['CLOSE'],
};
const ACTION_TEXT: Record<Action, { en: string; mr: string }> = {
  RESOLVE: { en: 'Mark resolved', mr: 'निकाली काढा' },
  REJECT: { en: 'Reject (not civic / duplicate)', mr: 'नाकारा (नागरी नाही / दुहेरी)' },
  CLOSE: { en: 'Close', mr: 'बंद करा' },
};
const ROUTE_TO: Record<string, readonly Role[]> = {
  ADMIN: ['WARD_INSPECTOR', 'INSPECTOR', 'WORKER'],
  WARD_INSPECTOR: ['INSPECTOR', 'WORKER'],
};

function ComplaintDetail({ id, onDone }: { id: string; onDone(): void }) {
  const { pick, lang } = useLocale();
  const role = useRole();
  const queryClient = useQueryClient();
  const { wardName } = useWards();
  const [assignee, setAssignee] = useState('');
  const [priority, setPriority] = useState<Schemas['AssignComplaintDto']['priority']>('NORMAL');
  const L = (en: string, mr: string) => pick({ en, mr });
  const canAct = role === 'ADMIN' || role === 'WARD_INSPECTOR';

  const one = useQuery({
    queryKey: ['complaints', 'one', id],
    queryFn: () => unwrap(api.GET('/api/v1/complaints/{id}', { params: { path: { id } } })),
  });
  const c = one.data;
  const names = useStaffNames(c?.tasks?.map((x) => x.assignedToId) ?? []);
  const refresh = async () => {
    await queryClient.invalidateQueries({ queryKey: ['complaints'] });
    await queryClient.invalidateQueries({ queryKey: ['tasks'] });
  };
  const assign = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/complaints/{id}/assign', {
          params: { path: { id } },
          body: { expectedVersion: c!.version, assignedToId: assignee, priority },
        }),
      ),
    onSuccess: refresh,
  });
  const act = useMutation({
    mutationFn: (action: Action) =>
      unwrap(
        api.POST('/api/v1/complaints/{id}/status', {
          params: { path: { id } },
          body: { expectedVersion: c!.version, action },
        }),
      ),
    onSuccess: async () => {
      await refresh();
      onDone();
    },
  });

  if (one.isError) return <ErrorBanner error={one.error} onRetry={() => one.refetch()} />;
  if (!c) return <p className="text-sm text-slate-500">…</p>;
  return (
    <div className="space-y-4 text-sm">
      <div className="flex flex-wrap items-center gap-2">
        <span className="font-mono font-semibold">{c.trackingId}</span>
        <Badge tone={TONE[c.status]}>{pick(COMPLAINT_STATUS_TEXT[c.status])}</Badge>
        <Badge>{pick(CATEGORY_TEXT[c.category])}</Badge>
      </div>
      <p className="whitespace-pre-wrap">{c.description}</p>
      <dl className="grid grid-cols-2 gap-x-4 gap-y-1">
        <dt className="text-slate-500">{L('Filed', 'नोंद')}</dt>
        <dd>{istDateTime(c.createdAt, lang)}</dd>
        <dt className="text-slate-500">{L('Ward', 'प्रभाग')}</dt>
        <dd>{wardName(c.wardId)}</dd>
        <dt className="text-slate-500">{L('Citizen', 'नागरिक')}</dt>
        <dd>
          {c.citizenName ?? '—'} {c.citizenPhone ? `· ${c.citizenPhone}` : ''}
        </dd>
        <dt className="text-slate-500">{L('Location', 'ठिकाण')}</dt>
        <dd>
          {c.lat !== null && c.lng !== null ? (
            <a
              className="text-smkc underline"
              target="_blank"
              rel="noreferrer"
              href={`https://www.openstreetmap.org/?mlat=${c.lat}&mlon=${c.lng}#map=18/${c.lat}/${c.lng}`}
            >
              {c.lat.toFixed(5)}, {c.lng.toFixed(5)}
            </a>
          ) : (
            '—'
          )}
        </dd>
      </dl>
      {c.tasks && c.tasks.length > 0 ? (
        <section>
          <h3 className="font-medium">{L('Tasks raised', 'दिलेली कामे')}</h3>
          <ul className="mt-1 space-y-1">
            {c.tasks.map((x) => (
              <li key={x.id} className="flex flex-wrap items-center gap-2">
                <Badge tone={TASK_STATUS_TEXT[x.status].tone}>{pick(TASK_STATUS_TEXT[x.status])}</Badge>
                {names.name(x.assignedToId)}
              </li>
            ))}
          </ul>
        </section>
      ) : null}
      {canAct && (c.status === 'RECEIVED' || c.status === 'ASSIGNED') ? (
        <section className="space-y-2 border-t border-slate-200 pt-3">
          <StaffPicker
            label={L('Send to a team member (raises a task)', 'पथकातील व्यक्तीकडे पाठवा (काम तयार होते)')}
            value={assignee}
            onChange={setAssignee}
            roles={ROUTE_TO[role] ?? []}
          />
          <Field label={L('Priority', 'प्राधान्य')}>
            <Select
              value={priority}
              onChange={(e) => setPriority(e.target.value as typeof priority)}
              options={enumOptions(PRIORITY_TEXT, pick)}
            />
          </Field>
          {assign.isError ? <ErrorBanner error={assign.error} /> : null}
          {assign.isSuccess ? <p className="text-green-700">{L('Task raised.', 'काम दिले.')}</p> : null}
          <div className="flex justify-end">
            <button type="button" className="btn-primary" disabled={!assignee || assign.isPending} onClick={() => assign.mutate()}>
              {L('Raise task', 'काम द्या')}
            </button>
          </div>
        </section>
      ) : null}
      {canAct && ACTIONS[c.status].length > 0 ? (
        <section className="space-y-2 border-t border-slate-200 pt-3">
          {act.isError ? <ErrorBanner error={act.error} /> : null}
          <div className="flex flex-wrap justify-end gap-2">
            {ACTIONS[c.status].map((a) => (
              <button
                key={a}
                type="button"
                className={a === 'REJECT' ? 'btn-danger' : 'btn-secondary'}
                disabled={act.isPending}
                onClick={() => act.mutate(a)}
              >
                {pick(ACTION_TEXT[a])}
              </button>
            ))}
          </div>
        </section>
      ) : null}
    </div>
  );
}

/** Citizens' complaints in the caller's scope: route each to a team as a task, then close the loop. */
export function ComplaintsPage() {
  const { t, pick, lang } = useLocale();
  const role = useRole();
  const { wards, wardName } = useWards();
  const [status, setStatus] = useState<Status | ''>('RECEIVED');
  const [wardId, setWardId] = useState('');
  const [page, setPage] = useState(1);
  const [open, setOpen] = useState<string | null>(null);
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: ['complaints', 'list', { status, wardId, page }],
    placeholderData: keepPreviousData,
    refetchInterval: 60_000,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/complaints', {
          params: { query: { status: status || undefined, wardId: wardId || undefined, page, pageSize: PAGE_SIZE } },
        }),
      ),
  });

  const columns: Column<Complaint>[] = [
    { key: 'id', header: L('Tracking ID', 'मागोवा क्रमांक'), cell: (c) => <span className="font-mono">{c.trackingId}</span> },
    { key: 'cat', header: L('Problem', 'समस्या'), cell: (c) => pick(CATEGORY_TEXT[c.category]) },
    { key: 'desc', header: t('details'), cell: (c) => <span className="line-clamp-2 max-w-sm">{c.description}</span> },
    { key: 'ward', header: t('ward'), cell: (c) => wardName(c.wardId) },
    { key: 'when', header: L('Filed', 'नोंद'), cell: (c) => <span className="whitespace-nowrap">{istDateTime(c.createdAt, lang)}</span> },
    { key: 'status', header: t('status'), cell: (c) => <Badge tone={TONE[c.status]}>{pick(COMPLAINT_STATUS_TEXT[c.status])}</Badge> },
  ];

  return (
    <div>
      <PageHeader title={L('Citizen complaints', 'नागरिक तक्रारी')} subtitle={list.data ? `${list.data.total}` : undefined} />
      <FilterBar>
        <Field label={t('status')}>
          <Select
            value={status}
            onChange={(e) => {
              setStatus(e.target.value as Status | '');
              setPage(1);
            }}
            placeholder={t('all')}
            options={(Object.keys(COMPLAINT_STATUS_TEXT) as Status[]).map((s) => ({ value: s, label: pick(COMPLAINT_STATUS_TEXT[s]) }))}
          />
        </Field>
        {role !== 'WARD_INSPECTOR' ? (
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
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(c) => c.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={(c) => setOpen(c.id)}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog open={open !== null} wide title={L('Complaint', 'तक्रार')} onClose={() => setOpen(null)}>
        {open ? <ComplaintDetail key={open} id={open} onDone={() => setOpen(null)} /> : null}
      </Dialog>
    </div>
  );
}
