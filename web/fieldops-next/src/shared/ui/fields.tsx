'use client';

import type { InputHTMLAttributes, ReactNode, SelectHTMLAttributes, TextareaHTMLAttributes } from 'react';

const control =
  'mt-1 block w-full rounded-md border border-slate-300 bg-white px-3 py-2 text-sm focus:border-smkc focus:outline-none focus:ring-1 focus:ring-smkc disabled:bg-slate-100';

export function Field({ label, children, hint }: { label: string; children: ReactNode; hint?: string }) {
  return (
    <label className="block text-sm">
      <span className="font-medium text-slate-700">{label}</span>
      {children}
      {hint ? <span className="mt-1 block text-xs text-slate-500">{hint}</span> : null}
    </label>
  );
}

export function TextInput(props: InputHTMLAttributes<HTMLInputElement>) {
  return <input {...props} className={`${control} ${props.className ?? ''}`} />;
}

export function TextArea(props: TextareaHTMLAttributes<HTMLTextAreaElement>) {
  return <textarea rows={3} {...props} className={`${control} ${props.className ?? ''}`} />;
}

export interface Option {
  value: string;
  label: string;
}

export function Select({
  options,
  placeholder,
  ...props
}: SelectHTMLAttributes<HTMLSelectElement> & { options: readonly Option[]; placeholder?: string }) {
  return (
    <select {...props} className={`${control} ${props.className ?? ''}`}>
      {placeholder !== undefined ? <option value="">{placeholder}</option> : null}
      {options.map((o) => (
        <option key={o.value} value={o.value}>
          {o.label}
        </option>
      ))}
    </select>
  );
}

/** A row of filters above a list; wraps on small screens. */
export function FilterBar({ children }: { children: ReactNode }) {
  return <div className="mb-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">{children}</div>;
}
