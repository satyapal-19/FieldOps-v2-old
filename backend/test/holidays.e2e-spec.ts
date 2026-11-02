/**
 * The holiday calendar through the API.
 */
import { Role } from '../src/shared/auth/roles';
import { istDate } from '../src/shared/clock/ist';
import { bearerFor, createTestApp, seedStaff, TestApp } from './helpers';

describe('holidays (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;
  let worker: string;
  const day = (offset: number) => istDate(new Date(Date.now() + offset * 86_400_000));
  const year = Number(day(30).slice(0, 4));

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'HO-ADMIN' });
    await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'HO-WK' });
    admin = await bearerFor(http, 'HO-ADMIN');
    worker = await bearerFor(http, 'HO-WK');
  });

  afterAll(async () => {
    await t?.app.close();
  });

  let id: string;

  it('an admin adds a holiday; everyone can read the year', async () => {
    const res = await http
      .post('/api/v1/holidays')
      .set('Authorization', admin)
      .send({ date: day(30), name: 'Test Festival', nameMr: 'चाचणी सण' })
      .expect(201);
    expect(res.body).toMatchObject({
      date: day(30),
      holidayType: 'GAZETTE',
      nameMr: 'चाचणी सण',
      version: 1,
    });
    id = res.body.id;
    const list = await http
      .get(`/api/v1/holidays?year=${year}`)
      .set('Authorization', worker)
      .expect(200);
    expect(list.body.map((h: { id: string }) => h.id)).toContain(id);
  });

  it.each<[string, () => Record<string, unknown>, number, string]>([
    [
      'a second holiday on the same date',
      () => ({ date: day(30), name: 'Copy' }),
      409,
      'HOLIDAY_DATE_TAKEN',
    ],
    ['a past date', () => ({ date: day(-1), name: 'Too late' }), 422, 'RULE_VIOLATION'],
    ['an impossible date', () => ({ date: '2027-02-30', name: 'Nope' }), 422, 'RULE_VIOLATION'],
  ])('refuses %s', async (_label, body, status, code) => {
    const res = await http
      .post('/api/v1/holidays')
      .set('Authorization', admin)
      .send(body())
      .expect(status);
    expect(res.body.code).toBe(code);
  });

  it('changes need the current version', async () => {
    const ok = await http
      .patch(`/api/v1/holidays/${id}`)
      .set('Authorization', admin)
      .send({ expectedVersion: 1, holidayType: 'OPTIONAL' })
      .expect(200);
    expect(ok.body).toMatchObject({ holidayType: 'OPTIONAL', version: 2 });
    await http
      .patch(`/api/v1/holidays/${id}`)
      .set('Authorization', admin)
      .send({ expectedVersion: 1, name: 'Stale edit' })
      .expect(409);
  });

  it('only admins write', async () => {
    await http
      .post('/api/v1/holidays')
      .set('Authorization', worker)
      .send({ date: day(40), name: 'No' })
      .expect(403);
    await http.delete(`/api/v1/holidays/${id}`).set('Authorization', worker).expect(403);
    await http.get(`/api/v1/holidays?year=${year}`).expect(401);
  });

  it('an admin removes a coming holiday', async () => {
    await http.delete(`/api/v1/holidays/${id}`).set('Authorization', admin).expect(204);
    await http.delete(`/api/v1/holidays/${id}`).set('Authorization', admin).expect(404);
  });
});
