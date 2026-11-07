import Link from 'next/link';
import { CITIZEN_TEXT } from '@/features/citizen/citizen-text';
import { serverLocale } from '@/server/locale';
import { publicApi } from '@/server/public-api';

export const dynamic = 'force-dynamic';

const ZONE = { SANGLI: { en: 'Sangli', mr: 'सांगली' }, MIRAJ: { en: 'Miraj', mr: 'मिरज' }, KUPWAD: { en: 'Kupwad', mr: 'कुपवाड' } };

export default async function WardsPage() {
  const { pick } = await serverLocale();
  const { data: wards } = await (await publicApi()).GET('/api/v1/public/wards');
  return (
    <div className="space-y-4">
      <h1 className="text-xl font-semibold text-smkc">{pick(CITIZEN_TEXT.wards)}</h1>
      <ul className="grid grid-cols-1 gap-2 sm:grid-cols-2">
        {(wards ?? []).map((w) => (
          <li key={w.id}>
            <Link href={`/citizen/wards/${w.id}`} className="block rounded-lg border border-slate-200 bg-white p-4 hover:border-smkc">
              <span className="font-mono text-sm text-slate-500">{w.code}</span>
              <span className="block font-medium">{pick({ en: w.name, mr: w.nameMr })}</span>
              <span className="text-sm text-slate-500">{pick(ZONE[w.zone])}</span>
            </Link>
          </li>
        ))}
      </ul>
    </div>
  );
}
