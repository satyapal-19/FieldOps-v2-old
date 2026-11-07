import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * One notification interface (action plan Phase 4):
 * - notifications: each person's in-app inbox. The app polls it while on duty, so spot checks
 *   and alerts arrive even when push (FCM) is unavailable on the SMKC network.
 * - push_tokens: FCM registration tokens of signed-in phones (one row per token).
 */
export class CreateNotifications1793577600000 implements MigrationInterface {
  name = 'CreateNotifications1793577600000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    await queryRunner.createTable(
      new Table({
        name: 'notifications',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'kind', type: t.varchar, length: '20' },
          { name: 'priority', type: t.varchar, length: '10' },
          { name: 'title', type: t.unicodeVarchar, length: '150' },
          { name: 'title_mr', type: t.unicodeVarchar, length: '150', isNullable: true },
          { name: 'body', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'body_mr', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'ref_type', type: t.varchar, length: '20', isNullable: true },
          { name: 'ref_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'created_at', type: t.timestamp },
          { name: 'read_at', type: t.timestamp, isNullable: true },
        ],
        checks: [
          {
            name: 'ck_notif_kind',
            expression: `"kind" IN ('SPOT_CHECK', 'ALERT', 'TASK', 'CHAT', 'REQUEST', 'SYSTEM')`,
          },
          { name: 'ck_notif_priority', expression: `"priority" IN ('HIGH', 'NORMAL')` },
        ],
        foreignKeys: [
          {
            name: 'fk_notif_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'notifications',
      new TableIndex({ name: 'ix_notif_staff_time', columnNames: ['staff_id', 'created_at'] }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'push_tokens',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'token', type: t.varchar, length: '255' },
          { name: 'platform', type: t.varchar, length: '10' },
          { name: 'created_at', type: t.timestamp },
          { name: 'last_seen_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_push_tokens_token', columnNames: ['token'] }],
        checks: [{ name: 'ck_push_platform', expression: `"platform" IN ('ANDROID', 'IOS')` }],
        foreignKeys: [
          {
            name: 'fk_push_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'push_tokens',
      new TableIndex({ name: 'ix_push_staff', columnNames: ['staff_id'] }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('push_tokens');
    await queryRunner.dropTable('notifications');
  }
}
