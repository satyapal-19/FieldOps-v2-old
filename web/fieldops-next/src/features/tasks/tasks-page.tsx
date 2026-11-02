'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState, type FormEvent } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { enumOptions, PRIORITY_TEXT, TASK_STATUS_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextArea, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Task = Schemas['TaskDto'];
type Status = Task['status'];
type Action = Schemas['SupervisorActionDto']['action'];
type Role = Schemas['StaffProfileDto']['role'];
const PAGE_SIZE = 50;

/** Who each web role can hand a task to (down the hierarchy; the API has the final say). */
const ASSIGNABLE: Record<string, readonly Role[]> = {
  ADMIN: ['WARD_INSPECTOR', 'INSPECTOR', 'WORKER'],
  WARD_INSPECTOR: ['INSPECTOR', 'WORKER'],
};

/** Supervisor actions per status (tasks.policy: SUPERVISOR_ACTIONS). */
const ACTIONS: Record<Status, readonly Action[]> = {
  OPEN: ['ESCALATE', 'CLOSE'],
  IN_PROGRESS: ['ESCALATE'],
  SUBMITTED: ['APPROVE', 'REJECT'],
  APPROVED: ['CLOSE'],
  REJECTED: ['ESCALATE'],
  ESCALATED: ['CLOSE'],
  CLOSED: [],
};
const REASSIGNABLE: readonly Status[] = ['OPEN', 'IN_PROGRESS', 'REJECTED', 'ESCALATED'];

const ACTION_TEXT: Record<Action, { en: string; mr: string }> = {
  APPROVE: { en: 'Approve work', mr: 'काम मंजूर करा' },
  REJECT: { en: 'Send back', mr: 'परत पाठवा' },
  ESCALATE: { en: 'Escalate', mr: 'वरिष्ठांकडे पाठवा' },
  CLOSE: { en: 'Close', mr: 'बंद करा' },
};

/** A datetime-local value (the dashboard runs in IST) as a UTC ISO timestamp. */
const istLocalToIso = (v: string) => (v ? new Date(`${v}:00+05:30`).toISOString() : undefined);

function NewTaskForm({ onDone }: { onDone(): void }) {
  const { t, pick } = useLocale();
  const role = useRole();
  const queryClient = useQueryClient();
  const [f, setF] = useState({ title: '', titleMr: '', description: '', priority: 'NORMAL' as Task['priority'], assignedToId: '', dueAt: '', locationLabel: '' });
  const L = (en: string, mr: string) => pick({ en, mr });
  const create = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/tasks', {
          body: {
            title: f.title.trim(),
            titleMr: f.titleMr.trim() || undefined,
            description: f.description.trim() || undefined,
            priority: f.priority,
            assignedToId: f.assignedToId,
            dueAt: istLocalToIso(f.dueAt),
            locationLabel: f.locationLabel.trim() || undefined,
          },
        }),
      ),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['tasks'] });
      onDone();
    },
  });
  const submit = (e: FormEvent) => {
    e.preventDefault();
    if (!create.isPending) create.mutate();
  };
  return (
    <form onSubmit={submit} className="space-y-3">
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <Field label={L('Title (English)', 'शीर्षक (इंग्रजी)')}>
          <TextInput required maxLength={200} value={f.title} onChange={(e) => setF({ ...f, title: e.target.value })} />
        </Field>
        <Field label={L('Title (Marathi)', 'शीर्षक (मराठी)')}>
          <TextInput maxLength={200} value={f.titleMr} onChange={(e) => setF({ ...f, titleMr: e.target.value })} />
        </Field>
      </div>
      <Field label={L('Description', 'वर्णन')}>
        <TextArea maxLength={2000} value={f.description} onChange={(e) => setF({ ...f, description: e.target.value })} />
      </Field>
      <StaffPicker
        label={L('Assign to', 'कोणाला द्यायचे')}
        value={f.assignedToId}
        onChange={(id) => setF({ ...f, assignedToId: id })}
        roles={ASSIGNABLE[role] ?? []}
      />
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-3">
        <Field label={L('Priority', 'प्राधान्य')}>
          <Select value={f.priority} onChange={(e) => setF({ ...f, priority: e.target.value as Task['priority'] })} options={enumOptions(PRIORITY_TEXT, pick)} />
        </Field>
        <Field label={L('Due (IST)', 'मुदत (IST)')}>
          <TextInput type="datetime-local" value={f.dueAt} onChange={(e) => setF({ ...f, dueAt: e.target.value })} />
        </Field>
        <Field label={L('Place', 'ठिकाण')}>
          <TextInput maxLength={200} value={f.locationLabel} onChange={(e) => setF({ ...f, locationLabel: e.target.value })} />
        </Field>
      </div>
      {create.isError ? <ErrorBanner error={create.error} /> : null}
      <div className="flex justify-end gap-2">
        <button type="button" className="btn-secondary" onClick={onDone}>
          {t('cancel')}
        </button>
        <button type="submit" className="btn-primary" disabled={create.isPending || !f.assignedToId}>
          {L('Assign task', 'काम द्या')}
        </button>
      </div>
    </form>
  );
}

