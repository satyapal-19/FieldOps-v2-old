import type { Metadata } from 'next';
import { cookies } from 'next/headers';
import type { ReactNode } from 'react';
import { DEFAULT_LANG, isLang, LANG_COOKIE } from '@/shared/i18n/lang';
import { Providers } from './providers';
import './globals.css';

export const metadata: Metadata = {
  title: 'FieldOps SMKMC',
  description: 'Geo-tagged attendance and field presence for Sangli Miraj Kupwad Municipal Corporation',
};

export default async function RootLayout({ children }: { children: ReactNode }) {
  const saved = (await cookies()).get(LANG_COOKIE)?.value;
  const lang = isLang(saved) ? saved : DEFAULT_LANG;
  return (
    <html lang={lang}>
      <body className="min-h-screen bg-slate-50 text-slate-900 antialiased">
        <Providers lang={lang}>{children}</Providers>
      </body>
    </html>
  );
}
