/**
 * Co-presence for proxy punches (rolling QR) and the offline tile endpoints, end to end.
 */
import { randomUUID } from 'node:crypto';
import { presenceCode, windowAt } from '../src/modules/attendance/copresence.policy';
import {
  FaceCaptureOptions,
  FaceVerificationResult,
  FaceVerifier,
} from '../src/modules/face/face-verifier';
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
    return { provider: 'local', matched: true, score: 0.9, threshold: 0.5 };
  }
}

const DAY = '2026-11-02';
const INSIDE = { latitude: 16.855, longitude: 74.585 };

describe('co-presence and tiles (e2e)', () => {
  const clock = new FixedClock('2026-11-02T00:40:00Z');
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  const as = (who: string) => ({ Authorization: tok[who] });

  const proxyCheckIn = async (worker: string, presenceCode?: string) => {
    const challenge = await http
      .post('/api/v1/attendance/challenges')
      .set(as('IN1'))
      .send({ staffId: s[worker].id })
      .expect(201);
    return http
      .post('/api/v1/attendance/punches')
      .set(as('IN1'))
      .send({
        clientUuid: randomUUID(),
        type: 'CHECK_IN',
        staffId: s[worker].id,
        challengeId: challenge.body.challengeId,
        ...INSIDE,
        accuracyM: 10,
        faceImageBase64: Buffer.from('face').toString('base64'),
        ...(presenceCode ? { presenceCode } : {}),
      });
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
    jest.spyOn(t.app.get(AppConfig), 'copresenceRequired', 'get').mockReturnValue(true);
    const w1 = await insertWard(t.dataSource, 'Q1');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['WI1', Role.WARD_INSPECTOR, w1, null],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `Q-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `Q-${key}`);
    }
    for (const body of [
      { date: DAY, staffId: s.IN1.id, wardId: w1 },
      { date: DAY, staffId: s.WK1.id, inspectorId: s.IN1.id },
    ]) {
      await http.post('/api/v1/assignments').set(as('WI1')).send(body).expect(201);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it("refuses a proxy punch without, or with a wrong, worker's code; accepts the right one", async () => {
    const key = await http.get('/api/v1/attendance/presence-key').set(as('WK1')).expect(200);
    expect(key.body).toMatchObject({ periodSeconds: 30, digits: 6 });
    await http.get('/api/v1/attendance/presence-key').set(as('WI1')).expect(403);

    const missing = await proxyCheckIn('WK1');
    expect(missing.status).toBe(422);
    expect(missing.body).toMatchObject({
      code: 'COPRESENCE_FAILED',
      details: { reason: 'MISSING' },
    });
    const wrong = await proxyCheckIn('WK1', '000000');
    expect(wrong.status).toBe(422);
    expect(wrong.body.details.reason).toBe('WRONG');

    // What the worker's phone shows right now, from the key it was given.
    const code = presenceCode(Buffer.from(key.body.key, 'base64'), windowAt(clock.now()));
    const ok = await proxyCheckIn('WK1', code);
    expect(ok.status).toBe(200);
    expect(ok.body.attendance.checkin.mode).toBe('INSPECTOR_PROXY');
  });

  it('answers the tile manifest without a pack, and 404 for tiles', async () => {
    const manifest = await http.get('/api/v1/tiles/manifest').expect(200);
    expect(manifest.body).toMatchObject({
      available: false,
      attribution: '© OpenStreetMap contributors',
    });
    await http.get('/api/v1/tiles/16/46335/30244.png').expect(404);
    await http.get('/api/v1/tiles/2/9/0.png').expect(404);
  });
});
