/**
 * Spot checks and the notification inbox, end to end with a frozen clock and a fake face match:
 * a senior orders a check, the worker sees it (inbox + pending list), snoozes once and answers
 * with the punch proof; an unanswered check is escalated; random checks are planned once per
 * shift and notified at their time.
 */
import { randomUUID } from 'node:crypto';
import { AlertsService } from '../src/modules/alerts/alerts.service';
import {
  FaceCaptureOptions,
  FaceVerificationResult,
  FaceVerifier,
} from '../src/modules/face/face-verifier';
import { SpotChecksService } from '../src/modules/spot-checks/spot-checks.service';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { Clock, FixedClock } from '../src/shared/clock/clock';
import { AppConfig } from '../src/shared/config/app-config';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

class AlwaysMatches extends FaceVerifier {
  readonly provider = 'local' as const;
  async captureOptions(): Promise<FaceCaptureOptions> {
    return { provider: 'local', instructions: 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP' };
  }
  async verify(): Promise<FaceVerificationResult> {
    return { provider: 'local', matched: true, score: 0.88, threshold: 0.5 };
  }
}

const DAY = '2026-11-02';
const INSIDE = { latitude: 16.855, longitude: 74.585 };
const FAR = { latitude: 16.95, longitude: 74.7 };

describe('spot checks and notifications (e2e)', () => {
  const clock = new FixedClock('2026-11-02T00:40:00Z'); // 06:10 IST, shifts 06:00-14:00
  let t: TestApp;
  let http: TestApp['http'];
  let service: SpotChecksService;
  let rate: jest.SpyInstance<number, []>;
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};

  const as = (who: string) => ({ Authorization: tok[who] });
  const challenge = async (who: string) =>
    (await http.post('/api/v1/attendance/challenges').set(as(who)).send({}).expect(201)).body
      .challengeId as string;
  // The challenge comes first: supertest closes the shared server when a request ends.
  const checkIn = async (who: string) => {
    const challengeId = await challenge(who);
    return http
      .post('/api/v1/attendance/punches')
      .set(as(who))
      .send({
        clientUuid: randomUUID(),
        type: 'CHECK_IN',
        challengeId,
        ...INSIDE,
        accuracyM: 10,
        faceImageBase64: Buffer.from('face').toString('base64'),
      })
      .expect(200);
  };
  const answer = async (who: string, id: string, status: number, where = INSIDE) => {
    const challengeId = await challenge(who);
    return http
      .post(`/api/v1/spot-checks/${id}/respond`)
      .set(as(who))
      .send({
        clientUuid: randomUUID(),
        challengeId,
        ...where,
        accuracyM: 12,
        faceImageBase64: Buffer.from('face').toString('base64'),
      })
      .expect(status);
  };

  beforeAll(async () => {
    t = await createTestApp((b) =>
      b
        .overrideProvider(Clock)
        .useValue(clock)
        .overrideProvider(FaceVerifier)
        .useClass(AlwaysMatches),
    );
    http = t.http;
    service = t.app.get(SpotChecksService);
    // No random checks unless a test asks (the local .env.test may keep the default rate).
    rate = jest.spyOn(t.app.get(AppConfig), 'spotCheckDailyRate', 'get').mockReturnValue(0);
    const w1 = await insertWard(t.dataSource, 'S1');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['IN2', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
      ['WK2', Role.WORKER, w1, 'IN1'],
      ['WK3', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `SC-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `SC-${key}`);
    }
    for (const body of [
      { date: DAY, staffId: s.IN1.id, wardId: w1 },
      ...['WK1', 'WK2', 'WK3'].map((k) => ({ date: DAY, staffId: s[k].id, inspectorId: s.IN1.id })),
    ]) {
      await http.post('/api/v1/assignments').set(as('WI1')).send(body).expect(201);
    }
    for (const who of ['WK1', 'WK2', 'WK3']) await checkIn(who);
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('a check ordered by a senior', () => {
    let id: string;

    it('reaches the worker at once: pending list and inbox', async () => {
      clock.set('2026-11-02T03:00:00Z');
      await http.post('/api/v1/spot-checks').set(as('IN2')).send({ staffId: s.WK1.id }).expect(403);
      await http.post('/api/v1/spot-checks').set(as('WK2')).send({ staffId: s.WK1.id }).expect(403);
      const ordered = await http
        .post('/api/v1/spot-checks')
        .set(as('IN1'))
        .send({ staffId: s.WK1.id, reason: 'Not seen at the market beat' })
        .expect(201);
      id = ordered.body.id;
      expect(ordered.body).toMatchObject({
        status: 'NOTIFIED',
        trigger: 'SENIOR_MANUAL',
        dueAt: '2026-11-02T03:10:00.000Z',
      });
      await http.post('/api/v1/spot-checks').set(as('IN1')).send({ staffId: s.WK1.id }).expect(409);

      const mine = await http.get('/api/v1/spot-checks/mine').set(as('WK1')).expect(200);
      expect(mine.body.map((c: { id: string }) => c.id)).toEqual([id]);
      const inbox = await http.get('/api/v1/notifications').set(as('WK1')).expect(200);
      expect(inbox.body.unreadCount).toBe(1);
      expect(inbox.body.items[0]).toMatchObject({
        kind: 'SPOT_CHECK',
        priority: 'HIGH',
        refId: id,
      });
    });

    it('can be snoozed once, then answered with the punch proof', async () => {
      await http.post(`/api/v1/spot-checks/${id}/snooze`).set(as('WK2')).expect(404);
      const snoozed = await http
        .post(`/api/v1/spot-checks/${id}/snooze`)
        .set(as('WK1'))
        .expect(200);
      expect(snoozed.body).toMatchObject({
        status: 'SNOOZED',
        snoozed: true,
        dueAt: '2026-11-02T03:20:00.000Z',
      });
      const again = await http.post(`/api/v1/spot-checks/${id}/snooze`).set(as('WK1')).expect(422);
      expect(again.body.details.reason).toBe('SNOOZE_USED');

      clock.set('2026-11-02T03:15:00Z');
      const res = await answer('WK1', id, 200);
      expect(res.body).toMatchObject({ status: 'VERIFIED', inGeofence: true, faceScore: 0.88 });
      const late = await answer('WK1', id, 422);
      expect(late.body.code).toBe('SPOT_CHECK_CLOSED');
      expect((await http.get('/api/v1/spot-checks/mine').set(as('WK1')).expect(200)).body).toEqual(
        [],
      );
    });

    it('records an answer from outside the ward and alerts the supervisors', async () => {
      const ordered = await http
        .post('/api/v1/spot-checks')
        .set(as('WI1'))
        .send({ staffId: s.WK2.id })
        .expect(201);
      const res = await answer('WK2', ordered.body.id, 200, FAR);
      expect(res.body).toMatchObject({ status: 'OUT_OF_GEOFENCE', inGeofence: false });
      const alerts = await http
        .get(`/api/v1/alerts?alertType=OUT_OF_ZONE&staffId=${s.WK2.id}`)
        .set(as('IN1'))
        .expect(200);
      expect(alerts.body.total).toBe(1);
      const inbox = await http
        .get('/api/v1/notifications?unreadOnly=true')
        .set(as('IN1'))
        .expect(200);
      expect(inbox.body.items.some((n: { kind: string }) => n.kind === 'ALERT')).toBe(true);
    });
  });

  describe('the job', () => {
    it('escalates a check nobody answered', async () => {
      clock.set('2026-11-02T04:00:00Z');
      const ordered = await http
        .post('/api/v1/spot-checks')
        .set(as('IN1'))
        .send({ staffId: s.WK3.id })
        .expect(201);
      clock.set('2026-11-02T04:11:00Z');
      expect(await service.runCycle()).toMatch(/missed 1/);
      const list = await http
        .get(`/api/v1/spot-checks?date=${DAY}&status=MISSED`)
        .set(as('WI1'))
        .expect(200);
      expect(list.body.items.map((c: { id: string }) => c.id)).toEqual([ordered.body.id]);
      const alerts = await http
        .get(`/api/v1/alerts?alertType=MISSED_SPOT_CHECK`)
        .set(as('WI1'))
        .expect(200);
      expect(alerts.body.total).toBe(1);
      await answer('WK3', ordered.body.id, 422);
    });

    it('plans a random check once per shift and notifies it at its time', async () => {
      rate.mockReturnValue(1);
      clock.set('2026-11-02T00:50:00Z'); // before the window (check-in + 30 min) opens
      expect(await service.runCycle()).toMatch(/planned 3, notified 0/);
      expect(await service.runCycle()).toMatch(/planned 0/); // decided once per shift
      const planned = await http
        .get(`/api/v1/spot-checks?date=${DAY}&status=SCHEDULED`)
        .set(as('ADM'))
        .expect(200);
      expect(planned.body.total).toBe(3);
      expect(planned.body.items.every((c: { trigger: string }) => c.trigger === 'RANDOM')).toBe(
        true,
      );
      clock.set('2026-11-02T08:00:00Z'); // the end of the window: all are due
      expect(await service.runCycle()).toMatch(/notified 3/);
      const mine = await http.get('/api/v1/spot-checks/mine').set(as('WK1')).expect(200);
      expect(mine.body).toHaveLength(1);
      expect(mine.body[0].trigger).toBe('RANDOM');
      rate.mockReturnValue(0);
    });

    it('lists checks only within the caller scope', async () => {
      await http.get('/api/v1/spot-checks').set(as('WK1')).expect(403);
      const ins = await http.get(`/api/v1/spot-checks?date=${DAY}`).set(as('IN2')).expect(200);
      expect(ins.body.total).toBe(0);
    });
  });

  describe('inbox and push tokens', () => {
    it('marks messages read and registers / removes a push token', async () => {
      const before = await http.get('/api/v1/notifications').set(as('WK1')).expect(200);
      expect(before.body.unreadCount).toBeGreaterThan(0);
      const one = before.body.items[0].id;
      await http
        .post('/api/v1/notifications/read')
        .set(as('WK2'))
        .send({ ids: [one] })
        .expect(200)
        .expect({ marked: 0 });
      await http.post('/api/v1/notifications/read').set(as('WK1')).send({}).expect(400);
      await http.post('/api/v1/notifications/read').set(as('WK1')).send({ all: true }).expect(200);
      expect(
        (await http.get('/api/v1/notifications').set(as('WK1')).expect(200)).body.unreadCount,
      ).toBe(0);

      const token = `fcm-token-${randomUUID()}`;
      await http
        .put('/api/v1/devices/push-token')
        .set(as('WK1'))
        .send({ token, platform: 'ANDROID' })
        .expect(204);
      await http
        .put('/api/v1/devices/push-token')
        .set(as('WK2'))
        .send({ token, platform: 'ANDROID' })
        .expect(204);
      await http.delete('/api/v1/devices/push-token').set(as('WK2')).send({ token }).expect(204);
      await t.app.get(AlertsService); // still wired
    });
  });
});
