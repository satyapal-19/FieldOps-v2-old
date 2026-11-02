/**
 * Citizen complaints: the public portal (no sign-in, no personal data back) and staff routing
 * through tasks, end to end.
 */
import { randomUUID } from 'node:crypto';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

/** A ~1.1 km square starting at the given south-west corner. */
const square = (west: number, south: number) => ({
  type: 'Polygon',
  coordinates: [
    [
      [west, south],
      [west + 0.01, south],
      [west + 0.01, south + 0.01],
      [west, south + 0.01],
      [west, south],
    ],
  ],
});

describe('complaints (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let w1: string;
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  const inWard1 = { lat: 16.855, lng: 74.585 };

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    w1 = await insertWard(t.dataSource, 'C1', square(74.58, 16.85));
    const w2 = await insertWard(t.dataSource, 'C2', square(74.6, 16.85));
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['OFF', Role.OFFICE_STAFF, null, 'ADM'],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['WI2', Role.WARD_INSPECTOR, w2, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      // Office staff need an office for staff rules elsewhere; here only the role matters.
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `C-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `C-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  const file = (body: Record<string, unknown>) => http.post('/api/v1/public/complaints').send(body);

  describe('public portal', () => {
    let trackingId: string;
    const clientUuid = randomUUID();
    const body = {
      clientUuid,
      category: 'GARBAGE',
      description: 'Garbage not collected for three days near the bus stand.',
      citizenName: 'Ramesh Jadhav',
      citizenPhone: '9812345678',
      ...inWard1,
    };

    it('files without sign-in, finds the ward from the location, and returns no personal data', async () => {
      const res = await file(body).expect(201);
      expect(res.body).toMatchObject({
        category: 'GARBAGE',
        status: 'RECEIVED',
        wardCode: 'C1',
        resolvedAt: null,
      });
      expect(res.body.trackingId).toMatch(/^SMK-\d{4}-[A-HJ-NP-Z2-9]{6}$/);
      expect(JSON.stringify(res.body)).not.toMatch(/Ramesh|9812345678|16\.855/);
      trackingId = res.body.trackingId;
    });

    it('a double-submitted form returns the same tracking ID', async () => {
      expect((await file(body).expect(201)).body.trackingId).toBe(trackingId);
    });

    it('tracks by ID, forgiving case and spaces', async () => {
      const res = await http
        .get(`/api/v1/public/complaints/${encodeURIComponent(` ${trackingId.toLowerCase()} `)}`)
        .expect(200);
      expect(res.body.trackingId).toBe(trackingId);
      await http.get('/api/v1/public/complaints/SMK-2026-ZZZZZZ').expect(404);
      await http.get('/api/v1/public/complaints/not-an-id').expect(404);
    });

    it.each<[string, Record<string, unknown>, number]>([
      [
        'a latitude without a longitude',
        { category: 'ROAD', description: 'Pothole in the main road.', lat: 16.85 },
        400,
      ],
      ['a too-short description', { category: 'ROAD', description: 'hole' }, 400],
      [
        'a landline as phone',
        { category: 'ROAD', description: 'Pothole in the main road.', citizenPhone: '0233234567' },
        400,
      ],
      [
        'an unknown category',
        { category: 'NOISE', description: 'Loud music every night here.' },
        400,
      ],
    ])('refuses %s', async (_label, b, status) => {
      await file(b).expect(status);
    });
  });

  describe('staff routing', () => {
    let id: string;
    let trackingId: string;

    beforeAll(async () => {
      const res = await file({
        category: 'DRAIN',
        description: 'Drain overflowing onto the street.',
        citizenPhone: '9876543210',
        ...inWard1,
      }).expect(201);
      trackingId = res.body.trackingId;
      const list = await http
        .get('/api/v1/complaints?status=RECEIVED&pageSize=200')
        .set('Authorization', tok.WI1)
        .expect(200);
      id = list.body.items.find((c: { trackingId: string }) => c.trackingId === trackingId).id;
    });

    it('scopes reads and masks the phone for inspectors', async () => {
      const wi = await http
        .get(`/api/v1/complaints/${id}`)
        .set('Authorization', tok.WI1)
        .expect(200);
      expect(wi.body).toMatchObject({ wardId: w1, citizenPhone: '9876543210', tasks: [] });
      const ins = await http
        .get(`/api/v1/complaints/${id}`)
        .set('Authorization', tok.IN1)
        .expect(200);
      expect(ins.body.citizenPhone).toBe('******3210');
      await http.get(`/api/v1/complaints/${id}`).set('Authorization', tok.WI2).expect(404);
      await http.get('/api/v1/complaints').set('Authorization', tok.WK1).expect(403);
      await http.get('/api/v1/complaints').expect(401);
    });

    it('the ward inspector routes it by raising a task', async () => {
      await http
        .post(`/api/v1/complaints/${id}/assign`)
        .set('Authorization', tok.IN1)
        .send({ expectedVersion: 1, assignedToId: s.WK1.id })
        .expect(403);
      const res = await http
        .post(`/api/v1/complaints/${id}/assign`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 1, assignedToId: s.WK1.id, priority: 'URGENT' })
        .expect(200);
      expect(res.body.status).toBe('ASSIGNED');
      expect(res.body.tasks).toHaveLength(1);
      expect(res.body.tasks[0]).toMatchObject({
        complaintId: id,
        assignedToId: s.WK1.id,
        priority: 'URGENT',
        status: 'OPEN',
      });
      await http
        .post(`/api/v1/complaints/${id}/assign`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 1, assignedToId: s.WK1.id })
        .expect(409);
    });

    it('the citizen sees progress; it resolves only after the task is approved', async () => {
      const taskId = (
        await http.get(`/api/v1/complaints/${id}`).set('Authorization', tok.WI1).expect(200)
      ).body.tasks[0].id;
      await http
        .post(`/api/v1/tasks/${taskId}/updates`)
        .set('Authorization', tok.WK1)
        .send({ clientUuid: randomUUID(), action: 'START' })
        .expect(200);
      expect(
        (await http.get(`/api/v1/public/complaints/${trackingId}`).expect(200)).body.status,
      ).toBe('IN_PROGRESS');

      await http
        .post(`/api/v1/complaints/${id}/status`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 2, action: 'RESOLVE' })
        .expect(422);
      await http
        .post(`/api/v1/tasks/${taskId}/updates`)
        .set('Authorization', tok.WK1)
        .send({ clientUuid: randomUUID(), action: 'SUBMIT', note: 'Drain cleared.' })
        .expect(200);
      await http
        .post(`/api/v1/tasks/${taskId}/review`)
        .set('Authorization', tok.IN1)
        .send({ expectedVersion: 3, action: 'APPROVE' })
        .expect(200);

      const resolved = await http
        .post(`/api/v1/complaints/${id}/status`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 2, action: 'RESOLVE' })
        .expect(200);
      expect(resolved.body.status).toBe('RESOLVED');
      expect(resolved.body.resolvedAt).not.toBeNull();
      const pub = await http.get(`/api/v1/public/complaints/${trackingId}`).expect(200);
      expect(pub.body).toMatchObject({ status: 'RESOLVED' });
      await http
        .post(`/api/v1/complaints/${id}/status`)
        .set('Authorization', tok.WI1)
        .send({ expectedVersion: 3, action: 'CLOSE' })
        .expect(200);
    });
  });

  it('a complaint with no ward waits for the admin, who routes it into a ward', async () => {
    const res = await file({
      category: 'TREE',
      description: 'Fallen tree blocking the lane after rain.',
    }).expect(201);
    expect(res.body.wardCode).toBeNull();
    const queue = await http
      .get('/api/v1/complaints?unrouted=true')
      .set('Authorization', tok.OFF)
      .expect(200);
    const c = queue.body.items.find(
      (x: { trackingId: string }) => x.trackingId === res.body.trackingId,
    );
    await http.get(`/api/v1/complaints/${c.id}`).set('Authorization', tok.WI1).expect(404);
    await http
      .post(`/api/v1/complaints/${c.id}/assign`)
      .set('Authorization', tok.OFF)
      .send({ expectedVersion: 1, assignedToId: s.WI1.id })
      .expect(403);
    const routed = await http
      .post(`/api/v1/complaints/${c.id}/assign`)
      .set('Authorization', tok.ADM)
      .send({ expectedVersion: 1, assignedToId: s.WI1.id })
      .expect(200);
    expect(routed.body.wardId).toBe(w1);
    expect(
      (await http.get(`/api/v1/public/complaints/${res.body.trackingId}`).expect(200)).body
        .wardCode,
    ).toBe('C1');
  });

  it('rejects a received complaint that is not a civic issue', async () => {
    const res = await file({
      category: 'OTHER',
      description: 'My neighbour is very rude to me.',
      ...inWard1,
    }).expect(201);
    const list = await http
      .get('/api/v1/complaints?status=RECEIVED&pageSize=200')
      .set('Authorization', tok.WI1)
      .expect(200);
    const c = list.body.items.find(
      (x: { trackingId: string }) => x.trackingId === res.body.trackingId,
    );
    const rejected = await http
      .post(`/api/v1/complaints/${c.id}/status`)
      .set('Authorization', tok.WI1)
      .send({ expectedVersion: 1, action: 'REJECT' })
      .expect(200);
    expect(rejected.body.status).toBe('REJECTED');
    expect(
      (await http.get(`/api/v1/public/complaints/${res.body.trackingId}`).expect(200)).body.status,
    ).toBe('REJECTED');
  });
});
