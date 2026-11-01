import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type LeaveType = 'CASUAL' | 'SICK' | 'EARNED' | 'WEEKLY_OFF';
export type ReviewStatus = 'PENDING' | 'APPROVED' | 'REJECTED' | 'CANCELLED';

@Entity({ name: 'leave_requests' })
export class LeaveRequest {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'leave_type', type: varcharType(), length: 20 })
  leaveType: LeaveType;

  /** IST calendar dates, YYYY-MM-DD, both inclusive. */
  @Column({ name: 'from_date', type: dateType() })
  fromDate: string;

  @Column({ name: 'to_date', type: dateType() })
  toDate: string;

  @Column({ name: 'days_count', ...intColumn() })
  daysCount: number;

  @Column({ type: unicodeVarcharType(), length: 500, nullable: true })
  reason: string | null;

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
