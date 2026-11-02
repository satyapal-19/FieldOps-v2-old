/**
 * Shared e2e helpers: build the app exactly as production does, reset the test database
 * and seed staff directly (staff CRUD endpoints arrive in phase 1B).
 */
import { INestApplication } from '@nestjs/common';
import { Test, TestingModuleBuilder } from '@nestjs/testing';
import * as bcrypt from 'bcryptjs';
import request from 'supertest';
import { DataSource } from 'typeorm';
import { AppModule } from '../src/app.module';
import { configureApp } from '../src/app.setup';
import { OtpMessage, OtpSender } from '../src/modules/auth/otp/otp-sender';
import { CorporationOffice } from '../src/modules/offices/entities/corporation-office.entity';
import { Staff } from '../src/modules/staff/entities/staff.entity';
import { Ward } from '../src/modules/wards/entities/ward.entity';
import type { StaffRole } from '../src/shared/auth/roles';
import { ENTITIES } from '../src/database/entities';
import { randomUUID } from 'node:crypto';

/** Keeps sent codes in memory so tests can read them. */
export class CapturingOtpSender extends OtpSender {
  readonly name = 'capture';
  readonly sent: OtpMessage[] = [];
  async send(message: OtpMessage): Promise<void> {
    this.sent.push(message);
  }
  lastCodeFor(phone: string): string | undefined {
    return [...this.sent].reverse().find((m) => m.phone === phone)?.code;
  }
}

export interface TestApp {
  app: INestApplication;
  http: ReturnType<typeof request>;
  dataSource: DataSource;
  otp: CapturingOtpSender;
}

/** Extra provider overrides for one suite, e.g. a FixedClock or a fake FaceVerifier. */
export type TestOverrides = (builder: TestingModuleBuilder) => TestingModuleBuilder;

export async function createTestApp(overrides?: TestOverrides): Promise<TestApp> {
  const otp = new CapturingOtpSender();
  let builder = Test.createTestingModule({ imports: [AppModule] })
    .overrideProvider(OtpSender)
    .useValue(otp);
  if (overrides) builder = overrides(builder);
  const moduleRef = await builder.compile();
  const app = moduleRef.createNestApplication({ bufferLogs: true });
  configureApp(app);
  await app.init();

  const dataSource = app.get(DataSource);
  await dataSource.runMigrations();
  await resetDatabase(dataSource);
  return { app, http: request(app.getHttpServer()), dataSource, otp };
}

/** Deletes every row, children before parents (TRUNCATE is refused with foreign keys). */
export async function resetDatabase(dataSource: DataSource): Promise<void> {
  const order = [
    'AuditLog',
    'AuthSession',
    'AuthOtp',
    'Message',
    'ConversationParticipant',
    'Conversation',
    'Alert',
    'Holiday',
    'RegularizationRequest',
    'LeaveRequest',
    'TaskUpdate',
    'Task',
    'CitizenComplaint',
    'SpotCheck',
    'TamperEvent',
    'LocationPing',
    'AttendanceLog',
    'LivenessChallenge',
    'Shift',
    'DailyAssignment',
    'StandingRoster',
    'Staff',
    'CorporationOffice',
    'Ward',
  ];
  const byName = new Map(ENTITIES.map((e) => [e.name, e]));
  for (const name of order) {
    const entity = byName.get(name);
    if (!entity) throw new Error(`resetDatabase: unknown entity ${name}`);
    if (name === 'Staff') {
      // Self-reference: clear reports_to before deleting.
      await dataSource.createQueryBuilder().update(Staff).set({ reportsToId: null }).execute();
    }
    await dataSource.createQueryBuilder().delete().from(entity).execute();
  }
}

let phoneCounter = 0;

export async function seedStaff(
  dataSource: DataSource,
  fields: {
    role: StaffRole;
    employeeCode: string;
    homeWardId?: string | null;
    officeId?: string | null;
    reportsToId?: string | null;
    password?: string;
  },
): Promise<Staff> {
  phoneCounter += 1;
  const now = new Date();
  const staff: Staff = {
    id: randomUUID(),
    employeeCode: fields.employeeCode,
    fullName: `Test ${fields.employeeCode}`,
    fullNameMr: null,
    phone: `98${String(10_000_000 + phoneCounter).slice(-8)}`,
    role: fields.role,
    homeWardId: fields.homeWardId ?? null,
    officeId: fields.officeId ?? null,
    reportsToId: fields.reportsToId ?? null,
    department: null,
    shiftStart: '06:00',
    shiftEnd: '14:00',
    // Low cost factor: these are throwaway test accounts.
    passwordHash: fields.password ? await bcrypt.hash(fields.password, 4) : null,
    isActive: true,
    deactivatedAt: null,
    version: 1,
    createdAt: now,
    updatedAt: now,
  };
  await dataSource.getRepository(Staff).insert(staff);
  return staff;
}

/** Inserts an active ward directly (when the test is not about wards). Returns its id. */
export async function insertWard(
  dataSource: DataSource,
  code: string,
  boundary: object = SQUARE_BOUNDARY,
): Promise<string> {
  const now = new Date();
  const ward: Ward = {
    id: randomUUID(),
    code,
    name: `Ward ${code}`,
    nameMr: `प्रभाग ${code}`,
    zone: 'SANGLI',
    boundaryGeojson: JSON.stringify(boundary),
    isActive: true,
    version: 1,
    createdAt: now,
    updatedAt: now,
  };
  await dataSource.getRepository(Ward).insert(ward);
  return ward.id;
}

/** Signs in through the dev/test-only endpoint and returns the bearer header value. */
export async function bearerFor(http: TestApp['http'], identifier: string): Promise<string> {
  const res = await http.post('/api/v1/auth/test-login').send({ identifier }).expect(200);
  return `Bearer ${res.body.accessToken as string}`;
}

export async function insertOffice(
  dataSource: DataSource,
  code: string,
  premises: object = SQUARE_BOUNDARY,
): Promise<string> {
  const now = new Date();
  const office: CorporationOffice = {
    id: randomUUID(),
    code,
    name: `Office ${code}`,
    nameMr: `कार्यालय ${code}`,
    zone: 'SANGLI',
    premisesGeojson: JSON.stringify(premises),
    bufferMeters: 100,
    isActive: true,
    version: 1,
    createdAt: now,
    updatedAt: now,
  };
  await dataSource.getRepository(CorporationOffice).insert(office);
  return office.id;
}

export const SQUARE_BOUNDARY = {
  type: 'Polygon',
  coordinates: [
    [
      [74.58, 16.85],
      [74.59, 16.85],
      [74.59, 16.86],
      [74.58, 16.86],
      [74.58, 16.85],
    ],
  ],
};
