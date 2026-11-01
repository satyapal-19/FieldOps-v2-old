import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Hierarchy-based chat (v4 §9): direct threads, squad threads per inspector per day, and
 * ward / city broadcasts. Messages are soft-deleted and kept as permanent history; voice
 * clips live in backend storage (storage_key) and are purged after 90 days by a job.
 *
 * Changes from the v4 schema:
 * - conversation_key is built in Node ("D:<staffA>:<staffB>" sorted, "S:<inspector>:<date>"),
 *   not an MD5 in SQL; UNIQUE stops duplicate threads.
 * - Messages carry a client UUID (sending from an offline phone is retry-safe).
 * - receiver_id is dropped: who can read a thread is decided by its participants.
 * - Each message type must carry its payload (text body, storage key, or coordinates).
 */
export class CreateChat1793318400300 implements MigrationInterface {
  name = 'CreateChat1793318400300';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    const lat = t.decimal(10, 7);

    await queryRunner.createTable(
      new Table({
        name: 'conversations',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'conversation_key', type: t.varchar, length: '80', isNullable: true },
          { name: 'conv_type', type: t.varchar, length: '20' },
          { name: 'title', type: t.unicodeVarchar, length: '150', isNullable: true },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'inspector_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'shift_date', type: t.date, isNullable: true },
          { name: 'is_archived', ...t.bool, default: 0 },
          { name: 'created_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'last_message_at', type: t.timestamp, isNullable: true },
          { name: 'created_at', type: t.timestamp },
          { name: 'deleted_at', type: t.timestamp, isNullable: true },
        ],
        uniques: [{ name: 'uq_conversations_key', columnNames: ['conversation_key'] }],
        checks: [
          {
            name: 'ck_conversations_type',
            expression: `"conv_type" IN ('DIRECT', 'SQUAD_TEAM', 'WARD_BROADCAST', 'CITY_BROADCAST')`,
          },
          { name: 'ck_conversations_is_archived', expression: `"is_archived" IN (0, 1)` },
          // A squad thread belongs to one inspector's team on one day; a ward broadcast to a ward.
          {
            name: 'ck_conversations_squad',
            expression: `"conv_type" <> 'SQUAD_TEAM' OR ("inspector_id" IS NOT NULL AND "shift_date" IS NOT NULL)`,
          },
          {
            name: 'ck_conversations_ward',
            expression: `"conv_type" <> 'WARD_BROADCAST' OR "ward_id" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          {
            name: 'fk_conversations_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_conversations_inspector',
            columnNames: ['inspector_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_conversations_created_by',
            columnNames: ['created_by_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_conversations_ward', ['ward_id']],
      ['ix_conversations_type_date', ['conv_type', 'shift_date']],
    ] as const) {
      await queryRunner.createIndex(
        'conversations',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'conversation_participants',
        columns: [
          { name: 'conversation_id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'is_active', ...t.bool, default: 1 },
          { name: 'joined_at', type: t.timestamp },
          { name: 'left_at', type: t.timestamp, isNullable: true },
          { name: 'last_read_at', type: t.timestamp, isNullable: true },
        ],
        checks: [{ name: 'ck_participants_is_active', expression: `"is_active" IN (0, 1)` }],
        foreignKeys: [
          {
            name: 'fk_participants_conversation',
            columnNames: ['conversation_id'],
            referencedTableName: 'conversations',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_participants_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    // The primary key covers lookups by conversation; this one serves "my threads".
    await queryRunner.createIndex(
      'conversation_participants',
      new TableIndex({
        name: 'ix_participants_staff_active',
        columnNames: ['staff_id', 'is_active'],
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'messages',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'conversation_id', type: t.varchar, length: '36' },
          { name: 'sender_id', type: t.varchar, length: '36' },
          { name: 'msg_type', type: t.varchar, length: '10', default: "'TEXT'" },
          { name: 'body', type: t.unicodeVarchar, length: '2000', isNullable: true },
          { name: 'storage_key', type: t.varchar, length: '100', isNullable: true },
          { name: 'mime_type', type: t.varchar, length: '50', isNullable: true },
          { name: 'size_bytes', ...t.int, isNullable: true },
          { name: 'duration_sec', ...t.int, isNullable: true },
          { name: 'lat', ...lat, isNullable: true },
          { name: 'lng', ...lat, isNullable: true },
          { name: 'created_at', type: t.timestamp },
          { name: 'deleted_at', type: t.timestamp, isNullable: true },
        ],
        uniques: [{ name: 'uq_messages_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_messages_type',
            expression: `"msg_type" IN ('TEXT', 'VOICE', 'IMAGE', 'LOCATION')`,
          },
          {
            name: 'ck_messages_payload',
            expression:
              `("msg_type" = 'TEXT' AND "body" IS NOT NULL) OR ` +
              `("msg_type" IN ('VOICE', 'IMAGE') AND "storage_key" IS NOT NULL) OR ` +
              `("msg_type" = 'LOCATION' AND "lat" IS NOT NULL AND "lng" IS NOT NULL)`,
          },
          {
            name: 'ck_messages_sizes',
            expression: `("size_bytes" IS NULL OR "size_bytes" >= 0) AND ("duration_sec" IS NULL OR "duration_sec" >= 0)`,
          },
        ],
        foreignKeys: [
          {
            name: 'fk_messages_conversation',
            columnNames: ['conversation_id'],
            referencedTableName: 'conversations',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_messages_sender',
            columnNames: ['sender_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_messages_conv_time', ['conversation_id', 'created_at']],
      ['ix_messages_sender', ['sender_id']],
      ['ix_messages_type_time', ['msg_type', 'created_at']],
    ] as const) {
      await queryRunner.createIndex(
        'messages',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('messages');
    await queryRunner.dropTable('conversation_participants');
    await queryRunner.dropTable('conversations');
  }
}
