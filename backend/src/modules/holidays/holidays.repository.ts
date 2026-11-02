import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, EntityManager, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { Holiday } from './entities/holiday.entity';

export type HolidayChanges = Partial<
  Pick<Holiday, 'holidayDate' | 'name' | 'nameMr' | 'holidayType' | 'updatedAt'>
>;

/** The only place that queries the holidays table. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class HolidaysRepository {
  constructor(@InjectRepository(Holiday) private readonly repo: Repository<Holiday>) {}

  private r(tx?: EntityManager): Repository<Holiday> {
    return tx ? tx.getRepository(Holiday) : this.repo;
  }

  findById(id: string): Promise<Holiday | null> {
    return this.repo.findOne({ where: { id } });
  }

  findByDate(date: string): Promise<Holiday | null> {
    return this.repo.findOne({ where: { holidayDate: date } });
  }

  findRange(from: string, to: string): Promise<Holiday[]> {
    return this.repo.find({
      where: { holidayDate: Between(from, to) },
      order: { holidayDate: 'ASC' },
    });
  }

  async insert(row: Holiday, tx?: EntityManager): Promise<void> {
    try {
      await this.r(tx).insert(row);
    } catch (error) {
      if (isUniqueViolation(error))
        throw new AppError(ErrorCode.HOLIDAY_DATE_TAKEN, undefined, { date: row.holidayDate });
      throw error;
    }
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: HolidayChanges,
    tx?: EntityManager,
  ): Promise<number> {
    try {
      const result = await this.r(tx).update(
        { id, version: expectedVersion },
        { ...changes, version: expectedVersion + 1 },
      );
      return result.affected ?? 0;
    } catch (error) {
      if (isUniqueViolation(error))
        throw new AppError(ErrorCode.HOLIDAY_DATE_TAKEN, undefined, { date: changes.holidayDate });
      throw error;
    }
  }

  async delete(id: string, tx?: EntityManager): Promise<void> {
    await this.r(tx).delete({ id });
  }
}
