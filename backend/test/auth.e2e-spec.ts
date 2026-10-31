/**
 * Sign-in, sessions and role checks against a real database (Gate G1 security tests).
 */
import { AuditLog } from '../src/shared/audit/audit-log.entity';
import { Role } from '../src/shared/auth/roles';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { bearerFor, createTestApp, seedStaff, SQUARE_BOUNDARY, TestApp } from './helpers';

const ADMIN_PASSWORD = 'Sangli2026Miraj';

describe('Auth and roles (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;
  let worker: Staff;
  let otherWorker: Staff;
  let wardId: string;

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'AUTH-ADMIN', password: ADMIN_PASSWORD });
    admin = await bearerFor(http, 'AUTH-ADMIN');

    const ward = await http
      .post('/api/v1/wards')
      .set('Authorization', admin)
      .send({ code: 'W09', name: 'Ward 9', nameMr: 'प्रभाग ९', zone: 'SANGLI', boundary: SQUARE_BOUNDARY })
      .expect(201);
    wardId = ward.body.id;

    worker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'AUTH-W1', homeWardId: wardId });
    otherWorker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'AUTH-W2', homeWardId: wardId });
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('protected by default', () => {
    it('refuses a request without a token as UNAUTHENTICATED problem+json', async () => {
      const res = await http.get('/api/v1/wards').expect(401);
      expect(res.headers['content-type']).toContain('application/problem+json');
      expect(res.body.code).toBe('UNAUTHENTICATED');
    });

    it('refuses a forged token', async () => {
      const forged = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ4Iiwic2lkIjoieSIsInJvbGUiOiJBRE1JTiJ9.c2lnbmF0dXJlLWZvcmdlZA';
      await http.get('/api/v1/wards').set('Authorization', `Bearer ${forged}`).expect(401);
    });

    it('keeps health endpoints public', async () => {
      await http.get('/api/v1/health').expect(200);
    });
  });

  describe('roles', () => {
    it('lets a worker read wards but not create them', async () => {
      const w = await bearerFor(http, worker.employeeCode);
      await http.get('/api/v1/wards').set('Authorization', w).expect(200);
      const res = await http
        .post('/api/v1/wards')
        .set('Authorization', w)
        .send({ code: 'W10', name: 'Ward 10', nameMr: 'प्रभाग १०', zone: 'SANGLI', boundary: SQUARE_BOUNDARY })
        .expect(403);
      expect(res.body.code).toBe('FORBIDDEN');
    });

    it("stops a worker asking for another worker's face capture", async () => {
      const w = await bearerFor(http, worker.employeeCode);
      await http.get(`/api/v1/face/capture-options?staffId=${otherWorker.id}`).set('Authorization', w).expect(403);
      await http.get('/api/v1/face/capture-options').set('Authorization', w).expect(200);
    });

    it('stops a worker revoking sessions (ADMIN only)', async () => {
      const w = await bearerFor(http, worker.employeeCode);
      await http.post(`/api/v1/auth/staff/${otherWorker.id}/revoke-sessions`).set('Authorization', w).expect(403);
    });
  });

  describe('OTP sign-in', () => {
    it('signs in with the SMS code, once', async () => {
      await http.post('/api/v1/auth/otp/request').send({ phone: `+91 ${worker.phone}` }).expect(202);
      const code = t.otp.lastCodeFor(worker.phone);
      expect(code).toMatch(/^\d{6}$/);

      const wrong = code === '000000' ? '111111' : '000000';
      const bad = await http.post('/api/v1/auth/otp/verify').send({ phone: worker.phone, code: wrong }).expect(401);
      expect(bad.body).toMatchObject({ code: 'AUTH_OTP_INVALID', details: { attemptsLeft: 4 } });

      const ok = await http.post('/api/v1/auth/otp/verify').send({ phone: worker.phone, code }).expect(200);
      expect(ok.body.staff).toMatchObject({ id: worker.id, role: 'WORKER' });
      expect(ok.body.refreshToken).toContain('.');

      await http.post('/api/v1/auth/otp/verify').send({ phone: worker.phone, code }).expect(401);
    });

    it('answers the same for an unregistered number and sends nothing', async () => {
      const before = t.otp.sent.length;
      const res = await http.post('/api/v1/auth/otp/request').send({ phone: '7000000001' }).expect(202);
      expect(res.body.sent).toBe(true);
      expect(t.otp.sent.length).toBe(before);
    });

    it('rejects a malformed phone as VALIDATION_FAILED', async () => {
      const res = await http.post('/api/v1/auth/otp/request').send({ phone: '12345678901' }).expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
    });

    it('locks the code after too many wrong guesses', async () => {
      await http.post('/api/v1/auth/otp/request').send({ phone: otherWorker.phone }).expect(202);
      const code = t.otp.lastCodeFor(otherWorker.phone)!;
      const wrong = code === '000000' ? '111111' : '000000';
      for (let i = 0; i < 5; i++) {
        await http.post('/api/v1/auth/otp/verify').send({ phone: otherWorker.phone, code: wrong }).expect(401);
      }
      const res = await http.post('/api/v1/auth/otp/verify').send({ phone: otherWorker.phone, code }).expect(429);
      expect(res.body.code).toBe('AUTH_OTP_TOO_MANY_ATTEMPTS');
    });
  });

  describe('password sign-in', () => {
    it('signs an admin in by employee code', async () => {
      const res = await http
        .post('/api/v1/auth/login')
        .send({ identifier: 'auth-admin', password: ADMIN_PASSWORD })
        .expect(200);
      expect(res.body.staff.role).toBe('ADMIN');
    });

    it('gives the same error for a wrong password and an unknown account', async () => {
      const a = await http.post('/api/v1/auth/login').send({ identifier: 'AUTH-ADMIN', password: 'nope' }).expect(401);
      const b = await http.post('/api/v1/auth/login').send({ identifier: 'NOBODY-1', password: 'nope' }).expect(401);
      expect(a.body.code).toBe('AUTH_INVALID_CREDENTIALS');
      expect(b.body.code).toBe('AUTH_INVALID_CREDENTIALS');
    });
  });

  describe('sessions', () => {
    it('rotates refresh tokens and revokes the session when an old one is reused', async () => {
      const first = await http.post('/api/v1/auth/test-login').send({ identifier: worker.employeeCode }).expect(200);
      const second = await http
        .post('/api/v1/auth/refresh')
        .send({ refreshToken: first.body.refreshToken })
        .expect(200);
      expect(second.body.refreshToken).not.toBe(first.body.refreshToken);

      // The new access token works...
      await http.get('/api/v1/auth/me').set('Authorization', `Bearer ${second.body.accessToken}`).expect(200);
      // ...until the old refresh token is replayed, which kills the whole session.
      const replay = await http.post('/api/v1/auth/refresh').send({ refreshToken: first.body.refreshToken }).expect(401);
      expect(replay.body.code).toBe('AUTH_SESSION_REVOKED');
      await http.get('/api/v1/auth/me').set('Authorization', `Bearer ${second.body.accessToken}`).expect(401);
    });

    it('stops an access token working after logout', async () => {
      const token = await bearerFor(http, worker.employeeCode);
      await http.get('/api/v1/auth/me').set('Authorization', token).expect(200);
      await http.post('/api/v1/auth/logout').set('Authorization', token).send({}).expect(204);
      const res = await http.get('/api/v1/auth/me').set('Authorization', token).expect(401);
      expect(res.body.code).toBe('AUTH_SESSION_REVOKED');
    });

    it('lets an admin sign a worker out of every device', async () => {
      const token = await bearerFor(http, otherWorker.employeeCode);
      const res = await http
        .post(`/api/v1/auth/staff/${otherWorker.id}/revoke-sessions`)
        .set('Authorization', admin)
        .expect(200);
      expect(res.body.revoked).toBeGreaterThanOrEqual(1);
      await http.get('/api/v1/auth/me').set('Authorization', token).expect(401);
    });
  });

  describe('audit trail', () => {
    it('records sign-ins and changes with the request ID', async () => {
      const res = await http
        .post('/api/v1/offices')
        .set('Authorization', admin)
        .set('X-Request-Id', 'audit-check-0001')
        .send({
          code: 'HO-SANGLI',
          name: 'SMKMC Head Office',
          nameMr: 'मुख्यालय - सांगली',
          zone: 'SANGLI',
          premises: SQUARE_BOUNDARY,
        })
        .expect(201);

      const rows = await t.dataSource.getRepository(AuditLog).find({ where: { entityId: res.body.id } });
      expect(rows).toHaveLength(1);
      expect(rows[0]).toMatchObject({ action: 'OFFICE_CREATED', requestId: 'audit-check-0001', actorRole: 'ADMIN' });

      const logins = await t.dataSource.getRepository(AuditLog).count({ where: { action: 'LOGIN_SUCCEEDED' } });
      expect(logins).toBeGreaterThan(0);
      const failures = await t.dataSource.getRepository(AuditLog).count({ where: { action: 'LOGIN_FAILED' } });
      expect(failures).toBeGreaterThan(0);
    });

    it('checks office geofences with the 100 m buffer', async () => {
      const office = await http
        .post('/api/v1/offices')
        .set('Authorization', admin)
        .send({ code: 'DO-MIRAJ', name: 'Miraj Office', nameMr: 'मिरज', zone: 'MIRAJ', premises: SQUARE_BOUNDARY })
        .expect(201);
      const near = await http
        .post(`/api/v1/offices/${office.body.id}/location-check`)
        .set('Authorization', admin)
        .send({ latitude: 16.8605, longitude: 74.585 })
        .expect(200);
      expect(near.body).toMatchObject({ inside: false, withinTolerance: true, bufferMeters: 100 });
    });
  });
});
