'use client';

import { useMutation } from '@tanstack/react-query';
import { useState } from 'react';
import { api, toApiError } from '@/api/client';
import { useRole } from '@/features/shell/role-context';
import { useLocale } from '@/shared/i18n/locale';
import { istToday } from '@/shared/ist';
import { useWards } from '@/shared/lookups/use-wards';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select, TextInput } from '@/shared/ui/fields';

/** Download a ward's monthly muster roll: CSV (opens in Excel, Marathi names) or a printable PDF. */
export function MusterDownload() {
  const { t, pick } = useLocale();
  const role = useRole();
  const { wards } = useWards();
  const [month, setMonth] = useState(istToday().slice(0, 7));
  const [wardId, setWardId] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const download = useMutation({
    mutationFn: async (format: 'csv' | 'pdf') => {
      const { data, error, response } = await api.GET('/api/v1/reports/muster-roll', {
        params: { query: { month, format, wardId: wardId || undefined } },
        parseAs: 'blob',
      });
      if (!response.ok || !data) {
        const body = error ?? (await response.clone().json().catch(() => null));
        throw toApiError(body, response.status, response.headers.get('X-Request-Id'));
      }
      const name = /filename="([^"]+)"/.exec(response.headers.get('content-disposition') ?? '')?.[1] ?? `muster-roll.${format}`;
      const url = URL.createObjectURL(data as Blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = name;
      a.click();
      URL.revokeObjectURL(url);
    },
  });

  return (
    <section className="mb-4 rounded-lg border border-slate-200 bg-white p-4">
      <h2 className="font-medium">{L('Muster roll', 'हजेरी पत्रक (मस्टर)')}</h2>
      <div className="mt-2 grid grid-cols-1 gap-3 sm:grid-cols-4">
        <Field label={L('Month', 'महिना')}>
          <TextInput type="month" max={istToday().slice(0, 7)} value={month} onChange={(e) => e.target.value && setMonth(e.target.value)} />
        </Field>
        {role === 'ADMIN' ? (
          <Field label={t('ward')}>
            <Select
              value={wardId}
              onChange={(e) => setWardId(e.target.value)}
              placeholder="—"
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        ) : null}
        <div className="flex items-end gap-2 sm:col-span-2">
          <button
            type="button"
            className="btn-secondary"
            disabled={download.isPending || (role === 'ADMIN' && !wardId)}
            onClick={() => download.mutate('csv')}
          >
            {L('Download CSV', 'CSV डाउनलोड')}
          </button>
          <button
            type="button"
            className="btn-secondary"
            disabled={download.isPending || (role === 'ADMIN' && !wardId)}
            onClick={() => download.mutate('pdf')}
          >
            {L('Download PDF', 'PDF डाउनलोड')}
          </button>
        </div>
      </div>
      {download.isError ? (
        <div className="mt-2">
          <ErrorBanner error={download.error} />
        </div>
      ) : null}
    </section>
  );
}
