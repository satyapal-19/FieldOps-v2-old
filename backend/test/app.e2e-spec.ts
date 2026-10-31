/**
 * End-to-end tests against a real database (NODE_ENV=test, see .env.test).
 * Runs the same pipeline as production via configureApp().
 */
import { createTestApp, bearerFor, seedStaff, SQUARE_BOUNDARY as boundary, TestApp } from './helpers';
import { Role } from '../src/shared/auth/roles';

describe('FieldOps API (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  let admin: string;

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    await seedStaff(t.dataSource, { role: Role.ADMIN, employeeCode: 'E2E-ADMIN' });
    admin = await bearerFor(http, 'E2E-ADMIN');
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('health', () => {
    it('GET /api/v1/health answers and returns a request ID', async () => {
      const res = await http.get('/api/v1/health').expect(200);
      expect(res.body).toMatchObject({ status: 'ok', environment: 'test' });
      expect(res.headers['x-request-id']).toMatch(/^[A-Za-z0-9-]{8,64}$/);
    });

    it('echoes a client-supplied request ID', async () => {
      const res = await http.get('/api/v1/health').set('X-Request-Id', 'phone-req-12345678').expect(200);
      expect(res.headers['x-request-id']).toBe('phone-req-12345678');
    });

    it('GET /api/v1/ready confirms the database and migrations', async () => {
      const res = await http.get('/api/v1/ready').expect(200);
      expect(res.body).toMatchObject({ status: 'ready', pendingMigrations: false });
    });
  });

  describe('wards', () => {
    let wardId: string;

    it('creates a ward', async () => {
      const res = await http
        .post('/api/v1/wards')
        .set('Authorization', admin)
        .send({ code: 'w04', name: 'Ward 4 - Vishrambag', nameMr: 'प्रभाग ४', zone: 'SANGLI', boundary })
        .expect(201);
      expect(res.body).toMatchObject({ code: 'W04', version: 1, isActive: true, nameMr: 'प्रभाग ४' });
      wardId = res.body.id;
    });

    it('rejects a duplicate code as problem+json WARD_CODE_TAKEN', async () => {
      const res = await http
        .post('/api/v1/wards')
        .set('Authorization', admin)
        .send({ code: 'W04', name: 'Copy', nameMr: 'प्रत', zone: 'SANGLI', boundary })
        .expect(409);
      expect(res.headers['content-type']).toContain('application/problem+json');
      expect(res.body).toMatchObject({ code: 'WARD_CODE_TAKEN', status: 409 });
      expect(res.body.requestId).toBe(res.headers['x-request-id']);
    });

    it('rejects unknown fields and bad values as VALIDATION_FAILED', async () => {
      const res = await http
        .post('/api/v1/wards')
        .set('Authorization', admin)
        .send({ code: '!', name: 'x', nameMr: '', zone: 'PUNE', boundary, hacker: true })
        .expect(400);
      expect(res.body.code).toBe('VALIDATION_FAILED');
      expect(Array.isArray(res.body.details.errors)).toBe(true);
    });

    it('checks locations against the boundary', async () => {
      const inside = await http
        .post(`/api/v1/wards/${wardId}/location-check`)
        .set('Authorization', admin)
        .send({ latitude: 16.855, longitude: 74.585 })
        .expect(200);
      expect(inside.body).toMatchObject({ inside: true, withinTolerance: true });

      const outside = await http
        .post(`/api/v1/wards/${wardId}/location-check`)
        .set('Authorization', admin)
        .send({ latitude: 16.861, longitude: 74.585 })
        .expect(200);
      expect(outside.body).toMatchObject({ inside: false, withinTolerance: false });
    });

    it('updates with optimistic locking', async () => {
      await http.patch(`/api/v1/wards/${wardId}`).set('Authorization', admin).send({ expectedVersion: 1, name: 'Ward 4' }).expect(200);
      const stale = await http
        .patch(`/api/v1/wards/${wardId}`)
        .set('Authorization', admin)
        .send({ expectedVersion: 1, name: 'Stale edit' })
        .expect(409);
      expect(stale.body.code).toBe('VERSION_CONFLICT');
    });

    it('stores timestamps in UTC and lists by page', async () => {
      const res = await http.get('/api/v1/wards?page=1&pageSize=10').set('Authorization', admin).expect(200);
      expect(res.body.total).toBe(1);
      expect(res.body.items[0].createdAt).toMatch(/Z$/);
      const created = new Date(res.body.items[0].createdAt).getTime();
      expect(Math.abs(Date.now() - created)).toBeLessThan(5 * 60_000);
    });

    it('returns NOT_FOUND for an unknown ward', async () => {
      const res = await http.get('/api/v1/wards/3f2a9c1e-5b7d-4e8a-9c21-7d4e5f6a8b90').set('Authorization', admin).expect(404);
      expect(res.body.code).toBe('NOT_FOUND');
    });
  });
});
