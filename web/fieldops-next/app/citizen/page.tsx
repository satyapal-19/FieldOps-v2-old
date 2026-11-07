import { CITIZEN_TEXT } from '@/features/citizen/citizen-text';
import { ComplaintForm } from '@/features/citizen/complaint-form';
import { serverLocale } from '@/server/locale';
import { publicApi } from '@/server/public-api';

export const dynamic = 'force-dynamic';

export default async function CitizenHome() {
  const { pick } = await serverLocale();
  const { data: wards } = await (await publicApi()).GET('/api/v1/public/wards');
  return (
    <div className="space-y-4">
      <h1 className="text-xl font-semibold text-smkc">{pick(CITIZEN_TEXT.fileComplaint)}</h1>
      <p className="text-sm text-slate-600">
        {pick({
          en: 'Tell us about garbage, drains, roads, water or other civic problems. The ward team is assigned and you can follow progress with your tracking ID.',
          mr: 'कचरा, गटार, रस्ते, पाणी किंवा इतर नागरी समस्यांबद्दल कळवा. प्रभाग पथकाकडे काम सोपवले जाते आणि मागोवा क्रमांकाने प्रगती पाहता येते.',
        })}
      </p>
      <div className="rounded-lg border border-slate-200 bg-white p-5">
        <ComplaintForm wards={wards ?? []} />
      </div>
    </div>
  );
}
