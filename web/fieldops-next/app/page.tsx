import { ApiStatus } from '@/features/system/api-status';

export default function HomePage() {
  return (
    <main className="mx-auto max-w-3xl px-4 py-12">
      <h1 className="text-2xl font-semibold text-smkc">FieldOps SMKMC</h1>
      <p className="mt-2 text-slate-600">
        Next.js dashboard scaffold (Phase 0). Pages from the current Vite app move here in Phase 3.
      </p>
      <div className="mt-8">
        <ApiStatus />
      </div>
    </main>
  );
}
