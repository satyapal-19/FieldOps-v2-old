/**
 * Schema-level guarantees of the attendance / pings / tamper / spot-check migration,
 * checked against the real test database.
 */
import { randomUUID } from 'node:crypto';
import { AttendanceLog } from '../src/modules/attendance/entities/attendance-log.entity';
import { LocationPing } from '../src/modules/attendance/entities/location-ping.entity';
import { TamperEvent } from '../src/modules/attendance/entities/tamper-event.entity';
import { SpotCheck } from '../src/modules/spot-checks/entities/spot-check.entity';
import { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role } from '../src/shared/auth/roles';
import { isUniqueViolation } from '../src/shared/database/db-errors';
import { createTestApp, seedStaff, TestApp } from './helpers';

describe('attendance and tracking schema (e2e)', () => {
  let t: TestApp;
  let worker: Staff;
  let inspector: Staff;
  const date = '2026-11-02';
  const checkin = new Date('2026-11-02T00:35:00.000Z'); // 06:05 IST

  function attendance(fields: Partial<AttendanceLog>): Partial<AttendanceLog> {
    const now = new Date();
    return {
      id: randomUUID(),
      staffId: worker.id,
      attendanceDate: date,
      checkinClientUuid: randomUUID(),
      checkinAt: checkin,
      checkinLat: 16.8524123,
      checkinLng: 74.5815456,
      checkinAccuracyM: 12.5,
      checkinMode: 'SELF',
      status: 'PRESENT',
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  function ping(fields: Partial<LocationPing>): Partial<LocationPing> {
    return {
      id: randomUUID(),
      clientUuid: randomUUID(),
      staffId: worker.id,
      lat: 16.85,
      lng: 74.58,
      recordedAt: checkin,
      receivedAt: checkin,
      ...fields,
    };
  }

  const logs = () => t.dataSource.getRepository(AttendanceLog);
  const pings = () => t.dataSource.getRepository(LocationPing);

  beforeAll(async () => {
    t = await createTestApp();
    worker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'A-WK1' });
    inspector = await seedStaff(t.dataSource, { role: Role.INSPECTOR, employeeCode: 'A-IN1' });
  });

  afterEach(async () => {
    for (const entity of [SpotCheck, TamperEvent, LocationPing, AttendanceLog]) {
      await t.dataSource.createQueryBuilder().delete().from(entity).execute();
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('attendance_logs', () => {
    it('round-trips decimals as numbers and defaults face_passed to false (no fail-open)', async () => {
      const row = attendance({});
      await logs().insert(row);
      const read = await logs().findOneByOrFail({ id: row.id! });
      expect(read).toMatchObject({
        attendanceDate: date,
        checkinLat: 16.8524123,
        checkinLng: 74.5815456,
        checkinAccuracyM: 12.5,
        checkinFacePassed: false,
        checkinInGeofence: false,
        isLate: false,
        lateMinutes: 0,
        version: 1,
      });
      expect(read.checkinAt?.toISOString()).toBe(checkin.toISOString());
    });

    it('keeps one row per staff member per day', async () => {
      await logs().insert(attendance({}));
      const err = await logs()
        .insert(attendance({}))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    it('makes a retried check-in (same client UUID) a duplicate', async () => {
      const uuid = randomUUID();
      await logs().insert(attendance({ checkinClientUuid: uuid }));
      const err = await logs()
        .insert(attendance({ checkinClientUuid: uuid, staffId: inspector.id }))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    it('records a proxy punch with who marked it', async () => {
      const row = attendance({ checkinMode: 'INSPECTOR_PROXY', checkinMarkedById: inspector.id });
      await logs().insert(row);
      expect(await logs().findOneByOrFail({ id: row.id! })).toMatchObject({
        checkinMarkedById: inspector.id,
      });
    });

    it.each<[string, () => Partial<AttendanceLog>]>([
      ['an unknown status', () => ({ status: 'GONE' as never })],
      ['an unknown punch mode', () => ({ checkinMode: 'FRIEND' as never })],
      [
        'a check-out before the check-in',
        () => ({ checkoutAt: new Date(checkin.getTime() - 60_000) }),
      ],
      ['a check-out without a check-in', () => ({ checkinAt: null, checkoutAt: checkin })],
      ['negative late minutes', () => ({ lateMinutes: -1 })],
      ['a punch at a ward and an office at once', () => ({ wardId: 'x', officeId: 'y' })],
    ])('refuses %s', async (_label, fields) => {
      await expect(logs().insert(attendance(fields()))).rejects.toThrow();
    });
  });

  describe('location_pings', () => {
    it('stores a batch and refuses a re-sent ping', async () => {
      const batch = [ping({}), ping({}), ping({})];
      await pings().insert(batch);
      const err = await pings()
        .insert(ping({ clientUuid: batch[1].clientUuid }))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
      expect(await pings().countBy({ staffId: worker.id })).toBe(3);
    });

    it('refuses a battery level above 100', async () => {
      await expect(pings().insert(ping({ batteryPct: 101 }))).rejects.toThrow();
    });
  });

  describe('tamper_events', () => {
    const event = (fields: Partial<TamperEvent>): Partial<TamperEvent> => ({
      id: randomUUID(),
      clientUuid: randomUUID(),
      staffId: worker.id,
      eventType: 'GPS_DISABLED',
      source: 'DEVICE',
      startedAt: checkin,
      createdAt: checkin,
      ...fields,
    });

    it('stores device and server events, and refuses a resolution before the start', async () => {
      await t.dataSource.getRepository(TamperEvent).insert(event({}));
      await t.dataSource
        .getRepository(TamperEvent)
        .insert(event({ clientUuid: null, source: 'SERVER', eventType: 'SILENT_GAP' }));
      await expect(
        t.dataSource
          .getRepository(TamperEvent)
          .insert(event({ resolvedAt: new Date(checkin.getTime() - 1) })),
      ).rejects.toThrow();
    });
  });

  describe('spot_checks', () => {
    const check = (fields: Partial<SpotCheck>): Partial<SpotCheck> => ({
      id: randomUUID(),
      staffId: worker.id,
      shiftDate: date,
      triggerType: 'RANDOM',
      scheduledAt: checkin,
      createdAt: checkin,
      updatedAt: checkin,
      ...fields,
    });
    const checks = () => t.dataSource.getRepository(SpotCheck);

    it('starts SCHEDULED with no snooze used', async () => {
      const row = check({});
      await checks().insert(row);
      expect(await checks().findOneByOrFail({ id: row.id! })).toMatchObject({
        status: 'SCHEDULED',
        snoozeCount: 0,
      });
    });

    it.each<[string, () => Partial<SpotCheck>]>([
      ['a second snooze', () => ({ snoozeCount: 2 })],
      ['a senior check without the senior', () => ({ triggerType: 'SENIOR_MANUAL' })],
      ['an unknown status', () => ({ status: 'LOST' as never })],
    ])('refuses %s', async (_label, fields) => {
      await expect(checks().insert(check(fields()))).rejects.toThrow();
    });
  });
});
