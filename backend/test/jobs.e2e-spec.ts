/**
 * The scheduled attendance jobs and route history, end to end with a frozen clock: the
 * run-once lock, silent gaps, auto-checkout, the nightly roll-up into route and ward
 * summaries, the retention purge, and GET /staff/:id/route before and after the purge.
 */
import { randomUUID } from 'node:crypto';
import { AttendanceJobsService } from '../src/modules/attendance/attendance-jobs.service';
import { AttendanceScheduler } from '../src/modules/attendance/attendance.scheduler';
import { AttendanceLog } from '../src/modules/attendance/entities/attendance-log.entity';
import { LivenessChallenge } from '../src/modules/attendance/entities/liveness-challenge.entity';
import { LocationPing } from '../src/modules/attendance/entities/location-ping.entity';
import { RouteSummary } from '../src/modules/attendance/entities/route-summary.entity';
import { TamperEvent } from '../src/modules/attendance/entities/tamper-event.entity';
import { WardDailySummary } from '../src/modules/attendance/entities/ward-daily-summary.entity';
import {
  FaceCaptureOptions,
  FaceVerificationResult,
  FaceVerifier,
} from '../src/modules/face/face-verifier';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { AuditLog } from '../src/shared/audit/audit-log.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { Clock, FixedClock } from '../src/shared/clock/clock';
import { JobLock } from '../src/shared/jobs/job-lock.entity';
import { JobRunner } from '../src/shared/jobs/job-runner';
import { bearerFor, createTestApp, insertOffice, insertWard, seedStaff, TestApp } from './helpers';

class AlwaysMatches extends FaceVerifier {
  readonly provider = 'local' as const;
  async captureOptions(): Promise<FaceCaptureOptions> {
    return { provider: 'local', instructions: 'ML_KIT_LIVENESS_THEN_UPLOAD_CROP' };
  }
  async verify(): Promise<FaceVerificationResult> {
    return { provider: 'local', matched: true, score: 0.9, threshold: 0.5 };
  }
}

const DAY = '2026-11-02';
const OFFICE_POINT = { latitude: 16.8505, longitude: 74.6005 };

