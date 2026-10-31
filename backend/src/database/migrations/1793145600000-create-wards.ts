import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Wards: the 20 SMKMC prabhags. Portable across PostgreSQL and Oracle 12c:
 * no PostGIS (boundary is GeoJSON text), UUIDs as VARCHAR(36), booleans as 0/1.
 * Column names in CHECK constraints are double-quoted because TypeORM creates
 * lower-case quoted identifiers on Oracle.
 */
export class CreateWards1793145600000 implements MigrationInterface {
  name = 'CreateWards1793145600000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);

    await queryRunner.createTable(
      new Table({
        name: 'wards',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'code', type: t.varchar, length: '20', isUnique: true },
          { name: 'name', type: t.unicodeVarchar, length: '100' },
          { name: 'name_mr', type: t.unicodeVarchar, length: '100' },
          { name: 'zone', type: t.varchar, length: '20' },
          { name: 'boundary_geojson', type: t.longText },
          { name: 'is_active', ...t.bool, default: 1 },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          { name: 'ck_wards_zone', expression: `"zone" IN ('SANGLI', 'MIRAJ', 'KUPWAD')` },
          { name: 'ck_wards_is_active', expression: `"is_active" IN (0, 1)` },
        ],
      }),
    );

    await queryRunner.createIndex(
      'wards',
      new TableIndex({ name: 'ix_wards_zone', columnNames: ['zone'] }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropIndex('wards', 'ix_wards_zone');
    await queryRunner.dropTable('wards');
  }
}
