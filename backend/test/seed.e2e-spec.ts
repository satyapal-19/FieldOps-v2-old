/**
 * The sample seed loads through the real services onto an empty database, and never twice.
 */
import { AlreadySeededError, seedSampleData } from '../src/database/seed/sample-data';
import { istDate } from '../src/shared/clock/ist';
import { bearerFor, createTestApp, TestApp } from './helpers';

describe('sample seed (e2e)', () => {
  let t: TestApp;

  beforeAll(async () => {
    t = await createTestApp();
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it("loads wards, an office, staff, standing squads and today's assignments", async () => {
    const summary = await seedSampleData(t.app);
    expect(summary).toMatchObject({
      wards: 4,
      offices: 1,
      // 1 admin + 2 office staff + 4 wards x (1 ward inspector + 2 inspectors + 6 workers)
      staff: 39,
      standingRosters: 24,
      // every inspector and worker is placed today
      assignmentsToday: 32,
    });

    // The sample logins work and see their scope.
    const wi = await bearerFor(t.http, summary.sampleLogins.WARD_INSPECTOR);
    const staff = await t.http
      .get('/api/v1/staff?pageSize=100')
      .set('Authorization', wi)
      .expect(200);
    expect(staff.body.total).toBe(9);
    const worker = await bearerFor(t.http, summary.sampleLogins.WORKER);
    const today = await t.http
      .get(`/api/v1/assignments?date=${istDate(new Date())}`)
      .set('Authorization', worker)
      .expect(200);
    expect(today.body.items).toHaveLength(1);
    expect(today.body.items[0]).toMatchObject({
      isApproved: true,
      assignmentMode: 'STANDING_ROSTER',
    });
  });

  it('refuses to run on a database that already has data', async () => {
    await expect(seedSampleData(t.app)).rejects.toBeInstanceOf(AlreadySeededError);
  });
});
