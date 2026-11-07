'use client';

import { keepPreviousData, useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { useLocale, type Bilingual } from '@/shared/i18n/locale';
import { addDays, istToday } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';

type Assignment = Schemas['AssignmentDto'];
type Squad = Schemas['StandingRosterDto'];
const PAGE_SIZE = 200;

const MODE_TEXT: Record<Assignment['assignmentMode'], Bilingual> = {
  STANDING_ROSTER: { en: 'Standing squad', mr: 'कायम पथक' },
  ADMIN_ASSIGNED: { en: 'By admin', mr: 'प्रशासकाकडून' },
  WARD_INSPECTOR_ASSIGNED: { en: 'By ward inspector', mr: 'प्रभाग निरीक्षकाकडून' },
  INSPECTOR_SELF_PICK: { en: 'Self-picked ward', mr: 'स्वतः निवडलेला प्रभाग' },
  WORKER_SELF_JOIN: { en: 'Self-joined team', mr: 'स्वतः पथकात सामील' },
};

/** Who works where on a day (inspectors in wards, workers in teams), and the standing squads. */
export function PlanningPage() {
  const { t, pick } = useLocale();
  const role = useRole();
  const queryClient = useQueryClient();
  const { wards, wardName } = useWards();
  const [tab, setTab] = useState<'day' | 'squads'>('day');
  const [date, setDate] = useState(istToday());
  const [wardId, setWardId] = useState('');
  const [page, setPage] = useState(1);
  const [placing, setPlacing] = useState(false);
  const [editing, setEditing] = useState<Squad | 'new' | null>(null);
  const L = (en: string, mr: string) => pick({ en, mr });
  const wardFilter = role === 'ADMIN' ? wardId || undefined : undefined;

  const day = useQuery({
    queryKey: ['assignments', date, wardFilter, page],
    enabled: tab === 'day',
    placeholderData: keepPreviousData,
    queryFn: () =>
      unwrap(api.GET('/api/v1/assignments', { params: { query: { date, wardId: wardFilter, page, pageSize: PAGE_SIZE } } })),
  });
  const squads = useQuery({
    queryKey: ['squads', wardFilter, page],
    enabled: tab === 'squads',
    placeholderData: keepPreviousData,
    queryFn: () =>
      unwrap(api.GET('/api/v1/rosters/standing', { params: { query: { wardId: wardFilter, page, pageSize: PAGE_SIZE } } })),
  });
  const names = useStaffNames([
    ...(day.data?.items.flatMap((a) => [a.staffId, a.inspectorId]) ?? []),
    ...(squads.data?.items.flatMap((s) => [s.workerId, s.inspectorId]) ?? []),
  ]);

  const generate = useMutation({
    mutationFn: () => unwrap(api.POST('/api/v1/assignments/generate', { body: { date } })),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['assignments'] }),
  });
  const approve = useMutation({
    mutationFn: (a: Assignment) =>
      unwrap(
        api.POST('/api/v1/assignments/{id}/approve', {
          params: { path: { id: a.id } },
          body: { expectedVersion: a.version },
        }),
      ),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['assignments'] }),
  });

  const dayColumns: Column<Assignment>[] = [
    { key: 'who', header: t('staffMember'), cell: (a) => names.name(a.staffId) },
    { key: 'role', header: t('role'), cell: (a) => (a.staffRole === 'INSPECTOR' ? L('Inspector', 'निरीक्षक') : L('Worker', 'कामगार')) },
    { key: 'ward', header: t('ward'), cell: (a) => wardName(a.wardId) },
    { key: 'team', header: L('Inspector', 'निरीक्षक'), cell: (a) => (a.staffRole === 'WORKER' ? names.name(a.inspectorId) : '—') },
    { key: 'mode', header: L('How', 'कसे'), cell: (a) => pick(MODE_TEXT[a.assignmentMode]) },
    {
      key: 'ok',
      header: t('status'),
      cell: (a) =>
        a.isApproved ? (
          <Badge tone="green">{L('Approved', 'मंजूर')}</Badge>
        ) : (
          <button type="button" className="btn-secondary" disabled={approve.isPending} onClick={() => approve.mutate(a)}>
            {t('approve')}
          </button>
        ),
    },
  ];
  const squadColumns: Column<Squad>[] = [
    { key: 'worker', header: L('Worker', 'कामगार'), cell: (s) => names.name(s.workerId) },
    { key: 'inspector', header: L('Inspector', 'निरीक्षक'), cell: (s) => names.name(s.inspectorId) },
    { key: 'ward', header: t('ward'), cell: (s) => wardName(s.wardId) },
    { key: 'active', header: t('status'), cell: (s) => <Badge tone={s.isActive ? 'green' : 'slate'}>{s.isActive ? t('active') : t('inactive')}</Badge> },
  ];

  return (
    <div>
      <PageHeader
        title={L('Planning', 'नियोजन')}
        actions={
          tab === 'day' ? (
            <>
              <button type="button" className="btn-secondary" disabled={generate.isPending} onClick={() => generate.mutate()}>
                {L('Create from standing squads', 'कायम पथकांतून तयार करा')}
              </button>
              <button type="button" className="btn-primary" onClick={() => setPlacing(true)}>
                {L('Place someone', 'नेमणूक करा')}
              </button>
            </>
          ) : (
            <button type="button" className="btn-primary" onClick={() => setEditing('new')}>
              {L('Add worker to a squad', 'पथकात कामगार जोडा')}
            </button>
          )
        }
      />
      <div className="mb-4 flex gap-2" role="tablist">
        {(
          [
            ['day', L('Day plan', 'दिवसाचे नियोजन')],
            ['squads', L('Standing squads', 'कायम पथके')],
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
        {tab === 'day' ? (
          <Field label={t('date')}>
            <TextInput
              type="date"
              value={date}
              max={addDays(istToday(), 7)}
              onChange={(e) => {
                if (e.target.value) setDate(e.target.value);
                setPage(1);
              }}
            />
          </Field>
        ) : null}
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
      {generate.isSuccess ? (
        <p className="mb-3 text-sm text-green-700">
          {L(`${generate.data.created} assignments created for ${generate.data.date}.`, `${generate.data.date} साठी ${generate.data.created} नेमणुका तयार केल्या.`)}
        </p>
      ) : null}
      {[generate, approve].map((m, i) => (m.isError ? <ErrorBanner key={i} error={m.error} /> : null))}
      {tab === 'day' ? (
        <>
          {day.isError ? <ErrorBanner error={day.error} onRetry={() => day.refetch()} /> : null}
          <DataTable columns={dayColumns} rows={day.data?.items} rowKey={(a) => a.id} loading={day.isPending} empty={t('noRecords')} />
          <Pager page={page} pageSize={PAGE_SIZE} total={day.data?.total} onPage={setPage} />
        </>
      ) : (
        <>
          {squads.isError ? <ErrorBanner error={squads.error} onRetry={() => squads.refetch()} /> : null}
          <DataTable
            columns={squadColumns}
            rows={squads.data?.items}
            rowKey={(s) => s.id}
            loading={squads.isPending}
            empty={t('noRecords')}
            onRowClick={(s) => setEditing(s)}
          />
          <Pager page={page} pageSize={PAGE_SIZE} total={squads.data?.total} onPage={setPage} />
        </>
      )}
      <Dialog open={placing} title={L('Place someone for the day', 'दिवसासाठी नेमणूक')} onClose={() => setPlacing(false)}>
        {placing ? <PlaceForm date={date} onDone={() => setPlacing(false)} /> : null}
      </Dialog>
      <Dialog
        open={editing !== null}
        title={editing === 'new' ? L('Add worker to a squad', 'पथकात कामगार जोडा') : L('Standing squad', 'कायम पथक')}
        onClose={() => setEditing(null)}
      >
        {editing !== null ? <SquadForm key={editing === 'new' ? 'new' : editing.id} squad={editing === 'new' ? null : editing} onDone={() => setEditing(null)} /> : null}
      </Dialog>
    </div>
  );
}

/** An inspector goes to a ward; a worker joins an inspector's team. Approved at once. */
function PlaceForm({ date, onDone }: { date: string; onDone(): void }) {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const { wards } = useWards();
  const [kind, setKind] = useState<'INSPECTOR' | 'WORKER'>('WORKER');
  const [staffId, setStaffId] = useState('');
  const [target, setTarget] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });
  const place = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/assignments', {
          body: kind === 'INSPECTOR' ? { date, staffId, wardId: target } : { date, staffId, inspectorId: target },
        }),
      ),
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['assignments'] });
      onDone();
    },
  });
  return (
    <div className="space-y-3 text-sm">
      <p className="text-slate-600">{date}</p>
      <Field label={t('role')}>
        <Select
          value={kind}
          onChange={(e) => {
            setKind(e.target.value as 'INSPECTOR' | 'WORKER');
            setStaffId('');
            setTarget('');
          }}
          options={[
            { value: 'WORKER', label: L('Worker into a team', 'कामगार पथकात') },
            { value: 'INSPECTOR', label: L('Inspector into a ward', 'निरीक्षक प्रभागात') },
          ]}
        />
      </Field>
      <StaffPicker key={`who-${kind}`} label={L('Who', 'कोण')} value={staffId} onChange={setStaffId} roles={[kind]} />
      {kind === 'INSPECTOR' ? (
        <Field label={t('ward')}>
          <Select
            value={target}
            onChange={(e) => setTarget(e.target.value)}
            placeholder="—"
            options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
          />
        </Field>
      ) : (
        <StaffPicker key="team" label={L('Inspector (team)', 'निरीक्षक (पथक)')} value={target} onChange={setTarget} roles={['INSPECTOR']} />
      )}
      {place.isError ? <ErrorBanner error={place.error} /> : null}
      <div className="flex justify-end gap-2">
        <button type="button" className="btn-secondary" onClick={onDone}>
          {t('cancel')}
        </button>
        <button type="button" className="btn-primary" disabled={!staffId || !target || place.isPending} onClick={() => place.mutate()}>
          {t('save')}
        </button>
      </div>
    </div>
  );
}

