import Link from 'next/link';
import { notFound } from 'next/navigation';
import { WardMap } from '@/features/citizen/ward-map';
import { serverLocale } from '@/server/locale';
import { publicApi } from '@/server/public-api';
import { polygonRing } from '@/shared/map/tiles';

export const dynamic = 'force-dynamic';

const UUID = /^[0-9a-f-]{36}$/i;

/** A ward's boundary and how many staff were placed and present each day last week (no names). */
export default async function WardPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  if (!UUID.test(id)) notFound();
  const { pick } = await serverLocale();
  const client = await publicApi();
  const [{ data: wards }, attendance] = await Promise.all([
    client.GET('/api/v1/public/wards'),
    client.GET('/api/v1/public/wards/{id}/attendance', { params: { path: { id } } }),
  ]);
  const ward = wards?.find((w) => w.id === id);
  if (!ward || !attendance.data) notFound();
  const ring = polygonRing(ward.boundary);
  const days = attendance.data.days;

  return (
    <div className="space-y-4">
      <Link href="/citizen/wards" className="text-sm text-smkc hover:underline">
        ‹ {pick({ en: 'All wards', mr: 'सर्व प्रभाग' })}
      </Link>
      <h1 className="text-xl font-semibold text-smkc">
        {ward.code} · {pick({ en: ward.name, mr: ward.nameMr })}
      </h1>
      {ring ? <WardMap wards={[{ id: ward.id, label: ward.code, ring }]} /> : null}
      <section className="rounded-lg border border-slate-200 bg-white p-4">
        <h2 className="font-medium">{pick({ en: 'Field staff on duty, last 7 days', mr: 'मागील ७ दिवसांतील कामावरील कर्मचारी' })}</h2>
        {days.length === 0 ? (
          <p className="mt-2 text-sm text-slate-500">{pick({ en: 'No figures yet.', mr: 'अद्याप आकडेवारी नाही.' })}</p>
        ) : (
          <table className="mt-2 w-full text-sm">
            <thead>
              <tr className="text-left text-slate-500">
                <th className="py-1">{pick({ en: 'Date', mr: 'तारीख' })}</th>
                <th className="py-1">{pick({ en: 'Placed', mr: 'नेमलेले' })}</th>
                <th className="py-1">{pick({ en: 'Present', mr: 'उपस्थित' })}</th>
                <th className="py-1">{pick({ en: 'On leave', mr: 'रजेवर' })}</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {days.map((d) => (
                <tr key={d.date}>
                  <td className="py-1">{d.date}</td>
                  <td className="py-1">{d.assignedCount}</td>
                  <td className="py-1">{d.presentCount}</td>
                  <td className="py-1">{d.onLeaveCount}</td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
        <p className="mt-3 text-xs text-slate-500">
          {pick({
            en: 'Counts only: names, photos and locations of staff are never published.',
            mr: 'फक्त संख्या: कर्मचाऱ्यांची नावे, फोटो व ठिकाणे कधीही प्रसिद्ध केली जात नाहीत.',
          })}
        </p>
      </section>
    </div>
  );
}
