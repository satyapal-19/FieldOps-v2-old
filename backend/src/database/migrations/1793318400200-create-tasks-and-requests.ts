import { MigrationInterface, QueryRunner, Table, TableIndex } from 'typeorm';
import { migrationColumnTypes } from '../../shared/database/column-types';

/**
 * Tasks, citizen complaints, leave, attendance regularization, holidays and alerts
 * (v4 §8–§11, action plan Phase 1).
 *
 * Changes from the v4 schema:
 * - No trigger or sequence for complaint tracking IDs: Node generates them; UNIQUE guards them.
 * - Phone task updates go to task_updates with a client UUID (retry-safe, and the history).
 * - Photos are storage keys from the backend upload service, never public URLs.
 * - Only tasks point at complaints (no circular foreign key).
 * - alerts.details_json is text (no JSONB); dedupe_key stops a job raising the same alert twice.
 */
export class CreateTasksAndRequests1793318400200 implements MigrationInterface {
  name = 'CreateTasksAndRequests1793318400200';

  async up(queryRunner: QueryRunner): Promise<void> {
    const t = migrationColumnTypes(queryRunner.connection.options.type);
    const lat = t.decimal(10, 7);
    const fk = (name: string, column: string, table = 'staff') => ({
      name,
      columnNames: [column],
      referencedTableName: table,
      referencedColumnNames: ['id'],
    });
    const reviewStatus = (name: string) => ({
      name,
      expression: `"status" IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED')`,
    });

    await queryRunner.createTable(
      new Table({
        name: 'citizen_complaints',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'tracking_id', type: t.varchar, length: '20', isUnique: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'citizen_name', type: t.unicodeVarchar, length: '100', isNullable: true },
          { name: 'citizen_phone', type: t.varchar, length: '10', isNullable: true },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'category', type: t.varchar, length: '20' },
          { name: 'description', type: t.unicodeVarchar, length: '1000' },
          { name: 'photo_key', type: t.varchar, length: '100', isNullable: true },
          { name: 'lat', ...lat, isNullable: true },
          { name: 'lng', ...lat, isNullable: true },
          { name: 'status', type: t.varchar, length: '20', default: "'RECEIVED'" },
          { name: 'resolved_at', type: t.timestamp, isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_complaints_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_complaints_category',
            expression: `"category" IN ('GARBAGE', 'DRAIN', 'ROAD', 'WATER', 'TREE', 'STRAY_ANIMAL', 'OTHER')`,
          },
          {
            name: 'ck_complaints_status',
            expression: `"status" IN ('RECEIVED', 'ASSIGNED', 'IN_PROGRESS', 'RESOLVED', 'CLOSED', 'REJECTED')`,
          },
        ],
        foreignKeys: [fk('fk_complaints_ward', 'ward_id', 'wards')],
      }),
    );
    for (const [name, columns] of [
      ['ix_complaints_ward_status', ['ward_id', 'status']],
      ['ix_complaints_created', ['created_at']],
    ] as const) {
      await queryRunner.createIndex(
        'citizen_complaints',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'tasks',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'title', type: t.unicodeVarchar, length: '200' },
          { name: 'title_mr', type: t.unicodeVarchar, length: '200', isNullable: true },
          { name: 'description', type: t.unicodeVarchar, length: '1000', isNullable: true },
          { name: 'priority', type: t.varchar, length: '10', default: "'NORMAL'" },
          { name: 'status', type: t.varchar, length: '20', default: "'OPEN'" },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'assigned_to_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'created_by_id', type: t.varchar, length: '36' },
          { name: 'complaint_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'location_lat', ...lat, isNullable: true },
          { name: 'location_lng', ...lat, isNullable: true },
          { name: 'location_label', type: t.unicodeVarchar, length: '200', isNullable: true },
          { name: 'due_at', type: t.timestamp, isNullable: true },
          { name: 'started_at', type: t.timestamp, isNullable: true },
          { name: 'submitted_at', type: t.timestamp, isNullable: true },
          { name: 'closed_at', type: t.timestamp, isNullable: true },
          { name: 'before_photo_key', type: t.varchar, length: '100', isNullable: true },
          { name: 'after_photo_key', type: t.varchar, length: '100', isNullable: true },
          { name: 'completion_note', type: t.unicodeVarchar, length: '1000', isNullable: true },
          { name: 'rejection_reason', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'rejection_count', ...t.int, default: 0 },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          { name: 'ck_tasks_priority', expression: `"priority" IN ('URGENT', 'NORMAL', 'LOW')` },
          {
            name: 'ck_tasks_status',
            expression: `"status" IN ('OPEN', 'IN_PROGRESS', 'SUBMITTED', 'APPROVED', 'REJECTED', 'ESCALATED', 'CLOSED')`,
          },
          { name: 'ck_tasks_rejection_count', expression: `"rejection_count" >= 0` },
        ],
        foreignKeys: [
          fk('fk_tasks_ward', 'ward_id', 'wards'),
          fk('fk_tasks_assigned_to', 'assigned_to_id'),
          fk('fk_tasks_created_by', 'created_by_id'),
          fk('fk_tasks_complaint', 'complaint_id', 'citizen_complaints'),
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_tasks_assignee_status', ['assigned_to_id', 'status']],
      ['ix_tasks_ward_status', ['ward_id', 'status']],
      ['ix_tasks_complaint', ['complaint_id']],
      ['ix_tasks_status_due', ['status', 'due_at']],
    ] as const) {
      await queryRunner.createIndex('tasks', new TableIndex({ name, columnNames: [...columns] }));
    }

    await queryRunner.createTable(
      new Table({
        name: 'task_updates',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'task_id', type: t.varchar, length: '36' },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'from_status', type: t.varchar, length: '20' },
          { name: 'to_status', type: t.varchar, length: '20' },
          { name: 'note', type: t.unicodeVarchar, length: '1000', isNullable: true },
          { name: 'photo_key', type: t.varchar, length: '100', isNullable: true },
          { name: 'lat', ...lat, isNullable: true },
          { name: 'lng', ...lat, isNullable: true },
          { name: 'created_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_task_updates_client_uuid', columnNames: ['client_uuid'] }],
        foreignKeys: [
          fk('fk_task_updates_task', 'task_id', 'tasks'),
          fk('fk_task_updates_staff', 'staff_id'),
        ],
      }),
    );
    await queryRunner.createIndex(
      'task_updates',
      new TableIndex({ name: 'ix_task_updates_task_time', columnNames: ['task_id', 'created_at'] }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'leave_requests',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'leave_type', type: t.varchar, length: '20' },
          { name: 'from_date', type: t.date },
          { name: 'to_date', type: t.date },
          { name: 'days_count', ...t.int },
          { name: 'reason', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'status', type: t.varchar, length: '20', default: "'PENDING'" },
          { name: 'reviewed_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'reviewed_at', type: t.timestamp, isNullable: true },
          { name: 'review_note', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_leave_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_leave_type',
            expression: `"leave_type" IN ('CASUAL', 'SICK', 'EARNED', 'WEEKLY_OFF')`,
          },
          reviewStatus('ck_leave_status'),
          { name: 'ck_leave_dates', expression: `"to_date" >= "from_date"` },
          { name: 'ck_leave_days', expression: `"days_count" > 0` },
          {
            name: 'ck_leave_reviewed',
            expression: `"status" IN ('PENDING', 'CANCELLED') OR "reviewed_by_id" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          fk('fk_leave_staff', 'staff_id'),
          fk('fk_leave_reviewed_by', 'reviewed_by_id'),
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_leave_staff_from', ['staff_id', 'from_date']],
      ['ix_leave_status', ['status']],
    ] as const) {
      await queryRunner.createIndex(
        'leave_requests',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'regularization_requests',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'client_uuid', type: t.varchar, length: '36', isNullable: true },
          { name: 'staff_id', type: t.varchar, length: '36' },
          { name: 'attendance_date', type: t.date },
          { name: 'reason_type', type: t.varchar, length: '30' },
          { name: 'explanation', type: t.unicodeVarchar, length: '1000' },
          { name: 'status', type: t.varchar, length: '20', default: "'PENDING'" },
          { name: 'reviewed_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'reviewed_at', type: t.timestamp, isNullable: true },
          { name: 'review_note', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        uniques: [{ name: 'uq_regularize_client_uuid', columnNames: ['client_uuid'] }],
        checks: [
          {
            name: 'ck_regularize_reason',
            expression: `"reason_type" IN ('BATTERY_DEAD', 'APP_CRASH', 'FIELD_RESCUE_DUTY', 'OUT_OF_NETWORK', 'OTHER')`,
          },
          reviewStatus('ck_regularize_status'),
          {
            name: 'ck_regularize_reviewed',
            expression: `"status" IN ('PENDING', 'CANCELLED') OR "reviewed_by_id" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          fk('fk_regularize_staff', 'staff_id'),
          fk('fk_regularize_reviewed_by', 'reviewed_by_id'),
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_regularize_staff_date', ['staff_id', 'attendance_date']],
      ['ix_regularize_status', ['status']],
    ] as const) {
      await queryRunner.createIndex(
        'regularization_requests',
        new TableIndex({ name, columnNames: [...columns] }),
      );
    }

    await queryRunner.createTable(
      new Table({
        name: 'holidays',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'holiday_date', type: t.date, isUnique: true },
          { name: 'name', type: t.unicodeVarchar, length: '100' },
          { name: 'name_mr', type: t.unicodeVarchar, length: '100', isNullable: true },
          { name: 'holiday_type', type: t.varchar, length: '20', default: "'GAZETTE'" },
          { name: 'version', ...t.int, default: 1 },
          { name: 'created_at', type: t.timestamp },
          { name: 'updated_at', type: t.timestamp },
        ],
        checks: [
          { name: 'ck_holidays_type', expression: `"holiday_type" IN ('GAZETTE', 'OPTIONAL')` },
        ],
      }),
    );

    await queryRunner.createTable(
      new Table({
        name: 'alerts',
        columns: [
          { name: 'id', type: t.varchar, length: '36', isPrimary: true },
          { name: 'dedupe_key', type: t.varchar, length: '120', isNullable: true },
          { name: 'staff_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'ward_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'alert_type', type: t.varchar, length: '30' },
          { name: 'severity', type: t.varchar, length: '10' },
          { name: 'message', type: t.unicodeVarchar, length: '500' },
          { name: 'message_mr', type: t.unicodeVarchar, length: '500', isNullable: true },
          { name: 'details_json', type: t.longText, isNullable: true },
          { name: 'is_resolved', ...t.bool, default: 0 },
          { name: 'triggered_at', type: t.timestamp },
          { name: 'resolved_at', type: t.timestamp, isNullable: true },
          { name: 'resolved_by_id', type: t.varchar, length: '36', isNullable: true },
          { name: 'resolution_note', type: t.unicodeVarchar, length: '500', isNullable: true },
        ],
        uniques: [{ name: 'uq_alerts_dedupe_key', columnNames: ['dedupe_key'] }],
        checks: [
          {
            name: 'ck_alerts_type',
            expression:
              `"alert_type" IN ('LATE_CHECKIN', 'OUT_OF_ZONE', 'MISSED_SPOT_CHECK', 'GHOST_PUNCH', 'ABSENT', ` +
              `'TAMPER_DETECTED', 'STATIONARY_TOO_LONG', 'TASK_OVERDUE', 'REPEATED_LATE')`,
          },
          {
            name: 'ck_alerts_severity',
            expression: `"severity" IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')`,
          },
          { name: 'ck_alerts_is_resolved', expression: `"is_resolved" IN (0, 1)` },
          {
            name: 'ck_alerts_resolved_at',
            expression: `"is_resolved" = 0 OR "resolved_at" IS NOT NULL`,
          },
        ],
        foreignKeys: [
          fk('fk_alerts_staff', 'staff_id'),
          fk('fk_alerts_ward', 'ward_id', 'wards'),
          fk('fk_alerts_resolved_by', 'resolved_by_id'),
        ],
      }),
    );
    for (const [name, columns] of [
      ['ix_alerts_ward_open', ['ward_id', 'is_resolved', 'triggered_at']],
      ['ix_alerts_staff_time', ['staff_id', 'triggered_at']],
      ['ix_alerts_open_time', ['is_resolved', 'triggered_at']],
    ] as const) {
      await queryRunner.createIndex('alerts', new TableIndex({ name, columnNames: [...columns] }));
    }
  }

  async down(queryRunner: QueryRunner): Promise<void> {
    for (const table of [
      'alerts',
      'holidays',
      'regularization_requests',
      'leave_requests',
      'task_updates',
      'tasks',
      'citizen_complaints',
    ]) {
      await queryRunner.dropTable(table);
    }
  }
}
