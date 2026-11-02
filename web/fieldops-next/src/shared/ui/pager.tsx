'use client';

import { useLocale } from '@/shared/i18n/locale';

export function Pager({
  page,
  pageSize,
  total,
  onPage,
}: {
  page: number;
  pageSize: number;
  total: number | undefined;
  onPage(page: number): void;
}) {
  const { t } = useLocale();
  if (!total) return null;
  const pages = Math.max(1, Math.ceil(total / pageSize));
  const from = (page - 1) * pageSize + 1;
  const to = Math.min(total, page * pageSize);
  return (
    <div className="mt-3 flex items-center justify-between text-sm text-slate-600">
      <span>
        {from}–{to} / {total}
      </span>
      <span className="flex gap-2">
        <button type="button" disabled={page <= 1} onClick={() => onPage(page - 1)} className="btn-secondary">
          {t('previous')}
        </button>
        <button type="button" disabled={page >= pages} onClick={() => onPage(page + 1)} className="btn-secondary">
          {t('next')}
        </button>
      </span>
    </div>
  );
}
