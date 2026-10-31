import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { Staff } from './entities/staff.entity';

export type StaffChanges = Partial<Omit<Staff, 'id' | 'version' | 'createdAt'>>;

/** The only place that queries the staff table. Pass `tx` when inside a UnitOfWork. */
@Injectable()
export class StaffRepository {
  constructor(@InjectRepository(Staff) private readonly repo: Repository<Staff>) {}

  private r(tx?: EntityManager): Repository<Staff> {
    return tx ? tx.getRepository(Staff) : this.repo;
  }

  findById(id: string, tx?: EntityManager): Promise<Staff | null> {
    return this.r(tx).findOne({ where: { id } });
  }

  findByPhone(phone: string): Promise<Staff | null> {
    return this.repo.findOne({ where: { phone } });
  }

  findByEmployeeCode(employeeCode: string): Promise<Staff | null> {
    return this.repo.findOne({ where: { employeeCode } });
  }

  async insert(staff: Staff, tx?: EntityManager): Promise<void> {
    try {
      await this.r(tx).insert(staff);
    } catch (error) {
      if (isUniqueViolation(error)) {
        // Which unique key clashed is checked by the service before insert; this is the race fallback.
        throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
      }
      throw error;
    }
  }

  async setPasswordHash(id: string, passwordHash: string, at: Date, tx?: EntityManager): Promise<void> {
    await this.r(tx).update({ id }, { passwordHash, updatedAt: at });
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: StaffChanges,
    tx?: EntityManager,
  ): Promise<number> {
    try {
      const result = await this.r(tx).update(
        { id, version: expectedVersion },
        { ...changes, version: expectedVersion + 1 },
      );
      return result.affected ?? 0;
    } catch (error) {
      if (isUniqueViolation(error)) throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
      throw error;
    }
  }
}
