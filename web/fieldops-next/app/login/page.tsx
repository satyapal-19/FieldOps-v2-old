import { Suspense } from 'react';
import { LoginForm } from '@/features/auth/login-form';
import { LoginHeading } from '@/features/auth/login-heading';
import { LanguageSwitch } from '@/shared/ui/language-switch';

export default function LoginPage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-md flex-col justify-center px-4 py-12">
      <div className="mb-6 flex justify-end">
        <LanguageSwitch />
      </div>
      <div className="rounded-lg border border-slate-200 bg-white p-6 shadow-sm">
        <LoginHeading />
        <Suspense>
          <LoginForm />
        </Suspense>
      </div>
    </main>
  );
}
