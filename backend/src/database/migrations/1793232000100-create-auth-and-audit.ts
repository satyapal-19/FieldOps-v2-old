import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/** Sign-in codes, device sessions and the audit trail (SMKC security checklist). */
export class CreateAuthAndAudit1793232000100 implements MigrationInterface {
  name = 'CreateAuthAndAudit1793232000100';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);

    await queryRunner.createTable(
      new Table({
        name: 'auth_otps',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'phone', type: t.varchar, length: '10' },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'code_hash', type: t.varchar, length: '64' },
          { name: 'expires_at', type: t.timestamp },
          { name: 'attempts', ...t.int, default: 0 },
          { name: 'consumed_at', type: t.timestamp, isNullable: true },
          { name: 'created_at', type: t.timestamp },
        ],
        foreignKeys: [
          { name: 'fk_auth_otps_staff', columnNames: ['staff_id'], referencedTableName: 'staff', referencedColumnNames: ['id'] },
        ],
      }),
    );
    await queryRunner.createIndex(
      'auth_otps',
      new TableIndex({ name: 'ix_auth_otps_phone_created', columnNames: ['phone', 'created_at'] }),
    );
    await queryRunner.createIndex('auth_otps', new TableIndex({ name: 'ix_auth_otps_staff', columnNames: ['staff_id'] }));

    await queryRunner.createTable(
      new Table({
        name: 'auth_sessions',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'refresh_hash', type: t.varchar, length: '64' },
          { name: 'method', type: t.varchar, length: '10' },
          { name: 'device_id', type: t.varchar, length: '100', isNullable: true },
          { name: 'user_agent', type: t.unicodeVarchar, length: '200', isNullable: true },
          { name: 'ip', type: t.varchar, length: '45', isNullable: true },
          { name: 'created_at', type: t.timestamp },
          { name: 'last_refreshed_at', type: t.timestamp, isNullable: true },
          { name: 'expires_at', type: t.timestamp },
          { name: 'revoked_at', type: t.timestamp, isNullable: true },
          { name: 'revoke_reason', type: t.varchar, length: '20', isNullable: true },
        ],
        checks: [{ name: 'ck_auth_sessions_method', expression: `"method" IN ('OTP', 'PASSWORD', 'TEST')` }],
        foreignKeys: [
          {
            name: 'fk_auth_sessions_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'auth_sessions',
      new TableIndex({ name: 'ix_auth_sessions_staff', columnNames: ['staff_id'] }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'audit_log',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'occurred_at', type: t.timestamp },
          { name: 'actor_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'actor_role', type: t.varchar, length: '20', isNullable: true },
          { name: 'action', type: t.varchar, length: '60' },
          { name: 'entity_type', type: t.varchar, length: '40' },
          { name: 'entity_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'request_id', type: t.varchar, length: '64', isNullable: true },
          { name: 'ip', type: t.varchar, length: '45', isNullable: true },
          { name: 'details_json', type: t.longText, isNullable: true },
        ],
      }),
    );
    // No foreign keys on audit_log: audit rows must outlive anything they describe.
    for (const [name, columns] of [
      ['ix_audit_entity', ['entity_type', 'entity_id']],
      ['ix_audit_actor_time', ['actor_id', 'occurred_at']],
      ['ix_audit_time', ['occurred_at']],
    ] as const) {
      await queryRunner.createIndex('audit_log', new TableIndex({ name, columnNames: [...columns] }));
    }
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('audit_log');
    await queryRunner.dropTable('auth_sessions');
    await queryRunner.dropTable('auth_otps');
  }
}
