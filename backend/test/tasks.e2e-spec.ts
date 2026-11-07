/**
 * Field tasks through the API: assignment down the hierarchy, the status machine, retry-safe
 * phone updates and scope.
 */
import { randomUUID } from 'node:crypto';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

describe('tasks (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    const w1 = await insertWard(t.dataSource, 'T1');
    const w2 = await insertWard(t.dataSource, 'T2');
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
        employeeCode: `T-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `T-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  const create = (who: string, assignee: string, extra: Record<string, unknown> = {}) =>
    http
      .post('/api/v1/tasks')
      .set('Authorization', tok[who])
      .send({ title: 'Clear the blocked drain', assignedToId: s[assignee].id, ...extra });
  const phone = (who: string, id: string, body: Record<string, unknown>) =>
    http
      .post(`/api/v1/tasks/${id}/updates`)
      .set('Authorization', tok[who])
      .send({ clientUuid: randomUUID(), ...body });
  const review = (who: string, id: string, body: Record<string, unknown>) =>
    http.post(`/api/v1/tasks/${id}/review`).set('Authorization', tok[who]).send(body);

  describe('assignment', () => {
    it.each<[string, string, number]>([
      ['IN1', 'WK1', 201],
      ['IN1', 'WK2', 422],
      ['WI1', 'IN2', 201],
      ['WI2', 'WK1', 422],
      ['ADM', 'WI2', 201],
      ['WK1', 'WK2', 403],
    ])('%s assigning to %s -> %s', async (who, assignee, status) => {
      await create(who, assignee).expect(status);
    });

    it('takes the ward from the assignee and refuses a past due time', async () => {
      const res = await create('IN1', 'WK1', {
        priority: 'URGENT',
        locationLat: 16.85,
        locationLng: 74.58,
      }).expect(201);
      expect(res.body).toMatchObject({
        status: 'OPEN',
        priority: 'URGENT',
        wardId: s.WK1.homeWardId,
        locationLat: 16.85,
      });
      await create('IN1', 'WK1', { dueAt: '2020-01-01T00:00:00.000Z' }).expect(422);
    });
  });

  describe('life cycle', () => {
    let id: string;

    beforeAll(async () => {
      id = (await create('IN1', 'WK1').expect(201)).body.id;
    });

    it('the assignee starts it; a retry of the same update changes nothing', async () => {
      const clientUuid = randomUUID();
      const first = await phone('WK1', id, {
        clientUuid,
        action: 'START',
        lat: 16.85,
        lng: 74.58,
      }).expect(200);
      expect(first.body).toMatchObject({ status: 'IN_PROGRESS', version: 2 });
      expect(first.body.startedAt).not.toBeNull();
      const retry = await phone('WK1', id, { clientUuid, action: 'START' }).expect(200);
      expect(retry.body.version).toBe(2);
    });

    it('only the assignee updates from the phone; submit needs a note or photo', async () => {
      await phone('WK2', id, { action: 'SUBMIT', note: 'done' }).expect(404);
      await phone('IN1', id, { action: 'SUBMIT', note: 'done' }).expect(403);
      await phone('WK1', id, { action: 'SUBMIT' }).expect(422);
      const res = await phone('WK1', id, {
        action: 'SUBMIT',
        note: 'Drain cleared, water flowing.',
      }).expect(200);
      expect(res.body).toMatchObject({
        status: 'SUBMITTED',
        completionNote: 'Drain cleared, water flowing.',
      });
    });

    it('the supervisor rejects with a reason; the worker restarts and resubmits', async () => {
      await review('IN1', id, { expectedVersion: 3, action: 'REJECT' }).expect(422);
      await review('IN2', id, { expectedVersion: 3, action: 'APPROVE' }).expect(404);
      const rejected = await review('IN1', id, {
        expectedVersion: 3,
        action: 'REJECT',
        reason: 'Silt still there',
      }).expect(200);
      expect(rejected.body).toMatchObject({
        status: 'REJECTED',
        rejectionCount: 1,
        rejectionReason: 'Silt still there',
      });
      await phone('WK1', id, { action: 'START' }).expect(200);
      // The photo goes up first (POST /uploads); only the uploader's own key is accepted.
      const jpeg = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46]);
      const photo = await http
        .post('/api/v1/uploads')
        .set('Authorization', tok.WK1)
        .field('clientUuid', randomUUID())
        .field('kind', 'TASK_PHOTO')
        .attach('file', jpeg, { filename: 'after.jpg', contentType: 'image/jpeg' })
        .expect(201);
      await phone('WK1', id, { action: 'SUBMIT', photoKey: randomUUID() }).expect(400);
      await phone('WK1', id, { action: 'SUBMIT', photoKey: photo.body.id }).expect(200);
    });

    it('stale versions are refused; the ward inspector approves and closes', async () => {
      await review('WI1', id, { expectedVersion: 3, action: 'APPROVE' }).expect(409);
      const approved = await review('WI1', id, { expectedVersion: 6, action: 'APPROVE' }).expect(
        200,
      );
      expect(approved.body.status).toBe('APPROVED');
      await review('WI1', id, { expectedVersion: 7, action: 'ESCALATE' }).expect(422);
      const closed = await review('WI1', id, { expectedVersion: 7, action: 'CLOSE' }).expect(200);
      expect(closed.body.closedAt).not.toBeNull();
    });

    it('keeps the full history', async () => {
      const res = await http
        .get(`/api/v1/tasks/${id}/history`)
        .set('Authorization', tok.WK1)
        .expect(200);
      expect(res.body.map((u: { toStatus: string }) => u.toStatus)).toEqual([
        'IN_PROGRESS',
        'SUBMITTED',
        'REJECTED',
        'IN_PROGRESS',
        'SUBMITTED',
        'APPROVED',
        'CLOSED',
      ]);
    });
  });

  it('reassigns an unfinished task within scope', async () => {
    const id = (await create('WI1', 'WK1').expect(201)).body.id;
    await phone('WK1', id, { action: 'START' }).expect(200);
    const res = await http
      .post(`/api/v1/tasks/${id}/reassign`)
      .set('Authorization', tok.WI1)
      .send({ expectedVersion: 2, assignedToId: s.WK2.id })
      .expect(200);
    expect(res.body).toMatchObject({ status: 'OPEN', assignedToId: s.WK2.id, startedAt: null });
    await http
      .post(`/api/v1/tasks/${id}/reassign`)
      .set('Authorization', tok.WI2)
      .send({ expectedVersion: 3, assignedToId: s.WK1.id })
      .expect(404);
  });

  it('lists by scope', async () => {
    const ids = async (who: string) =>
      (
        (await http.get('/api/v1/tasks?pageSize=200').set('Authorization', tok[who]).expect(200))
          .body.items as { assignedToId: string }[]
      ).map((x) => x.assignedToId);
    expect((await ids('WK1')).every((a) => a === s.WK1.id)).toBe(true);
    expect((await ids('IN2')).every((a) => a === s.WK2.id || a === s.IN2.id)).toBe(true);
    // Ward 2's only task is the one the admin gave its ward inspector.
    expect(await ids('WI2')).toEqual([s.WI2.id]);
    await http
      .get(`/api/v1/tasks?assignedToId=${s.WK2.id}`)
      .set('Authorization', tok.WK1)
      .expect(403);
  });
});
