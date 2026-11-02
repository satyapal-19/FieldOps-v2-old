import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { Role } from '../../shared/auth/roles';
import {
  canManageWard,
  checkAssignmentDate,
  daysBetween,
  RosterRuleError,
} from '../rosters/rosters.policy';
import { canViewStaff } from '../staff-admin/staff-admin.policy';
import type { Staff } from '../staff/entities/staff.entity';
import { StaffService } from '../staff/staff.service';
import type { EffectiveShiftDto, PutShiftDto, ShiftDto } from './dto/shifts.dto';
import { Shift } from './entities/shift.entity';
import { checkShiftTimes, EffectiveShift, effectiveShift, ShiftRuleError } from './shifts.policy';
import { ShiftsRepository } from './shifts.repository';

const MAX_RANGE_DAYS = 62;

export function toShiftDto(s: Shift): ShiftDto {
  return {
    id: s.id,
    staffId: s.staffId,
    date: s.shiftDate,
    shiftType: s.shiftType,
    startTime: s.startTime,
    endTime: s.endTime,
    version: Number(s.version),
    updatedAt: s.updatedAt.toISOString(),
  };
}

function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof ShiftRuleError || error instanceof RosterRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/**
 * Per-day shift overrides and the effective shift for a day. Writes: ADMIN anywhere,
 * WARD_INSPECTOR for staff of their ward. Reads follow the staff visibility rules.
 */
@Injectable()
export class ShiftsService {
  constructor(
    private readonly repo: ShiftsRepository,
    private readonly staff: StaffService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  async list(actor: AuthUser, staffId: string, from: string, to: string): Promise<ShiftDto[]> {
    await this.visibleStaff(actor, staffId);
    const span = daysBetween(from, to);
    if (span < 0 || span > MAX_RANGE_DAYS) {
      throw new AppError(ErrorCode.RULE_VIOLATION, `Range must be 0-${MAX_RANGE_DAYS} days`, {
        field: 'to',
      });
    }
    return (await this.repo.findRange(staffId, from, to)).map(toShiftDto);
  }

  /** For other modules (attendance late marks, spot checks) and the API: never null. */
  async effective(staffId: string, date: string): Promise<EffectiveShiftDto> {
    const person = await this.staff.findById(staffId);
    if (!person) throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: staffId });
    const s = effectiveShift(date, person, await this.repo.findFor(staffId, date));
    return { staffId, ...s, startsAt: s.startsAt.toISOString(), endsAt: s.endsAt.toISOString() };
  }

  /** For the attendance engine: the shift window (UTC instants) of a person on an IST date. */
  async shiftFor(
    person: Pick<Staff, 'id' | 'shiftStart' | 'shiftEnd'>,
    date: string,
  ): Promise<EffectiveShift> {
    return effectiveShift(date, person, await this.repo.findFor(person.id, date));
  }

  /** shiftFor for many people at once: one query per 1000 people instead of one each. */
  async shiftsFor(
    people: readonly Pick<Staff, 'id' | 'shiftStart' | 'shiftEnd'>[],
    date: string,
  ): Promise<Map<string, EffectiveShift>> {
    const overrides = new Map(
      (await this.repo.findForMany(people.map((p) => p.id), date)).map((o) => [o.staffId, o]),
    );
    return new Map(people.map((p) => [p.id, effectiveShift(date, p, overrides.get(p.id) ?? null)]));
  }

  async effectiveFor(actor: AuthUser, staffId: string, date: string): Promise<EffectiveShiftDto> {
    await this.visibleStaff(actor, staffId);
    return this.effective(staffId, date);
  }

  /** Creates or replaces the override for one person on one day. */
  async put(actor: AuthUser, dto: PutShiftDto): Promise<ShiftDto> {
    await this.manageableStaff(actor, dto.staffId);
    rule(() => checkAssignmentDate(dto.date, istDate(this.clock.now()), false));
    rule(() => checkShiftTimes(dto.shiftType, dto.startTime, dto.endTime));
    const now = this.clock.now();
    const existing = await this.repo.findFor(dto.staffId, dto.date);

    if (existing) {
      if (dto.expectedVersion === undefined || dto.expectedVersion !== Number(existing.version)) {
        throw new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
          currentVersion: Number(existing.version),
          expectedVersion: dto.expectedVersion ?? null,
        });
      }
      const changes = {
        shiftType: dto.shiftType,
        startTime: dto.startTime,
        endTime: dto.endTime,
        updatedAt: now,
      };
      const count = await this.uow.run(async (tx) => {
        const n = await this.repo.updateVersioned(existing.id, dto.expectedVersion!, changes, tx);
        if (n > 0)
          await this.audit.write(tx, {
            action: 'SHIFT_UPDATED',
            entityType: 'shift',
            entityId: existing.id,
            details: { ...dto },
          });
        return n;
      });
      if (count === 0) throw new AppError(ErrorCode.VERSION_CONFLICT);
      return toShiftDto((await this.repo.findById(existing.id))!);
    }

    const row: Shift = {
      id: this.ids.next(),
      staffId: dto.staffId,
      shiftDate: dto.date,
      shiftType: dto.shiftType,
      startTime: dto.startTime,
      endTime: dto.endTime,
      createdById: actor.staffId,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    try {
      await this.uow.run(async (tx) => {
        await this.repo.insert(row, tx);
        await this.audit.write(tx, {
          action: 'SHIFT_CREATED',
          entityType: 'shift',
          entityId: row.id,
          details: { ...dto },
        });
      });
    } catch (error) {
      // Someone created the same day's override between our read and write.
      if (isUniqueViolation(error)) throw new AppError(ErrorCode.VERSION_CONFLICT);
      throw error;
    }
    return toShiftDto(row);
  }

  /** Removes an override (the staff defaults apply again). Not for past days: they are history. */
  async remove(actor: AuthUser, id: string): Promise<void> {
    const row = await this.repo.findById(id);
    if (!row) throw new AppError(ErrorCode.NOT_FOUND, 'Shift not found', { id });
    await this.manageableStaff(actor, row.staffId);
    rule(() => checkAssignmentDate(row.shiftDate, istDate(this.clock.now()), false));
    await this.uow.run(async (tx) => {
      await this.repo.delete(id, tx);
      await this.audit.write(tx, {
        action: 'SHIFT_DELETED',
        entityType: 'shift',
        entityId: id,
        details: { staffId: row.staffId, date: row.shiftDate },
      });
    });
  }

  private async visibleStaff(actor: AuthUser, staffId: string): Promise<Staff> {
    const person = await this.staff.findById(staffId);
    const visible =
      person &&
      canViewStaff(actor, {
        id: person.id,
        role: person.role,
        homeWardId: person.homeWardId ?? null,
        reportsToId: person.reportsToId ?? null,
        isActive: Boolean(Number(person.isActive)),
      });
    if (!person || !visible)
      throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: staffId });
    return person;
  }

  private async manageableStaff(actor: AuthUser, staffId: string): Promise<Staff> {
    const person = await this.staff.findById(staffId);
    if (!person) throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: staffId });
    const wardId = person.homeWardId ?? null;
    // Ward inspectors manage their ward's staff (not themselves); office staff and admins are ADMIN-only.
    const allowed =
      actor.role === Role.ADMIN ||
      (wardId !== null && person.id !== actor.staffId && canManageWard(actor, wardId));
    if (!allowed) throw new AppError(ErrorCode.FORBIDDEN);
    return person;
  }
}
