import Link from 'next/link';
import type { ReactNode } from 'react';
import { CITIZEN_TEXT } from '@/features/citizen/citizen-text';
import { serverLocale } from '@/server/locale';
import { LanguageSwitch } from '@/shared/ui/language-switch';

/** The public portal: no sign-in, server-rendered, works on a basic phone browser. */
export default async function CitizenLayout({ children }: { children: ReactNode }) {
  const { pick } = await serverLocale();
  const links = [
    ['/citizen', CITIZEN_TEXT.fileComplaint],
    ['/citizen/track', CITIZEN_TEXT.track],
    ['/citizen/wards', CITIZEN_TEXT.wards],
  ] as const;
  return (
    <div className="min-h-screen">
      <header className="bg-smkc text-white">
        <div className="mx-auto flex max-w-4xl flex-wrap items-center justify-between gap-3 px-4 py-3">
          <div>
            <p className="text-xs text-blue-100">
              {pick({ en: 'Sangli Miraj Kupwad Municipal Corporation', mr: 'सांगली मिरज कुपवाड शहर महानगरपालिका' })}
            </p>
            <p className="text-lg font-semibold">{pick(CITIZEN_TEXT.portal)}</p>
          </div>
          <LanguageSwitch className="border-white/40 text-white hover:bg-white/10" />
        </div>
        <nav className="mx-auto flex max-w-4xl gap-1 overflow-x-auto px-2 pb-2">
          {links.map(([href, label]) => (
            <Link key={href} href={href} className="whitespace-nowrap rounded-md px-3 py-1.5 text-sm hover:bg-white/10">
              {pick(label)}
            </Link>
          ))}
        </nav>
      </header>
      <main className="mx-auto max-w-4xl px-4 py-6">{children}</main>
    </div>
  );
}
