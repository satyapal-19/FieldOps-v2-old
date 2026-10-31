import { Column, Entity, PrimaryColumn } from 'typeorm';
import type { StaffRole } from '../../../shared/auth/roles';
import {
  booleanColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

/**
 * Every municipal employee who signs in. Ward links follow v4:
 * WARD_INSPECTOR has a fixed ward; INSPECTOR / WORKER have a default ward (daily
 * assignments may move them); OFFICE_STAFF belong to an office; ADMIN is global.
 */
@Entity({ name: 'staff' })
export class Staff {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'employee_code', type: varcharType(), length: 20, unique: true })
  employeeCode: string;

  @Column({ name: 'full_name', type: unicodeVarcharType(), length: 100 })
  fullName: string;

  @Column({ name: 'full_name_mr', type: unicodeVarcharType(), length: 100, nullable: true })
  fullNameMr: string | null;

  /** 10-digit Indian mobile number, the OTP sign-in identity. */
  @Column({ type: varcharType(), length: 10, unique: true })
  phone: string;

  @Column({ type: varcharType(), length: 20 })
  role: StaffRole;

  @Column({ name: 'home_ward_id', type: varcharType(), length: 36, nullable: true })
  homeWardId: string | null;

  @Column({ name: 'office_id', type: varcharType(), length: 36, nullable: true })
  officeId: string | null;

  /** Line manager (v4 hierarchy): worker -> inspector -> ward inspector -> admin. */
  @Column({ name: 'reports_to_id', type: varcharType(), length: 36, nullable: true })
  reportsToId: string | null;

  @Column({ type: unicodeVarcharType(), length: 100, nullable: true })
  department: string | null;

  /** Shift start/end as IST wall-clock "HH:MM". Late after start + 15 minutes. */
  @Column({ name: 'shift_start', type: varcharType(), length: 5 })
  shiftStart: string;

  @Column({ name: 'shift_end', type: varcharType(), length: 5 })
  shiftEnd: string;

  /** bcrypt hash; only for web dashboard users. Never returned by the API. */
  @Column({ name: 'password_hash', type: varcharType(), length: 100, nullable: true })
  passwordHash: string | null;

  @Column({ name: 'is_active', ...booleanColumn(), default: 1 })
  isActive: boolean;

  @Column({ name: 'deactivated_at', type: timestampType(), nullable: true })
  deactivatedAt: Date | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
