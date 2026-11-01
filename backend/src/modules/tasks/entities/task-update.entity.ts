import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  decimalColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';
import type { TaskStatus } from './task.entity';

/** One status change on a task: the history, and the retry-safe record of a phone update. */
@Entity({ name: 'task_updates' })
export class TaskUpdate {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'task_id', type: varcharType(), length: 36 })
  taskId: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'from_status', type: varcharType(), length: 20 })
  fromStatus: TaskStatus;

  @Column({ name: 'to_status', type: varcharType(), length: 20 })
  toStatus: TaskStatus;

  @Column({ type: unicodeVarcharType(), length: 1000, nullable: true })
  note: string | null;

  @Column({ name: 'photo_key', type: varcharType(), length: 100, nullable: true })
  photoKey: string | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lat: number | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lng: number | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;
}
