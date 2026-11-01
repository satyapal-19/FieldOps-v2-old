import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Attendance, location pings, tamper events and spot checks (v4 §4–§7, action plan Phase 1).
 *
 * Changes from the v4 schema:
 * - Every phone write carries a client UUID with a unique constraint (offline retries are safe):
 *   check-in and check-out each have one, as do pings, tamper events and spot-check answers.
 * - All times are real UTC; attendance_date / shift_date are the IST calendar date.
 * - Face crops and selfies are never stored, so there are no photo URL columns; face_passed
 *   defaults to 0 (no fail-open). The liveness challenge used for each punch is recorded.
 * - No PostGIS: latitude / longitude are DECIMAL(10,7); geofence results are computed in Node.
 * - Proxy punches record who marked them, separately for check-in and check-out.
 * - Spot checks follow the safer v4 variant: one notification, a 10-minute window, one snooze.
 */
export class CreateAttendanceAndTracking1793318400100 implements MigrationInterface {
  name = 'CreateAttendanceAndTracking1793318400100';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    const lat = t.decimal(10, 7);
    const meters = t.decimal(8, 2);
    const score = t.decimal(5, 4);
    const staffFk = (name: string, column: string) => ({
      name,
      columnNames: [column],
      referencedTableName: 'staff',
      referencedColumnNames: ['id'],
    });

