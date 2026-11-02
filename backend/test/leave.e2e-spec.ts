/**
 * Leave and regularization requests through the API: self-service, line-manager review, scope.
 */
import { randomUUID } from 'node:crypto';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { istDate } from '../src/shared/clock/ist';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

describe('leave and regularization (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  const day = (offset: number) => istDate(new Date(Date.now() + offset * 86_400_000));

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    const w1 = await insertWard(t.dataSource, 'L1');
    const w2 = await insertWard(t.dataSource, 'L2');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['WI2', Role.WARD_INSPECTOR, w2, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['IN2', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
      ['WK2', Role.WORKER, w1, 'IN2'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `L-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `L-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  const ask = (who: string, body: Record<string, unknown>) =>
    http.post('/api/v1/leave').set('Authorization', tok[who]).send(body);

  describe('leave', () => {
    let leaveId: string;
    const uuid = randomUUID();

    it('a worker asks for leave; a retry returns the same request', async () => {
      const body = {
        clientUuid: uuid,
        leaveType: 'CASUAL',
        fromDate: day(3),
        toDate: day(4),
        reason: 'Family function',
      };
      const res = await ask('WK1', body).expect(201);
      expect(res.body).toMatchObject({
        status: 'PENDING',
        daysCount: 2,
        staffId: s.WK1.id,
        version: 1,
      });
      leaveId = res.body.id;
      expect((await ask('WK1', body).expect(201)).body.id).toBe(leaveId);
    });

    it.each<[string, () => Record<string, unknown>, number, string]>([
      [
        'overlapping leave',
        () => ({ leaveType: 'EARNED', fromDate: day(4), toDate: day(6) }),
        409,
        'LEAVE_OVERLAP',
      ],
      [
        'casual leave in the past',
        () => ({ leaveType: 'CASUAL', fromDate: day(-1), toDate: day(0) }),
        422,
        'RULE_VIOLATION',
      ],
      [
        'more than 31 days',
        () => ({ leaveType: 'EARNED', fromDate: day(10), toDate: day(41) }),
        422,
        'RULE_VIOLATION',
      ],
    ])('refuses %s', async (_label, body, status, code) => {
      expect((await ask('WK1', body()).expect(status)).body.code).toBe(code);
    });

    it('accepts back-dated sick leave', async () => {
      await ask('WK1', { leaveType: 'SICK', fromDate: day(-3), toDate: day(-2) }).expect(201);
    });

    it("only the worker's own inspector (or the ward inspector) sees and reviews it", async () => {
      await http.get(`/api/v1/leave/${leaveId}`).set('Authorization', tok.IN2).expect(404);
      await http.get(`/api/v1/leave/${leaveId}`).set('Authorization', tok.WK2).expect(404);
      await http.get(`/api/v1/leave/${leaveId}`).set('Authorization', tok.WI2).expect(404);
      await http
        .post(`/api/v1/leave/${leaveId}/review`)
        .set('Authorization', tok.IN2)
        .send({ expectedVersion: 1, decision: 'APPROVED' })
        .expect(404);
      await http
        .post(`/api/v1/leave/${leaveId}/review`)
        .set('Authorization', tok.WK1)
        .send({ expectedVersion: 1, decision: 'APPROVED' })
        .expect(403);
      const ok = await http
        .post(`/api/v1/leave/${leaveId}/review`)
        .set('Authorization', tok.IN1)
        .send({ expectedVersion: 1, decision: 'APPROVED', note: 'OK' })
        .expect(200);
      expect(ok.body).toMatchObject({
        status: 'APPROVED',
        reviewedById: s.IN1.id,
        reviewNote: 'OK',
        version: 2,
      });
    });

    it('a decided request is not reviewed twice, but approved future leave can be withdrawn', async () => {
      await http
        .post(`/api/v1/leave/${leaveId}/review`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 2, decision: 'REJECTED' })
        .expect(422);
      await http
        .post(`/api/v1/leave/${leaveId}/cancel`)
        .set('Authorization', tok.IN1)
        .send({ expectedVersion: 2 })
        .expect(403);
      const res = await http
        .post(`/api/v1/leave/${leaveId}/cancel`)
        .set('Authorization', tok.WK1)
        .send({ expectedVersion: 2 })
        .expect(200);
      expect(res.body.status).toBe('CANCELLED');
    });

    it('lists follow scope: inspector sees direct reports, ward inspector the ward, worker only self', async () => {
      await ask('WK2', { leaveType: 'CASUAL', fromDate: day(8), toDate: day(8) }).expect(201);
      const count = async (who: string) =>
        (await http.get('/api/v1/leave').set('Authorization', tok[who]).expect(200)).body
          .total as number;
      expect(await count('IN1')).toBe(2); // WK1's two requests
      expect(await count('IN2')).toBe(1); // WK2's
      expect(await count('WI1')).toBe(3);
      expect(await count('WI2')).toBe(0);
      expect(await count('WK2')).toBe(1);
      expect(await count('ADM')).toBe(3);
      await http.get(`/api/v1/leave?staffId=${s.WK1.id}`).set('Authorization', tok.WK2).expect(403);
    });
  });

  describe('regularization', () => {
    let regId: string;

    it('a worker asks to regularize yesterday; a second open request for that day is refused', async () => {
      const body = {
        attendanceDate: day(-1),
        reasonType: 'BATTERY_DEAD',
        explanation: 'Battery died at 07:10, worked full shift.',
      };
      const res = await http
        .post('/api/v1/regularizations')
        .set('Authorization', tok.WK1)
        .send(body)
        .expect(201);
      expect(res.body).toMatchObject({ status: 'PENDING', attendanceDate: day(-1) });
      regId = res.body.id;
      const dup = await http
        .post('/api/v1/regularizations')
        .set('Authorization', tok.WK1)
        .send(body)
        .expect(409);
      expect(dup.body.code).toBe('REGULARIZATION_EXISTS');
    });

    it.each<[string, () => string]>([
      ['today', () => day(0)],
      ['8 days back', () => day(-8)],
    ])('refuses %s', async (_label, date) => {
      await http
        .post('/api/v1/regularizations')
        .set('Authorization', tok.WK2)
        .send({
          attendanceDate: date(),
          reasonType: 'OTHER',
          explanation: 'Forgot to punch in the morning.',
        })
        .expect(422);
    });

    it('the ward inspector approves; it can no longer be withdrawn', async () => {
      const ok = await http
        .post(`/api/v1/regularizations/${regId}/review`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 1, decision: 'APPROVED' })
        .expect(200);
      expect(ok.body).toMatchObject({ status: 'APPROVED', reviewedById: s.WI1.id });
      await http
        .post(`/api/v1/regularizations/${regId}/cancel`)
        .set('Authorization', tok.WK1)
        .send({ expectedVersion: 2 })
        .expect(422);
    });
  });
});
