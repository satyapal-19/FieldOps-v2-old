/**
 * Location pings and device tamper reports: batched, idempotent, linked to the open shift,
 * geofenced against the assigned ward, with OUT_OF_ZONE and TAMPER_DETECTED alerts.
 */
import { randomUUID } from 'node:crypto';
import { LocationPing } from '../src/modules/attendance/entities/location-ping.entity';
import { TamperEvent } from '../src/modules/attendance/entities/tamper-event.entity';
import {
  FaceCaptureOptions,
  FaceVerificationResult,
  FaceVerifier,
} from '../src/modules/face/face-verifier';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { Clock, FixedClock } from '../src/shared/clock/clock';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

class AlwaysMatches extends FaceVerifier {
  readonly provider = 'local' as const;
  async captureOptions(): Promise<FaceCaptureOptions> {
    return { provider: 'local', instructions: 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP' };
  }
  async verify(): Promise<FaceVerificationResult> {
    return { provider: 'local', matched: true, score: 0.9, threshold: 0.5 };
  }
}

const INSIDE = { latitude: 16.855, longitude: 74.585 };
const OUTSIDE = { latitude: 16.87, longitude: 74.585 };

describe('location pings and tamper events (e2e)', () => {
  const clock = new FixedClock('2026-11-02T00:40:00Z'); // 06:10 IST
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  let attendanceId: string;

  const minutesAgo = (m: number) => new Date(clock.now().getTime() - m * 60_000).toISOString();
  const ping = (fields: Record<string, unknown> = {}) => ({
    clientUuid: randomUUID(),
    ...INSIDE,
    accuracyM: 8,
    batteryPct: 70,
    recordedAt: minutesAgo(0),
    ...fields,
  });
  const send = (who: string, pings: unknown[]) =>
    http.post('/api/v1/attendance/pings').set('Authorization', tok[who]).send({ pings });
  const openAlerts = async (type: string) =>
    (
      await http
        .get(`/api/v1/alerts?alertType=${type}&staffId=${s.WK1.id}`)
        .set('Authorization', tok.IN1)
        .expect(200)
    ).body.items as { severity: string }[];

  beforeAll(async () => {
    t = await createTestApp((b) =>
      b
        .overrideProvider(Clock)
        .useValue(clock)
        .overrideProvider(FaceVerifier)
        .useClass(AlwaysMatches),
    );
    http = t.http;
    const w1 = await insertWard(t.dataSource, 'T1');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `T-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `T-${key}`);
    }
    for (const body of [
      { date: '2026-11-02', staffId: s.IN1.id, wardId: w1 },
      { date: '2026-11-02', staffId: s.WK1.id, inspectorId: s.IN1.id },
    ]) {
      await http.post('/api/v1/assignments').set('Authorization', tok.WI1).send(body).expect(201);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it('stores pings before check-in without a shift or ward flag', async () => {
    const early = ping({ recordedAt: minutesAgo(5) });
    const res = await send('WK1', [early]).expect(200);
    expect(res.body).toEqual({ accepted: 1, duplicates: 0, rejected: [] });
    const row = await t.dataSource
      .getRepository(LocationPing)
      .findOneByOrFail({ clientUuid: early.clientUuid });
    expect(row).toMatchObject({ attendanceId: null, inWard: null, isStationary: false });
  });

  it('links pings to the open shift and geofences them', async () => {
    const challenge = await http
      .post('/api/v1/attendance/challenges')
      .set('Authorization', tok.WK1)
      .send({})
      .expect(201);
    const punch = await http
      .post('/api/v1/attendance/punches')
      .set('Authorization', tok.WK1)
      .send({
        clientUuid: randomUUID(),
        type: 'CHECK_IN',
        challengeId: challenge.body.challengeId,
        ...INSIDE,
        accuracyM: 10,
        faceImageBase64: Buffer.from('face').toString('base64'),
      })
      .expect(200);
    attendanceId = punch.body.attendance.id;

    clock.advanceMinutes(10);
    const near = ping({ latitude: 16.85505 }); // ~6 m from the last fix: standing still
    const res = await send('WK1', [near, ping({ recordedAt: minutesAgo(0), latitude: 16.857 })]);
    expect(res.status).toBe(200);
    expect(res.body.accepted).toBe(2);
    const row = await t.dataSource
      .getRepository(LocationPing)
      .findOneByOrFail({ clientUuid: near.clientUuid });
    expect(row).toMatchObject({ attendanceId, inWard: true, isStationary: true });
  });

  it('is idempotent and rejects fixes from the future or too long ago', async () => {
    const a = ping({ recordedAt: minutesAgo(1) });
    await send('WK1', [a]).expect(200);
    const future = ping({
      recordedAt: new Date(clock.now().getTime() + 10 * 60_000).toISOString(),
    });
    const ancient = ping({ recordedAt: minutesAgo(49 * 60) });
    const res = await send('WK1', [a, a, future, ancient]).expect(200);
    expect(res.body.accepted).toBe(0);
    expect(res.body.duplicates).toBe(2);
    expect(res.body.rejected).toEqual([
      { clientUuid: future.clientUuid, reason: 'TIME_OUT_OF_RANGE' },
      { clientUuid: ancient.clientUuid, reason: 'TIME_OUT_OF_RANGE' },
    ]);
  });

  it('raises OUT_OF_ZONE after two outside pings in a row, once', async () => {
    clock.advanceMinutes(10);
    await send('WK1', [ping(OUTSIDE)]).expect(200);
    expect(await openAlerts('OUT_OF_ZONE')).toHaveLength(0);

    clock.advanceMinutes(10);
    await send('WK1', [ping(OUTSIDE)]).expect(200);
    expect(await openAlerts('OUT_OF_ZONE')).toHaveLength(1);

    clock.advanceMinutes(10);
    await send('WK1', [ping(OUTSIDE)]).expect(200);
    expect(await openAlerts('OUT_OF_ZONE')).toHaveLength(1);
  });

  it('validates the batch and who may send it', async () => {
    await send('WK1', []).expect(400);
    await send(
      'WK1',
      Array.from({ length: 201 }, () => ping()),
    ).expect(400);
    await send('WK1', [ping({ latitude: 91 })]).expect(400);
    await send('ADM', [ping()]).expect(403);
    await http
      .post('/api/v1/attendance/pings')
      .send({ pings: [ping()] })
      .expect(401);
  });

  describe('tamper events', () => {
    const report = (who: string, events: unknown[]) =>
      http.post('/api/v1/attendance/tamper-events').set('Authorization', tok[who]).send({ events });
    const gpsOff = { clientUuid: randomUUID(), eventType: 'GPS_DISABLED' };

    it('stores a device report and alerts the supervisors', async () => {
      const res = await report('WK1', [
        { ...gpsOff, startedAt: minutesAgo(3), lastLatitude: 16.855, lastLongitude: 74.585 },
      ]);
      expect(res.status).toBe(200);
      expect(res.body).toEqual({ accepted: 1, duplicates: 0, rejected: [] });
      const alerts = await openAlerts('TAMPER_DETECTED');
      expect(alerts).toHaveLength(1);
      expect(alerts[0].severity).toBe('HIGH');
    });

    it('records the end of the event when the phone resends it', async () => {
      const res = await report('WK1', [
        { ...gpsOff, startedAt: minutesAgo(3), resolvedAt: minutesAgo(0) },
      ]).expect(200);
      expect(res.body.duplicates).toBe(1);
      const row = await t.dataSource
        .getRepository(TamperEvent)
        .findOneByOrFail({ clientUuid: gpsOff.clientUuid });
      expect(row.resolvedAt?.toISOString()).toBe(minutesAgo(0));
      expect(row.source).toBe('DEVICE');
      expect(await openAlerts('TAMPER_DETECTED')).toHaveLength(1);
    });

    it('refuses server-only types, bad times and the wrong roles', async () => {
      await report('WK1', [
        { clientUuid: randomUUID(), eventType: 'SILENT_GAP', startedAt: minutesAgo(1) },
      ]).expect(400);
      const backwards = { clientUuid: randomUUID(), eventType: 'AIRPLANE_MODE' };
      const res = await report('WK1', [
        { ...backwards, startedAt: minutesAgo(1), resolvedAt: minutesAgo(5) },
      ]).expect(200);
      expect(res.body.rejected).toEqual([
        { clientUuid: backwards.clientUuid, reason: 'TIME_OUT_OF_RANGE' },
      ]);
      await report('ADM', [{ ...backwards, startedAt: minutesAgo(1) }]).expect(403);
    });
  });
});
