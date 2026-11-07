'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useEffect, useRef, useState } from 'react';
import { api, unwrap } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';

/** The in-app inbox (the same one the phones poll): unread count, latest messages, mark read. */
export function InboxBell() {
  const { pick, lang } = useLocale();
  const queryClient = useQueryClient();
  const [open, setOpen] = useState(false);
  const box = useRef<HTMLDivElement>(null);
  const L = (en: string, mr: string) => pick({ en, mr });

  const inbox = useQuery({
    queryKey: ['notifications'],
    refetchInterval: 60_000,
    queryFn: () => unwrap(api.GET('/api/v1/notifications', { params: { query: { limit: 15 } } })),
  });
  const readAll = useMutation({
    mutationFn: () => unwrap(api.POST('/api/v1/notifications/read', { body: { all: true } })),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ['notifications'] }),
  });

  // Close on a click elsewhere (a plain DOM listener, not data fetching).
  useEffect(() => {
    if (!open) return;
    const close = (e: MouseEvent) => {
      if (box.current && !box.current.contains(e.target as Node)) setOpen(false);
    };
    document.addEventListener('mousedown', close);
    return () => document.removeEventListener('mousedown', close);
  }, [open]);

  const unread = inbox.data?.unreadCount ?? 0;
  return (
    <div className="relative" ref={box}>
      <button
        type="button"
        onClick={() => setOpen(!open)}
        aria-label={L(`Notifications, ${unread} unread`, `सूचना, ${unread} न वाचलेल्या`)}
        className="relative rounded-md border border-slate-300 px-2 py-1 hover:bg-slate-100"
      >
        🔔
        {unread > 0 ? (
          <span className="absolute -right-1.5 -top-1.5 rounded-full bg-red-600 px-1.5 text-xs font-medium text-white">
            {unread > 99 ? '99+' : unread}
          </span>
        ) : null}
      </button>
      {open ? (
        <div className="absolute right-0 z-[1000] mt-2 w-80 max-w-[calc(100vw-2rem)] rounded-lg border border-slate-200 bg-white shadow-lg">
          <div className="flex items-center justify-between border-b border-slate-200 px-3 py-2">
            <span className="font-medium">{L('Notifications', 'सूचना')}</span>
            <button type="button" className="text-xs text-smkc underline" disabled={readAll.isPending || unread === 0} onClick={() => readAll.mutate()}>
              {L('Mark all read', 'सर्व वाचल्या')}
            </button>
          </div>
          <ul className="max-h-96 divide-y divide-slate-100 overflow-y-auto">
            {(inbox.data?.items ?? []).length === 0 ? (
              <li className="px-3 py-4 text-sm text-slate-500">{L('Nothing new.', 'नवीन काही नाही.')}</li>
            ) : (
              inbox.data!.items.map((n) => (
                <li key={n.id} className={`px-3 py-2 text-sm ${n.readAt ? '' : 'bg-blue-50'}`}>
                  <p className="font-medium">
                    {n.priority === 'HIGH' ? '❗ ' : ''}
                    {pick({ en: n.title, mr: n.titleMr })}
                  </p>
                  {n.body ? <p className="text-slate-600">{pick({ en: n.body, mr: n.bodyMr })}</p> : null}
                  <p className="text-xs text-slate-400">{istDateTime(n.createdAt, lang)}</p>
                </li>
              ))
            )}
          </ul>
        </div>
      ) : null}
    </div>
  );
}