/** Add a worker to an inspector's standing squad, move them, or (de)activate the row. */
function SquadForm({ squad, onDone }: { squad: Squad | null; onDone(): void }) {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const names = useStaffNames(squad ? [squad.workerId] : []);
  const [workerId, setWorkerId] = useState('');
  const [inspectorId, setInspectorId] = useState(squad?.inspectorId ?? '');
  const L = (en: string, mr: string) => pick({ en, mr });
  const done = async () => {
    await queryClient.invalidateQueries({ queryKey: ['squads'] });
    onDone();
  };
  const save = useMutation({
    mutationFn: (fields: { isActive?: boolean }) =>
      squad
        ? unwrap(
            api.PATCH('/api/v1/rosters/standing/{id}', {
              params: { path: { id: squad.id } },
              body: {
                expectedVersion: squad.version,
                inspectorId: inspectorId !== squad.inspectorId ? inspectorId : undefined,
                ...fields,
              },
            }),
          )
        : unwrap(api.POST('/api/v1/rosters/standing', { body: { workerId, inspectorId } })),
    onSuccess: done,
  });
  return (
    <div className="space-y-3 text-sm">
      {squad ? (
        <p className="font-medium">{names.name(squad.workerId)}</p>
      ) : (
        <StaffPicker label={L('Worker', 'कामगार')} value={workerId} onChange={setWorkerId} roles={['WORKER']} />
      )}
      <StaffPicker label={L('Inspector', 'निरीक्षक')} value={inspectorId} onChange={setInspectorId} roles={['INSPECTOR']} />
      {save.isError ? <ErrorBanner error={save.error} /> : null}
      <div className="flex flex-wrap justify-between gap-2">
        {squad ? (
          <button type="button" className="btn-secondary" disabled={save.isPending} onClick={() => save.mutate({ isActive: !squad.isActive })}>
            {squad.isActive ? L('Remove from squad', 'पथकातून काढा') : L('Put back in squad', 'पुन्हा पथकात घ्या')}
          </button>
        ) : (
          <span />
        )}
        <span className="flex gap-2">
          <button type="button" className="btn-secondary" onClick={onDone}>
            {t('cancel')}
          </button>
          <button
            type="button"
            className="btn-primary"
            disabled={save.isPending || !inspectorId || (!squad && !workerId)}
            onClick={() => save.mutate({})}
          >
            {t('save')}
          </button>
        </span>
      </div>
    </div>
  );
}
