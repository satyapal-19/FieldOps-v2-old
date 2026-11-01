import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';
import type { ReviewStatus } from './leave-request.entity';

export type RegularizationReason =
  'BATTERY_DEAD' | 'APP_CRASH' | 'FIELD_RESCUE_DUTY' | 'OUT_OF_NETWORK' | 'OTHER';

/** A request to correct a day's attendance after a missed or failed punch. */
@Entity({ name: 'regularization_requests' })
export class RegularizationRequest {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  /** IST calendar date, YYYY-MM-DD. */
  @Column({ name: 'attendance_date', type: dateType() })
  attendanceDate: string;

  @Column({ name: 'reason_type', type: varcharType(), length: 30 })
  reasonType: RegularizationReason;

  @Column({ type: unicodeVarcharType(), length: 1000 })
  explanation: string;

  @Column({ type: varcharType(), length: 20, default: 'PENDING' })
  status: ReviewStatus;

  @Column({ name: 'reviewed_by_id', type: varcharType(), length: 36, nullable: true })
  reviewedById: string | null;

  @Column({ name: 'reviewed_at', type: timestampType(), nullable: true })
  reviewedAt: Date | null;

  @Column({ name: 'review_note', type: unicodeVarcharType(), length: 500, nullable: true })
  reviewNote: string | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
