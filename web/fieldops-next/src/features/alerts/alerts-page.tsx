'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState, type FormEvent } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { ALERT_TYPE_TEXT, enumOptions, SEVERITY_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextArea } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Alert = Schemas['AlertDto'];
const PAGE_SIZE = 50;

/** The alert queue in the caller's scope, newest first; open alerts can be resolved with a note. */
export function AlertsPage() {
  const { t, pick, lang } = useLocale();
  const queryClient = useQueryClient();
  const { wardName } = useWards();
  const [resolved, setResolved] = useState<'false' | 'true' | ''>('false');
  const [alertType, setAlertType] = useState<Alert['alertType'] | ''>('');
  const [severity, setSeverity] = useState<Alert['severity'] | ''>('');
  const [page, setPage] = useState(1);
  const [open, setOpen] = useState<Alert | null>(null);
  const [note, setNote] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: ['alerts', 'list', { resolved, alertType, severity, page }],
    placeholderData: keepPreviousData,
    refetchInterval: 30_000,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/alerts', {
          params: {
            query: {
              isResolved: resolved === '' ? undefined : resolved === 'true',
              alertType: alertType || undefined,
              severity: severity || undefined,
              page,
              pageSize: PAGE_SIZE,
            },
          },
        }),
      ),
  });
  const names = useStaffNames([
    ...(list.data?.items.map((a) => a.staffId) ?? []),
    ...(list.data?.items.map((a) => a.resolvedById) ?? []),
  ]);

  const resolve = useMutation({
    mutationFn: (alert: Alert) =>
      unwrap(
        api.POST('/api/v1/alerts/{id}/resolve', {
          params: { path: { id: alert.id } },
          body: { note: note.trim() || undefined },
        }),
      ),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['alerts'] });
      setOpen(null);
    },
  });

  const show = (a: Alert) => {
    resolve.reset();
    setNote('');
    setOpen(a);
  };
  const submit = (e: FormEvent) => {
    e.preventDefault();
    if (open && !resolve.isPending) resolve.mutate(open);
  };
  const reset = <T,>(fn: (v: T) => void) => (v: T) => {
    fn(v);
    setPage(1);
  };

  const columns: Column<Alert>[] = [
    { key: 'when', header: L('When', 'केव्हा'), cell: (a) => <span className="whitespace-nowrap">{istDateTime(a.triggeredAt, lang)}</span> },
    {
      key: 'severity',
      header: L('Severity', 'तीव्रता'),
      cell: (a) => <Badge tone={SEVERITY_TEXT[a.severity].tone}>{pick(SEVERITY_TEXT[a.severity])}</Badge>,
    },
    { key: 'type', header: L('Type', 'प्रकार'), cell: (a) => pick(ALERT_TYPE_TEXT[a.alertType]) },
    { key: 'staff', header: t('staffMember'), cell: (a) => names.name(a.staffId) },
    { key: 'ward', header: t('ward'), cell: (a) => wardName(a.wardId) },
    { key: 'message', header: L('Message', 'संदेश'), cell: (a) => pick({ en: a.message, mr: a.messageMr }) },
    {
      key: 'state',
      header: t('status'),
      cell: (a) =>
        a.isResolved ? <Badge tone="green">{L('Resolved', 'निकाली')}</Badge> : <Badge tone="amber">{L('Open', 'खुली')}</Badge>,
    },
  ];

  return (
    <div>
      <PageHeader title={L('Alerts', 'सूचना')} subtitle={list.data ? `${list.data.total}` : undefined} />
      <FilterBar>
        <Field label={t('status')}>
          <Select
            value={resolved}
            onChange={(e) => reset(setResolved)(e.target.value as 'false' | 'true' | '')}
            placeholder={t('all')}
            options={[
              { value: 'false', label: L('Open', 'खुली') },
              { value: 'true', label: L('Resolved', 'निकाली') },
            ]}
          />
        </Field>
        <Field label={L('Type', 'प्रकार')}>
          <Select
            value={alertType}
            onChange={(e) => reset(setAlertType)(e.target.value as Alert['alertType'] | '')}
            placeholder={t('all')}
            options={enumOptions(ALERT_TYPE_TEXT, pick)}
          />
        </Field>
        <Field label={L('Severity', 'तीव्रता')}>
          <Select
            value={severity}
            onChange={(e) => reset(setSeverity)(e.target.value as Alert['severity'] | '')}
            placeholder={t('all')}
            options={enumOptions(SEVERITY_TEXT, pick)}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(a) => a.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={(a) => show(a)}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog open={!!open} title={open ? pick(ALERT_TYPE_TEXT[open.alertType]) : ''} onClose={() => setOpen(null)}>
        {open ? (
          <form onSubmit={submit} className="space-y-3 text-sm">
            <p>{pick({ en: open.message, mr: open.messageMr })}</p>
            <p className="text-slate-500">
              {names.name(open.staffId)} · {wardName(open.wardId)} · {istDateTime(open.triggeredAt, lang)}
            </p>
            {open.isResolved ? (
              <p className="rounded-md bg-green-50 p-3 text-green-900">
                {L('Resolved by', 'निकाली काढले:')} {names.name(open.resolvedById)}
                {open.resolvedAt ? ` · ${istDateTime(open.resolvedAt, lang)}` : ''}
                {open.resolutionNote ? <span className="mt-1 block">{open.resolutionNote}</span> : null}
              </p>
            ) : (
              <>
                <Field label={L('What was done (optional)', 'काय कारवाई केली (ऐच्छिक)')}>
                  <TextArea value={note} maxLength={500} onChange={(e) => setNote(e.target.value)} />
                </Field>
                {resolve.isError ? <ErrorBanner error={resolve.error} /> : null}
                <div className="flex justify-end gap-2">
                  <button type="button" className="btn-secondary" onClick={() => setOpen(null)}>
                    {t('cancel')}
                  </button>
                  <button type="submit" className="btn-primary" disabled={resolve.isPending}>
                    {L('Mark resolved', 'निकाली काढा')}
                  </button>
                </div>
              </>
            )}
          </form>
        ) : null}
      </Dialog>
    </div>
  );
}
