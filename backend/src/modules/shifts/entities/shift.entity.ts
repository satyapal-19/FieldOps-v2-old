import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';
import type { ShiftType } from '../shift-types';

/**
 * A staff member's shift on one IST date, overriding staff.shift_start / shift_end.
 * With no row, the staff defaults apply (spot checks and late marks fall back to them).
 */
@Entity({ name: 'shifts' })
@Unique('uq_shifts_staff_date', ['staffId', 'shiftDate'])
export class Shift {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  /** IST calendar date, YYYY-MM-DD. */
  @Column({ name: 'shift_date', type: dateType() })
  shiftDate: string;

  @Column({ name: 'shift_type', type: varcharType(), length: 20 })
  shiftType: ShiftType;

  /** IST wall-clock "HH:MM". An end before the start means the shift ends the next day. */
  @Column({ name: 'start_time', type: varcharType(), length: 5 })
  startTime: string;

  @Column({ name: 'end_time', type: varcharType(), length: 5 })
  endTime: string;

  @Column({ name: 'created_by_id', type: varcharType(), length: 36, nullable: true })
  createdById: string | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
