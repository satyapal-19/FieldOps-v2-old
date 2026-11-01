import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Standing rosters (the default squad), daily assignments (approved exceptions per IST date)
 * and per-day shift overrides (v4 §3, action plan Phase 1).
 *
 * Changes from the v4 schema:
 * - daily_assignments has one row per person placed for the day (staff_id + staff_role)
 *   instead of a nullable worker_id. UNIQUE (shift_date, staff_id) then covers both
 *   "one assignment per worker per day" and "one ward per inspector per day", and stays
 *   correct on Oracle, which treats NULLs in a partly-null composite key as equal.
 * - is_approved defaults to 0: self-picked and self-joined rows start unapproved.
 * - client_uuid makes offline self-pick / self-join retries safe.
 * - Shift times are IST wall-clock "HH:MM" text (Oracle has no TIME type); a NIGHT shift
 *   whose end is before its start ends on the next day.
 */
export class CreateRostersAndShifts1793318400000 implements MigrationInterface {
  name = 'CreateRostersAndShifts1793318400000';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);

    await queryRunner.createTable(
      new Table({
        name: 'standing_rosters',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'ward_id', type: t.varchar, length: '36' },
          { name: 'ward_inspector_id', type: t.varchar, length: '36' },
          { name: 'inspector_id', type: t.varchar, length: '36' },
          { name: 'worker_id', type: t.varchar, length: '36', isUnique: true },
          { name: 'is_active', ...t.bool, default: 1 },
          { name: 'created_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          { name: 'ck_rosters_is_active', expression: `"is_active" IN (0, 1)` },
          { name: 'ck_rosters_distinct', expression: `"worker_id" <> "inspector_id"` },
        ],
        foreignKeys: [
          {
            name: 'fk_rosters_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_rosters_ward_inspector',
            columnNames: ['ward_inspector_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_rosters_inspector',
            columnNames: ['inspector_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_rosters_worker',
            columnNames: ['worker_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_rosters_created_by',
            columnNames: ['created_by_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    for (const [name, column] of [
      ['ix_rosters_ward', 'ward_id'],
      ['ix_rosters_ward_inspector', 'ward_inspector_id'],
      ['ix_rosters_inspector', 'inspector_id'],
    ] as const) {
      await queryRunner.createIndex(
        'standing_rosters',
        new TableIndex({ name, columnNames: [column] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'daily_assignments',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'shift_date', type: t.date },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'staff_role', type: t.varchar, length: '20' },
          { name: 'ward_id', type: t.varchar, length: '36' },
          { name: 'ward_inspector_id', type: t.varchar, length: '36' },
          { name: 'inspector_id', type: t.varchar, length: '36' },
          { name: 'assignment_mode', type: t.varchar, length: '30' },
          { name: 'is_approved', ...t.bool, default: 0 },
          { name: 'approved_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'approved_at', type: t.timestamp, isNullable: true },
          { name: 'assigned_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [
          { name: 'uq_daily_asg_date_staff', columnNames: ['shift_date', 'staff_id'] },
          { name: 'uq_daily_asg_client_uuid', columnNames: ['client_uuid'] },
        ],
        checks: [
          { name: 'ck_daily_asg_role', expression: `"staff_role" IN ('INSPECTOR', 'WORKER')` },
          {
            name: 'ck_daily_asg_mode',
            expression:
              `"assignment_mode" IN ('STANDING_ROSTER', 'ADMIN_ASSIGNED', 'WARD_INSPECTOR_ASSIGNED', ` +
              `'INSPECTOR_SELF_PICK', 'WORKER_SELF_JOIN')`,
          },
          // An inspector row leads its own team; a worker row points at a different inspector.
          {
            name: 'ck_daily_asg_inspector',
            expression:
              `("staff_role" = 'INSPECTOR' AND "inspector_id" = "staff_id") OR ` +
              `("staff_role" = 'WORKER' AND "inspector_id" <> "staff_id")`,
          },
          { name: 'ck_daily_asg_is_approved', expression: `"is_approved" IN (0, 1)` },
          {
            name: 'ck_daily_asg_approved_at',
            expression: `"is_approved" = 0 OR "approved_at" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          {
            name: 'fk_daily_asg_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_daily_asg_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_daily_asg_ward_inspector',
            columnNames: ['ward_inspector_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_daily_asg_inspector',
            columnNames: ['inspector_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_daily_asg_approved_by',
            columnNames: ['approved_by_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_daily_asg_assigned_by',
            columnNames: ['assigned_by_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    // (shift_date, staff_id) is already indexed by its unique constraint.
    for (const [name, columns] of [
      ['ix_daily_asg_date_ward', ['shift_date', 'ward_id']],
      ['ix_daily_asg_date_inspector', ['shift_date', 'inspector_id']],
    ] as const) {
      await queryRunner.createIndex(
        'daily_assignments',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'shifts',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'shift_date', type: t.date },
          { name: 'shift_type', type: t.varchar, length: '20' },
          { name: 'start_time', type: t.varchar, length: '5' },
          { name: 'end_time', type: t.varchar, length: '5' },
          { name: 'created_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_shifts_staff_date', columnNames: ['staff_id', 'shift_date'] }],
        checks: [
          {
            name: 'ck_shifts_type',
            expression: `"shift_type" IN ('MORNING', 'EVENING', 'NIGHT', 'GENERAL_OFFICE')`,
          },
          { name: 'ck_shifts_start_fmt', expression: `"start_time" LIKE '__:__'` },
          { name: 'ck_shifts_end_fmt', expression: `"end_time" LIKE '__:__'` },
          { name: 'ck_shifts_times_differ', expression: `"start_time" <> "end_time"` },
        ],
        foreignKeys: [
          {
            name: 'fk_shifts_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_shifts_created_by',
            columnNames: ['created_by_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'shifts',
      new TableIndex({ name: 'ix_shifts_date', columnNames: ['shift_date'] }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('shifts');
    await queryRunner.dropTable('daily_assignments');
    await queryRunner.dropTable('standing_rosters');
  }
}
