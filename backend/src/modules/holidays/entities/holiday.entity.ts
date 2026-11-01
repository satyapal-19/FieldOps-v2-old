import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type HolidayType = 'GAZETTE' | 'OPTIONAL';

@Entity({ name: 'holidays' })
export class Holiday {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** IST calendar date, YYYY-MM-DD; one holiday per date. */
  @Column({ name: 'holiday_date', type: dateType(), unique: true })
  holidayDate: string;

  @Column({ type: unicodeVarcharType(), length: 100 })
  name: string;

  @Column({ name: 'name_mr', type: unicodeVarcharType(), length: 100, nullable: true })
  nameMr: string | null;

  @Column({ name: 'holiday_type', type: varcharType(), length: 20, default: 'GAZETTE' })
  holidayType: HolidayType;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
