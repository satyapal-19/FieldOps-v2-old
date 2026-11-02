'use client';

import { useQuery } from '@tanstack/react-query';
import { api, unwrap, type Schemas } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';

type Staff = Schemas['StaffProfileDto'];
const BATCH = 100;

/**
 * Names for the staff ids on a page, fetched in batches of 100 through `GET /staff?ids=`
 * (same scope rules as the list). Unknown or out-of-scope ids show a short id.
 */
export function useStaffNames(ids: readonly (string | null | undefined)[]) {
  const { pick } = useLocale();
  const unique = [...new Set(ids.filter((id): id is string => !!id))].sort();
  const query = useQuery({
    queryKey: ['staff', 'names', unique],
    enabled: unique.length > 0,
    staleTime: 5 * 60_000,
    queryFn: async () => {
      const found = new Map<string, Staff>();
      for (let i = 0; i < unique.length; i += BATCH) {
        const page = await unwrap(
          api.GET('/api/v1/staff', {
            params: { query: { ids: unique.slice(i, i + BATCH).join(','), pageSize: BATCH } },
          }),
        );
        page.items.forEach((s) => found.set(s.id, s));
      }
      return found;
    },
  });
  const byId = query.data;
  return {
    staff: (id: string | null | undefined) => (id ? byId?.get(id) : undefined),
    name: (id: string | null | undefined) => {
      if (!id) return '—';
      const s = byId?.get(id);
      return s ? `${pick({ en: s.fullName, mr: s.fullNameMr })} (${s.employeeCode})` : `#${id.slice(0, 8)}`;
    },
  };
}
