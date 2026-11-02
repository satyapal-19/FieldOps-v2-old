import { ApiStatus } from '@/features/system/api-status';
import { HomeLinks } from '@/features/system/home-links';

export default function HomePage() {
  return (
    <main className="mx-auto max-w-3xl px-4 py-12">
      <HomeLinks />
      <div className="mt-8">
        <ApiStatus />
      </div>
    </main>
  );
}
