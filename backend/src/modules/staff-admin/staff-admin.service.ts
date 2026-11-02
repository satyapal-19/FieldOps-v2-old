import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { passwordProblems } from '../auth/auth.policy';
import { AuthService } from '../auth/auth.service';
import { OfficesService } from '../offices/offices.service';
import type { StaffProfileDto } from '../staff/dto/staff-profile.dto';
import { Staff } from '../staff/entities/staff.entity';
import { toStaffProfileDto } from '../staff/staff.mapper';
import {
  checkStaffLinks,
  normalizeEmployeeCode,
  normalizePhone,
  parseShiftTime,
  StaffRuleError,
} from '../staff/staff.policy';
import { StaffService, type StaffChanges } from '../staff/staff.service';
import { WardsService } from '../wards/wards.service';
import type {
  CreateStaffDto,
  ListStaffQueryDto,
  StaffPageDto,
  UpdateStaffDto,
} from './dto/staff-admin.dto';
import {
  canSeeFullPhone,
  canViewStaff,
  changeBreaksReports,
  changesNeedSignOut,
  checkPasswordAllowed,
  checkReportsTo,
  StaffFacts,
  staffListScope,
} from './staff-admin.policy';

const DEFAULT_SHIFT = { start: '06:00', end: '14:00' };

function facts(s: Staff): StaffFacts {
  return {
    id: s.id,
    role: s.role,
    homeWardId: s.homeWardId ?? null,
    reportsToId: s.reportsToId ?? null,
    isActive: Boolean(Number(s.isActive)),
  };
}

/** Format problems are 400; broken links and hierarchy are 422 (business rules). */
function asAppError(error: unknown, code: ErrorCode): never {
  if (error instanceof StaffRuleError) {
    throw new AppError(code, error.message, { field: error.field });
  }
  throw error;
}

