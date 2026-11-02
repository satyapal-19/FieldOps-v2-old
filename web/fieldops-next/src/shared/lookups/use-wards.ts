'use client';

import { useQuery } from '@tanstack/react-query';
import { api, unwrap } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';

/** Every ward (SMKMC has a few dozen), cached for the session. */
export function useWards() {
  const { pick } = useLocale();
  const query = useQuery({
    queryKey: ['wards', 'all'],
    staleTime: 30 * 60_000,
    queryFn: () => unwrap(api.GET('/api/v1/wards', { params: { query: { pageSize: 100 } } })),
  });
  const wards = query.data?.items ?? [];
  return {
    query,
    wards,
    wardName: (id: string | null | undefined) => {
      if (!id) return '—';
      const w = wards.find((x) => x.id === id);
      return w ? `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` : `#${id.slice(0, 8)}`;
    },
  };
}

/** Corporation offices (for office staff). */
export function useOffices() {
  const { pick } = useLocale();
  const query = useQuery({
    queryKey: ['offices', 'all'],
    staleTime: 30 * 60_000,
    queryFn: () => unwrap(api.GET('/api/v1/offices')),
  });
  const offices = query.data ?? [];
  return {
    query,
    offices,
    officeName: (id: string | null | undefined) => {
      if (!id) return '—';
      const o = offices.find((x) => x.id === id);
      return o ? pick({ en: o.name, mr: o.nameMr }) : `#${id.slice(0, 8)}`;
    },
  };
}
