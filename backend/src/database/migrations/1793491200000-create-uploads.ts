import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Photos staff attach (task evidence; voice notes later in Phase 4). The file lives on this
 * server's disk under UPLOAD_DIR; the database keeps only who uploaded what, its type, size and
 * SHA-256. client_uuid makes a retried upload from the phone's offline outbox land once.
 */
export class CreateUploads1793491200000 implements MigrationInterface {
  name = 'CreateUploads1793491200000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    await queryRunner.createTable(
      new Table({
        name: 'uploads',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36' },
          { name: 'owner_staff_id', type: t.varchar, length: '36' },
          { name: 'kind', type: t.varchar, length: '20' },
          { name: 'content_type', type: t.varchar, length: '30' },
          { name: 'size_bytes', ...t.int },
          { name: 'sha256', type: t.varchar, length: '64' },
          { name: 'storage_path', type: t.varchar, length: '200' },
          { name: 'created_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_uploads_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          { name: 'ck_uploads_kind', expression: `"kind" IN ('TASK_PHOTO')` },
          { name: 'ck_uploads_size', expression: `"size_bytes" > 0` },
        ],
        foreignKeys: [
          {
            name: 'fk_uploads_owner',
            columnNames: ['owner_staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'uploads',
      new TableIndex({
        name: 'ix_uploads_owner_time',
        columnNames: ['owner_staff_id', 'created_at'],
      }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('uploads');
  }
}
