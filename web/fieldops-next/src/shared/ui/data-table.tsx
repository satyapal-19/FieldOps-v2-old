'use client';

import type { ReactNode } from 'react';
import { useLocale } from '@/shared/i18n/locale';

export interface Column<T> {
  key: string;
  header: string;
  cell(row: T): ReactNode;
  className?: string;
}

/** A plain table that scrolls sideways on a phone instead of squeezing columns. */
export function DataTable<T>({
  columns,
  rows,
  rowKey,
  loading,
  empty,
  onRowClick,
}: {
  columns: Column<T>[];
  rows: readonly T[] | undefined;
  rowKey(row: T): string;
  loading?: boolean;
  empty: string;
  onRowClick?(row: T): void;
}) {
  const { t } = useLocale();
  const message = loading ? t('loading') : !rows || rows.length === 0 ? empty : null;
  return (
    <div className="overflow-x-auto rounded-lg border border-slate-200 bg-white">
      <table className="min-w-full divide-y divide-slate-200 text-sm">
        <thead className="bg-slate-50">
          <tr>
            {columns.map((c) => (
              <th
                key={c.key}
                scope="col"
                className={`whitespace-nowrap px-3 py-2 text-left font-medium text-slate-600 ${c.className ?? ''}`}
              >
                {c.header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-slate-100">
          {message !== null ? (
            <tr>
              <td colSpan={columns.length} className="px-3 py-6 text-center text-slate-500">
                {message}
              </td>
            </tr>
          ) : (
            rows?.map((row) => (
              <tr
                key={rowKey(row)}
                onClick={onRowClick ? () => onRowClick(row) : undefined}
                className={onRowClick ? 'cursor-pointer hover:bg-slate-50' : undefined}
              >
                {columns.map((c) => (
                  <td key={c.key} className={`px-3 py-2 align-top ${c.className ?? ''}`}>
                    {c.cell(row)}
                  </td>
                ))}
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
}
