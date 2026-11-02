'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import { useState, type FormEvent } from 'react';
import { api, unwrap, type Schemas } from '@/api/client';
import { enumOptions, ROLE_TEXT } from '@/shared/i18n/enum-text';
import { useLocale } from '@/shared/i18n/locale';
import { useOffices, useWards } from '@/shared/lookups/use-wards';
import { ErrorBanner } from '@/shared/ui/error-banner';
import { Field, Select, TextInput } from '@/shared/ui/fields';

type Staff = Schemas['StaffProfileDto'];
type Role = Staff['role'];

/** v4 reporting lines (mirrors MANAGER_ROLE in the backend policy, which has the final say). */
const MANAGER_ROLE: Record<Role, Role | null> = {
  ADMIN: null,
  WARD_INSPECTOR: 'ADMIN',
  INSPECTOR: 'WARD_INSPECTOR',
  WORKER: 'INSPECTOR',
  OFFICE_STAFF: 'ADMIN',
};
const PASSWORD_ROLES: readonly Role[] = ['ADMIN', 'WARD_INSPECTOR', 'OFFICE_STAFF'];
const WARD_ROLES: readonly Role[] = ['WARD_INSPECTOR', 'INSPECTOR', 'WORKER'];

interface FormState {
  employeeCode: string;
  fullName: string;
  fullNameMr: string;
  phone: string;
  role: Role;
  homeWardId: string;
  officeId: string;
  reportsToId: string;
  department: string;
  shiftStart: string;
  shiftEnd: string;
  initialPassword: string;
  isActive: boolean;
}

function initial(staff: Staff | null): FormState {
  return {
    employeeCode: staff?.employeeCode ?? '',
    fullName: staff?.fullName ?? '',
    fullNameMr: staff?.fullNameMr ?? '',
    phone: '',
    role: staff?.role ?? 'WORKER',
    homeWardId: staff?.homeWardId ?? '',
    officeId: staff?.officeId ?? '',
    reportsToId: staff?.reportsToId ?? '',
    department: staff?.department ?? '',
    shiftStart: staff?.shiftStart ?? '06:00',
    shiftEnd: staff?.shiftEnd ?? '14:00',
    initialPassword: '',
    isActive: staff?.isActive ?? true,
  };
}

const orUndefined = (v: string) => (v.trim() === '' ? undefined : v.trim());

