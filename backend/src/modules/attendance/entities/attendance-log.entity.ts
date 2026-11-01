import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';
import type { ShiftType } from '../../shifts/shift-types';
import {
  booleanColumn,
  dateType,
  decimalColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';
import type { AttendanceStatus, CheckoutType, PunchMode } from '../attendance-types';

/**
 * One row per staff member per IST date, holding the check-in and check-out punches.
 * Each punch carries its own client UUID, so a retried punch from the phone is a duplicate,
 * not a second punch. Face crops are never stored; only the score and the challenge used.
 */
@Entity({ name: 'attendance_logs' })
@Unique('uq_attendance_staff_date', ['staffId', 'attendanceDate'])
export class AttendanceLog {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  /** IST calendar date, YYYY-MM-DD. */
  @Column({ name: 'attendance_date', type: dateType() })
  attendanceDate: string;

  /** Field punches are in a ward, office punches at an office; never both. */
  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  @Column({ name: 'office_id', type: varcharType(), length: 36, nullable: true })
  officeId: string | null;

  /** The approved daily assignment the punch was accepted against. */
  @Column({ name: 'assignment_id', type: varcharType(), length: 36, nullable: true })
  assignmentId: string | null;

  @Column({ name: 'shift_type', type: varcharType(), length: 20, nullable: true })
  shiftType: ShiftType | null;

  @Column({ type: varcharType(), length: 20, default: 'ABSENT' })
  status: AttendanceStatus;

  @Column({ name: 'is_late', ...booleanColumn(), default: 0 })
  isLate: boolean;

  @Column({ name: 'late_minutes', ...intColumn(), default: 0 })
  lateMinutes: number;

  @Column({ name: 'worked_minutes', ...intColumn(), nullable: true })
  workedMinutes: number | null;

  @Column({
    name: 'checkin_client_uuid',
    type: varcharType(),
    length: 36,
    nullable: true,
    unique: true,
  })
  checkinClientUuid: string | null;

  /** Server time of the accepted check-in (UTC). */
  @Column({ name: 'checkin_at', type: timestampType(), nullable: true })
  checkinAt: Date | null;

  @Column({ name: 'checkin_lat', ...decimalColumn(10, 7), nullable: true })
  checkinLat: number | null;

  @Column({ name: 'checkin_lng', ...decimalColumn(10, 7), nullable: true })
  checkinLng: number | null;

  @Column({ name: 'checkin_accuracy_m', ...decimalColumn(8, 2), nullable: true })
  checkinAccuracyM: number | null;

  @Column({ name: 'checkin_in_geofence', ...booleanColumn(), default: 0 })
  checkinInGeofence: boolean;

  /** Distance outside the boundary in metres (0 when inside). */
  @Column({ name: 'checkin_distance_m', ...decimalColumn(8, 2), nullable: true })
  checkinDistanceM: number | null;

  @Column({ name: 'checkin_is_mocked', ...booleanColumn(), default: 0 })
  checkinIsMocked: boolean;

  @Column({ name: 'checkin_challenge_id', type: varcharType(), length: 36, nullable: true })
  checkinChallengeId: string | null;

  @Column({ name: 'checkin_face_score', ...decimalColumn(5, 4), nullable: true })
  checkinFaceScore: number | null;

  /** No fail-open: false until the server matched the face. */
  @Column({ name: 'checkin_face_passed', ...booleanColumn(), default: 0 })
  checkinFacePassed: boolean;

  @Column({ name: 'checkin_mode', type: varcharType(), length: 20, nullable: true })
  checkinMode: PunchMode | null;

  @Column({ name: 'checkin_marked_by_id', type: varcharType(), length: 36, nullable: true })
  checkinMarkedById: string | null;

  @Column({
    name: 'checkout_client_uuid',
    type: varcharType(),
    length: 36,
    nullable: true,
    unique: true,
  })
  checkoutClientUuid: string | null;

  @Column({ name: 'checkout_at', type: timestampType(), nullable: true })
  checkoutAt: Date | null;

  @Column({ name: 'checkout_lat', ...decimalColumn(10, 7), nullable: true })
  checkoutLat: number | null;

  @Column({ name: 'checkout_lng', ...decimalColumn(10, 7), nullable: true })
  checkoutLng: number | null;

  @Column({ name: 'checkout_accuracy_m', ...decimalColumn(8, 2), nullable: true })
  checkoutAccuracyM: number | null;

  @Column({ name: 'checkout_in_geofence', ...booleanColumn(), nullable: true })
  checkoutInGeofence: boolean | null;

  @Column({ name: 'checkout_type', type: varcharType(), length: 30, nullable: true })
  checkoutType: CheckoutType | null;

  @Column({ name: 'checkout_mode', type: varcharType(), length: 20, nullable: true })
  checkoutMode: PunchMode | null;

  @Column({ name: 'checkout_marked_by_id', type: varcharType(), length: 36, nullable: true })
  checkoutMarkedById: string | null;

  @Column({ name: 'is_suspicious', ...booleanColumn(), default: 0 })
  isSuspicious: boolean;

  @Column({ type: unicodeVarcharType(), length: 500, nullable: true })
  notes: string | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
