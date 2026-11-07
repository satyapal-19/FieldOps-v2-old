/**
 * Live map, reports and the citizens' ward figures, end to end with a frozen clock: who sees
 * whom on the live map, the ward-day and staff-day reports after the day is closed and rolled
 * up, and the public ward endpoints (no sign-in, counts only).
 */
import { randomUUID } from 'node:crypto';
import { AttendanceJobsService } from '../src/modules/attendance/attendance-jobs.service';
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

const DAY = '2026-11-02';
const INSIDE = { latitude: 16.855, longitude: 74.585 };

describe('live map, reports and public ward figures (e2e)', () => {
  const clock = new FixedClock('2026-11-02T00:40:00Z'); // 06:10 IST, shifts 06:00-14:00
  let t: TestApp;
  let http: TestApp['http'];
  let w1: string;
  let w2: string;
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};

  const get = (who: string | null, path: string) => {
    const req = http.get(`/api/v1/${path}`);
    return who ? req.set('Authorization', tok[who]) : req;
  };
  const checkIn = async (who: string, subject?: string) => {
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
        ...INSIDE,
        accuracyM: 10,
        faceImageBase64: Buffer.from('face').toString('base64'),
      })
      .expect(200);
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
    w1 = await insertWard(t.dataSource, 'R1');
    w2 = await insertWard(t.dataSource, 'R2');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['WI2', Role.WARD_INSPECTOR, w2, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
      ['WK2', Role.WORKER, w1, 'IN1'],
      ['WK3', Role.WORKER, w1, 'IN1'], // placed but never turns up
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `R-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
        createdAt: new Date('2026-10-01T00:00:00Z'),
      });
      tok[key] = await bearerFor(http, `R-${key}`);
    }
    for (const body of [
      { date: DAY, staffId: s.IN1.id, wardId: w1 },
      ...['WK1', 'WK2', 'WK3'].map((k) => ({ date: DAY, staffId: s[k].id, inspectorId: s.IN1.id })),
    ]) {
      await http.post('/api/v1/assignments').set('Authorization', tok.WI1).send(body).expect(201);
    }
    await checkIn('WK1');
    await checkIn('IN1', 'WK2'); // proxy, no phone pings afterwards
    clock.set('2026-11-02T00:45:00Z');
    await http
      .post('/api/v1/attendance/pings')
      .set('Authorization', tok.WK1)
      .send({
        pings: [
          {
            clientUuid: randomUUID(),
            latitude: 16.856,
            longitude: 74.585,
            accuracyM: 8,
            recordedAt: clock.now().toISOString(),
          },
        ],
      })
      .expect(200);
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('live map', () => {
    it('shows each checked-in field worker with their latest position and state', async () => {
      clock.set('2026-11-02T00:50:00Z');
      const res = await get('ADM', 'live/positions').expect(200);
      const byStaff = new Map(res.body.items.map((i: { staffId: string }) => [i.staffId, i]));
      expect(byStaff.size).toBe(2);
      expect(byStaff.get(s.WK1.id)).toMatchObject({
        state: 'ACTIVE',
        latitude: 16.856,
        wardId: w1,
      });
      expect(byStaff.get(s.WK2.id)).toMatchObject({
        state: 'NO_SIGNAL',
        latitude: INSIDE.latitude,
      });
    });

    it('limits each supervisor to their scope', async () => {
      expect((await get('WI1', 'live/positions').expect(200)).body.items).toHaveLength(2);
      expect((await get('WI2', 'live/positions').expect(200)).body.items).toHaveLength(0);
      await get('WI2', `live/positions?wardId=${w1}`).expect(403);
      expect((await get('ADM', `live/positions?wardId=${w2}`).expect(200)).body.items).toHaveLength(
        0,
      );
      expect((await get('IN1', 'live/positions').expect(200)).body.items).toHaveLength(2);
      await get('WK1', 'live/positions').expect(403);
      await get(null, 'live/positions').expect(401);
    });

    it('turns stale, then silent, as the phone stays quiet', async () => {
      clock.set('2026-11-02T01:05:00Z'); // 20 min after the last ping
      let res = await get('ADM', 'live/positions').expect(200);
      expect(res.body.items.find((i: { staffId: string }) => i.staffId === s.WK1.id).state).toBe(
        'STALE',
      );
      clock.set('2026-11-02T01:20:00Z'); // 35 min
      res = await get('ADM', 'live/positions').expect(200);
      expect(res.body.items.find((i: { staffId: string }) => i.staffId === s.WK1.id).state).toBe(
        'SILENT',
      );
    });
  });

  describe('reports', () => {
    beforeAll(async () => {
      // The next night: the day is closed (WK3 absent) and rolled up.
      clock.set('2026-11-02T20:00:00Z'); // 01:30 IST on 3 Nov
      const jobs = t.app.get(AttendanceJobsService);
      await jobs.autoCheckout();
      await jobs.closeDays();
      await jobs.rollUp();
    });

    it('gives the ward-day summary for the ward', async () => {
      const res = await get('WI1', `reports/ward-days?from=${DAY}&to=${DAY}`).expect(200);
      expect(res.body.items).toHaveLength(1);
      expect(res.body.items[0]).toMatchObject({
        date: DAY,
        wardId: w1,
        assignedCount: 4,
        presentCount: 2,
        absentCount: 2, // WK3 and the inspector
        proxyCount: 1,
      });
      expect(
        (await get('ADM', `reports/ward-days?from=${DAY}&to=${DAY}`).expect(200)).body.items.length,
      ).toBeGreaterThanOrEqual(1);
    });

    it('totals each person over the range, most late days first', async () => {
      const res = await get('ADM', `reports/staff-days?from=${DAY}&to=${DAY}&wardId=${w1}`).expect(
        200,
      );
      const row = (key: string) =>
        res.body.items.find((r: { staffId: string }) => r.staffId === s[key].id);
      expect(row('WK1')).toMatchObject({ days: 1, present: 1, absent: 0, autoCheckout: 1 });
      expect(row('WK3')).toMatchObject({ days: 1, present: 0, absent: 1 });
      expect(row('WI1')).toMatchObject({ absent: 1 }); // ward inspectors are expected in their ward
      expect(res.body.total).toBe(5);
    });

    it('refuses bad ranges and other wards', async () => {
      const bad = await get('ADM', 'reports/ward-days?from=2026-11-02&to=2026-11-01').expect(422);
      expect(bad.body.details.problem).toBe('FROM_AFTER_TO');
      await get('ADM', 'reports/ward-days?from=2026-01-01&to=2026-11-02').expect(422);
      await get('WI2', `reports/staff-days?from=${DAY}&to=${DAY}&wardId=${w1}`).expect(403);
      await get('IN1', `reports/ward-days?from=${DAY}&to=${DAY}`).expect(403);
      await get('ADM', 'reports/ward-days?from=2026-11-02').expect(400);
    });
  });

  describe('muster roll', () => {
    const muster = (who: string, query: string) =>
      http
        .get(`/api/v1/reports/muster-roll?${query}`)
        .set('Authorization', tok[who])
        .buffer(true)
        .parse((res, cb) => {
          const chunks: Buffer[] = [];
          res.on('data', (c: Buffer) => chunks.push(c));
          res.on('end', () => cb(null, Buffer.concat(chunks)));
        });

    it('gives a ward month as CSV with a code per day and totals', async () => {
      const res = await muster('WI1', 'month=2026-11').expect(200);
      expect(res.headers['content-type']).toContain('text/csv');
      expect(res.headers['content-disposition']).toContain('muster-roll_R1_2026-11.csv');
      const text = (res.body as Buffer).toString('utf8');
      expect(text.charCodeAt(0)).toBe(0xfeff);
      const line = (code: string) =>
        text
          .split(/\r\n/)
          .find((l) => l.startsWith(code))!
          .split(',');
      // Columns: code, name, role, 30 days, then totals. 2 Nov is the 4th day column.
      // WK1 was auto-checked-out at the last ping, five minutes in: a half day.
      expect(line('R-WK1')[3 + 1]).toBe('H');
      expect(line('R-WK3')[3 + 1]).toBe('A');
      expect(line('R-WK3').slice(-4)).toEqual(['0', '1', '0', '0']);
    });

    it('prints a PDF and refuses bad requests', async () => {
      const pdf = await muster('ADM', `month=2026-11&wardId=${w1}&format=pdf`).expect(200);
      expect(pdf.headers['content-type']).toBe('application/pdf');
      expect((pdf.body as Buffer).subarray(0, 5).toString()).toBe('%PDF-');
      await muster('ADM', 'month=2026-11').expect(400); // admins choose a ward
      await muster('WI2', `month=2026-11&wardId=${w1}`).expect(403);
      await muster('WI1', 'month=2027-01').expect(422);
      await muster('WI1', 'month=2026-13').expect(400);
      await muster('IN1', 'month=2026-11').expect(403);
    });
  });

  describe('public ward figures', () => {
    it('lists wards and shows counts only, without signing in', async () => {
      const wards = await get(null, 'public/wards').expect(200);
      expect(wards.body.map((w: { code: string }) => w.code)).toEqual(
        expect.arrayContaining(['R1', 'R2']),
      );
      expect(wards.body[0]).toHaveProperty('boundary');
      expect(wards.body[0]).not.toHaveProperty('version');

      const res = await get(null, `public/wards/${w1}/attendance`).expect(200);
      expect(res.body.days[0]).toEqual({
        date: DAY,
        assignedCount: 4,
        presentCount: 2,
        onLeaveCount: 0,
      });
      expect(JSON.stringify(res.body)).not.toContain(s.WK1.id);
      await get(null, `public/wards/${randomUUID()}/attendance`).expect(404);
    });
  });
});
