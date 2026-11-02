import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Scheduled-job locks and the summary tables the nightly jobs fill (action plan Phase 2, R7).
 *
 * - job_locks: one row per job. Every PM2 instance runs the scheduler; a guarded update on
 *   this row lets exactly one of them run each slot (last_run_key) and stops overlap
 *   (locked_until). No pg_cron, no advisory locks: plain rows work the same on Oracle.
 * - route_summaries: one row per person per IST attendance date, rolled up from the raw
 *   pings before they are purged. Aggregates only, no coordinates, so ending the 90-day
 *   ping retention really removes the location history.
 * - ward_daily_summaries: attendance counts per ward per day for dashboards and reports.
 */
export class CreateJobsAndSummaries1793404800100 implements MigrationInterface {
  name = 'CreateJobsAndSummaries1793404800100';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    const count = (name: string) => ({ name, ...t.int, default: 0 });

    await queryRunner.createTable(
      new Table({
        name: 'job_locks',
        columns: [
          { name: 'job_name', type: t.varchar, length: '50', isPrimary: true },
          { name: 'locked_by', type: t.varchar, length: '100', isNullable: true },
          { name: 'locked_until', type: t.timestamp, isNullable: true },
          { name: 'last_run_key', type: t.varchar, length: '30', isNullable: true },
          { name: 'last_started_at', type: t.timestamp, isNullable: true },
          { name: 'last_finished_at', type: t.timestamp, isNullable: true },
          { name: 'last_status', type: t.varchar, length: '10', isNullable: true },
          { name: 'last_result', type: t.unicodeVarchar, length: '500', isNullable: true },
        ],
        checks: [
          {
            name: 'ck_job_locks_status',
            expression: `"last_status" IS NULL OR "last_status" IN ('RUNNING', 'OK', 'FAILED')`,
          },
        ],
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'route_summaries',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'summary_date', type: t.date },
          { name: 'attendance_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          count('ping_count'),
          count('distance_m'),
          { name: 'first_ping_at', type: t.timestamp, isNullable: true },
          { name: 'last_ping_at', type: t.timestamp, isNullable: true },
          count('in_ward_pings'),
          count('out_ward_pings'),
          count('stationary_pings'),
          count('mocked_pings'),
          count('offline_pings'),
          { name: 'max_gap_minutes', ...t.int, isNullable: true },
          count('tamper_events'),
          { name: 'computed_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_route_staff_date', columnNames: ['staff_id', 'summary_date'] }],
        checks: [
          {
            name: 'ck_route_counts',
            expression:
              `"ping_count" >= 0 AND "distance_m" >= 0 AND "in_ward_pings" + "out_ward_pings" <= "ping_count" ` +
              `AND "stationary_pings" <= "ping_count" AND "mocked_pings" <= "ping_count" ` +
              `AND "offline_pings" <= "ping_count"`,
          },
        ],
        // attendance_id has no foreign key, like location_pings: the roll-up rewrites rows
        // freely and never has to order its writes against attendance rows.
        foreignKeys: [
          {
            name: 'fk_route_staff',
            columnNames: ['staff_id'],
            referencedTableName: 'staff',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_route_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'route_summaries',
      new TableIndex({ name: 'ix_route_date_ward', columnNames: ['summary_date', 'ward_id'] }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'ward_daily_summaries',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'ward_id', type: t.varchar, length: '36' },
          { name: 'summary_date', type: t.date },
          count('assigned_count'),
          count('present_count'),
          count('late_count'),
          count('half_day_count'),
          count('absent_count'),
          count('on_leave_count'),
          count('proxy_count'),
          count('auto_checkout_count'),
          count('suspicious_count'),
          count('distance_m'),
          { name: 'computed_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_ward_summary_date', columnNames: ['ward_id', 'summary_date'] }],
        checks: [
          {
            name: 'ck_ward_summary_counts',
            expression:
              `"assigned_count" >= 0 AND "present_count" >= 0 AND "absent_count" >= 0 ` +
              `AND "late_count" <= "present_count" AND "half_day_count" <= "present_count"`,
          },
        ],
        foreignKeys: [
          {
            name: 'fk_ward_summary_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
        ],
      }),
    );
    await queryRunner.createIndex(
      'ward_daily_summaries',
      new TableIndex({ name: 'ix_ward_summary_date', columnNames: ['summary_date'] }),
    );
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('ward_daily_summaries');
    await queryRunner.dropTable('route_summaries');
    await queryRunner.dropTable('job_locks');
  }
}
