import { AttendanceLog } from '../modules/attendance/entities/attendance-log.entity';
import { LocationPing } from '../modules/attendance/entities/location-ping.entity';
import { TamperEvent } from '../modules/attendance/entities/tamper-event.entity';
import { AuthOtp } from '../modules/auth/entities/auth-otp.entity';
import { AuthSession } from '../modules/auth/entities/auth-session.entity';
import { CorporationOffice } from '../modules/offices/entities/corporation-office.entity';
import { DailyAssignment } from '../modules/rosters/entities/daily-assignment.entity';
import { StandingRoster } from '../modules/rosters/entities/standing-roster.entity';
import { Shift } from '../modules/shifts/entities/shift.entity';
import { SpotCheck } from '../modules/spot-checks/entities/spot-check.entity';
import { Staff } from '../modules/staff/entities/staff.entity';
import { Ward } from '../modules/wards/entities/ward.entity';
import { AuditLog } from '../shared/audit/audit-log.entity';

/** Every TypeORM entity. Add new entities here when a module adds one. */
export const ENTITIES = [
  Ward,
  CorporationOffice,
  Staff,
  AuthOtp,
  AuthSession,
  AuditLog,
  StandingRoster,
  DailyAssignment,
  Shift,
  AttendanceLog,
  LocationPing,
  TamperEvent,
  SpotCheck,
];
