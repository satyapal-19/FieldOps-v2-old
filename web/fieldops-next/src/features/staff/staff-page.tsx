'use client';

import { keepPreviousData, useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { enumOptions, ROLE_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { useOffices, useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { DataTable, type Column } from '@/shared/ui/data-table';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, FilterBar, Select, TextInput } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';
import { Pager } from '@/shared/ui/pager';
import { StaffForm } from './staff-form';

type Staff = Schemas['StaffProfileDto'];
type Role = Staff['role'];
const PAGE_SIZE = 50;

/** Staff in the caller's scope (admin all, ward inspector their ward). Admins add and edit. */
export function StaffPage() {
  const { t, pick } = useLocale();
  const role = useRole();
  const isAdmin = role === 'ADMIN';
  const { wards, wardName } = useWards();
  const { officeName } = useOffices();
  const [q, setQ] = useState('');
  const [staffRole, setStaffRole] = useState<Role | ''>('');
  const [wardId, setWardId] = useState('');
  const [active, setActive] = useState<'true' | 'false' | ''>('true');
  const [page, setPage] = useState(1);
  const [editing, setEditing] = useState<Staff | 'new' | null>(null);

  const list = useQuery({
    queryKey: ['staff', 'list', { q, staffRole, wardId, active, page }],
    placeholderData: keepPreviousData,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/staff', {
          params: {
            query: {
              q: q.trim() || undefined,
              role: staffRole || undefined,
              wardId: wardId || undefined,
              isActive: active === '' ? undefined : active === 'true',
              page,
              pageSize: PAGE_SIZE,
            },
          },
        }),
      ),
  });

  const filter = <T,>(fn: (v: T) => void) => (v: T) => {
    fn(v);
    setPage(1);
  };
  const L = (en: string, mr: string) => pick({ en, mr });

  const columns: Column<Staff>[] = [
    { key: 'code', header: L('Code', 'कोड'), cell: (s) => <span className="font-mono">{s.employeeCode}</span> },
    { key: 'name', header: t('name'), cell: (s) => pick({ en: s.fullName, mr: s.fullNameMr }) },
    {
      key: 'role',
      header: t('role'),
      cell: (s) => <Badge tone={ROLE_TEXT[s.role].tone}>{pick(ROLE_TEXT[s.role])}</Badge>,
    },
    {
      key: 'place',
      header: L('Ward / office', 'प्रभाग / कार्यालय'),
      cell: (s) => (s.officeId ? officeName(s.officeId) : wardName(s.homeWardId)),
    },
    { key: 'phone', header: L('Mobile', 'मोबाइल'), cell: (s) => <span className="font-mono">{s.phone}</span> },
    { key: 'shift', header: L('Shift', 'शिफ्ट'), cell: (s) => `${s.shiftStart}–${s.shiftEnd}` },
    {
      key: 'status',
      header: t('status'),
      cell: (s) => <Badge tone={s.isActive ? 'green' : 'slate'}>{s.isActive ? t('active') : t('inactive')}</Badge>,
    },
  ];

  return (
    <div>
      <PageHeader
        title={L('Staff', 'कर्मचारी')}
        subtitle={list.data ? L(`${list.data.total} people`, `${list.data.total} व्यक्ती`) : undefined}
        actions={
          isAdmin ? (
            <button type="button" className="btn-primary" onClick={() => setEditing('new')}>
              {L('Add staff', 'कर्मचारी जोडा')}
            </button>
          ) : null
        }
      />
      <FilterBar>
        <Field label={t('search')}>
          <TextInput
            type="search"
            value={q}
            placeholder={L('Code or name', 'कोड किंवा नाव')}
            onChange={(e) => filter(setQ)(e.target.value)}
          />
        </Field>
        <Field label={t('role')}>
          <Select
            value={staffRole}
            onChange={(e) => filter(setStaffRole)(e.target.value as Role | '')}
            placeholder={t('all')}
            options={enumOptions(ROLE_TEXT, pick)}
          />
        </Field>
        {isAdmin ? (
          <Field label={t('ward')}>
            <Select
              value={wardId}
              onChange={(e) => filter(setWardId)(e.target.value)}
              placeholder={t('all')}
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        ) : null}
        <Field label={t('status')}>
          <Select
            value={active}
            onChange={(e) => filter(setActive)(e.target.value as 'true' | 'false' | '')}
            placeholder={t('all')}
            options={[
              { value: 'true', label: t('active') },
              { value: 'false', label: t('inactive') },
            ]}
          />
        </Field>
      </FilterBar>
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <DataTable
        columns={columns}
        rows={list.data?.items}
        rowKey={(s) => s.id}
        loading={list.isPending}
        empty={t('noRecords')}
        onRowClick={isAdmin ? (s) => setEditing(s) : undefined}
      />
      <Pager page={page} pageSize={PAGE_SIZE} total={list.data?.total} onPage={setPage} />
      <Dialog
        open={editing !== null}
        wide
        title={editing === 'new' ? L('Add staff', 'कर्मचारी जोडा') : L('Edit staff', 'कर्मचारी माहिती बदला')}
        onClose={() => setEditing(null)}
      >
        {editing !== null ? (
          <StaffForm
            key={editing === 'new' ? 'new' : editing.id}
            staff={editing === 'new' ? null : editing}
            onDone={() => setEditing(null)}
          />
        ) : null}
      </Dialog>
    </div>
  );
}
