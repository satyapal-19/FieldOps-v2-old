'use client';

import { useMutation } from '@tanstack/react-query';
import Link from 'next/link';
import { useState, type FormEvent } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { useLocale } from '@/shared/i18n/locale';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select, TextArea, TextInput } from '@/shared/ui/fields';
import { CATEGORY_TEXT, CITIZEN_TEXT } from './citizen-text';

type Category = Schemas['SubmitComplaintDto']['category'];
type Ward = Schemas['PublicWardDto'];

/** A citizen files a complaint without signing in; they get a tracking ID to follow it. */
export function ComplaintForm({ wards }: { wards: Ward[] }) {
  const { t, pick } = useLocale();
  const L = (en: string, mr: string) => pick({ en, mr });
  // One id per form: a double tap or a retry files the complaint once.
  const [clientUuid, setClientUuid] = useState(() => crypto.randomUUID());
  const [f, setF] = useState({ category: 'GARBAGE' as Category, description: '', wardId: '', citizenName: '', citizenPhone: '' });
  const [point, setPoint] = useState<{ lat: number; lng: number } | null>(null);
  const [locating, setLocating] = useState(false);

  const submit = useMutation({
    mutationFn: () =>
      unwrap(
        api.POST('/api/v1/public/complaints', {
          body: {
            clientUuid,
            category: f.category,
            description: f.description.trim(),
            wardId: f.wardId || undefined,
            citizenName: f.citizenName.trim() || undefined,
            citizenPhone: f.citizenPhone.trim() || undefined,
            lat: point?.lat,
            lng: point?.lng,
          },
        }),
      ),
  });

  const locate = () => {
    if (!navigator.geolocation) return;
    setLocating(true);
    navigator.geolocation.getCurrentPosition(
      (p) => {
        setPoint({ lat: Number(p.coords.latitude.toFixed(6)), lng: Number(p.coords.longitude.toFixed(6)) });
        setLocating(false);
      },
      () => setLocating(false),
      { enableHighAccuracy: true, timeout: 15_000 },
    );
  };

  const onSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (!submit.isPending) submit.mutate();
  };

  if (submit.isSuccess) {
    return (
      <div className="rounded-lg border border-green-200 bg-green-50 p-5">
        <p className="font-medium text-green-900">{L('Complaint registered. Thank you.', 'तक्रार नोंदवली. धन्यवाद.')}</p>
        <p className="mt-2 text-sm text-green-900">{L('Your tracking ID', 'तुमचा मागोवा क्रमांक')}</p>
        <p className="mt-1 font-mono text-2xl font-semibold tracking-wider">{submit.data.trackingId}</p>
        <div className="mt-4 flex flex-wrap gap-2">
          <Link href={`/citizen/track?id=${encodeURIComponent(submit.data.trackingId)}`} className="btn-primary">
            {pick(CITIZEN_TEXT.track)}
          </Link>
          <button
            type="button"
            className="btn-secondary"
            onClick={() => {
              submit.reset();
              setClientUuid(crypto.randomUUID());
              setF({ ...f, description: '' });
              setPoint(null);
            }}
          >
            {L('Report another problem', 'आणखी तक्रार नोंदवा')}
          </button>
        </div>
      </div>
    );
  }

  return (
    <form onSubmit={onSubmit} className="space-y-3">
      <Field label={L('What is the problem?', 'समस्या काय आहे?')}>
        <Select
          value={f.category}
          onChange={(e) => setF({ ...f, category: e.target.value as Category })}
          options={(Object.keys(CATEGORY_TEXT) as Category[]).map((c) => ({ value: c, label: pick(CATEGORY_TEXT[c]) }))}
        />
      </Field>
      <Field label={L('Describe it and the place (landmark)', 'समस्या व ठिकाण (खूण) सांगा')}>
        <TextArea required minLength={10} maxLength={1000} value={f.description} onChange={(e) => setF({ ...f, description: e.target.value })} />
      </Field>
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <Field label={L('Ward (if you know it)', 'प्रभाग (माहीत असल्यास)')}>
          <Select
            value={f.wardId}
            onChange={(e) => setF({ ...f, wardId: e.target.value })}
            placeholder={L("Don't know", 'माहीत नाही')}
            options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
          />
        </Field>
        <Field label={L('Location', 'ठिकाण')} hint={point ? `${point.lat}, ${point.lng}` : undefined}>
          <button type="button" className="btn-secondary mt-1 w-full py-2" onClick={locate} disabled={locating}>
            {point ? L('Location added ✓', 'ठिकाण जोडले ✓') : locating ? t('loading') : L('Use my current location', 'माझे सध्याचे ठिकाण वापरा')}
          </button>
        </Field>
        <Field label={L('Your name (optional)', 'तुमचे नाव (ऐच्छिक)')}>
          <TextInput maxLength={100} value={f.citizenName} onChange={(e) => setF({ ...f, citizenName: e.target.value })} />
        </Field>
        <Field label={L('Mobile number (optional)', 'मोबाइल क्रमांक (ऐच्छिक)')}>
          <TextInput
            inputMode="numeric"
            pattern="[6-9][0-9]{9}"
            maxLength={10}
            value={f.citizenPhone}
            onChange={(e) => setF({ ...f, citizenPhone: e.target.value.replace(/\D/g, '') })}
          />
        </Field>
      </div>
      <p className="text-xs text-slate-500">{pick(CITIZEN_TEXT.privacy)}</p>
      {submit.isError ? <ErrorBanner error={submit.error} /> : null}
      <button type="submit" className="btn-primary w-full sm:w-auto" disabled={submit.isPending}>
        {submit.isPending ? t('saving') : pick(CITIZEN_TEXT.fileComplaint)}
      </button>
    </form>
  );
}