describe('attendance jobs and route history (e2e)', () => {
  const clock = new FixedClock('2026-11-02T00:40:00Z'); // 06:10 IST, shift 06:00-14:00
  let t: TestApp;
  let http: TestApp['http'];
  let jobs: AttendanceJobsService;
  let w1: string;
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  let wk1Distance = 0;
  let wk2Distance = 0;

  const ping = (who: string, latitude: number) =>
    http
      .post('/api/v1/attendance/pings')
      .set('Authorization', tok[who])
      .send({
        pings: [
          {
            clientUuid: randomUUID(),
            latitude,
            longitude: 74.585,
            accuracyM: 8,
            recordedAt: clock.now().toISOString(),
          },
        ],
      })
      .expect(200);
  const checkIn = async (
    who: string,
    point: { latitude: number; longitude: number },
    accuracyM: number,
    subject?: string,
  ) => {
    const staffId = subject ? s[subject].id : undefined;
    const challenge = await http
      .post('/api/v1/attendance/challenges')
      .set('Authorization', tok[who])
      .send(staffId ? { staffId } : {})
      .expect(201);
    await http
      .post('/api/v1/attendance/punches')
      .set('Authorization', tok[who])
      .send({
        clientUuid: randomUUID(),
        type: 'CHECK_IN',
        staffId,
        challengeId: challenge.body.challengeId,
        ...point,
        accuracyM,
        faceImageBase64: Buffer.from('face').toString('base64'),
      })
      .expect(200);
  };
  const logOf = (key: string) =>
    t.dataSource
      .getRepository(AttendanceLog)
      .findOneByOrFail({ staffId: s[key].id, attendanceDate: DAY });
  const route = (who: string, key: string, date = DAY) =>
    http.get(`/api/v1/staff/${s[key].id}/route?date=${date}`).set('Authorization', tok[who]);

  beforeAll(async () => {
    t = await createTestApp((b) =>
      b
        .overrideProvider(Clock)
        .useValue(clock)
        .overrideProvider(FaceVerifier)
        .useClass(AlwaysMatches),
    );
    http = t.http;
    jobs = t.app.get(AttendanceJobsService);
    w1 = await insertWard(t.dataSource, 'J1');
    const office = await insertOffice(t.dataSource, 'JHQ', {
      type: 'Polygon',
      coordinates: [
        [
          [74.6, 16.85],
          [74.601, 16.85],
          [74.601, 16.851],
          [74.6, 16.851],
          [74.6, 16.85],
        ],
      ],
    });
    const people: [string, StaffRole, string | null, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM', null],
      ['IN1', Role.INSPECTOR, w1, 'WI1', null],
      ['WK1', Role.WORKER, w1, 'IN1', null],
      ['WK2', Role.WORKER, w1, 'IN1', null],
      ['WK3', Role.WORKER, w1, 'IN1', null],
      ['OF1', Role.OFFICE_STAFF, null, 'ADM', office],
    ];
    for (const [key, role, homeWardId, managerKey, officeId] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `J-${key}`,
        homeWardId,
        officeId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `J-${key}`);
    }
    for (const body of [
      { date: DAY, staffId: s.IN1.id, wardId: w1 },
      { date: DAY, staffId: s.WK1.id, inspectorId: s.IN1.id },
      { date: DAY, staffId: s.WK2.id, inspectorId: s.IN1.id },
      { date: DAY, staffId: s.WK3.id, inspectorId: s.IN1.id }, // never turns up
    ]) {
      await http.post('/api/v1/assignments').set('Authorization', tok.WI1).send(body).expect(201);
    }
    await checkIn('WK1', { latitude: 16.855, longitude: 74.585 }, 10);
    await checkIn('IN1', { latitude: 16.855, longitude: 74.585 }, 10, 'WK2'); // proxy
    await checkIn('OF1', OFFICE_POINT, 50);
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('JobRunner', () => {
    it('runs each slot once, even when two instances fire together', async () => {
      const runner = t.app.get(JobRunner);
      let runs = 0;
      const work = async () => `run ${++runs}`;
      expect(await runner.run('test-job', 'slot-1', 5, work)).toEqual({
        ran: true,
        result: 'run 1',
      });
      expect(await runner.run('test-job', 'slot-1', 5, work)).toEqual({ ran: false });
      const both = await Promise.all([
        runner.run('test-job', 'slot-2', 5, work),
        runner.run('test-job', 'slot-2', 5, work),
      ]);
      expect(both.filter((o) => o.ran)).toHaveLength(1);
      expect(runs).toBe(2);
    });

    it('records a failure and releases the lock for the next slot', async () => {
      const runner = t.app.get(JobRunner);
      await expect(
        runner.run('test-job', 'slot-3', 5, async () => {
          throw new Error('boom');
        }),
      ).rejects.toThrow('boom');
      const row = await t.dataSource
        .getRepository(JobLock)
        .findOneByOrFail({ jobName: 'test-job' });
      expect(row).toMatchObject({ lastStatus: 'FAILED', lastResult: 'boom', lockedBy: null });
      expect((await runner.run('test-job', 'slot-4', 5, async () => 'ok')).ran).toBe(true);
    });

    it('does nothing from the scheduler while JOBS_ENABLED is false', async () => {
      await t.app.get(AttendanceScheduler).autoCheckout();
      expect(await t.dataSource.getRepository(JobLock).countBy({ jobName: 'auto-checkout' })).toBe(
        0,
      );
    });
  });

  describe('silent gaps', () => {
    it('opens a server gap for a checked-in phone that sends nothing for 30 minutes', async () => {
      for (const [time, lat] of [
        ['2026-11-02T00:50:00Z', 16.851],
        ['2026-11-02T01:00:00Z', 16.852],
        ['2026-11-02T01:10:00Z', 16.853],
      ] as const) {
        clock.set(time);
        await ping('WK1', lat);
      }
      // WK2 checked in at 00:40Z and has sent nothing; WK1 is fine; OF1 is office staff.
      expect(await jobs.detectSilentGaps()).toBe('opened 1 silent gaps, closed 0');
      const gaps = await t.dataSource
        .getRepository(TamperEvent)
        .findBy({ eventType: 'SILENT_GAP' });
      expect(gaps).toHaveLength(1);
      expect(gaps[0]).toMatchObject({ staffId: s.WK2.id, source: 'SERVER', resolvedAt: null });
      expect(gaps[0].startedAt.toISOString()).toBe('2026-11-02T00:40:00.000Z');

      const alerts = await http
        .get(`/api/v1/alerts?alertType=TAMPER_DETECTED&staffId=${s.WK2.id}`)
        .set('Authorization', tok.IN1)
        .expect(200);
      expect(alerts.body.items).toHaveLength(1);

      clock.set('2026-11-02T01:12:00Z');
      expect(await jobs.detectSilentGaps()).toBe('opened 0 silent gaps, closed 0');
    });

    it('closes the gap at the first ping after it', async () => {
      clock.set('2026-11-02T01:20:00Z');
      await ping('WK2', 16.855);
      clock.set('2026-11-02T01:25:00Z');
      expect(await jobs.detectSilentGaps()).toBe('opened 0 silent gaps, closed 1');
      const gap = await t.dataSource
        .getRepository(TamperEvent)
        .findOneByOrFail({ eventType: 'SILENT_GAP' });
      expect(gap.resolvedAt?.toISOString()).toBe('2026-11-02T01:20:00.000Z');
    });
  });

  describe('auto-checkout', () => {
    it('waits an hour after the shift end', async () => {
      clock.set('2026-11-02T07:30:00Z'); // 13:00 IST
      await ping('WK1', 16.854);
      clock.set('2026-11-02T09:00:00Z'); // 14:30 IST
      expect(await jobs.autoCheckout()).toBe('closed 0 of 3 open shifts');
    });

    it('closes field shifts when last seen and office shifts at the scheduled end', async () => {
      clock.set('2026-11-02T10:00:00Z'); // 15:30 IST
      expect(await jobs.autoCheckout()).toBe('closed 3 of 3 open shifts');

      const wk1 = await logOf('WK1');
      expect(wk1.checkoutAt?.toISOString()).toBe('2026-11-02T07:30:00.000Z');
      expect(wk1).toMatchObject({
        checkoutType: 'AUTO_GPS_LAST_SEEN',
        status: 'PRESENT',
        workedMinutes: 410,
      });
      const wk2 = await logOf('WK2');
      expect(wk2.checkoutAt?.toISOString()).toBe('2026-11-02T01:20:00.000Z');
      expect(wk2).toMatchObject({ status: 'HALF_DAY', workedMinutes: 40 });
      const of1 = await logOf('OF1');
      expect(of1.checkoutAt?.toISOString()).toBe('2026-11-02T08:30:00.000Z');
      expect(of1).toMatchObject({ checkoutType: 'AUTO_OFFICE_SCHEDULED', workedMinutes: 470 });

      const audit = await t.dataSource
        .getRepository(AuditLog)
        .findBy({ action: 'ATTENDANCE_AUTO_CHECKOUT' });
      expect(audit).toHaveLength(3);
      expect(audit.every((a) => a.actorRole === 'SYSTEM' && a.actorId === null)).toBe(true);

      expect(await jobs.autoCheckout()).toBe('closed 0 of 0 open shifts');
    });
  });

  describe('GET /staff/:id/route', () => {
    it('shows a worker their own route for today, with live stats', async () => {
      const res = await route('WK1', 'WK1').expect(200);
      expect(res.body.points).toHaveLength(4);
      expect(res.body.points[0]).toMatchObject({ latitude: 16.851, inWard: true });
      expect(res.body.summary).toMatchObject({ source: 'LIVE', pingCount: 4, maxGapMinutes: 380 });
      // 16.851 -> 16.854 in steps of 0.001 deg latitude: about 334 m.
      expect(res.body.summary.distanceM).toBeGreaterThan(320);
      expect(res.body.summary.distanceM).toBeLessThan(345);
      expect(res.body.shift).toMatchObject({ checkoutAt: '2026-11-02T07:30:00.000Z' });
      expect(res.body.pointsPurged).toBe(false);
      wk1Distance = res.body.summary.distanceM;
    });

    it("shows the inspector a team member's route with its tamper events", async () => {
      const res = await route('IN1', 'WK2').expect(200);
      expect(res.body.tamperEvents).toEqual([
        {
          eventType: 'SILENT_GAP',
          source: 'SERVER',
          startedAt: '2026-11-02T00:40:00.000Z',
          resolvedAt: '2026-11-02T01:20:00.000Z',
        },
      ]);
      wk2Distance = res.body.summary.distanceM;
      await route('WI1', 'WK1').expect(200);
      await route('ADM', 'WK1').expect(200);
    });

    it('hides other people and other days from a worker', async () => {
      await route('WK1', 'WK2').expect(404);
      const res = await route('WK1', 'WK1', '2026-10-30').expect(403);
      expect(res.body.code).toBe('FORBIDDEN');
      await route('WK1', 'WK1', '2026-11-03').expect(422);
      await route('WK1', 'WK1', '2026-11-2').expect(400);
      await http
        .get(`/api/v1/staff/not-a-uuid/route?date=${DAY}`)
        .set('Authorization', tok.WK1)
        .expect(400);
      await http.get(`/api/v1/staff/${s.WK1.id}/route?date=${DAY}`).expect(401);
    });
  });

  describe('nightly roll-up', () => {
    it('writes one route summary per person and one ward summary, and can re-run', async () => {
      clock.set('2026-11-03T20:00:00Z'); // 01:30 IST on 4 Nov
      expect(await jobs.rollUp()).toBe(
        '2026-11-02: 2 routes, 1 wards; 2026-11-03: 0 routes, 0 wards',
      );
      expect(await jobs.rollUp()).toBe(
        '2026-11-02: 2 routes, 1 wards; 2026-11-03: 0 routes, 0 wards',
      );

      const routes = t.dataSource.getRepository(RouteSummary);
      expect(await routes.count()).toBe(2);
      const wk1 = await routes.findOneByOrFail({ staffId: s.WK1.id, summaryDate: DAY });
      expect(wk1).toMatchObject({
        wardId: w1,
        attendanceId: (await logOf('WK1')).id,
        pingCount: 4,
        inWardPings: 4,
        distanceM: wk1Distance,
        maxGapMinutes: 380,
      });
      const wk2 = await routes.findOneByOrFail({ staffId: s.WK2.id, summaryDate: DAY });
      expect(wk2).toMatchObject({ pingCount: 1, tamperEvents: 1 });

      const ward = await t.dataSource
        .getRepository(WardDailySummary)
        .findOneByOrFail({ wardId: w1, summaryDate: DAY });
      expect(ward).toMatchObject({
        assignedCount: 4, // IN1, WK1, WK2, WK3
        presentCount: 2,
        lateCount: 0,
        halfDayCount: 1,
        absentCount: 2, // IN1 and WK3 never checked in
        onLeaveCount: 0,
        proxyCount: 1,
        autoCheckoutCount: 2,
        distanceM: wk1Distance + wk2Distance,
      });
    });

    it("no longer shows a worker that day's route two days later", async () => {
      await route('WK1', 'WK1').expect(403);
      expect((await route('IN1', 'WK1').expect(200)).body.summary.source).toBe('LIVE');
    });
  });

  describe('retention purge', () => {
    it('deletes pings past retention; the route then comes from the nightly summary', async () => {
      clock.set('2027-02-05T00:00:00Z'); // 95 days later
      expect(await jobs.purge()).toBe('deleted 5 pings older than 90 days and 3 challenges');
      expect(await t.dataSource.getRepository(LocationPing).count()).toBe(0);
      expect(await t.dataSource.getRepository(LivenessChallenge).count()).toBe(0);

      tok.ADM = await bearerFor(http, 'J-ADM'); // the old session has expired by now
      const res = await route('ADM', 'WK1').expect(200);
      expect(res.body.points).toEqual([]);
      expect(res.body.pointsPurged).toBe(true);
      expect(res.body.summary).toMatchObject({
        source: 'NIGHTLY',
        pingCount: 4,
        distanceM: wk1Distance,
      });
      expect(await jobs.purge()).toBe('deleted 0 pings older than 90 days and 0 challenges');
    });
  });
});