function TaskDetail({ task, onDone }: { task: Task; onDone(): void }) {
  const { pick, lang } = useLocale();
  const role = useRole();
  const queryClient = useQueryClient();
  const [reason, setReason] = useState('');
  const [reassignTo, setReassignTo] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });
  const history = useQuery({
    queryKey: ['tasks', 'history', task.id],
    queryFn: () => unwrap(api.GET('/api/v1/tasks/{id}/history', { params: { path: { id: task.id } } })),
  });
  const names = useStaffNames([task.assignedToId, task.createdById, ...(history.data?.map((h) => h.staffId) ?? [])]);
  const done = async () => {
    await queryClient.invalidateQueries({ queryKey: ['tasks'] });
    onDone();
  };
  const act = useMutation({
    mutationFn: (action: Action) =>
      unwrap(
        api.POST('/api/v1/tasks/{id}/review', {
          params: { path: { id: task.id } },
          body: { expectedVersion: task.version, action, reason: reason.trim() || undefined },
        }),
      ),
    onSuccess: done,
  });
  const reassign = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/tasks/{id}/reassign', {
          params: { path: { id: task.id } },
          body: { expectedVersion: task.version, assignedToId: reassignTo },
        }),
      ),
    onSuccess: done,
  });

  return (
    <div className="space-y-4 text-sm">
      <div className="flex flex-wrap gap-2">
        <Badge tone={TASK_STATUS_TEXT[task.status].tone}>{pick(TASK_STATUS_TEXT[task.status])}</Badge>
        <Badge tone={PRIORITY_TEXT[task.priority].tone}>{pick(PRIORITY_TEXT[task.priority])}</Badge>
        {task.rejectionCount > 0 ? <Badge tone="red">{L(`Sent back ${task.rejectionCount}×`, `${task.rejectionCount} वेळा परत`)}</Badge> : null}
      </div>
      {task.description ? <p className="whitespace-pre-wrap">{task.description}</p> : null}
      <dl className="grid grid-cols-2 gap-x-4 gap-y-1">
        <dt className="text-slate-500">{L('Assigned to', 'कोणाकडे')}</dt>
        <dd>{names.name(task.assignedToId)}</dd>
        <dt className="text-slate-500">{L('Given by', 'कोणी दिले')}</dt>
        <dd>{names.name(task.createdById)}</dd>
        <dt className="text-slate-500">{L('Due', 'मुदत')}</dt>
        <dd>{task.dueAt ? istDateTime(task.dueAt, lang) : '—'}</dd>
        <dt className="text-slate-500">{L('Place', 'ठिकाण')}</dt>
        <dd>{task.locationLabel ?? '—'}</dd>
        {task.completionNote ? (
          <>
            <dt className="text-slate-500">{L('Worker note', 'कर्मचाऱ्याची टीप')}</dt>
            <dd>{task.completionNote}</dd>
          </>
        ) : null}
        {task.rejectionReason ? (
          <>
            <dt className="text-slate-500">{L('Last sent back for', 'परत पाठवण्याचे कारण')}</dt>
            <dd>{task.rejectionReason}</dd>
          </>
        ) : null}
      </dl>
      <section>
        <h3 className="font-medium">{L('History', 'इतिहास')}</h3>
        <ol className="mt-1 space-y-1">
          {history.data?.map((h) => (
            <li key={h.id} className="text-slate-700">
              <span className="text-slate-500">{istDateTime(h.createdAt, lang)}</span> · {names.name(h.staffId)}:{' '}
              {pick(TASK_STATUS_TEXT[h.fromStatus])} → {pick(TASK_STATUS_TEXT[h.toStatus])}
              {h.note ? ` — ${h.note}` : ''}
            </li>
          ))}
        </ol>
      </section>
      {ACTIONS[task.status].length > 0 ? (
        <section className="space-y-2 border-t border-slate-200 pt-3">
          <Field label={L('Reason (needed to send back)', 'कारण (परत पाठवताना आवश्यक)')}>
            <TextArea value={reason} maxLength={500} onChange={(e) => setReason(e.target.value)} />
          </Field>
          {act.isError ? <ErrorBanner error={act.error} /> : null}
          <div className="flex flex-wrap justify-end gap-2">
            {ACTIONS[task.status].map((a) => (
              <button
                key={a}
                type="button"
                disabled={act.isPending || (a === 'REJECT' && !reason.trim())}
                className={a === 'REJECT' || a === 'ESCALATE' ? 'btn-danger' : 'btn-primary'}
                onClick={() => act.mutate(a)}
              >
                {pick(ACTION_TEXT[a])}
              </button>
            ))}
          </div>
        </section>
      ) : null}
      {REASSIGNABLE.includes(task.status) ? (
        <section className="space-y-2 border-t border-slate-200 pt-3">
          <StaffPicker
            label={L('Give to someone else', 'दुसऱ्याला द्या')}
            value={reassignTo}
            onChange={setReassignTo}
            roles={ASSIGNABLE[role] ?? []}
            excludeId={task.assignedToId ?? undefined}
          />
          {reassign.isError ? <ErrorBanner error={reassign.error} /> : null}
          <div className="flex justify-end">
            <button type="button" className="btn-secondary" disabled={!reassignTo || reassign.isPending} onClick={() => reassign.mutate()}>
              {L('Reassign', 'पुन्हा नेमा')}
            </button>
          </div>
        </section>
      ) : null}
    </div>
  );
}

