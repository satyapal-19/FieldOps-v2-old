import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  decimalColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type TaskPriority = 'URGENT' | 'NORMAL' | 'LOW';
export type TaskStatus =
  'OPEN' | 'IN_PROGRESS' | 'SUBMITTED' | 'APPROVED' | 'REJECTED' | 'ESCALATED' | 'CLOSED';

/** Field work assigned down the hierarchy, optionally raised from a citizen complaint. */
@Entity({ name: 'tasks' })
export class Task {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ type: unicodeVarcharType(), length: 200 })
  title: string;

  @Column({ name: 'title_mr', type: unicodeVarcharType(), length: 200, nullable: true })
  titleMr: string | null;

  @Column({ type: unicodeVarcharType(), length: 1000, nullable: true })
  description: string | null;

  @Column({ type: varcharType(), length: 10, default: 'NORMAL' })
  priority: TaskPriority;

  @Column({ type: varcharType(), length: 20, default: 'OPEN' })
  status: TaskStatus;

  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  @Column({ name: 'assigned_to_id', type: varcharType(), length: 36, nullable: true })
  assignedToId: string | null;

  @Column({ name: 'created_by_id', type: varcharType(), length: 36 })
  createdById: string;

  @Column({ name: 'complaint_id', type: varcharType(), length: 36, nullable: true })
  complaintId: string | null;

  @Column({ name: 'location_lat', ...decimalColumn(10, 7), nullable: true })
  locationLat: number | null;

  @Column({ name: 'location_lng', ...decimalColumn(10, 7), nullable: true })
  locationLng: number | null;

  @Column({ name: 'location_label', type: unicodeVarcharType(), length: 200, nullable: true })
  locationLabel: string | null;

  @Column({ name: 'due_at', type: timestampType(), nullable: true })
  dueAt: Date | null;

  @Column({ name: 'started_at', type: timestampType(), nullable: true })
  startedAt: Date | null;

  @Column({ name: 'submitted_at', type: timestampType(), nullable: true })
  submittedAt: Date | null;

  @Column({ name: 'closed_at', type: timestampType(), nullable: true })
  closedAt: Date | null;

  @Column({ name: 'before_photo_key', type: varcharType(), length: 100, nullable: true })
  beforePhotoKey: string | null;

  @Column({ name: 'after_photo_key', type: varcharType(), length: 100, nullable: true })
  afterPhotoKey: string | null;

  @Column({ name: 'completion_note', type: unicodeVarcharType(), length: 1000, nullable: true })
  completionNote: string | null;

  @Column({ name: 'rejection_reason', type: unicodeVarcharType(), length: 500, nullable: true })
  rejectionReason: string | null;

  @Column({ name: 'rejection_count', ...intColumn(), default: 0 })
  rejectionCount: number;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
