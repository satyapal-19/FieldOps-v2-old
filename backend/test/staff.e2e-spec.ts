/**
 * /staff endpoints: admin CRUD with v4 rules, and scoped reads for supervisors.
 */
import { Role } from '../src/shared/auth/roles';
import {
  bearerFor,
  createTestApp,
  seedStaff,
  SQUARE_BOUNDARY as boundary,
  TestApp,
} from './helpers';

describe('staff (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;
  let ward1: string;
  let ward2: string;
  let wardInspectorId: string;
  let inspectorId: string;
  let workerId: string;
  let otherWardWorkerId: string;

  const createWard = async (code: string): Promise<string> =>
    (
      await http
        .post('/api/v1/wards')
        .set('Authorization', admin)
        .send({ code, name: `Ward ${code}`, nameMr: `प्रभाग ${code}`, zone: 'SANGLI', boundary })
        .expect(201)
    ).body.id as string;

  const create = (body: Record<string, unknown>, auth = admin) =>
    http.post('/api/v1/staff').set('Authorization', auth).send(body);

  let phoneSeq = 0;
  const phone = () => `97${String(10_000_000 + ++phoneSeq).slice(-8)}`;

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'S-ADMIN' });
    admin = await bearerFor(http, 'S-ADMIN');
    ward1 = await createWard('S01');
    ward2 = await createWard('S02');

    wardInspectorId = (
      await create({
        employeeCode: 's-wi-01',
        fullName: 'Ward Inspector One',
        phone: phone(),
        role: 'WARD_INSPECTOR',
        homeWardId: ward1,
        initialPassword: 'Ward-Inspector-2026!',
      }).expect(201)
    ).body.id;
    inspectorId = (
      await create({
        employeeCode: 'S-IN-01',
        fullName: 'Inspector One',
        phone: phone(),
        role: 'INSPECTOR',
        homeWardId: ward1,
        reportsToId: wardInspectorId,
      }).expect(201)
    ).body.id;
    workerId = (
      await create({
        employeeCode: 'S-WK-01',
        fullName: 'Worker One',
        fullNameMr: 'कामगार एक',
        phone: `+91 ${phone()}`,
        role: 'WORKER',
        homeWardId: ward1,
        reportsToId: inspectorId,
      }).expect(201)
    ).body.id;
    otherWardWorkerId = (
      await create({
        employeeCode: 'S-WK-02',
        fullName: 'Worker Two',
        phone: phone(),
        role: 'WORKER',
        homeWardId: ward2,
      }).expect(201)
    ).body.id;
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('create (ADMIN)', () => {
    it('normalizes the code and phone, defaults the shift and never returns a password', async () => {
      const res = await http
        .get(`/api/v1/staff/${workerId}`)
        .set('Authorization', admin)
        .expect(200);
      expect(res.body).toMatchObject({
        employeeCode: 'S-WK-01',
        role: 'WORKER',
        homeWardId: ward1,
        reportsToId: inspectorId,
        fullNameMr: 'कामगार एक',
        shiftStart: '06:00',
        shiftEnd: '14:00',
        isActive: true,
        hasPassword: false,
        version: 1,
      });
      expect(res.body.phone).toMatch(/^\d{10}$/);
      expect(res.body).not.toHaveProperty('passwordHash');
    });

    it('stores a password for a web role, signed in with it afterwards', async () => {
      const wi = await http
        .get(`/api/v1/staff/${wardInspectorId}`)
        .set('Authorization', admin)
        .expect(200);
      expect(wi.body.hasPassword).toBe(true);
      await http
        .post('/api/v1/auth/login')
        .send({ identifier: 'S-WI-01', password: 'Ward-Inspector-2026!' })
        .expect(200);
    });

    it('rejects a duplicate employee code as STAFF_IDENTITY_TAKEN', async () => {
      const res = await create({
        employeeCode: 'S-WK-01',
        fullName: 'Copy',
        phone: phone(),
        role: 'WORKER',
        homeWardId: ward1,
      }).expect(409);
      expect(res.body.code).toBe('STAFF_IDENTITY_TAKEN');
    });

    it.each<[string, Record<string, unknown>, number, string]>([
      ['a worker without a ward', { role: 'WORKER' }, 422, 'RULE_VIOLATION'],
      ['office staff without an office', { role: 'OFFICE_STAFF' }, 422, 'RULE_VIOLATION'],
      [
        'a password for a field role',
        { role: 'WORKER', homeWardId: 'W1', initialPassword: 'Field-Worker-2026!' },
        422,
        'RULE_VIOLATION',
      ],
      [
        'a worker reporting to a ward inspector',
        { role: 'WORKER', homeWardId: 'W1', reportsToId: 'WI' },
        422,
        'RULE_VIOLATION',
      ],
      [
        'a worker reporting across wards',
        { role: 'WORKER', homeWardId: 'W2', reportsToId: 'IN' },
        422,
        'RULE_VIOLATION',
      ],
      [
        'an unknown ward',
        { role: 'WORKER', homeWardId: '00000000-0000-4000-8000-000000000000' },
        422,
        'RULE_VIOLATION',
      ],
      [
        'a weak password (letters only)',
        { role: 'ADMIN', initialPassword: 'onlylettershere' },
        422,
        'AUTH_WEAK_PASSWORD',
      ],
      ['a landline number', { role: 'ADMIN', phone: '0233-2345678' }, 400, 'VALIDATION_FAILED'],
      ['a bad shift time', { role: 'ADMIN', shiftStart: '6am' }, 400, 'VALIDATION_FAILED'],
    ])('refuses %s', async (_label, fields, status, code) => {
      const resolved = { ...fields };
      if (resolved.homeWardId === 'W1') resolved.homeWardId = ward1;
      if (resolved.homeWardId === 'W2') resolved.homeWardId = ward2;
      if (resolved.reportsToId === 'WI') resolved.reportsToId = wardInspectorId;
      if (resolved.reportsToId === 'IN') resolved.reportsToId = inspectorId;
      const res = await create({
        employeeCode: `S-BAD-${++phoneSeq}`,
        fullName: 'Bad',
        phone: phone(),
        ...resolved,
      }).expect(status);
      expect(res.body.code).toBe(code);
    });

    it('is ADMIN only', async () => {
      const wi = await bearerFor(http, 'S-WI-01');
      await create(
        {
          employeeCode: 'S-NOPE',
          fullName: 'No',
          phone: phone(),
          role: 'WORKER',
          homeWardId: ward1,
        },
        wi,
      ).expect(403);
      await http.post('/api/v1/staff').send({}).expect(401);
    });
  });

  describe('scoped reads', () => {
    const ids = (body: { items: { id: string }[] }) => body.items.map((s) => s.id).sort();

    it('admin lists everyone, filters by role and searches', async () => {
      const all = await http
        .get('/api/v1/staff?pageSize=100')
        .set('Authorization', admin)
        .expect(200);
      expect(all.body.total).toBeGreaterThanOrEqual(5);
      const workers = await http
        .get('/api/v1/staff?role=WORKER')
        .set('Authorization', admin)
        .expect(200);
      expect(ids(workers.body)).toEqual([workerId, otherWardWorkerId].sort());
      const search = await http.get('/api/v1/staff?q=wk-0').set('Authorization', admin).expect(200);
      expect(search.body.total).toBe(2);
      const literal = await http.get('/api/v1/staff?q=%25').set('Authorization', admin).expect(200);
      expect(literal.body.total).toBe(0);
    });

    it('a ward inspector sees only their own ward, with phones masked', async () => {
      const wi = await bearerFor(http, 'S-WI-01');
      const res = await http.get('/api/v1/staff').set('Authorization', wi).expect(200);
      expect(ids(res.body)).toEqual([wardInspectorId, inspectorId, workerId].sort());
      const worker = res.body.items.find((s: { id: string }) => s.id === workerId);
      expect(worker.phone).toMatch(/^\*{6}\d{4}$/);
      await http.get(`/api/v1/staff/${otherWardWorkerId}`).set('Authorization', wi).expect(404);
    });

    it('an inspector sees their ward workers and themselves', async () => {
      const ins = await bearerFor(http, 'S-IN-01');
      const res = await http.get('/api/v1/staff').set('Authorization', ins).expect(200);
      expect(ids(res.body)).toEqual([inspectorId, workerId].sort());
      await http.get(`/api/v1/staff/${wardInspectorId}`).set('Authorization', ins).expect(404);
    });

    it('a worker cannot list staff or read another worker, but can read themselves', async () => {
      const wk = await bearerFor(http, 'S-WK-01');
      const list = await http.get('/api/v1/staff').set('Authorization', wk).expect(403);
      expect(list.body.code).toBe('FORBIDDEN');
      await http.get(`/api/v1/staff/${otherWardWorkerId}`).set('Authorization', wk).expect(404);
      const self = await http.get(`/api/v1/staff/${workerId}`).set('Authorization', wk).expect(200);
      expect(self.body.phone).toMatch(/^\d{10}$/);
    });
  });

  describe('update (ADMIN)', () => {
    it('updates with the current version and refuses a stale one', async () => {
      const ok = await http
        .patch(`/api/v1/staff/${otherWardWorkerId}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 1, department: 'Sanitation', shiftStart: '07:00' })
        .expect(200);
      expect(ok.body).toMatchObject({ department: 'Sanitation', shiftStart: '07:00', version: 2 });
      const stale = await http
        .patch(`/api/v1/staff/${otherWardWorkerId}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 1, department: 'Roads' })
        .expect(409);
      expect(stale.body.code).toBe('VERSION_CONFLICT');
    });

    it('re-checks links when the role changes', async () => {
      const res = await http
        .patch(`/api/v1/staff/${otherWardWorkerId}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 2, role: 'OFFICE_STAFF' })
        .expect(422);
      expect(res.body.code).toBe('RULE_VIOLATION');
    });

    it('deactivating signs the person out at once', async () => {
      const wk = await bearerFor(http, 'S-WK-02');
      await http.get('/api/v1/auth/me').set('Authorization', wk).expect(200);
      const res = await http
        .patch(`/api/v1/staff/${otherWardWorkerId}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 2, isActive: false })
        .expect(200);
      expect(res.body.isActive).toBe(false);
      const after = await http.get('/api/v1/auth/me').set('Authorization', wk);
      expect([401, 403]).toContain(after.status);
      const inactive = await http
        .get('/api/v1/staff?isActive=false')
        .set('Authorization', admin)
        .expect(200);
      expect(inactive.body.items.map((s: { id: string }) => s.id)).toContain(otherWardWorkerId);
    });

    it('an admin cannot deactivate themselves', async () => {
      const me = await http.get('/api/v1/auth/me').set('Authorization', admin).expect(200);
      const id = (me.body.staff?.id ?? me.body.id) as string;
      const current = await http.get(`/api/v1/staff/${id}`).set('Authorization', admin).expect(200);
      await http
        .patch(`/api/v1/staff/${id}`)
        .set('Authorization', admin)
        .send({ expectedVersion: current.body.version, isActive: false })
        .expect(422);
    });
  });
});
