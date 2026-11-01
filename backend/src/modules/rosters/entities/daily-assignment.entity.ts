import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';
import {
  booleanColumn,
  dateType,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';
import type { AssignableRole, AssignmentMode } from '../roster-types';

/**
 * Who works where on one IST date. One row per person placed: an INSPECTOR row
 * (inspector_id = staff_id) puts the inspector in a ward; WORKER rows put workers in that
 * inspector's team. UNIQUE (shift_date, staff_id) = one ward per person per day.
 */
@Entity({ name: 'daily_assignments' })
@Unique('uq_daily_asg_date_staff', ['shiftDate', 'staffId'])
export class DailyAssignment {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** Idempotency key from the phone for offline self-pick / self-join; null for web writes. */
  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  /** IST calendar date, YYYY-MM-DD. */
  @Column({ name: 'shift_date', type: dateType() })
  shiftDate: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'staff_role', type: varcharType(), length: 20 })
  staffRole: AssignableRole;

  @Column({ name: 'ward_id', type: varcharType(), length: 36 })
  wardId: string;

  @Column({ name: 'ward_inspector_id', type: varcharType(), length: 36 })
  wardInspectorId: string;

  @Column({ name: 'inspector_id', type: varcharType(), length: 36 })
  inspectorId: string;

  @Column({ name: 'assignment_mode', type: varcharType(), length: 30 })
  assignmentMode: AssignmentMode;

  /** A punch is accepted only on an approved assignment. Defaults to unapproved. */
  @Column({ name: 'is_approved', ...booleanColumn(), default: 0 })
  isApproved: boolean;

  @Column({ name: 'approved_by_id', type: varcharType(), length: 36, nullable: true })
  approvedById: string | null;

  @Column({ name: 'approved_at', type: timestampType(), nullable: true })
  approvedAt: Date | null;

  @Column({ name: 'assigned_by_id', type: varcharType(), length: 36, nullable: true })
  assignedById: string | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
