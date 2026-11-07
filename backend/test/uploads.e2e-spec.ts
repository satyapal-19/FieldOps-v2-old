/**
 * Photo uploads and the mobile start-up settings, end to end: real type sniffing, size limit,
 * retry-safe clientUuid, who may download a photo, and GET /public/app-config.
 */
import { randomUUID } from 'node:crypto';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Upload } from '../src/modules/uploads/entities/upload.entity';
import { UploadsService } from '../src/modules/uploads/uploads.service';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

const JPEG = Buffer.from([0xff, 0xd8, 0xff, 0xe0, 0x00, 0x10, 0x4a, 0x46, 0x49, 0x46, 0x00, 0x01]);
const PNG = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00, 0x00]);

describe('uploads and app config (e2e)', () => {
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};

  const upload = (who: string, file: Buffer, clientUuid = randomUUID(), name = 'photo.jpg') =>
    http
      .post('/api/v1/uploads')
      .set('Authorization', tok[who])
      .field('clientUuid', clientUuid)
      .field('kind', 'TASK_PHOTO')
      .attach('file', file, { filename: name, contentType: 'image/jpeg' });

  beforeAll(async () => {
    t = await createTestApp();
    http = t.http;
    const w1 = await insertWard(t.dataSource, 'U1');
    const w2 = await insertWard(t.dataSource, 'U2');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['WI2', Role.WARD_INSPECTOR, w2, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['IN2', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
      ['WK2', Role.WORKER, w1, 'IN1'],
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `U-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `U-${key}`);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it('stores a JPEG or PNG and answers a retry with the same upload', async () => {
    const key = randomUUID();
    const first = await upload('WK1', JPEG, key).expect(201);
    expect(first.body).toMatchObject({
      kind: 'TASK_PHOTO',
      contentType: 'image/jpeg',
      sizeBytes: JPEG.length,
      replayed: false,
    });
    const again = await upload('WK1', JPEG, key).expect(201);
    expect(again.body).toMatchObject({ id: first.body.id, replayed: true });
    await upload('WK2', JPEG, key).expect(409); // someone else's clientUuid
    const png = await upload('WK1', PNG, randomUUID(), 'shot.png').expect(201);
    expect(png.body.contentType).toBe('image/png');
  });

  it('refuses files that are not images, whatever they claim to be', async () => {
    const pdf = await upload(
      'WK1',
      Buffer.from('%PDF-1.7 not a photo'),
      randomUUID(),
      'x.jpg',
    ).expect(400);
    expect(pdf.body).toMatchObject({ code: 'VALIDATION_FAILED', details: { field: 'file' } });
    await http
      .post('/api/v1/uploads')
      .set('Authorization', tok.WK1)
      .field('clientUuid', randomUUID())
      .field('kind', 'TASK_PHOTO')
      .expect(400);
    await http.post('/api/v1/uploads').attach('file', JPEG, 'a.jpg').expect(401);
  });

  it('refuses a photo over UPLOAD_MAX_BYTES', async () => {
    const big = Buffer.concat([JPEG, Buffer.alloc(2_100_000)]);
    const res = await upload('WK1', big).expect(413);
    expect(res.body.code).toBe('PAYLOAD_TOO_LARGE');
  });

  it('serves the photo to its uploader and their supervisors only', async () => {
    const { body } = await upload('WK1', JPEG).expect(201);
    const own = await http
      .get(`/api/v1/uploads/${body.id}`)
      .set('Authorization', tok.WK1)
      .expect(200);
    expect(own.headers['content-type']).toBe('image/jpeg');
    expect(Buffer.from(own.body).equals(JPEG)).toBe(true);
    for (const who of ['IN1', 'WI1', 'ADM']) {
      await http.get(`/api/v1/uploads/${body.id}`).set('Authorization', tok[who]).expect(200);
    }
    for (const who of ['WK2', 'IN2', 'WI2']) {
      await http.get(`/api/v1/uploads/${body.id}`).set('Authorization', tok[who]).expect(404);
    }
  });

  it('takes voice notes as audio only, and the retention job deletes old ones', async () => {
    const m4a = Buffer.concat([Buffer.from([0, 0, 0, 0x20]), Buffer.from('ftypM4A isom')]);
    const voice = await http
      .post('/api/v1/uploads')
      .set('Authorization', tok.WK1)
      .field('clientUuid', randomUUID())
      .field('kind', 'VOICE_NOTE')
      .attach('file', m4a, { filename: 'note.m4a', contentType: 'audio/mp4' })
      .expect(201);
    expect(voice.body.contentType).toBe('audio/mp4');
    await http
      .post('/api/v1/uploads')
      .set('Authorization', tok.WK1)
      .field('clientUuid', randomUUID())
      .field('kind', 'VOICE_NOTE')
      .attach('file', JPEG, { filename: 'x.m4a', contentType: 'audio/mp4' })
      .expect(400);

    const uploads = t.app.get(UploadsService);
    expect(await uploads.purgeVoiceNotes()).toMatch(/^deleted 0 /);
    await t.dataSource
      .getRepository(Upload)
      .update({ id: voice.body.id }, { createdAt: new Date(Date.now() - 100 * 86_400_000) });
    expect(await uploads.purgeVoiceNotes()).toMatch(/^deleted 1 /);
    await http.get(`/api/v1/uploads/${voice.body.id}`).set('Authorization', tok.WK1).expect(404);
  });

  it('gives the mobile app its start-up settings without sign-in', async () => {
    const res = await http.get('/api/v1/public/app-config').expect(200);
    expect(res.body).toMatchObject({
      minVersionCode: expect.any(Number),
      latestVersionCode: expect.any(Number),
      faceProvider: 'local',
      pingIntervalSeconds: 600,
      silentGapMinutes: 30,
    });
    expect(res.body.latestVersionCode).toBeGreaterThanOrEqual(res.body.minVersionCode);
    expect(new Date(res.body.serverTime).getTime()).toBeGreaterThan(0);
  });
});
