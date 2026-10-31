import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Corporation offices (v4 §4.2) and staff (v4 §2). Portable to Oracle 12c:
 * GeoJSON as text, booleans 0/1, app-generated UUIDs, names of 30 characters or fewer.
 */
export class CreateOfficesAndStaff1793232000000 implements MigrationInterface {
  name = 'CreateOfficesAndStaff1793232000000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);

    await queryRunner.createTable(
      new Table({
        name: 'corporation_offices',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'code', type: t.varchar, length: '20', isUnique: true },
          { name: 'name', type: t.unicodeVarchar, length: '100' },
          { name: 'name_mr', type: t.unicodeVarchar, length: '100' },
          { name: 'zone', type: t.varchar, length: '20' },
          { name: 'premises_geojson', type: t.longText },
          { name: 'buffer_meters', ...t.int, default: 100 },
          { name: 'is_active', ...t.bool, default: 1 },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          { name: 'ck_offices_zone', expression: `"zone" IN ('SANGLI', 'MIRAJ', 'KUPWAD')` },
          { name: 'ck_offices_is_active', expression: `"is_active" IN (0, 1)` },
          { name: 'ck_offices_buffer', expression: `"buffer_meters" BETWEEN 0 AND 300` },
        ],
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'staff',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'employee_code', type: t.varchar, length: '20', isUnique: true },
          { name: 'full_name', type: t.unicodeVarchar, length: '100' },
          { name: 'full_name_mr', type: t.unicodeVarchar, length: '100', isNullable: true },
          { name: 'phone', type: t.varchar, length: '10', isUnique: true },
          { name: 'role', type: t.varchar, length: '20' },
          { name: 'home_ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'office_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'reports_to_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'department', type: t.unicodeVarchar, length: '100', isNullable: true },
          { name: 'shift_start', type: t.varchar, length: '5' },
          { name: 'shift_end', type: t.varchar, length: '5' },
          { name: 'password_hash', type: t.varchar, length: '100', isNullable: true },
          { name: 'is_active', ...t.bool, default: 1 },
          { name: 'deactivated_at', type: t.timestamp, isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          {
            name: 'ck_staff_role',
            expression: `"role" IN ('ADMIN', 'WARD_INSPECTOR', 'INSPECTOR', 'WORKER', 'OFFICE_STAFF')`,
          },
          { name: 'ck_staff_is_active', expression: `"is_active" IN (0, 1)` },
        ],
        foreignKeys: [
          {
            name: 'fk_staff_home_ward',
            columnNames: ['home_ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_staff_office',
            columnNames: ['office_id'],
            referencedTableName: 'corporation_offices',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_staff_reports_to',
            columnNames: ['reports_to_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );

    for (const [name, column] of [
      ['ix_staff_role', 'role'],
      ['ix_staff_home_ward', 'home_ward_id'],
      ['ix_staff_office', 'office_id'],
      ['ix_staff_reports_to', 'reports_to_id'],
    ] as const) {
      await queryRunner.createIndex('staff', new TableIndex({ name, columnNames: [column] }));
    }
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('staff');
    await queryRunner.dropTable('corporation_offices');
  }
}
