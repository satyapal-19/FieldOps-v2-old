import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * One-time liveness challenges (action plan Phase 2). The app asks for a challenge before the
 * camera opens, performs the prompted actions with ML Kit, and sends the challenge ID with the
 * face crop; the punch consumes it with a guarded update (used_at IS NULL), so a captured
 * request cannot be replayed. Rows are purged by the retention job a day after they expire.
 */
export class CreateLivenessChallenges1793404800000 implements MigrationInterface {
  name = 'CreateLivenessChallenges1793404800000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);

    await queryRunner.createTable(
      new Table({
        name: 'liveness_challenges',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'subject_id', type: t.varchar, length: '36' },
          { name: 'issued_to_id', type: t.varchar, length: '36' },
          { name: 'actions', type: t.varchar, length: '60' },
          { name: 'issued_at', type: t.timestamp },
          { name: 'expires_at', type: t.timestamp },
          { name: 'used_at', type: t.timestamp, isNullable: true },
        ],
        checks: [{ name: 'ck_liveness_expiry', expression: `"expires_at" > "issued_at"` }],
        foreignKeys: [
          {
            name: 'fk_liveness_subject',
            columnNames: ['subject_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_liveness_issued_to',
            columnNames: ['issued_to_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'liveness_challenges',
      new TableIndex({ name: 'ix_liveness_expires', columnNames: ['expires_at'] }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('liveness_challenges');
  }
}
