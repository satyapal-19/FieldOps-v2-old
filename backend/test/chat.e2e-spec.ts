/**
 * Hierarchy chat end to end: today's squad and ward channels appear on their own, broadcasts
 * are one-way, direct messages follow the hierarchy, a voice note is readable by members only,
 * messages notify the others, retries send once, and yesterday's squad chat is archived.
 */
import { randomUUID } from 'node:crypto';
import { ChatService } from '../src/modules/chat/chat.service';
import type { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role, type StaffRole } from '../src/shared/auth/roles';
import { Clock, FixedClock } from '../src/shared/clock/clock';
import { bearerFor, createTestApp, insertWard, seedStaff, TestApp } from './helpers';

const DAY = '2026-11-02';
const M4A = Buffer.concat([Buffer.from([0, 0, 0, 0x20]), Buffer.from('ftypM4A isom')]);

describe('chat (e2e)', () => {
  const clock = new FixedClock('2026-11-02T03:00:00Z');
  let t: TestApp;
  let http: TestApp['http'];
  const s: Record<string, Staff> = {};
  const tok: Record<string, string> = {};
  const as = (who: string) => ({ Authorization: tok[who] });
  const conversations = async (who: string) =>
    (await http.get('/api/v1/chat/conversations').set(as(who)).expect(200)).body as {
      id: string;
      type: string;
      canPost: boolean;
      memberIds: string[];
      unread: number;
      archived: boolean;
    }[];
  const send = (who: string, id: string, body: Record<string, unknown>) =>
    http
      .post(`/api/v1/chat/conversations/${id}/messages`)
      .set(as(who))
      .send({ clientUuid: randomUUID(), ...body });

  beforeAll(async () => {
    t = await createTestApp((b) => b.overrideProvider(Clock).useValue(clock));
    http = t.http;
    const w1 = await insertWard(t.dataSource, 'C1');
    const people: [string, StaffRole, string | null, string | null][] = [
      ['ADM', Role.ADMIN, null, null],
      ['WI1', Role.WARD_INSPECTOR, w1, 'ADM'],
      ['IN1', Role.INSPECTOR, w1, 'WI1'],
      ['WK1', Role.WORKER, w1, 'IN1'],
      ['WK2', Role.WORKER, w1, 'IN1'],
      ['WK3', Role.WORKER, w1, 'IN1'], // not placed today
    ];
    for (const [key, role, homeWardId, managerKey] of people) {
      s[key] = await seedStaff(t.dataSource, {
        role,
        employeeCode: `CH-${key}`,
        homeWardId,
        reportsToId: managerKey ? s[managerKey].id : null,
      });
      tok[key] = await bearerFor(http, `CH-${key}`);
    }
    for (const body of [
      { date: DAY, staffId: s.IN1.id, wardId: w1 },
      { date: DAY, staffId: s.WK1.id, inspectorId: s.IN1.id },
      { date: DAY, staffId: s.WK2.id, inspectorId: s.IN1.id },
    ]) {
      await http.post('/api/v1/assignments').set(as('WI1')).send(body).expect(201);
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  let squad: string;
  let ward: string;

  it("puts people in today's channels", async () => {
    const mine = await conversations('IN1');
    expect(mine.map((c) => c.type).sort()).toEqual(['SQUAD_TEAM', 'WARD_BROADCAST']);
    squad = mine.find((c) => c.type === 'SQUAD_TEAM')!.id;
    ward = mine.find((c) => c.type === 'WARD_BROADCAST')!.id;
    expect(mine.find((c) => c.id === squad)!.memberIds.sort()).toEqual(
      [s.IN1.id, s.WK1.id, s.WK2.id].sort(),
    );
    expect((await conversations('WK1')).map((c) => c.id)).toEqual([squad]);
    expect(await conversations('WK3')).toEqual([]);
    const wi = await conversations('WI1');
    expect(wi.map((c) => c.type).sort()).toEqual(['CITY_BROADCAST', 'WARD_BROADCAST']);
    expect(wi.find((c) => c.type === 'WARD_BROADCAST')!.id).toBe(ward);
  });

  it('sends once per clientUuid, counts unread and keeps outsiders out', async () => {
    const clientUuid = randomUUID();
    const first = await http
      .post(`/api/v1/chat/conversations/${squad}/messages`)
      .set(as('WK1'))
      .send({ clientUuid, type: 'TEXT', text: 'Drain near the market is blocked' })
      .expect(201);
    const retry = await http
      .post(`/api/v1/chat/conversations/${squad}/messages`)
      .set(as('WK1'))
      .send({ clientUuid, type: 'TEXT', text: 'Drain near the market is blocked' })
      .expect(201);
    expect(retry.body.id).toBe(first.body.id);
    expect((await conversations('IN1')).find((c) => c.id === squad)!.unread).toBe(1);
    const inbox = await http.get('/api/v1/notifications').set(as('WK2')).expect(200);
    expect(inbox.body.items[0]).toMatchObject({ kind: 'CHAT', refId: squad });

    await http.get(`/api/v1/chat/conversations/${squad}/messages`).set(as('WK3')).expect(404);
    await send('WK3', squad, { type: 'TEXT', text: 'hi' }).expect(404);
    await http.post(`/api/v1/chat/conversations/${squad}/read`).set(as('IN1')).expect(204);
    expect((await conversations('IN1')).find((c) => c.id === squad)!.unread).toBe(0);
  });

  it('keeps broadcasts one-way', async () => {
    await send('IN1', ward, { type: 'TEXT', text: 'Can I reply?' }).expect(403);
    await send('WI1', ward, { type: 'TEXT', text: 'Monsoon drill at 7 tomorrow' }).expect(201);
    const msgs = await http
      .get(`/api/v1/chat/conversations/${ward}/messages`)
      .set(as('IN1'))
      .expect(200);
    expect(msgs.body[0].text).toBe('Monsoon drill at 7 tomorrow');
  });

  it('shares a voice note with members only', async () => {
    const upload = await http
      .post('/api/v1/uploads')
      .set(as('WK2'))
      .field('clientUuid', randomUUID())
      .field('kind', 'VOICE_NOTE')
      .attach('file', M4A, { filename: 'n.m4a', contentType: 'audio/mp4' })
      .expect(201);
    await send('WK1', squad, { type: 'VOICE', uploadId: upload.body.id }).expect(400); // not WK1's
    const msg = await send('WK2', squad, {
      type: 'VOICE',
      uploadId: upload.body.id,
      durationSec: 4,
    }).expect(201);
    expect(msg.body).toMatchObject({ type: 'VOICE', hasMedia: true, durationSec: 4 });
    const media = await http
      .get(`/api/v1/chat/messages/${msg.body.id}/media`)
      .set(as('IN1'))
      .expect(200);
    expect(media.headers['content-type']).toBe('audio/mp4');
    await http.get(`/api/v1/chat/messages/${msg.body.id}/media`).set(as('WK3')).expect(404);
  });

  it('opens direct chats along the hierarchy only', async () => {
    const direct = await http
      .post('/api/v1/chat/direct')
      .set(as('WK1'))
      .send({ staffId: s.IN1.id })
      .expect(200);
    const again = await http
      .post('/api/v1/chat/direct')
      .set(as('IN1'))
      .send({ staffId: s.WK1.id })
      .expect(200);
    expect(again.body.id).toBe(direct.body.id);
    await http.post('/api/v1/chat/direct').set(as('WK1')).send({ staffId: s.WK2.id }).expect(403);
    await http.post('/api/v1/chat/direct').set(as('WK1')).send({ staffId: s.ADM.id }).expect(403);
  });

  it("archives yesterday's squad chat: still readable, no longer writable", async () => {
    clock.set('2026-11-02T19:00:00Z'); // 00:30 IST on 3 Nov
    expect(await t.app.get(ChatService).archiveOldSquads()).toMatch(/archived 1/);
    const old = (await conversations('IN1')).find((c) => c.id === squad)!;
    expect(old).toMatchObject({ archived: true, canPost: false });
    await http.get(`/api/v1/chat/conversations/${squad}/messages`).set(as('WK1')).expect(200);
    await send('WK1', squad, { type: 'TEXT', text: 'late message' }).expect(422);
  });
});