/** Tasks in the caller's scope: assign new work, review submissions, escalate, reassign. */
export function TasksPage() {
  const { t, pick, lang } = useLocale();
  const { wardName } = useWards();
  const [status, setStatus] = useState<Status | ''>('');
  const [page, setPage] = useState(1);
  const [open, setOpen] = useState<Task | 'new' | null>(null);
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: ['tasks', 'list', { status, page }],
    placeholderData: keepPreviousData,
    refetchInterval: 60_000,
    queryFn: () =>
      unwrap(api.GET('/api/v1/tasks', { params: { query: { status: status || undefined, page, pageSize: PAGE_SIZE } } })),
  });
  const names = useStaffNames(list.data?.items.map((x) => x.assignedToId) ?? []);

  const columns: Column<Task>[] = [
    { key: 'title', header: L('Task', 'काम'), cell: (x) => pick({ en: x.title, mr: x.titleMr }) },
    {
      key: 'status',
      header: t('status'),
      cell: (x) => (
        <span className="flex flex-wrap gap-1">
          <Badge tone={TASK_STATUS_TEXT[x.status].tone}>{pick(TASK_STATUS_TEXT[x.status])}</Badge>
          {x.priority === 'URGENT' ? <Badge tone="red">{pick(PRIORITY_TEXT.URGENT)}</Badge> : null}
        </span>
      ),
    },
    { key: 'who', header: L('Assigned to', 'कोणाकडे'), cell: (x) => names.name(x.assignedToId) },
    { key: 'ward', header: t('ward'), cell: (x) => wardName(x.wardId) },
    { key: 'due', header: L('Due', 'मुदत'), cell: (x) => <span className="whitespace-nowrap">{x.dueAt ? istDateTime(x.dueAt, lang) : '—'}</span> },
  ];

  return (
    <div>
      <PageHeader
        title={L('Tasks', 'कामे')}
        subtitle={list.data ? `${list.data.total}` : undefined}
        actions={
          <button type="button" className="btn-primary" onClick={() => setOpen('new')}>
            {L('New task', 'नवीन काम')}
          </button>
        }
      />
      <FilterBar>
        <Field label={t('status')}>
          <Select
            value={status}
            onChange={(e) => {
              setStatus(e.target.value as Status | '');
              setPage(1);
            }}
            placeholder={t('all')}
            options={enumOptions(TASK_STATUS_TEXT, pick)}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(x) => x.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={(x) => setOpen(x)}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog
        open={open !== null}
        wide
        title={open === 'new' ? L('New task', 'नवीन काम') : open ? pick({ en: open.title, mr: open.titleMr }) : ''}
        onClose={() => setOpen(null)}
      >
        {open === 'new' ? <NewTaskForm onDone={() => setOpen(null)} /> : null}
        {open && open !== 'new' ? <TaskDetail key={open.id} task={open} onDone={() => setOpen(null)} /> : null}
      </Dialog>
    </div>
  );
}
