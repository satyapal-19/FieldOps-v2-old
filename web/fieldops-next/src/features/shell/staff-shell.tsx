'use client';

import { useQueryClient } from '@tanstack/react-query';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState, type ReactNode } from 'react';
import { CSRF_HEADERS } from '@/api/client';
import { menuFor, type WebRole } from '@/shared/auth/route-table';
import { useLocale } from '@/shared/i18n/locale';
import { LanguageSwitch } from '@/shared/ui/language-switch';
import { InboxBell } from './inbox-bell';
import { RoleProvider } from './role-context';
import { useMe } from './use-me';

const ROLE_LABEL: Record<WebRole, { en: string; mr: string }> = {
  ADMIN: { en: 'Administrator', mr: 'प्रशासक' },
  WARD_INSPECTOR: { en: 'Ward inspector', mr: 'प्रभाग निरीक्षक' },
  OFFICE_STAFF: { en: 'Office staff', mr: 'कार्यालयीन कर्मचारी' },
};

export function StaffShell({ role, children }: { role: WebRole; children: ReactNode }) {
  const { t, pick } = useLocale();
  const pathname = usePathname();
  const me = useMe();
  const queryClient = useQueryClient();
  const [signingOut, setSigningOut] = useState(false);

  const signOut = async () => {
    setSigningOut(true);
    await fetch('/session/logout', { method: 'POST', headers: { ...CSRF_HEADERS } }).catch(() => undefined);
    queryClient.clear();
    window.location.assign('/login');
  };

  return (
    <div className="flex min-h-screen flex-col md:flex-row">
      <aside className="border-b border-slate-200 bg-smkc text-white md:w-60 md:border-b-0 md:border-r">
        <div className="px-4 py-4">
          <p className="text-lg font-semibold">{t('appName')}</p>
          <p className="text-xs text-blue-100">{pick(ROLE_LABEL[role])}</p>
        </div>
        <nav className="flex gap-1 overflow-x-auto px-2 pb-2 md:flex-col md:pb-4">
          {menuFor(role).map((route) => {
            const active = pathname === route.path || pathname.startsWith(`${route.path}/`);
            return (
              <Link
                key={route.path}
                href={route.path}
                className={`whitespace-nowrap rounded-md px-3 py-2 text-sm ${active ? 'bg-white/15 font-medium' : 'hover:bg-white/10'}`}
              >
                {pick(route.label)}
              </Link>
            );
          })}
        </nav>
      </aside>
      <div className="flex min-w-0 flex-1 flex-col">
        <header className="flex items-center justify-end gap-3 border-b border-slate-200 bg-white px-4 py-2 text-sm">
          <span className="text-slate-600">
            {me.data ? pick({ en: me.data.fullName, mr: me.data.fullNameMr }) : ''}
          </span>
          <InboxBell />
          <LanguageSwitch />
          <button
            type="button"
            onClick={signOut}
            disabled={signingOut}
            className="rounded-md border border-slate-300 px-2 py-1 hover:bg-slate-100 disabled:opacity-60"
          >
            {t('signOut')}
          </button>
        </header>
        <main className="flex-1 p-4 md:p-6">
          <RoleProvider role={role}>{children}</RoleProvider>
        </main>
      </div>
    </div>
  );
}
