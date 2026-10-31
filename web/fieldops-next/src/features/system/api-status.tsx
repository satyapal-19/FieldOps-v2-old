'use client';

import { useQuery } from '@tanstack/react-query';
import { api, API_BASE_URL, toApiError } from '@/api/client';

/** Shows whether the NestJS API is up and ready: the first end-to-end check of the new stack. */
export function ApiStatus() {
  const health = useQuery({
    queryKey: ['system', 'health'],
    queryFn: async () => {
      const { data, error, response } = await api.GET('/api/v1/health');
      if (error || !data) throw toApiError(error, response.status);
      return data;
    },
  });

  const ready = useQuery({
    queryKey: ['system', 'ready'],
    queryFn: async () => {
      const { data, error, response } = await api.GET('/api/v1/ready');
      if (error || !data) throw toApiError(error, response.status);
      return data;
    },
  });

  return (
    <section className="rounded-lg border border-slate-200 bg-white p-6">
      <h2 className="text-lg font-semibold">API status</h2>
      <p className="mt-1 text-sm text-slate-500">{API_BASE_URL}</p>
      <dl className="mt-4 grid grid-cols-2 gap-y-2 text-sm">
        <dt className="text-slate-500">Health</dt>
        <dd>
          {health.isPending
            ? 'Checking...'
            : health.isError
              ? `Unavailable: ${health.error.message}`
              : `${health.data.status} (${health.data.environment}, v${health.data.version})`}
        </dd>
        <dt className="text-slate-500">Database</dt>
        <dd>
          {ready.isPending
            ? 'Checking...'
            : ready.isError
              ? `Not ready: ${ready.error.message}`
              : `${ready.data.database}, migrations up to date`}
        </dd>
      </dl>
    </section>
  );
}
