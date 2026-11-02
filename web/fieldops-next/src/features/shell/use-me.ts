'use client';

import { useQuery } from '@tanstack/react-query';
import { api, unwrap } from '@/api/client';

/** The signed-in staff member. */
export function useMe() {
  return useQuery({
    queryKey: ['auth', 'me'],
    queryFn: () => unwrap(api.GET('/api/v1/auth/me')),
    staleTime: 5 * 60_000,
  });
}
