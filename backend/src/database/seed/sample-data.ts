/**
 * Sample data for development, testing and the demo (deliverables 07 and 18).
 * Everything goes through the real services, so each row passes the same rules, repositories
 * and audit trail as an API call. Field roles sign in with the test login (employee code, no OTP);
 * the web roles (admin, office staff, ward inspectors) get SEED_WEB_PASSWORD when it is set in the
 * environment file, else no password. Production refuses to run the seed.
 *
 * Ward boundaries are synthetic squares around Sangli, NOT official limits: replace them with
 * SMKMC's GIS boundaries before the pilot.
 */
import type { INestApplicationContext } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, type StaffRole } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { OfficesService } from '../../modules/offices/offices.service';
import { RostersService } from '../../modules/rosters/rosters.service';
import { StaffAdminService } from '../../modules/staff-admin/staff-admin.service';
import { WardsService } from '../../modules/wards/wards.service';
import type { Zone } from '../../modules/wards/wards.policy';

export interface SeedSummary {
  wards: number;
  offices: number;
  staff: number;
  standingRosters: number;
  assignmentsToday: number;
  /** Employee codes to use with the test login, one per role. */
  sampleLogins: Record<StaffRole, string>;
}

const WARDS: { code: string; name: string; nameMr: string; zone: Zone }[] = [
  { code: 'W01', name: 'Prabhag 1', nameMr: 'प्रभाग १', zone: 'SANGLI' },
  { code: 'W02', name: 'Prabhag 2', nameMr: 'प्रभाग २', zone: 'SANGLI' },
  { code: 'W03', name: 'Prabhag 3', nameMr: 'प्रभाग ३', zone: 'MIRAJ' },
  { code: 'W04', name: 'Prabhag 4 (pilot)', nameMr: 'प्रभाग ४ (पथदर्शी)', zone: 'KUPWAD' },
];

const INSPECTORS_PER_WARD = 2;
const WORKERS_PER_INSPECTOR = 3;

/** A ~1.1 km square, side by side west to east (synthetic; see the file header). */
function squareBoundary(index: number): Record<string, unknown> {
  const west = 74.56 + index * 0.01;
  const south = 16.84;
  const ring = [
    [west, south],
    [west + 0.01, south],
    [west + 0.01, south + 0.01],
    [west, south + 0.01],
    [west, south],
  ];
  return { type: 'Polygon', coordinates: [ring] };
}

/** Sample mobile numbers 60000 00001 onwards; the dev OTP sender only logs, never sends. */
function phoneFor(n: number): string {
  return `60000${String(n).padStart(5, '0')}`;
}

/** Thrown when the database already has data; the seed never mixes with real records. */
export class AlreadySeededError extends Error {}

export async function seedSampleData(app: INestApplicationContext): Promise<SeedSummary> {
  const config = app.get(AppConfig);
  if (config.isProduction) throw new Error('The sample seed never runs in production.');

  const wards = app.get(WardsService);
  const offices = app.get(OfficesService);
  const staffAdmin = app.get(StaffAdminService);
  const rosters = app.get(RostersService);
  const clock = app.get(Clock);
  // Web sign-in roles get this password (development / test env file only; never in source).
  const webPassword = config.seedWebPassword ? { initialPassword: config.seedWebPassword } : {};

  if ((await wards.list(1, 1)).total > 0) {
    throw new AlreadySeededError(
      'The database already has wards; the sample seed only runs on an empty database.',
    );
  }

  let phoneSeq = 0;
  // The services read the caller's role (and id, for created_by); the seed acts as the admin it creates.
  const bootstrapActor: AuthUser = {
    staffId: 'seed',
    role: Role.ADMIN,
    sessionId: 'seed',
    homeWardId: null,
    officeId: null,
  };
  const adminProfile = await staffAdmin.create(bootstrapActor, {
    employeeCode: 'SMK-ADM-001',
    fullName: 'System Administrator',
    fullNameMr: 'प्रणाली प्रशासक',
    phone: phoneFor(++phoneSeq),
    role: Role.ADMIN,
    shiftStart: '10:00',
    shiftEnd: '18:00',
    ...webPassword,
  });
  const admin: AuthUser = { ...bootstrapActor, staffId: adminProfile.id, sessionId: 'seed' };
  let staffCount = 1;

  const office = await offices.create({
    code: 'HQ',
    name: 'SMKMC Head Office, Sangli',
    nameMr: 'सांगली मिरज कुपवाड महानगरपालिका मुख्य कार्यालय',
    zone: 'SANGLI',
    premises: {
      type: 'Polygon',
      coordinates: [
        [
          [74.5815, 16.8524],
          [74.5825, 16.8524],
          [74.5825, 16.8534],
          [74.5815, 16.8534],
          [74.5815, 16.8524],
        ],
      ],
    },
  });
  for (let i = 1; i <= 2; i++) {
    await staffAdmin.create(admin, {
      employeeCode: `SMK-OF-${String(i).padStart(3, '0')}`,
      fullName: `Office Clerk ${i}`,
      phone: phoneFor(++phoneSeq),
      role: Role.OFFICE_STAFF,
      officeId: office.id,
      reportsToId: admin.staffId,
      department: 'Establishment',
      shiftStart: '10:00',
      shiftEnd: '18:00',
      ...webPassword,
    });
    staffCount++;
  }

  let rosterCount = 0;
  for (const [w, def] of WARDS.entries()) {
    const ward = await wards.create({ ...def, boundary: squareBoundary(w) });
    const wn = String(w + 1).padStart(2, '0');
    const wardInspector = await staffAdmin.create(admin, {
      employeeCode: `SMK-WI-${wn}`,
      fullName: `Ward Inspector ${wn}`,
      phone: phoneFor(++phoneSeq),
      role: Role.WARD_INSPECTOR,
      homeWardId: ward.id,
      reportsToId: admin.staffId,
      department: 'Sanitation',
      ...webPassword,
    });
    staffCount++;

    for (let i = 1; i <= INSPECTORS_PER_WARD; i++) {
      const inspector = await staffAdmin.create(admin, {
        employeeCode: `SMK-IN-${wn}${i}`,
        fullName: `Inspector ${wn}-${i}`,
        phone: phoneFor(++phoneSeq),
        role: Role.INSPECTOR,
        homeWardId: ward.id,
        reportsToId: wardInspector.id,
        department: 'Sanitation',
      });
      staffCount++;
      for (let k = 1; k <= WORKERS_PER_INSPECTOR; k++) {
        const worker = await staffAdmin.create(admin, {
          employeeCode: `SMK-WK-${wn}${i}${k}`,
          fullName: `Worker ${wn}-${i}-${k}`,
          phone: phoneFor(++phoneSeq),
          role: Role.WORKER,
          homeWardId: ward.id,
          reportsToId: inspector.id,
          department: 'Sanitation',
        });
        staffCount++;
        await rosters.createRoster(admin, { workerId: worker.id, inspectorId: inspector.id });
        rosterCount++;
      }
    }
  }

  const today = await rosters.generate(admin, istDate(clock.now()));
  return {
    wards: WARDS.length,
    offices: 1,
    staff: staffCount,
    standingRosters: rosterCount,
    assignmentsToday: today.created,
    sampleLogins: {
      [Role.ADMIN]: 'SMK-ADM-001',
      [Role.WARD_INSPECTOR]: 'SMK-WI-04',
      [Role.INSPECTOR]: 'SMK-IN-041',
      [Role.WORKER]: 'SMK-WK-0411',
      [Role.OFFICE_STAFF]: 'SMK-OF-001',
    },
  };
}
