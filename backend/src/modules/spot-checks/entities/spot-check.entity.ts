import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  dateType,
  decimalColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type SpotCheckTrigger = 'RANDOM' | 'SENIOR_MANUAL';
export type SpotCheckStatus =
  | 'SCHEDULED'
  | 'NOTIFIED'
  | 'SNOOZED'
  | 'VERIFIED'
  | 'MISSED'
  | 'FACE_MISMATCH'
  | 'OUT_OF_GEOFENCE'
  | 'UNREACHABLE'
  | 'CANCELLED';

/**
 * A random (or senior-requested) "prove you are here" check during a shift: one notification,
 * a 10-minute window and at most one snooze. Unanswered checks are escalated.
 */
@Entity({ name: 'spot_checks' })
export class SpotCheck {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  /** IST calendar date, YYYY-MM-DD. */
  @Column({ name: 'shift_date', type: dateType() })
  shiftDate: string;

  @Column({ name: 'trigger_type', type: varcharType(), length: 20 })
  triggerType: SpotCheckTrigger;

  @Column({ name: 'initiated_by_id', type: varcharType(), length: 36, nullable: true })
  initiatedById: string | null;

  @Column({ type: unicodeVarcharType(), length: 500, nullable: true })
  reason: string | null;

  @Column({ type: varcharType(), length: 20, default: 'SCHEDULED' })
  status: SpotCheckStatus;

  @Column({ name: 'scheduled_at', type: timestampType() })
  scheduledAt: Date;

  @Column({ name: 'notified_at', type: timestampType(), nullable: true })
  notifiedAt: Date | null;

  /** End of the answer window (notified_at + 10 minutes, moved once by a snooze). */
  @Column({ name: 'due_at', type: timestampType(), nullable: true })
  dueAt: Date | null;

  @Column({ name: 'snooze_count', ...intColumn(), default: 0 })
  snoozeCount: number;

  @Column({
    name: 'response_client_uuid',
    type: varcharType(),
    length: 36,
    nullable: true,
    unique: true,
  })
  responseClientUuid: string | null;

  @Column({ name: 'responded_at', type: timestampType(), nullable: true })
  respondedAt: Date | null;

  @Column({ name: 'response_lat', ...decimalColumn(10, 7), nullable: true })
  responseLat: number | null;

  @Column({ name: 'response_lng', ...decimalColumn(10, 7), nullable: true })
  responseLng: number | null;

  @Column({ name: 'response_accuracy_m', ...decimalColumn(8, 2), nullable: true })
  responseAccuracyM: number | null;

  @Column({ name: 'response_in_geofence', ...booleanColumn(), nullable: true })
  responseInGeofence: boolean | null;

  @Column({ name: 'face_score', ...decimalColumn(5, 4), nullable: true })
  faceScore: number | null;

  @Column({ name: 'escalated_at', type: timestampType(), nullable: true })
  escalatedAt: Date | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
