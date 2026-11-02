'use client';

import { useMutation } from '@tanstack/react-query';
import { useSearchParams } from 'next/navigation';
import { useState, type FormEvent } from 'react';
import { CSRF_HEADERS, toApiError, type Schemas } from '@/api/client';
import { isWebRole, safeNext } from '@/shared/auth/route-table';
import { useLocale } from '@/shared/i18n/locale';
import { ErrorBanner } from '@/shared/ui/error-banner';

type Staff = Schemas['StaffProfileDto'];

async function signIn(identifier: string, password: string): Promise<Staff> {
  const requestId = crypto.randomUUID();
  const res = await fetch('/session/login', {
    method: 'POST',
    headers: { 'content-type': 'application/json', 'x-request-id': requestId, ...CSRF_HEADERS },
    body: JSON.stringify({ identifier: identifier.trim(), password }),
  });
  const body: unknown = await res.json().catch(() => null);
  if (!res.ok) throw toApiError(body, res.status, requestId);
  return (body as { staff: Staff }).staff;
}

/** Password sign-in; the session goes into httpOnly cookies set by /session/login. */
export function LoginForm() {
  const { t } = useLocale();
  const next = useSearchParams().get('next');
  const [identifier, setIdentifier] = useState('');
  const [password, setPassword] = useState('');
  const login = useMutation({
    mutationFn: () => signIn(identifier, password),
    onSuccess: (staff) => {
      // A full navigation, so middleware sees the new cookies.
      window.location.assign(isWebRole(staff.role) ? safeNext(staff.role, next) : '/');
    },
  });

  const submit = (e: FormEvent) => {
    e.preventDefault();
    if (!login.isPending) login.mutate();
  };

  return (
    <form onSubmit={submit} className="space-y-4">
      <label className="block text-sm">
        <span className="font-medium text-slate-700">{t('identifier')}</span>
        <input
          name="identifier"
          autoComplete="username"
          required
          minLength={2}
          maxLength={20}
          value={identifier}
          onChange={(e) => setIdentifier(e.target.value)}
          className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 focus:border-smkc focus:outline-none focus:ring-1 focus:ring-smkc"
        />
      </label>
      <label className="block text-sm">
        <span className="font-medium text-slate-700">{t('password')}</span>
        <input
          name="password"
          type="password"
          autoComplete="current-password"
          required
          maxLength={200}
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="mt-1 block w-full rounded-md border border-slate-300 px-3 py-2 focus:border-smkc focus:outline-none focus:ring-1 focus:ring-smkc"
        />
      </label>
      {login.isError ? <ErrorBanner error={login.error} /> : null}
      <button
        type="submit"
        disabled={login.isPending}
        className="w-full rounded-md bg-smkc px-4 py-2 font-medium text-white hover:bg-smkc-light disabled:opacity-60"
      >
        {login.isPending ? t('signingIn') : t('signIn')}
      </button>
    </form>
  );
}