    await queryRunner.createTable(
      new Table({
        name: 'attendance_logs',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'attendance_date', type: t.date },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'office_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'assignment_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'shift_type', type: t.varchar, length: '20', isNullable: true },
          { name: 'status', type: t.varchar, length: '20', default: "'ABSENT'" },
          { name: 'is_late', ...t.bool, default: 0 },
          { name: 'late_minutes', ...t.int, default: 0 },
          { name: 'worked_minutes', ...t.int, isNullable: true },
          // Check-in
          { name: 'checkin_client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'checkin_at', type: t.timestamp, isNullable: true },
          { name: 'checkin_lat', ...lat, isNullable: true },
          { name: 'checkin_lng', ...lat, isNullable: true },
          { name: 'checkin_accuracy_m', ...meters, isNullable: true },
          { name: 'checkin_in_geofence', ...t.bool, default: 0 },
          { name: 'checkin_distance_m', ...meters, isNullable: true },
          { name: 'checkin_is_mocked', ...t.bool, default: 0 },
          { name: 'checkin_challenge_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'checkin_face_score', ...score, isNullable: true },
          { name: 'checkin_face_passed', ...t.bool, default: 0 },
          { name: 'checkin_mode', type: t.varchar, length: '20', isNullable: true },
          { name: 'checkin_marked_by_id', type: t.varchar, length: '36', isNullable: true },
          // Check-out
          { name: 'checkout_client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'checkout_at', type: t.timestamp, isNullable: true },
          { name: 'checkout_lat', ...lat, isNullable: true },
          { name: 'checkout_lng', ...lat, isNullable: true },
          { name: 'checkout_accuracy_m', ...meters, isNullable: true },
          { name: 'checkout_in_geofence', ...t.bool, isNullable: true },
          { name: 'checkout_type', type: t.varchar, length: '30', isNullable: true },
          { name: 'checkout_mode', type: t.varchar, length: '20', isNullable: true },
          { name: 'checkout_marked_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'is_suspicious', ...t.bool, default: 0 },
          { name: 'notes', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [
          { name: 'uq_attendance_staff_date', columnNames: ['staff_id', 'attendance_date'] },
          { name: 'uq_attendance_checkin_uuid', columnNames: ['checkin_client_uuid'] },
          { name: 'uq_attendance_checkout_uuid', columnNames: ['checkout_client_uuid'] },
        ],
        checks: [
          {
            name: 'ck_attendance_status',
            expression: `"status" IN ('PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'HOLIDAY_OFF', 'ON_LEAVE', 'REGULARIZED')`,
          },
          {
            name: 'ck_attendance_shift_type',
            expression: `"shift_type" IS NULL OR "shift_type" IN ('MORNING', 'EVENING', 'NIGHT', 'GENERAL_OFFICE')`,
          },
          {
            name: 'ck_attendance_checkin_mode',
            expression: `"checkin_mode" IS NULL OR "checkin_mode" IN ('SELF', 'INSPECTOR_PROXY', 'ADMIN_PROXY')`,
          },
          {
            name: 'ck_attendance_checkout_mode',
            expression: `"checkout_mode" IS NULL OR "checkout_mode" IN ('SELF', 'INSPECTOR_PROXY', 'ADMIN_PROXY')`,
          },
          {
            name: 'ck_attendance_checkout_type',
            expression:
              `"checkout_type" IS NULL OR "checkout_type" IN ` +
              `('MANUAL', 'AUTO_GPS_LAST_SEEN', 'AUTO_OFFICE_SCHEDULED', 'SUPERVISOR_OVERRIDE')`,
          },
          { name: 'ck_attendance_late_minutes', expression: `"late_minutes" >= 0` },
          // A check-out needs a check-in first, and cannot be earlier.
          {
            name: 'ck_attendance_checkout_order',
            expression: `"checkout_at" IS NULL OR ("checkin_at" IS NOT NULL AND "checkout_at" >= "checkin_at")`,
          },
          // Every punch is either in a ward or at an office, never both.
          { name: 'ck_attendance_place', expression: `"ward_id" IS NULL OR "office_id" IS NULL` },
          {
            name: 'ck_attendance_bools',
            expression: `"is_late" IN (0, 1) AND "is_suspicious" IN (0, 1)`,
          },
          {
            name: 'ck_attendance_checkin_bools',
            expression: `"checkin_in_geofence" IN (0, 1) AND "checkin_is_mocked" IN (0, 1) AND "checkin_face_passed" IN (0, 1)`,
          },
        ],
        foreignKeys: [
          staffFk('fk_attendance_staff', 'staff_id'),
          {
            name: 'fk_attendance_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_attendance_office',
            columnNames: ['office_id'],
            referencedTableName: 'corporation_offices',
            referencedColumnNames: ['id'],
          },
          {
            name: 'fk_attendance_assignment',
            columnNames: ['assignment_id'],
            referencedTableName: 'daily_assignments',
            referencedColumnNames: ['id'],
          },
          staffFk('fk_attendance_checkin_by', 'checkin_marked_by_id'),
          staffFk('fk_attendance_checkout_by', 'checkout_marked_by_id'),
        ],
      }),
    );
    // (staff_id, attendance_date) is already indexed by its unique constraint.
    for (const [name, columns] of [
      ['ix_attendance_date_ward', ['attendance_date', 'ward_id']],
      ['ix_attendance_date_office', ['attendance_date', 'office_id']],
      ['ix_attendance_date_status', ['attendance_date', 'status']],
    ] as const) {
      await queryRunner.createIndex(
        'attendance_logs',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    // ~190k rows a day: keep it narrow. Rolled up nightly and purged after 90 days (Phase 2 job).
    await queryRunner.createTable(
      new Table({
        name: 'location_pings',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36' },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'attendance_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'lat', ...lat },
          { name: 'lng', ...lat },
          { name: 'accuracy_m', ...meters, isNullable: true },
          { name: 'battery_pct', ...t.int, isNullable: true },
          { name: 'in_ward', ...t.bool, isNullable: true },
          { name: 'is_mocked', ...t.bool, default: 0 },
          { name: 'is_stationary', ...t.bool, default: 0 },
          { name: 'from_offline', ...t.bool, default: 0 },
          { name: 'recorded_at', type: t.timestamp },
          { name: 'received_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_pings_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_pings_battery',
            expression: `"battery_pct" IS NULL OR "battery_pct" BETWEEN 0 AND 100`,
          },
          {
            name: 'ck_pings_bools',
            expression: `"is_mocked" IN (0, 1) AND "is_stationary" IN (0, 1) AND "from_offline" IN (0, 1)`,
          },
        ],
        // attendance_id has no foreign key on purpose: bulk ping inserts stay cheap and the
        // retention purge never has to order deletes against attendance rows.
        foreignKeys: [staffFk('fk_pings_staff', 'staff_id')],
      }),
    );
    for (const [name, columns] of [
      ['ix_pings_staff_time', ['staff_id', 'recorded_at']],
      ['ix_pings_recorded', ['recorded_at']],
    ] as const) {
      await queryRunner.createIndex(
        'location_pings',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'tamper_events',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'event_type', type: t.varchar, length: '30' },
          { name: 'source', type: t.varchar, length: '10' },
          { name: 'started_at', type: t.timestamp },
          { name: 'resolved_at', type: t.timestamp, isNullable: true },
          { name: 'last_lat', ...lat, isNullable: true },
          { name: 'last_lng', ...lat, isNullable: true },
          { name: 'created_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_tamper_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_tamper_event_type',
            expression:
              `"event_type" IN ('GPS_DISABLED', 'PERMISSION_REVOKED', 'AIRPLANE_MODE', 'DATA_DISABLED', ` +
              `'DEVICE_OFFLINE', 'MOCK_LOCATION', 'SILENT_GAP')`,
          },
          // DEVICE reports come from the phone watchdog; SERVER rows from silent-gap detection.
          { name: 'ck_tamper_source', expression: `"source" IN ('DEVICE', 'SERVER')` },
          {
            name: 'ck_tamper_order',
            expression: `"resolved_at" IS NULL OR "resolved_at" >= "started_at"`,
          },
        ],
        foreignKeys: [staffFk('fk_tamper_staff', 'staff_id')],
      }),
    );
    await queryRunner.createIndex(
      'tamper_events',
      new TableIndex({ name: 'ix_tamper_staff_started', columnNames: ['staff_id', 'started_at'] }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'spot_checks',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'shift_date', type: t.date },
          { name: 'trigger_type', type: t.varchar, length: '20' },
          { name: 'initiated_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'reason', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'status', type: t.varchar, length: '20', default: "'SCHEDULED'" },
          { name: 'scheduled_at', type: t.timestamp },
          { name: 'notified_at', type: t.timestamp, isNullable: true },
          { name: 'due_at', type: t.timestamp, isNullable: true },
          { name: 'snooze_count', ...t.int, default: 0 },
          { name: 'response_client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'responded_at', type: t.timestamp, isNullable: true },
          { name: 'response_lat', ...lat, isNullable: true },
          { name: 'response_lng', ...lat, isNullable: true },
          { name: 'response_accuracy_m', ...meters, isNullable: true },
          { name: 'response_in_geofence', ...t.bool, isNullable: true },
          { name: 'face_score', ...score, isNullable: true },
          { name: 'escalated_at', type: t.timestamp, isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_spot_response_uuid', columnNames: ['response_client_uuid'] }],
        checks: [
          { name: 'ck_spot_trigger', expression: `"trigger_type" IN ('RANDOM', 'SENIOR_MANUAL')` },
          {
            name: 'ck_spot_status',
            expression:
              `"status" IN ('SCHEDULED', 'NOTIFIED', 'SNOOZED', 'VERIFIED', 'MISSED', 'FACE_MISMATCH', ` +
              `'OUT_OF_GEOFENCE', 'UNREACHABLE', 'CANCELLED')`,
          },
          { name: 'ck_spot_snooze', expression: `"snooze_count" BETWEEN 0 AND 1` },
          // A senior-triggered check names who asked for it.
          {
            name: 'ck_spot_initiator',
            expression: `"trigger_type" = 'RANDOM' OR "initiated_by_id" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          staffFk('fk_spot_staff', 'staff_id'),
          {
            name: 'fk_spot_ward',
            columnNames: ['ward_id'],
            referencedTableName: 'wards',
            referencedColumnNames: ['id'],
          },
          staffFk('fk_spot_initiated_by', 'initiated_by_id'),
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_spot_staff_date', ['staff_id', 'shift_date']],
      ['ix_spot_status_due', ['status', 'due_at']],
    ] as const) {
      await queryRunner.createIndex(
        'spot_checks',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('spot_checks');
    await queryRunner.dropTable('tamper_events');
    await queryRunner.dropTable('location_pings');
    await queryRunner.dropTable('attendance_logs');
  }
}
