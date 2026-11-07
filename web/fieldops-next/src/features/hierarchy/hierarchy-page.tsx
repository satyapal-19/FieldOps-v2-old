'use client';

import { useQuery } from '@tanstack/react-query';
import { useMemo, useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { useMe } from '@/features/shell/use-me';
import { ATTENDANCE_STATUS_TEXT, ROLE_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { istToday } from '@/shared/ist';
import { useWards } from '@/shared/lookups/use-wards';
import { Badge } from '@/shared/ui/badge';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';

type Staff = Schemas['StaffProfileDto'];
type Log = Schemas['AttendanceLogDto'];

/** Every page of a paged list (a ward has a few hundred people at most). */
async function allPages<T>(fetchPage: (page: number) => Promise<{ items: T[]; total: number; pageSize: number }>): Promise<T[]> {
  const first = await fetchPage(1);
  const items = [...first.items];
  for (let page = 2; (page - 1) * first.pageSize < first.total; page++) items.push(...(await fetchPage(page)).items);
  return items;
}

function Node({
  person,
  childrenOf,
  today,
  depth,
}: {
  person: Staff;
  childrenOf: Map<string, Staff[]>;
  today: Map<string, Log>;
  depth: number;
}) {
  const { pick } = useLocale();
  const [open, setOpen] = useState(depth < 2);
  const kids = childrenOf.get(person.id) ?? [];
  const log = today.get(person.id);
  return (
    <li>
      <div className="flex flex-wrap items-center gap-2 py-1">
        {kids.length > 0 ? (
          <button type="button" onClick={() => setOpen(!open)} className="w-5 text-slate-500" aria-expanded={open}>
            {open ? '▾' : '▸'}
          </button>
        ) : (
          <span className="w-5" />
        )}
        <span className="font-medium">{pick({ en: person.fullName, mr: person.fullNameMr })}</span>
        <span className="font-mono text-xs text-slate-500">{person.employeeCode}</span>
        <Badge tone={ROLE_TEXT[person.role].tone}>{pick(ROLE_TEXT[person.role])}</Badge>
        {log ? <Badge tone={ATTENDANCE_STATUS_TEXT[log.status].tone}>{pick(ATTENDANCE_STATUS_TEXT[log.status])}</Badge> : null}
        {kids.length > 0 ? <span className="text-xs text-slate-500">({kids.length})</span> : null}
      </div>
      {open && kids.length > 0 ? (
        <ul className="ml-5 border-l border-slate-200 pl-3">
          {kids.map((k) => (
            <Node key={k.id} person={k} childrenOf={childrenOf} today={today} depth={depth + 1} />
          ))}
        </ul>
      ) : null}
    </li>
  );
}

/** The reporting tree of a ward (ward inspector → inspectors → workers) with today's attendance. */
export function HierarchyPage() {
  const { t, pick } = useLocale();
  const role = useRole();
  const me = useMe();
  const { wards } = useWards();
  const [picked, setPicked] = useState('');
  const wardId = role === 'ADMIN' ? picked || wards[0]?.id || '' : (me.data?.homeWardId ?? '');
  const date = istToday();
  const L = (en: string, mr: string) => pick({ en, mr });

  const staff = useQuery({
    queryKey: ['staff', 'tree', wardId],
    enabled: !!wardId,
    queryFn: () =>
      allPages((page) =>
        unwrap(api.GET('/api/v1/staff', { params: { query: { wardId, isActive: true, page, pageSize: 100 } } })),
      ),
  });
  const logs = useQuery({
    queryKey: ['attendance', 'tree', date, wardId],
    enabled: !!wardId,
    refetchInterval: 60_000,
    queryFn: () =>
      allPages((page) =>
        unwrap(api.GET('/api/v1/attendance', { params: { query: { from: date, to: date, page, pageSize: 200 } } })),
      ),
  });

  const { roots, childrenOf } = useMemo(() => {
    const people = staff.data ?? [];
    const ids = new Set(people.map((p) => p.id));
    const byManager = new Map<string, Staff[]>();
    const top: Staff[] = [];
    for (const p of people) {
      if (p.reportsToId && ids.has(p.reportsToId)) {
        byManager.set(p.reportsToId, [...(byManager.get(p.reportsToId) ?? []), p]);
      } else top.push(p);
    }
    const order = ['WARD_INSPECTOR', 'INSPECTOR', 'WORKER', 'OFFICE_STAFF', 'ADMIN'];
    const sort = (a: Staff, b: Staff) => order.indexOf(a.role) - order.indexOf(b.role) || a.employeeCode.localeCompare(b.employeeCode);
    byManager.forEach((list) => list.sort(sort));
    return { roots: top.sort(sort), childrenOf: byManager };
  }, [staff.data]);
  const today = useMemo(() => new Map((logs.data ?? []).map((l) => [l.staffId, l])), [logs.data]);
  const unlinked = roots.filter((r) => r.role !== 'WARD_INSPECTOR');

  return (
    <div className="space-y-4">
      <PageHeader title={L('Hierarchy', 'पदक्रम')} subtitle={`${t('today')} ${date}`} />
      {role === 'ADMIN' ? (
        <div className="max-w-xs">
          <Field label={t('ward')}>
            <Select
              value={wardId}
              onChange={(e) => setPicked(e.target.value)}
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        </div>
      ) : null}
      {staff.isError ? <ErrorBanner error={staff.error} onRetry={() => staff.refetch()} /> : null}
      {staff.isPending && wardId ? <p className="text-sm text-slate-500">{t('loading')}</p> : null}
      <section className="rounded-lg border border-slate-200 bg-white p-4 text-sm">
        <ul>
          {roots
            .filter((r) => r.role === 'WARD_INSPECTOR')
            .map((r) => (
              <Node key={r.id} person={r} childrenOf={childrenOf} today={today} depth={0} />
            ))}
        </ul>
        {unlinked.length > 0 ? (
          <div className="mt-4 border-t border-slate-200 pt-3">
            <h2 className="font-medium text-amber-800">
              {L('No manager in this ward (set "Reports to" on the Staff page)', 'या प्रभागात वरिष्ठ नाही (कर्मचारी पानावर "वरिष्ठ" निवडा)')}
            </h2>
            <ul className="mt-1">
              {unlinked.map((r) => (
                <Node key={r.id} person={r} childrenOf={childrenOf} today={today} depth={1} />
              ))}
            </ul>
          </div>
        ) : null}
      </section>
    </div>
  );
}
