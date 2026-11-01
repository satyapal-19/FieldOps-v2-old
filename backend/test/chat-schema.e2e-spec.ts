/**
 * Schema-level guarantees of the chat migration, checked against the real test database.
 */
import { randomUUID } from 'node:crypto';
import { ConversationParticipant } from '../src/modules/chat/entities/conversation-participant.entity';
import { Conversation } from '../src/modules/chat/entities/conversation.entity';
import { Message } from '../src/modules/chat/entities/message.entity';
import { Staff } from '../src/modules/staff/entities/staff.entity';
import { Role } from '../src/shared/auth/roles';
import { isUniqueViolation } from '../src/shared/database/db-errors';
import { createTestApp, seedStaff, TestApp } from './helpers';

describe('chat schema (e2e)', () => {
  let t: TestApp;
  let worker: Staff;
  let inspector: Staff;
  const now = new Date('2026-11-02T04:00:00.000Z');

  const conversations = () => t.dataSource.getRepository(Conversation);
  const messages = () => t.dataSource.getRepository(Message);
  const duplicate = (promise: Promise<unknown>) =>
    promise.then(
      () => false,
      (e: unknown) => isUniqueViolation(e),
    );

  function conversation(fields: Partial<Conversation> = {}): Partial<Conversation> {
    return { id: randomUUID(), convType: 'DIRECT', createdAt: now, ...fields };
  }

  async function directThread(): Promise<string> {
    const id = randomUUID();
    const key = `D:${[worker.id, inspector.id].sort().join(':')}`;
    await conversations().insert(conversation({ id, conversationKey: key }));
    return id;
  }

  function message(conversationId: string, fields: Partial<Message> = {}): Partial<Message> {
    return {
      id: randomUUID(),
      clientUuid: randomUUID(),
      conversationId,
      senderId: worker.id,
      body: 'नमस्कार',
      createdAt: now,
      ...fields,
    };
  }

  beforeAll(async () => {
    t = await createTestApp();
    worker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'C-WK1' });
    inspector = await seedStaff(t.dataSource, { role: Role.INSPECTOR, employeeCode: 'C-IN1' });
  });

  afterEach(async () => {
    for (const entity of [Message, ConversationParticipant, Conversation]) {
      await t.dataSource.createQueryBuilder().delete().from(entity).execute();
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it('never creates the same direct thread twice', async () => {
    await directThread();
    expect(await duplicate(directThread())).toBe(true);
  });

  it('lets broadcasts leave the key empty', async () => {
    await conversations().insert([
      conversation({ convType: 'CITY_BROADCAST' }),
      conversation({ convType: 'CITY_BROADCAST' }),
    ]);
    expect(await conversations().countBy({ convType: 'CITY_BROADCAST' })).toBe(2);
  });

  it('adds each participant once and defaults them to active', async () => {
    const conversationId = await directThread();
    const participant = (): Partial<ConversationParticipant> => ({
      conversationId,
      staffId: worker.id,
      joinedAt: now,
    });
    await t.dataSource.getRepository(ConversationParticipant).insert(participant());
    expect(
      await t.dataSource
        .getRepository(ConversationParticipant)
        .findOneByOrFail({ conversationId, staffId: worker.id }),
    ).toMatchObject({ isActive: true, lastReadAt: null });
    expect(
      await duplicate(t.dataSource.getRepository(ConversationParticipant).insert(participant())),
    ).toBe(true);
  });

  it('stores Marathi text, a voice clip and a location, and refuses a re-sent message', async () => {
    const conversationId = await directThread();
    const text = message(conversationId);
    await messages().insert([
      text,
      message(conversationId, {
        msgType: 'VOICE',
        body: null,
        storageKey: 'voice/2026/11/a.webm',
        durationSec: 12,
      }),
      message(conversationId, { msgType: 'LOCATION', body: null, lat: 16.8524, lng: 74.5815 }),
    ]);
    expect(await messages().findOneByOrFail({ id: text.id! })).toMatchObject({
      msgType: 'TEXT',
      body: 'नमस्कार',
    });
    expect(
      await duplicate(messages().insert(message(conversationId, { clientUuid: text.clientUuid }))),
    ).toBe(true);
  });

  it.each<[string, (conversationId: string) => Promise<unknown>]>([
    ['a text message without a body', (id) => messages().insert(message(id, { body: null }))],
    [
      'a voice message without a stored clip',
      (id) => messages().insert(message(id, { msgType: 'VOICE' })),
    ],
    [
      'a location message without coordinates',
      (id) => messages().insert(message(id, { msgType: 'LOCATION' })),
    ],
    [
      'a squad thread without inspector and date',
      () => conversations().insert(conversation({ convType: 'SQUAD_TEAM' })),
    ],
    [
      'a ward broadcast without a ward',
      () => conversations().insert(conversation({ convType: 'WARD_BROADCAST' })),
    ],
  ])('refuses %s', async (_label, insert) => {
    const conversationId = await directThread();
    await expect(insert(conversationId)).rejects.toThrow();
  });
});
