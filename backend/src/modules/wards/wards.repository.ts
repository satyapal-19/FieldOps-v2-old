import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { Ward } from './entities/ward.entity';

export type WardChanges = Partial<
  Pick<Ward, 'name' | 'nameMr' | 'zone' | 'boundaryGeojson' | 'isActive' | 'updatedAt'>
>;

/** The only place that queries the wards table. No business decisions here. */
@Injectable()
export class WardsRepository {
  constructor(@InjectRepository(Ward) private readonly repo: Repository<Ward>) {}

  findPage(skip: number, take: number): Promise<[Ward[], number]> {
    return this.repo.findAndCount({ order: { code: 'ASC' }, skip, take });
  }

  findById(id: string): Promise<Ward | null> {
    return this.repo.findOne({ where: { id } });
  }

  findByCode(code: string): Promise<Ward | null> {
    return this.repo.findOne({ where: { code } });
  }

  private r(tx?: EntityManager): Repository<Ward> {
    return tx ? tx.getRepository(Ward) : this.repo;
  }

  async insert(ward: Ward, tx?: EntityManager): Promise<void> {
    try {
      await this.r(tx).insert(ward);
    } catch (error) {
      if (isUniqueViolation(error)) {
        throw new AppError(ErrorCode.WARD_CODE_TAKEN, undefined, { code: ward.code });
      }
      throw error;
    }
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: WardChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.r(tx).update(
      { id, version: expectedVersion },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }
}
