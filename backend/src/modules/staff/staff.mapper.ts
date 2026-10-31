import type { StaffProfileDto } from './dto/staff-profile.dto';
import type { Staff } from './entities/staff.entity';
import { maskPhone } from './staff.policy';

export function toStaffProfileDto(staff: Staff, opts: { showPhone: boolean }): StaffProfileDto {
  return {
    id: staff.id,
    employeeCode: staff.employeeCode,
    fullName: staff.fullName,
    fullNameMr: staff.fullNameMr ?? null,
    phone: opts.showPhone ? staff.phone : maskPhone(staff.phone),
    role: staff.role,
    homeWardId: staff.homeWardId ?? null,
    officeId: staff.officeId ?? null,
    reportsToId: staff.reportsToId ?? null,
    department: staff.department ?? null,
    shiftStart: staff.shiftStart,
    shiftEnd: staff.shiftEnd,
    // Raw DB defaults (0/1) can land on the entity after an insert.
    isActive: Boolean(Number(staff.isActive)),
    hasPassword: Boolean(staff.passwordHash),
    version: Number(staff.version),
    createdAt: staff.createdAt.toISOString(),
    updatedAt: staff.updatedAt.toISOString(),
  };
}
