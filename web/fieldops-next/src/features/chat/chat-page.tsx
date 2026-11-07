'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState, type FormEvent } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useMe } from '@/features/shell/use-me';
import { useLocale, type Bilingual } from '@/shared/i18n/locale';
import { istDateTime } from '@/shared/ist';
import { StaffPicker } from '@/shared/lookups/staff-picker';
import { useStaffNames } from '@/shared/lookups/use-staff-names';
import { useWards } from '@/shared/lookups/use-wards';
import { Dialog } from '@/shared/ui/dialog';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { TextArea } from '@/shared/ui/fields';
import { PageHeader } from '@/shared/ui/page-header';

type Conversation = Schemas['ConversationDto'];
type Message = Schemas['MessageDto'];

const TYPE_TEXT: Record<Conversation['type'], Bilingual> = {
  DIRECT: { en: 'Direct', mr: 'थेट' },
  SQUAD_TEAM: { en: 'Squad', mr: 'पथक' },
  WARD_BROADCAST: { en: 'Ward broadcast', mr: 'प्रभाग प्रसारण' },
  CITY_BROADCAST: { en: 'SMKMC broadcast', mr: 'महानगरपालिका प्रसारण' },
};

/** Supervisors' chat: the same hierarchy channels as the app (squad, ward, city) and direct chats. */
export function ChatPage() {
  const { t, pick, lang } = useLocale();
  const queryClient = useQueryClient();
  const me = useMe();
  const { wardName } = useWards();
  const [openId, setOpenId] = useState<string | null>(null);
  const [text, setText] = useState('');
  const [starting, setStarting] = useState(false);
  const [target, setTarget] = useState('');
  const L = (en: string, mr: string) => pick({ en, mr });

  const list = useQuery({
    queryKey: ['chat', 'conversations'],
    refetchInterval: 30_000,
    queryFn: () => unwrap(api.GET('/api/v1/chat/conversations')),
  });
  const conversations = list.data ?? [];
  const open = conversations.find((c) => c.id === openId) ?? null;
  const messages = useQuery({
    queryKey: ['chat', 'messages', openId],
    enabled: !!openId,
    refetchInterval: 15_000,
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/chat/conversations/{id}/messages', {
          params: { path: { id: openId! }, query: { limit: 50 } },
        }),
      ),
  });
  const names = useStaffNames([
    ...conversations.flatMap((c) => c.memberIds),
    ...(messages.data?.map((m) => m.senderId) ?? []),
  ]);

  const select = async (id: string) => {
    setOpenId(id);
    await api.POST('/api/v1/chat/conversations/{id}/read', { params: { path: { id } } });
    await queryClient.invalidateQueries({ queryKey: ['chat', 'conversations'] });
  };
  const send = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/chat/conversations/{id}/messages', {
          params: { path: { id: openId! } },
          body: { clientUuid: crypto.randomUUID(), type: 'TEXT', text: text.trim() },
        }),
      ),
    onSuccess: async () => {
      setText('');
      await queryClient.invalidateQueries({ queryKey: ['chat'] });
    },
  });
  const direct = useMutation({
    mutationFn: () => unwrap(api.POST('/api/v1/chat/direct', { body: { staffId: target } })),
    onSuccess: async (c) => {
      await queryClient.invalidateQueries({ queryKey: ['chat', 'conversations'] });
      setStarting(false);
      setTarget('');
      setOpenId(c.id);
    },
  });

  const title = (c: Conversation) => {
    if (c.type === 'DIRECT') {
      const other = c.memberIds.find((id) => id !== me.data?.id);
      return names.name(other);
    }
    if (c.type === 'WARD_BROADCAST') return `${pick(TYPE_TEXT[c.type])} · ${wardName(c.wardId)}`;
    if (c.type === 'SQUAD_TEAM') return `${pick(TYPE_TEXT[c.type])} · ${names.name(c.inspectorId)} · ${c.date}`;
    return pick(TYPE_TEXT[c.type]);
  };
  const submit = (e: FormEvent) => {
    e.preventDefault();
    if (text.trim() && !send.isPending) send.mutate();
  };

  return (
    <div>
      <PageHeader
        title={L('Chat', 'संवाद')}
        actions={
          <button type="button" className="btn-primary" onClick={() => setStarting(true)}>
            {L('Message someone', 'संदेश पाठवा')}
          </button>
        }
      />
      {list.isError ? <ErrorBanner error={list.error} onRetry={() => list.refetch()} /> : null}
      <div className="grid gap-4 md:grid-cols-[300px_1fr]">
        <ul className="max-h-[600px] divide-y divide-slate-100 overflow-y-auto rounded-lg border border-slate-200 bg-white">
          {conversations.length === 0 ? (
            <li className="px-3 py-4 text-sm text-slate-500">{list.isPending ? t('loading') : t('noRecords')}</li>
          ) : (
            conversations.map((c) => (
              <li key={c.id}>
                <button
                  type="button"
                  onClick={() => select(c.id)}
                  className={`w-full px-3 py-2 text-left text-sm hover:bg-slate-50 ${c.id === openId ? 'bg-blue-50' : ''}`}
                >
                  <span className="flex items-center justify-between gap-2">
                    <span className="truncate font-medium">{title(c)}</span>
                    {c.unread > 0 ? (
                      <span className="rounded-full bg-red-600 px-1.5 text-xs text-white">{c.unread}</span>
                    ) : null}
                  </span>
                  <span className="text-xs text-slate-500">
                    {c.archived ? L('Archived · ', 'संग्रहित · ') : ''}
                    {c.lastMessageAt ? istDateTime(c.lastMessageAt, lang) : L('No messages yet', 'अद्याप संदेश नाहीत')}
                  </span>
                </button>
              </li>
            ))
          )}
        </ul>
        <section className="flex min-h-[400px] flex-col rounded-lg border border-slate-200 bg-white">
          {!open ? (
            <p className="m-auto text-sm text-slate-500">{L('Choose a conversation.', 'संवाद निवडा.')}</p>
          ) : (
            <>
              <header className="border-b border-slate-200 px-4 py-2">
                <p className="font-medium">{title(open)}</p>
                <p className="text-xs text-slate-500">
                  {open.memberIds.length} {L('members', 'सदस्य')}
                </p>
              </header>
              <ol className="flex max-h-[460px] flex-1 flex-col-reverse gap-2 overflow-y-auto p-4">
                {(messages.data ?? []).map((m: Message) => {
                  const mine = m.senderId === me.data?.id;
                  return (
                    <li key={m.id} className={`max-w-[80%] rounded-lg px-3 py-2 text-sm ${mine ? 'self-end bg-blue-100' : 'self-start bg-slate-100'}`}>
                      {!mine ? <p className="text-xs font-medium text-slate-600">{names.name(m.senderId)}</p> : null}
                      {m.type === 'TEXT' ? <p className="whitespace-pre-wrap">{m.text}</p> : null}
                      {m.type === 'VOICE' ? (
                        // Same-origin pass-through: the session cookie authorises the audio request.
                        <audio controls preload="none" src={`/api/v1/chat/messages/${m.id}/media`} className="max-w-full" />
                      ) : null}
                      {m.type === 'IMAGE' ? (
                        // eslint-disable-next-line @next/next/no-img-element
                        <img src={`/api/v1/chat/messages/${m.id}/media`} alt="" className="max-h-60 rounded" />
                      ) : null}
                      {m.type === 'LOCATION' && m.latitude !== null && m.longitude !== null ? (
                        <a
                          className="text-smkc underline"
                          target="_blank"
                          rel="noreferrer"
                          href={`https://www.openstreetmap.org/?mlat=${m.latitude}&mlon=${m.longitude}#map=18/${m.latitude}/${m.longitude}`}
                        >
                          📍 {m.latitude.toFixed(5)}, {m.longitude.toFixed(5)}
                        </a>
                      ) : null}
                      <p className="mt-1 text-right text-[10px] text-slate-500">{istDateTime(m.createdAt, lang)}</p>
                    </li>
                  );
                })}
              </ol>
              {open.canPost ? (
                <form onSubmit={submit} className="flex gap-2 border-t border-slate-200 p-3">
                  <TextArea rows={2} maxLength={2000} value={text} onChange={(e) => setText(e.target.value)} className="mt-0" />
                  <button type="submit" className="btn-primary self-end" disabled={!text.trim() || send.isPending}>
                    {L('Send', 'पाठवा')}
                  </button>
                </form>
              ) : (
                <p className="border-t border-slate-200 p-3 text-xs text-slate-500">
                  {open.archived
                    ? L('This squad chat is archived (read-only).', 'हा पथक संवाद संग्रहित आहे (फक्त वाचण्यासाठी).')
                    : L('Only the sender of this broadcast can post.', 'या प्रसारणात फक्त पाठवणारेच लिहू शकतात.')}
                </p>
              )}
              {send.isError ? <ErrorBanner error={send.error} /> : null}
            </>
          )}
        </section>
      </div>
      <Dialog open={starting} title={L('Message someone', 'संदेश पाठवा')} onClose={() => setStarting(false)}>
        {starting ? (
          <div className="space-y-3 text-sm">
            <StaffPicker
              label={t('staffMember')}
              value={target}
              onChange={setTarget}
              roles={['ADMIN', 'WARD_INSPECTOR', 'INSPECTOR', 'WORKER', 'OFFICE_STAFF']}
              excludeId={me.data?.id}
            />
            {direct.isError ? <ErrorBanner error={direct.error} /> : null}
            <div className="flex justify-end gap-2">
              <button type="button" className="btn-secondary" onClick={() => setStarting(false)}>
                {t('cancel')}
              </button>
              <button type="button" className="btn-primary" disabled={!target || direct.isPending} onClick={() => direct.mutate()}>
                {L('Open chat', 'संवाद उघडा')}
              </button>
            </div>
          </div>
        ) : null}
      </Dialog>
    </div>
  );
}
