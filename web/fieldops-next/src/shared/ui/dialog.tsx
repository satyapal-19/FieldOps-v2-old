'use client';

import { useEffect, useRef, type ReactNode } from 'react';
import { useLocale } from '@/shared/i18n/locale';

/** A modal built on <dialog>: focus handling, Esc to close and the backdrop come from the browser. */
export function Dialog({
  open,
  title,
  onClose,
  children,
  wide,
}: {
  open: boolean;
  title: string;
  onClose(): void;
  children: ReactNode;
  wide?: boolean;
}) {
  const ref = useRef<HTMLDialogElement>(null);
  const { t } = useLocale();
  useEffect(() => {
    const el = ref.current;
    if (!el) return;
    if (open && !el.open) el.showModal();
    if (!open && el.open) el.close();
  }, [open]);
  return (
    <dialog
      ref={ref}
      onClose={onClose}
      className={`w-[calc(100%-2rem)] rounded-lg p-0 shadow-xl backdrop:bg-slate-900/40 ${wide ? 'max-w-3xl' : 'max-w-lg'}`}
    >
      {open ? (
        <div className="p-5">
          <div className="mb-4 flex items-start justify-between gap-4">
            <h2 className="text-lg font-semibold text-smkc">{title}</h2>
            <button
              type="button"
              onClick={onClose}
              aria-label={t('close')}
              className="text-slate-500 hover:text-slate-800"
            >
              ✕
            </button>
          </div>
          {children}
        </div>
      ) : null}
    </dialog>
  );
}
