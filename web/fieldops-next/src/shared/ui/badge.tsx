import type { ReactNode } from 'react';

const TONES = {
  green: 'bg-green-100 text-green-800',
  amber: 'bg-amber-100 text-amber-800',
  red: 'bg-red-100 text-red-800',
  blue: 'bg-blue-100 text-blue-800',
  slate: 'bg-slate-100 text-slate-700',
} as const;
export type Tone = keyof typeof TONES;

export function Badge({ tone = 'slate', children }: { tone?: Tone; children: ReactNode }) {
  return (
    <span className={`inline-block whitespace-nowrap rounded px-1.5 py-0.5 text-xs font-medium ${TONES[tone]}`}>
      {children}
    </span>
  );
}