/** Create (staff = null) or edit a staff member. ADMIN only; the API validates every rule. */
export function StaffForm({ staff, onDone }: { staff: Staff | null; onDone(): void }) {
  const { t, pick } = useLocale();
  const queryClient = useQueryClient();
  const { wards } = useWards();
  const { offices } = useOffices();
  const [f, setF] = useState<FormState>(() => initial(staff));
  const set = <K extends keyof FormState>(key: K, value: FormState[K]) => setF((s) => ({ ...s, [key]: value }));

  const managerRole = MANAGER_ROLE[f.role];
  const needsWard = WARD_ROLES.includes(f.role);
  const sameWard = f.role === 'WORKER' || f.role === 'INSPECTOR';
  const managers = useQuery({
    queryKey: ['staff', 'managers', managerRole, sameWard ? f.homeWardId : ''],
    enabled: !!managerRole && (!sameWard || !!f.homeWardId),
    queryFn: () =>
      unwrap(
        api.GET('/api/v1/staff', {
          params: {
            query: {
              role: managerRole ?? undefined,
              wardId: sameWard ? f.homeWardId : undefined,
              isActive: true,
              pageSize: 100,
            },
          },
        }),
      ),
  });

  const save = useMutation({
    mutationFn: () => {
      const common = {
        fullName: f.fullName.trim(),
        fullNameMr: orUndefined(f.fullNameMr),
        role: f.role,
        homeWardId: needsWard ? orUndefined(f.homeWardId) : undefined,
        officeId: f.role === 'OFFICE_STAFF' ? orUndefined(f.officeId) : undefined,
        reportsToId: managerRole ? orUndefined(f.reportsToId) : undefined,
        department: orUndefined(f.department),
        shiftStart: f.shiftStart,
        shiftEnd: f.shiftEnd,
      };
      if (!staff) {
        return unwrap(
          api.POST('/api/v1/staff', {
            body: {
              ...common,
              employeeCode: f.employeeCode.trim(),
              phone: f.phone.trim(),
              initialPassword: PASSWORD_ROLES.includes(f.role) ? orUndefined(f.initialPassword) : undefined,
            },
          }),
        );
      }
      return unwrap(
        api.PATCH('/api/v1/staff/{id}', {
          params: { path: { id: staff.id } },
          body: { ...common, expectedVersion: staff.version, phone: orUndefined(f.phone), isActive: f.isActive },
        }),
      );
    },
    onSuccess: async () => {
      await queryClient.invalidateQueries({ queryKey: ['staff'] });
      onDone();
    },
  });

  const revoke = useMutation({
    mutationFn: () =>
      unwrap(api.POST('/api/v1/auth/staff/{staffId}/revoke-sessions', { params: { path: { staffId: staff!.id } } })),
  });

  const submit = (e: FormEvent) => {
    e.preventDefault();
    if (!save.isPending) save.mutate();
  };

  const L = (en: string, mr: string) => pick({ en, mr });

  return (
    <form onSubmit={submit} className="space-y-4">
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
        <Field label={L('Employee code', 'कर्मचारी कोड')}>
          <TextInput
            required
            disabled={!!staff}
            value={f.employeeCode}
            onChange={(e) => set('employeeCode', e.target.value)}
            maxLength={20}
          />
        </Field>
        <Field
          label={L('Mobile number', 'मोबाइल क्रमांक')}
          hint={staff ? L(`Now ${staff.phone}; leave empty to keep`, `सध्या ${staff.phone}; बदलायचा नसल्यास रिकामे ठेवा`) : undefined}
        >
          <TextInput
            required={!staff}
            inputMode="tel"
            value={f.phone}
            onChange={(e) => set('phone', e.target.value)}
            maxLength={16}
          />
        </Field>
        <Field label={L('Full name (English)', 'पूर्ण नाव (इंग्रजी)')}>
          <TextInput required value={f.fullName} onChange={(e) => set('fullName', e.target.value)} maxLength={100} />
        </Field>
        <Field label={L('Full name (Marathi)', 'पूर्ण नाव (मराठी)')}>
          <TextInput value={f.fullNameMr} onChange={(e) => set('fullNameMr', e.target.value)} maxLength={100} />
        </Field>
        <Field label={t('role')}>
          <Select
            value={f.role}
            onChange={(e) => setF((s) => ({ ...s, role: e.target.value as Role, reportsToId: '' }))}
            options={enumOptions(ROLE_TEXT, pick)}
          />
        </Field>
        {needsWard ? (
          <Field label={t('ward')}>
            <Select
              required
              value={f.homeWardId}
              onChange={(e) => setF((s) => ({ ...s, homeWardId: e.target.value, reportsToId: '' }))}
              placeholder="—"
              options={wards.map((w) => ({ value: w.id, label: `${w.code} · ${pick({ en: w.name, mr: w.nameMr })}` }))}
            />
          </Field>
        ) : null}
        {f.role === 'OFFICE_STAFF' ? (
          <Field label={t('office')}>
            <Select
              required
              value={f.officeId}
              onChange={(e) => set('officeId', e.target.value)}
              placeholder="—"
              options={offices.map((o) => ({ value: o.id, label: pick({ en: o.name, mr: o.nameMr }) }))}
            />
          </Field>
        ) : null}
        {managerRole ? (
          <Field label={L(`Reports to (${ROLE_TEXT[managerRole].en})`, `वरिष्ठ (${ROLE_TEXT[managerRole].mr})`)}>
            <Select
              value={f.reportsToId}
              onChange={(e) => set('reportsToId', e.target.value)}
              placeholder={t('none')}
              options={(managers.data?.items ?? [])
                .filter((m) => m.id !== staff?.id)
                .map((m) => ({ value: m.id, label: `${pick({ en: m.fullName, mr: m.fullNameMr })} (${m.employeeCode})` }))}
            />
          </Field>
        ) : null}
        <Field label={L('Department', 'विभाग')}>
          <TextInput value={f.department} onChange={(e) => set('department', e.target.value)} maxLength={50} />
        </Field>
        <div className="grid grid-cols-2 gap-3">
          <Field label={L('Shift start', 'शिफ्ट सुरू')}>
            <TextInput type="time" required value={f.shiftStart} onChange={(e) => set('shiftStart', e.target.value)} />
          </Field>
          <Field label={L('Shift end', 'शिफ्ट संपते')}>
            <TextInput type="time" required value={f.shiftEnd} onChange={(e) => set('shiftEnd', e.target.value)} />
          </Field>
        </div>
        {!staff && PASSWORD_ROLES.includes(f.role) ? (
          <Field
            label={L('Web password (optional)', 'वेब पासवर्ड (ऐच्छिक)')}
            hint={L('10+ characters with letters and digits', 'किमान १० अक्षरे, अक्षरे व अंक दोन्ही')}
          >
            <TextInput
              type="password"
              autoComplete="new-password"
              value={f.initialPassword}
              onChange={(e) => set('initialPassword', e.target.value)}
              maxLength={72}
            />
          </Field>
        ) : null}
        {staff ? (
          <label className="flex items-center gap-2 text-sm sm:col-span-2">
            <input type="checkbox" checked={f.isActive} onChange={(e) => set('isActive', e.target.checked)} />
            {L(
              'Active (unticking deactivates and signs the person out everywhere)',
              'सक्रिय (खूण काढल्यास खाते निष्क्रिय होऊन सर्व उपकरणांवरून साइन आउट होते)',
            )}
          </label>
        ) : null}
      </div>
      {save.isError ? <ErrorBanner error={save.error} /> : null}
      {revoke.isError ? <ErrorBanner error={revoke.error} /> : null}
      {revoke.isSuccess ? (
        <p className="text-sm text-green-700">
          {L(`Signed out of ${revoke.data.revoked} device(s).`, `${revoke.data.revoked} उपकरणांवरून साइन आउट केले.`)}
        </p>
      ) : null}
      <div className="flex flex-wrap justify-between gap-2">
        {staff ? (
          <button type="button" className="btn-secondary" disabled={revoke.isPending} onClick={() => revoke.mutate()}>
            {L('Sign out of all devices', 'सर्व उपकरणांवरून साइन आउट')}
          </button>
        ) : (
          <span />
        )}
        <span className="flex gap-2">
          <button type="button" className="btn-secondary" onClick={onDone}>
            {t('cancel')}
          </button>
          <button type="submit" className="btn-primary" disabled={save.isPending}>
            {save.isPending ? t('saving') : t('save')}
          </button>
        </span>
      </div>
    </form>
  );
}
