import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export const NOTIFICATION_KINDS = [
  'SPOT_CHECK',
  'ALERT',
  'TASK',
  'CHAT',
  'REQUEST',
  'SYSTEM',
] as const;
export type NotificationKind = (typeof NOTIFICATION_KINDS)[number];
export type NotificationPriority = 'HIGH' | 'NORMAL';

/** One message in a person's in-app inbox (the fallback every phone polls). */
@Entity({ name: 'notifications' })
export class Notification {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ type: varcharType(), length: 20 })
  kind: NotificationKind;

  @Column({ type: varcharType(), length: 10 })
  priority: NotificationPriority;

  @Column({ type: unicodeVarcharType(), length: 150 })
  title: string;

  @Column({ name: 'title_mr', type: unicodeVarcharType(), length: 150, nullable: true })
  titleMr: string | null;

  @Column({ type: unicodeVarcharType(), length: 500, nullable: true })
  body: string | null;

  @Column({ name: 'body_mr', type: unicodeVarcharType(), length: 500, nullable: true })
  bodyMr: string | null;

  /** What it is about, for the app to open: e.g. SPOT_CHECK + the check's id. */
  @Column({ name: 'ref_type', type: varcharType(), length: 20, nullable: true })
  refType: string | null;

  @Column({ name: 'ref_id', type: varcharType(), length: 36, nullable: true })
  refId: string | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'read_at', type: timestampType(), nullable: true })
  readAt: Date | null;
}
