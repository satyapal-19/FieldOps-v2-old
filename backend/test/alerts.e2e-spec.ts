/**
 * Supervisor alerts: raised by backend producers (here through AlertsService, as the Phase 2
 * punch flow and jobs will), listed and resolved through the API.
 */
import { AlertsService } from '../src/modules/alerts/alerts.service';
import { dedupeKey } from '../src/modules/alerts/alerts.policy';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

describe('alerts (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let alerts: AlertsService;
  let w1: string;
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    alerts = t.app.get(AlertsService);
    w1 = await insertWard(t.dataSource, 'A1');
    const w2 = await insertWard(t.dataSource, 'A2');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['WI2', Role.WARD_INSPECTOR, w2, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['IN2', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `A-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `A-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  let lateId: string;

  it('raises an alert once per dedupe key', async () => {
    const input = {
      alertType: 'LATE_CHECKIN' as const,
      severity: 'MEDIUM' as const,
      message: 'Checked in 22 minutes late',
      messageMr: '२२ मिनिटे उशिरा हजेरी',
      staffId: s.WK1.id,
      wardId: w1,
      details: { lateMinutes: 22 },
      dedupeKey: dedupeKey('LATE_CHECKIN', s.WK1.id, '2026-11-02'),
    };
    const first = await alerts.raise(input);
    const again = await alerts.raise(input);
    expect(again.id).toBe(first.id);
    expect(first).toMatchObject({ isResolved: false, details: { lateMinutes: 22 } });
    lateId = first.id;
    await alerts.raise({
      alertType: 'TAMPER_DETECTED',
      severity: 'HIGH',
      message: 'GPS turned off',
      staffId: s.WK1.id,
      wardId: w1,
    });
  });

  it('shows alerts to the right supervisors only', async () => {
    const total = async (who: string) =>
      (await http.get('/api/v1/alerts?isResolved=false').set('Authorization', tok[who]).expect(200))
        .body.total as number;
    expect(await total('ADM')).toBe(2);
    expect(await total('WI1')).toBe(2);
    expect(await total('IN1')).toBe(2);
    expect(await total('IN2')).toBe(0);
    expect(await total('WI2')).toBe(0);
    await http.get('/api/v1/alerts').set('Authorization', tok.WK1).expect(403);
    await http.get(`/api/v1/alerts/${lateId}`).set('Authorization', tok.IN2).expect(404);
    const typed = await http
      .get('/api/v1/alerts?alertType=TAMPER_DETECTED')
      .set('Authorization', tok.WI1)
      .expect(200);
    expect(typed.body.items).toHaveLength(1);
    expect(typed.body.items[0].severity).toBe('HIGH');
  });

  it("the worker's inspector resolves it once, with a note", async () => {
    const res = await http
      .post(`/api/v1/alerts/${lateId}/resolve`)
      .set('Authorization', tok.IN1)
      .send({ note: 'Bus was late; warned.' })
      .expect(200);
    expect(res.body).toMatchObject({
      isResolved: true,
      resolvedById: s.IN1.id,
      resolutionNote: 'Bus was late; warned.',
    });
    await http
      .post(`/api/v1/alerts/${lateId}/resolve`)
      .set('Authorization', tok.WI1)
      .send({})
      .expect(422);
    const open = await http
      .get('/api/v1/alerts?isResolved=false')
      .set('Authorization', tok.WI1)
      .expect(200);
    expect(open.body.total).toBe(1);
  });
});
