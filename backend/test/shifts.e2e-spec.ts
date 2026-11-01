/**
 * Shift overrides and the effective shift, through the API.
 */
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

describe('shifts (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;
  const s: Record<string, Staff> = {};
  const tokens: Record<string, string> = {};
  const today = istDate(new Date());
  const tomorrow = istDate(new Date(Date.now() + 86_400_000));
  const yesterday = istDate(new Date(Date.now() - 86_400_000));

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'H-ADMIN' });
    admin = await bearerFor(http, 'H-ADMIN');
    const ward = async (code: string) =>
      (
        await http
          .post('/api/v1/wards')
          .set('Authorization', admin)
          .send({ code, name: `Ward ${code}`, nameMr: `प्रभाग ${code}`, zone: 'KUPWAD', boundary })
          .expect(201)
      ).body.id as string;
    const w1 = await ward('H1');
    const w2 = await ward('H2');
    const people: [string, StaffRole, string][] = [
      ['WI1', Role.WARD_INSPECTOR, w1],
      ['WK1', Role.WORKER, w1],
      ['WK2', Role.WORKER, w1],
      ['WK3', Role.WORKER, w2],
    ];
    for (const [key, role, homeWardId] of people) {
      s[key] = await seedStaff(t.dataSource, { role, employeeCode: `H-${key}`, homeWardId });
      tokens[key] = await bearerFor(http, `H-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  const put = (body: Record<string, unknown>, auth = admin) =>
    http.put('/api/v1/shifts').set('Authorization', auth).send(body);
  const effective = (staffId: string, date: string, auth = admin) =>
    http.get(`/api/v1/shifts/effective?staffId=${staffId}&date=${date}`).set('Authorization', auth);

  let shiftId: string;

  it('falls back to the staff defaults when there is no override', async () => {
    const res = await effective(s.WK1.id, today).expect(200);
    expect(res.body).toMatchObject({
      source: 'DEFAULT',
      startTime: '06:00',
      endTime: '14:00',
      shiftType: null,
    });
  });

  it('a ward inspector sets a night shift for their worker; it ends the next day', async () => {
    const res = await put(
      {
        staffId: s.WK1.id,
        date: tomorrow,
        shiftType: 'NIGHT',
        startTime: '22:00',
        endTime: '06:00',
      },
      tokens.WI1,
    ).expect(200);
    expect(res.body).toMatchObject({ date: tomorrow, shiftType: 'NIGHT', version: 1 });
    shiftId = res.body.id;
    const eff = await effective(s.WK1.id, tomorrow, tokens.WK1).expect(200);
    expect(eff.body.source).toBe('OVERRIDE');
    expect(new Date(eff.body.endsAt).getTime() - new Date(eff.body.startsAt).getTime()).toBe(
      8 * 3_600_000,
    );
  });

  it('changing an override needs the current version', async () => {
    const body = {
      staffId: s.WK1.id,
      date: tomorrow,
      shiftType: 'EVENING',
      startTime: '14:00',
      endTime: '22:00',
    };
    expect((await put(body).expect(409)).body.code).toBe('VERSION_CONFLICT');
    const ok = await put({ ...body, expectedVersion: 1 }).expect(200);
    expect(ok.body).toMatchObject({ id: shiftId, shiftType: 'EVENING', version: 2 });
  });

  it.each<[string, () => Record<string, unknown>, number]>([
    [
      'a non-night shift ending next day',
      () => ({
        staffId: s.WK2.id,
        date: today,
        shiftType: 'MORNING',
        startTime: '22:00',
        endTime: '06:00',
      }),
      422,
    ],
    [
      'a past date',
      () => ({
        staffId: s.WK2.id,
        date: yesterday,
        shiftType: 'MORNING',
        startTime: '06:00',
        endTime: '14:00',
      }),
      422,
    ],
    [
      'a bad time',
      () => ({
        staffId: s.WK2.id,
        date: today,
        shiftType: 'MORNING',
        startTime: '6am',
        endTime: '14:00',
      }),
      422,
    ],
  ])('refuses %s', async (_label, body, status) => {
    await put(body()).expect(status);
  });

  it('keeps ward inspectors to their own ward, and workers out', async () => {
    const body = {
      staffId: s.WK3.id,
      date: today,
      shiftType: 'MORNING',
      startTime: '07:00',
      endTime: '15:00',
    };
    await put(body, tokens.WI1).expect(403);
    await put({ ...body, staffId: s.WK1.id }, tokens.WK1).expect(403);
  });

  it("lists overrides in a range; a worker cannot read another worker's shifts", async () => {
    const res = await http
      .get(`/api/v1/shifts?staffId=${s.WK1.id}&from=${today}&to=${tomorrow}`)
      .set('Authorization', tokens.WI1)
      .expect(200);
    expect(res.body).toHaveLength(1);
    await http
      .get(`/api/v1/shifts?staffId=${s.WK1.id}&from=${today}&to=${tomorrow}`)
      .set('Authorization', tokens.WK2)
      .expect(404);
    await effective(s.WK1.id, today, tokens.WK2).expect(404);
  });

  it('removing the override restores the defaults', async () => {
    await http.delete(`/api/v1/shifts/${shiftId}`).set('Authorization', tokens.WI1).expect(204);
    expect((await effective(s.WK1.id, tomorrow).expect(200)).body.source).toBe('DEFAULT');
  });
});
