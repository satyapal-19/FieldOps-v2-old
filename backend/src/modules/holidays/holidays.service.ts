import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import type { CreateHolidayDto, HolidayDto, UpdateHolidayDto } from './dto/holiday.dto';
import { Holiday } from './entities/holiday.entity';
import { checkHolidayDate, HolidayRuleError, yearRange } from './holidays.policy';
import { HolidayChanges, HolidaysRepository } from './holidays.repository';

export function toHolidayDto(h: Holiday): HolidayDto {
  return {
    id: h.id,
    date: h.holidayDate,
    name: h.name,
    nameMr: h.nameMr ?? null,
    holidayType: h.holidayType,
    version: Number(h.version),
  };
}

function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof HolidayRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/** The SMKMC holiday calendar. Reads: any signed-in staff. Writes: ADMIN. */
@Injectable()
export class HolidaysService {
  constructor(
    private readonly repo: HolidaysRepository,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  async list(year: number): Promise<HolidayDto[]> {
    const { from, to } = yearRange(year);
    return (await this.repo.findRange(from, to)).map(toHolidayDto);
  }

  /** For other modules (attendance marks HOLIDAY_OFF, spot checks skip holidays). */
  async isHoliday(date: string): Promise<boolean> {
    return (await this.repo.findByDate(date)) !== null;
  }

  async create(dto: CreateHolidayDto): Promise<HolidayDto> {
    rule(() => checkHolidayDate(dto.date, this.today()));
    const now = this.clock.now();
    const row: Holiday = {
      id: this.ids.next(),
      holidayDate: dto.date,
      name: dto.name.trim(),
      nameMr: dto.nameMr?.trim() ?? null,
      holidayType: dto.holidayType ?? 'GAZETTE',
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    await this.uow.run(async (tx) => {
      await this.repo.insert(row, tx);
      await this.audit.write(tx, {
        action: 'HOLIDAY_CREATED',
        entityType: 'holiday',
        entityId: row.id,
        details: { date: row.holidayDate, name: row.name },
      });
    });
    return toHolidayDto(row);
  }

  async update(id: string, dto: UpdateHolidayDto): Promise<HolidayDto> {
    const existing = await this.findOrThrow(id);
    rule(() => checkHolidayDate(existing.holidayDate, this.today()));
    if (Number(existing.version) !== dto.expectedVersion) {
      throw this.versionConflict(existing.version, dto.expectedVersion);
    }
    const changes: HolidayChanges = { updatedAt: this.clock.now() };
    if (dto.date !== undefined) {
      rule(() => checkHolidayDate(dto.date!, this.today()));
      changes.holidayDate = dto.date;
    }
    if (dto.name !== undefined) changes.name = dto.name.trim();
    if (dto.nameMr !== undefined) changes.nameMr = dto.nameMr?.trim() ?? null;
    if (dto.holidayType !== undefined) changes.holidayType = dto.holidayType;

    const updated = await this.uow.run(async (tx) => {
      const count = await this.repo.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (count > 0) {
        await this.audit.write(tx, {
          action: 'HOLIDAY_UPDATED',
          entityType: 'holiday',
          entityId: id,
          details: { fields: Object.keys(changes).filter((k) => k !== 'updatedAt') },
        });
      }
      return count;
    });
    if (updated === 0) {
      const current = await this.findOrThrow(id);
      throw this.versionConflict(current.version, dto.expectedVersion);
    }
    return toHolidayDto(await this.findOrThrow(id));
  }

  async remove(id: string): Promise<void> {
    const existing = await this.findOrThrow(id);
    rule(() => checkHolidayDate(existing.holidayDate, this.today()));
    await this.uow.run(async (tx) => {
      await this.repo.delete(id, tx);
      await this.audit.write(tx, {
        action: 'HOLIDAY_DELETED',
        entityType: 'holiday',
        entityId: id,
        details: { date: existing.holidayDate, name: existing.name },
      });
    });
  }

  private async findOrThrow(id: string): Promise<Holiday> {
    const row = await this.repo.findById(id);
    if (!row) throw new AppError(ErrorCode.NOT_FOUND, 'Holiday not found', { id });
    return row;
  }

  private today(): string {
    return istDate(this.clock.now());
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
      currentVersion: Number(currentVersion),
      expectedVersion,
    });
  }
}
