/**
 * Standing squads and daily assignments through the API (v4 §3), against the real test database.
 */
import { randomUUID } from 'node:crypto';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { istDate } from '../src/shared/clock/ist';
import {
  bearerFor,
  createTestApp,
  seedStaff,
  SQUARE_BOUNDARY as boundary,
  TestApp,
} from './helpers';

describe('rosters and assignments (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;
  let w1: string;
  let w2: string;
  const s: Record<string, Staff> = {};
  const tokens: Record<string, string> = {};
  const today = istDate(new Date());
  const tomorrow = istDate(new Date(Date.now() + 86_400_000));
  const yesterday = istDate(new Date(Date.now() - 86_400_000));

  const as = (who: string) => tokens[who];

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'R-ADMIN' });
    admin = await bearerFor(http, 'R-ADMIN');
    const ward = async (code: string) =>
      (
        await http
          .post('/api/v1/wards')
          .set('Authorization', admin)
          .send({ code, name: `Ward ${code}`, nameMr: `प्रभाग ${code}`, zone: 'MIRAJ', boundary })
          .expect(201)
      ).body.id as string;
    w1 = await ward('R1');
    w2 = await ward('R2');
    const people: [string, StaffRole, string][] = [
      ['WI1', Role.WARD_INSPECTOR, w1],
      ['WI2', Role.WARD_INSPECTOR, w2],
      ['IN1', Role.INSPECTOR, w1],
      ['IN2', Role.INSPECTOR, w1],
      ['IN3', Role.INSPECTOR, w2],
      ['WK1', Role.WORKER, w1],
      ['WK2', Role.WORKER, w1],
      ['WK3', Role.WORKER, w2],
    ];
    for (const [key, role, homeWardId] of people) {
      s[key] = await seedStaff(t.dataSource, { role, employeeCode: `R-${key}`, homeWardId });
      tokens[key] = await bearerFor(http, `R-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('standing squads', () => {
    const squad = (workerId: string, inspectorId: string, auth = admin) =>
      http
        .post('/api/v1/rosters/standing')
        .set('Authorization', auth)
        .send({ workerId, inspectorId });

    it('takes the ward and ward inspector from the inspector', async () => {
      const res = await squad(s.WK1.id, s.IN1.id).expect(201);
      expect(res.body).toMatchObject({
        wardId: w1,
        wardInspectorId: s.WI1.id,
        inspectorId: s.IN1.id,
        isActive: true,
        version: 1,
      });
    });

    it('lets a ward inspector build squads in their own ward only', async () => {
      await squad(s.WK2.id, s.IN1.id, as('WI2')).expect(403);
      await squad(s.WK2.id, s.IN1.id, as('WI1')).expect(201);
    });

    it.each<[string, () => [string, string], number, string]>([
      ['a worker already in a squad', () => [s.WK1.id, s.IN2.id], 409, 'ROSTER_WORKER_TAKEN'],
      ['a cross-ward pair', () => [s.WK3.id, s.IN1.id], 422, 'RULE_VIOLATION'],
      ['an inspector as the worker', () => [s.IN2.id, s.IN1.id], 422, 'RULE_VIOLATION'],
    ])('refuses %s', async (_label, pair, status, code) => {
      const [workerId, inspectorId] = pair();
      expect((await squad(workerId, inspectorId).expect(status)).body.code).toBe(code);
    });

    it('shows an inspector only their own squad, and no squads to workers', async () => {
      const res = await http
        .get('/api/v1/rosters/standing')
        .set('Authorization', as('IN1'))
        .expect(200);
      expect(res.body.items.map((r: { workerId: string }) => r.workerId).sort()).toEqual(
        [s.WK1.id, s.WK2.id].sort(),
      );
      await http
        .get('/api/v1/rosters/standing')
        .set('Authorization', as('IN2'))
        .expect(200, /"total":0/);
      await http.get('/api/v1/rosters/standing').set('Authorization', as('WK1')).expect(403);
    });

    it('moves a worker between inspectors with optimistic locking', async () => {
      const list = await http
        .get(`/api/v1/rosters/standing?inspectorId=${s.IN1.id}`)
        .set('Authorization', admin)
        .expect(200);
      const row = list.body.items.find((r: { workerId: string }) => r.workerId === s.WK2.id);
      const moved = await http
        .patch(`/api/v1/rosters/standing/${row.id}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 1, inspectorId: s.IN2.id })
        .expect(200);
      expect(moved.body).toMatchObject({ inspectorId: s.IN2.id, version: 2 });
      await http
        .patch(`/api/v1/rosters/standing/${row.id}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 1, inspectorId: s.IN1.id })
        .expect(409);
    });
  });

  describe('generating a day from standing squads', () => {
    it('creates approved rows once and is safe to repeat', async () => {
      const first = await http
        .post('/api/v1/assignments/generate')
        .set('Authorization', admin)
        .send({ date: today })
        .expect(200);
      // IN1 + WK1, IN2 + WK2
      expect(first.body).toEqual({ date: today, created: 4 });
      const again = await http
        .post('/api/v1/assignments/generate')
        .set('Authorization', admin)
        .send({ date: today })
        .expect(200);
      expect(again.body.created).toBe(0);
      const rows = await http
        .get(`/api/v1/assignments?date=${today}`)
        .set('Authorization', admin)
        .expect(200);
      expect(
        rows.body.items.every(
          (a: { isApproved: boolean; assignmentMode: string }) =>
            a.isApproved && a.assignmentMode === 'STANDING_ROSTER',
        ),
      ).toBe(true);
    });

    it('refuses a past date', async () => {
      await http
        .post('/api/v1/assignments/generate')
        .set('Authorization', admin)
        .send({ date: yesterday })
        .expect(422);
    });
  });

  describe('scoped lists', () => {
    const count = async (who: string) =>
      (
        await http
          .get(`/api/v1/assignments?date=${today}`)
          .set('Authorization', as(who))
          .expect(200)
      ).body.total as number;

    it('ward inspector: own ward; inspector: own team; worker: self', async () => {
      expect(await count('WI1')).toBe(4);
      expect(await count('WI2')).toBe(0);
      expect(await count('IN1')).toBe(2);
      expect(await count('WK1')).toBe(1);
      await http
        .get(`/api/v1/assignments?date=${today}&wardId=${w2}`)
        .set('Authorization', as('WI1'))
        .expect(403);
    });
  });

  describe('self-service and approval', () => {
    let pickId: string;
    let joinId: string;
    const pickUuid = randomUUID();

    it('an inspector self-picks a ward: unapproved, and a retry returns the same row', async () => {
      const body = { clientUuid: pickUuid, date: today, wardId: w2 };
      const res = await http
        .post('/api/v1/assignments/self')
        .set('Authorization', as('IN3'))
        .send(body)
        .expect(201);
      expect(res.body).toMatchObject({
        staffRole: 'INSPECTOR',
        wardId: w2,
        assignmentMode: 'INSPECTOR_SELF_PICK',
        isApproved: false,
      });
      pickId = res.body.id;
      const retry = await http
        .post('/api/v1/assignments/self')
        .set('Authorization', as('IN3'))
        .send(body)
        .expect(201);
      expect(retry.body.id).toBe(pickId);
    });

    it("a worker self-joins that inspector's team", async () => {
      const res = await http
        .post('/api/v1/assignments/self')
        .set('Authorization', as('WK3'))
        .send({ clientUuid: randomUUID(), date: today, inspectorId: s.IN3.id })
        .expect(201);
      expect(res.body).toMatchObject({
        staffRole: 'WORKER',
        wardId: w2,
        inspectorId: s.IN3.id,
        assignmentMode: 'WORKER_SELF_JOIN',
        isApproved: false,
      });
      joinId = res.body.id;
    });

    it('refuses self-service more than a day ahead, and for ward inspectors', async () => {
      const later = istDate(new Date(Date.now() + 3 * 86_400_000));
      await http
        .post('/api/v1/assignments/self')
        .set('Authorization', as('IN2'))
        .send({ clientUuid: randomUUID(), date: later, wardId: w1 })
        .expect(422);
      await http
        .post('/api/v1/assignments/self')
        .set('Authorization', as('WI1'))
        .send({ clientUuid: randomUUID(), date: today, wardId: w1 })
        .expect(403);
    });

    it('nobody approves their own row; the right senior does', async () => {
      await http
        .post(`/api/v1/assignments/${pickId}/approve`)
        .set('Authorization', as('IN3'))
        .send({ expectedVersion: 1 })
        .expect(403);
      await http
        .post(`/api/v1/assignments/${pickId}/approve`)
        .set('Authorization', as('WI1'))
        .send({ expectedVersion: 1 })
        .expect(403);
      const ok = await http
        .post(`/api/v1/assignments/${pickId}/approve`)
        .set('Authorization', as('WI2'))
        .send({ expectedVersion: 1 })
        .expect(200);
      expect(ok.body).toMatchObject({ isApproved: true, approvedById: s.WI2.id, version: 2 });
    });

    it('an inspector approves a worker joining their own team', async () => {
      await http
        .post(`/api/v1/assignments/${joinId}/approve`)
        .set('Authorization', as('IN1'))
        .send({ expectedVersion: 1 })
        .expect(403);
      await http
        .post(`/api/v1/assignments/${joinId}/approve`)
        .set('Authorization', as('WK1'))
        .send({ expectedVersion: 1 })
        .expect(403);
      const ok = await http
        .post(`/api/v1/assignments/${joinId}/approve`)
        .set('Authorization', as('IN3'))
        .send({ expectedVersion: 1 })
        .expect(200);
      expect(ok.body.isApproved).toBe(true);
    });
  });

  describe('senior assignments', () => {
    it('a ward inspector places an inspector in their ward, approved at once', async () => {
      const res = await http
        .post('/api/v1/assignments')
        .set('Authorization', as('WI1'))
        .send({ date: tomorrow, staffId: s.IN2.id, wardId: w1 })
        .expect(201);
      expect(res.body).toMatchObject({
        assignmentMode: 'WARD_INSPECTOR_ASSIGNED',
        isApproved: true,
        approvedById: s.WI1.id,
      });
    });

    it.each<[string, () => [string, Record<string, unknown>], number, string]>([
      [
        'another ward',
        () => ['WI1', { date: tomorrow, staffId: s.IN1.id, wardId: w2 }],
        403,
        'FORBIDDEN',
      ],
      [
        'a second placement that day',
        () => ['admin', { date: today, staffId: s.IN1.id, wardId: w1 }],
        409,
        'ASSIGNMENT_EXISTS',
      ],
      [
        'a worker under an unplaced inspector',
        () => ['admin', { date: tomorrow, staffId: s.WK1.id, inspectorId: s.IN1.id }],
        422,
        'RULE_VIOLATION',
      ],
      [
        'a past date',
        () => ['admin', { date: yesterday, staffId: s.IN1.id, wardId: w1 }],
        422,
        'RULE_VIOLATION',
      ],
      [
        'a ward inspector as the person',
        () => ['admin', { date: tomorrow, staffId: s.WI1.id, wardId: w1 }],
        422,
        'RULE_VIOLATION',
      ],
    ])('refuses %s', async (_label, args, status, code) => {
      const [who, body] = args();
      const res = await http
        .post('/api/v1/assignments')
        .set('Authorization', who === 'admin' ? admin : as(who))
        .send(body)
        .expect(status);
      expect(res.body.code).toBe(code);
    });

    it('is not open to inspectors or workers', async () => {
      await http
        .post('/api/v1/assignments')
        .set('Authorization', as('IN1'))
        .send({ date: today, staffId: s.WK1.id })
        .expect(403);
      await http.post('/api/v1/assignments').send({}).expect(401);
    });
  });
});
