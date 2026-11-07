import { CATEGORY_TEXT, CITIZEN_TEXT, COMPLAINT_STATUS_TEXT } from '@/features/citizen/citizen-text';
import { serverLocale } from '@/server/locale';
import { publicApi } from '@/server/public-api';
import { errorText } from '@/shared/i18n/error-text';
import { istDateTime } from '@/shared/ist';

export const dynamic = 'force-dynamic';

const STEPS = ['RECEIVED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED'] as const;

/** Server-rendered status of a complaint by tracking ID (a plain GET form: works without JavaScript). */
export default async function TrackPage({ searchParams }: { searchParams: Promise<{ id?: string }> }) {
  const { lang, pick } = await serverLocale();
  const id = (await searchParams).id?.trim().toUpperCase() ?? '';
  const result = id
    ? await (await publicApi()).GET('/api/v1/public/complaints/{trackingId}', {
        params: { path: { trackingId: id } },
      })
    : null;
  const complaint = result?.data;
  const problem = result?.error as { code?: string; title?: string; requestId?: string } | undefined;

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-semibold text-smkc">{pick(CITIZEN_TEXT.track)}</h1>
      <form method="get" className="flex flex-wrap items-end gap-2">
        <label className="block text-sm">
          <span className="font-medium text-slate-700">{pick({ en: 'Tracking ID', mr: 'मागोवा क्रमांक' })}</span>
          <input
            name="id"
            defaultValue={id}
            required
            maxLength={20}
            className="mt-1 block w-64 rounded-md border border-slate-300 px-3 py-2 font-mono uppercase"
          />
        </label>
        <button type="submit" className="btn-primary">
          {pick({ en: 'Check status', mr: 'स्थिती पाहा' })}
        </button>
      </form>

      {problem ? (
        <div role="alert" className="rounded-md border border-red-200 bg-red-50 p-4 text-sm text-red-800">
          {problem.code === 'NOT_FOUND'
            ? pick({ en: 'No complaint with this tracking ID.', mr: 'या मागोवा क्रमांकाची तक्रार नाही.' })
            : errorText(problem.code ?? 'INTERNAL_ERROR', lang, problem.title)}
          {problem.requestId ? <p className="mt-1 font-mono text-xs">ID: {problem.requestId}</p> : null}
        </div>
      ) : null}

      {complaint ? (
        <section className="rounded-lg border border-slate-200 bg-white p-5">
          <p className="font-mono text-lg font-semibold">{complaint.trackingId}</p>
          <p className="text-sm text-slate-600">
            {pick(CATEGORY_TEXT[complaint.category])} · {pick({ en: 'Ward', mr: 'प्रभाग' })} {complaint.wardCode ?? '—'} ·{' '}
            {istDateTime(complaint.createdAt, lang)}
          </p>
          {complaint.status === 'REJECTED' ? (
            <p className="mt-4 font-medium text-red-700">{pick(COMPLAINT_STATUS_TEXT.REJECTED)}</p>
          ) : (
            <ol className="mt-4 grid grid-cols-2 gap-2 sm:grid-cols-4">
              {STEPS.map((s) => {
                const done = COMPLAINT_STATUS_TEXT[complaint.status].step >= COMPLAINT_STATUS_TEXT[s].step;
                return (
                  <li
                    key={s}
                    className={`rounded-md border px-3 py-2 text-sm ${done ? 'border-green-300 bg-green-50 text-green-900' : 'border-slate-200 text-slate-500'}`}
                  >
                    {done ? '✓ ' : ''}
                    {pick(COMPLAINT_STATUS_TEXT[s])}
                  </li>
                );
              })}
            </ol>
          )}
          {complaint.resolvedAt ? (
            <p className="mt-3 text-sm text-slate-600">
              {pick({ en: 'Resolved on', mr: 'निकाली दिनांक' })} {istDateTime(complaint.resolvedAt, lang)}
            </p>
          ) : null}
        </section>
      ) : null}
    </div>
  );
}
