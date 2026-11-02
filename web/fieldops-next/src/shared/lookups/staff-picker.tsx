'use client';

import { useQuery } from '@tanstack/react-query';
import { useState } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';
import { Field, Select, TextInput } from '@/shared/ui/fields';

type Role = Schemas['StaffProfileDto']['role'];

/**
 * Pick an active staff member in the caller's scope: type part of a code or name, then choose.
 * `roles` narrows the list (the API still checks who may be picked).
 */
export function StaffPicker({
  label,
  value,
  onChange,
  roles,
  excludeId,
}: {
  label: string;
  value: string;
  onChange(id: string): void;
  roles: readonly Role[];
  excludeId?: string;
}) {
  const { pick } = useLocale();
  const [q, setQ] = useState('');
  const results = useQuery({
    queryKey: ['staff', 'picker', q.trim(), roles],
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/staff', {
          params: { query: { q: q.trim() || undefined, isActive: true, pageSize: 100 } },
        }),
      ),
  });
  const options = (results.data?.items ?? [])
    .filter((s) => roles.includes(s.role) && s.id !== excludeId)
    .map((s) => ({ value: s.id, label: `${pick({ en: s.fullName, mr: s.fullNameMr })} (${s.employeeCode})` }));
  return (
    <div className="grid grid-cols-1 gap-2 sm:grid-cols-2">
      <Field label={label}>
        <TextInput
          type="search"
          value={q}
          placeholder={pick({ en: 'Search code or name', mr: 'कोड किंवा नाव शोधा' })}
          onChange={(e) => setQ(e.target.value)}
        />
      </Field>
      <Field label={pick({ en: 'Choose', mr: 'निवडा' })}>
        <Select required value={value} onChange={(e) => onChange(e.target.value)} placeholder="—" options={options} />
      </Field>
    </div>
  );
}
