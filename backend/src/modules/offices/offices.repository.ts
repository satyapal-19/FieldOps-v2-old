import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { CorporationOffice } from './entities/corporation-office.entity';

export type OfficeChanges = Partial<
  Pick<CorporationOffice, 'name' | 'nameMr' | 'zone' | 'premisesGeojson' | 'bufferMeters' | 'isActive' | 'updatedAt'>
>;

/** The only place that queries corporation_offices. */
@Injectable()
export class OfficesRepository {
  constructor(@InjectRepository(CorporationOffice) private readonly repo: Repository<CorporationOffice>) {}

  private r(tx?: EntityManager): Repository<CorporationOffice> {
    return tx ? tx.getRepository(CorporationOffice) : this.repo;
  }

  findAll(): Promise<CorporationOffice[]> {
    return this.repo.find({ order: { code: 'ASC' } });
  }

  findById(id: string): Promise<CorporationOffice | null> {
    return this.repo.findOne({ where: { id } });
  }

  findByCode(code: string): Promise<CorporationOffice | null> {
    return this.repo.findOne({ where: { code } });
  }

  async insert(office: CorporationOffice, tx?: EntityManager): Promise<void> {
    try {
      await this.r(tx).insert(office);
    } catch (error) {
      if (isUniqueViolation(error)) throw new AppError(ErrorCode.OFFICE_CODE_TAKEN, undefined, { code: office.code });
      throw error;
    }
  }

  async updateVersioned(id: string, expectedVersion: number, changes: OfficeChanges, tx?: EntityManager): Promise<number> {
    const result = await this.r(tx).update({ id, version: expectedVersion }, { ...changes, version: expectedVersion + 1 });
    return result.affected ?? 0;
  }
}