/** Staff management (ADMIN writes; scoped reads for supervisors). Rules: staff + staff-admin policies. */
@Injectable()
export class StaffAdminService {
  constructor(
    private readonly staff: StaffService,
    private readonly wards: WardsService,
    private readonly offices: OfficesService,
    private readonly auth: AuthService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  async list(actor: AuthUser, query: ListStaffQueryDto): Promise<StaffPageDto> {
    const scope = staffListScope(actor);
    if (scope.kind === 'NONE') throw new AppError(ErrorCode.FORBIDDEN);
    const [items, total] = await this.staff.findPage(
      {
        role: query.role,
        wardId: query.wardId,
        officeId: query.officeId,
        isActive: query.isActive,
        search: query.q?.trim() || undefined,
        ids: query.ids,
        visibleTo: scope.kind === 'WARD' ? scope : undefined,
      },
      (query.page - 1) * query.pageSize,
      query.pageSize,
    );
    return {
      items: items.map((s) => toStaffProfileDto(s, { showPhone: canSeeFullPhone(actor, s.id) })),
      page: query.page,
      pageSize: query.pageSize,
      total,
    };
  }

  async get(actor: AuthUser, id: string): Promise<StaffProfileDto> {
    const target = await this.staff.findById(id);
    // Out-of-scope records answer 404, so supervisors cannot probe other wards for ids.
    if (!target || !canViewStaff(actor, facts(target))) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id });
    }
    return toStaffProfileDto(target, { showPhone: canSeeFullPhone(actor, target.id) });
  }

  async create(actor: AuthUser, dto: CreateStaffDto): Promise<StaffProfileDto> {
    let employeeCode: string, phone: string, shiftStart: string, shiftEnd: string;
    try {
      employeeCode = normalizeEmployeeCode(dto.employeeCode);
      phone = normalizePhone(dto.phone);
      shiftStart = parseShiftTime('shiftStart', dto.shiftStart ?? DEFAULT_SHIFT.start);
      shiftEnd = parseShiftTime('shiftEnd', dto.shiftEnd ?? DEFAULT_SHIFT.end);
    } catch (error) {
      asAppError(error, ErrorCode.VALIDATION_FAILED);
    }

    const links = {
      role: dto.role,
      homeWardId: dto.homeWardId ?? null,
      officeId: dto.officeId ?? null,
    };
    await this.checkLinks(links, { id: null, ...links }, dto.reportsToId ?? null);
    try {
      checkPasswordAllowed(dto.role, dto.initialPassword !== undefined);
    } catch (error) {
      asAppError(error, ErrorCode.RULE_VIOLATION);
    }
    if (dto.initialPassword !== undefined) {
      const problems = passwordProblems(dto.initialPassword, { employeeCode, phone });
      if (problems.length > 0)
        throw new AppError(ErrorCode.AUTH_WEAK_PASSWORD, undefined, { problems });
    }
    if (
      (await this.staff.findByEmployeeCode(employeeCode)) ||
      (await this.staff.findByPhone(phone))
    ) {
      throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
    }

    const now = this.clock.now();
    const staff: Staff = {
      id: this.ids.next(),
      employeeCode,
      fullName: dto.fullName.trim(),
      fullNameMr: dto.fullNameMr?.trim() ?? null,
      phone,
      role: dto.role,
      homeWardId: links.homeWardId,
      officeId: links.officeId,
      reportsToId: dto.reportsToId ?? null,
      department: dto.department?.trim() ?? null,
      shiftStart,
      shiftEnd,
      passwordHash: dto.initialPassword ? await this.auth.hashPassword(dto.initialPassword) : null,
      isActive: true,
      deactivatedAt: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    await this.uow.run(async (tx) => {
      await this.staff.insert(staff, tx);
      await this.audit.write(tx, {
        action: 'STAFF_CREATED',
        entityType: 'staff',
        entityId: staff.id,
        details: {
          employeeCode,
          role: staff.role,
          homeWardId: staff.homeWardId,
          officeId: staff.officeId,
        },
      });
    });
    return toStaffProfileDto(staff, { showPhone: canSeeFullPhone(actor, staff.id) });
  }

  async update(actor: AuthUser, id: string, dto: UpdateStaffDto): Promise<StaffProfileDto> {
    const existing = await this.staff.findById(id);
    if (!existing) throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id });
    if (existing.version !== dto.expectedVersion)
      throw this.versionConflict(existing.version, dto.expectedVersion);
    if (
      id === actor.staffId &&
      (dto.isActive === false || (dto.role && dto.role !== existing.role))
    ) {
      throw new AppError(
        ErrorCode.RULE_VIOLATION,
        'You cannot deactivate yourself or change your own role',
      );
    }

    const changes: StaffChanges = {};
    try {
      if (dto.phone !== undefined) changes.phone = normalizePhone(dto.phone);
      if (dto.shiftStart !== undefined)
        changes.shiftStart = parseShiftTime('shiftStart', dto.shiftStart);
      if (dto.shiftEnd !== undefined) changes.shiftEnd = parseShiftTime('shiftEnd', dto.shiftEnd);
    } catch (error) {
      asAppError(error, ErrorCode.VALIDATION_FAILED);
    }
    if (dto.fullName !== undefined) changes.fullName = dto.fullName.trim();
    if (dto.fullNameMr !== undefined) changes.fullNameMr = dto.fullNameMr?.trim() ?? null;
    if (dto.department !== undefined) changes.department = dto.department?.trim() ?? null;
    if (dto.role !== undefined) changes.role = dto.role;
    if (dto.homeWardId !== undefined) changes.homeWardId = dto.homeWardId;
    if (dto.officeId !== undefined) changes.officeId = dto.officeId;
    if (dto.reportsToId !== undefined) changes.reportsToId = dto.reportsToId;

    const after = {
      role: changes.role ?? existing.role,
      homeWardId:
        changes.homeWardId !== undefined ? changes.homeWardId : (existing.homeWardId ?? null),
      officeId: changes.officeId !== undefined ? changes.officeId : (existing.officeId ?? null),
      phone: changes.phone ?? existing.phone,
      isActive: dto.isActive ?? Boolean(Number(existing.isActive)),
    };
    const reportsToId =
      changes.reportsToId !== undefined ? changes.reportsToId : (existing.reportsToId ?? null);
    const linksChanged =
      changes.role !== undefined ||
      changes.homeWardId !== undefined ||
      changes.officeId !== undefined ||
      changes.reportsToId !== undefined;
    // People below come first: their lines must move before this person can change.
    const breaks = changeBreaksReports(
      {
        role: existing.role,
        homeWardId: existing.homeWardId ?? null,
        isActive: Boolean(Number(existing.isActive)),
      },
      after,
    );
    if (breaks) {
      const reports = await this.staff.findIds({ reportsToId: id, isActive: true });
      if (reports.length > 0) {
        throw new AppError(ErrorCode.STAFF_HAS_REPORTS, undefined, {
          reports: reports.length,
          change: breaks,
        });
      }
    }
    if (linksChanged) await this.checkLinks(after, { id, ...after }, reportsToId);
    // A role that loses web sign-in also loses its password.
    if (existing.passwordHash && changes.role !== undefined && !this.keepsPassword(after.role)) {
      changes.passwordHash = null;
    }

    if (changes.phone !== undefined && changes.phone !== existing.phone) {
      const holder = await this.staff.findByPhone(changes.phone);
      if (holder && holder.id !== id) throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
    }

    const now = this.clock.now();
    if (dto.isActive !== undefined && dto.isActive !== Boolean(Number(existing.isActive))) {
      changes.isActive = dto.isActive;
      changes.deactivatedAt = dto.isActive ? null : now;
    }
    changes.updatedAt = now;
    const signOut = changesNeedSignOut(existing, after);

    const updated = await this.uow.run(async (tx) => {
      const count = await this.staff.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (count === 0) return 0;
      await this.audit.write(tx, {
        action: changes.isActive === false ? 'STAFF_DEACTIVATED' : 'STAFF_UPDATED',
        entityType: 'staff',
        entityId: id,
        details: {
          fields: Object.keys(changes).filter((k) => k !== 'updatedAt' && k !== 'passwordHash'),
        },
      });
      if (signOut) await this.auth.revokeAllFor(id, after.isActive ? 'ADMIN' : 'DEACTIVATED', tx);
      return count;
    });
    if (updated === 0) {
      const current = await this.staff.findById(id);
      throw this.versionConflict(current?.version ?? -1, dto.expectedVersion);
    }
    return this.get(actor, id);
  }

  private keepsPassword(role: Staff['role']): boolean {
    try {
      checkPasswordAllowed(role, true);
      return true;
    } catch {
      return false;
    }
  }

  /** Role links (ward / office), that they exist, and the reporting line. */
  private async checkLinks(
    links: { role: Staff['role']; homeWardId: string | null; officeId: string | null },
    person: { id: string | null; role: Staff['role']; homeWardId: string | null },
    reportsToId: string | null,
  ): Promise<void> {
    try {
      checkStaffLinks(links);
    } catch (error) {
      asAppError(error, ErrorCode.RULE_VIOLATION);
    }
    if (links.homeWardId && !(await this.wards.exists(links.homeWardId))) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'Ward not found or inactive', {
        field: 'homeWardId',
      });
    }
    if (links.officeId && !(await this.offices.exists(links.officeId))) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'Office not found or inactive', {
        field: 'officeId',
      });
    }
    let manager: StaffFacts | null = null;
    if (reportsToId) {
      const found = await this.staff.findById(reportsToId);
      if (!found)
        throw new AppError(ErrorCode.RULE_VIOLATION, 'Manager not found', { field: 'reportsToId' });
      manager = facts(found);
    }
    try {
      checkReportsTo(person, manager);
    } catch (error) {
      asAppError(error, ErrorCode.RULE_VIOLATION);
    }
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, { currentVersion, expectedVersion });
  }
}
