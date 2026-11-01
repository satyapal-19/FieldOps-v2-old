import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, EntityManager, Repository } from 'typeorm';
import { Shift } from './entities/shift.entity';

export type ShiftChanges = Partial<
  Pick<Shift, 'shiftType' | 'startTime' | 'endTime' | 'updatedAt'>
>;

/** The only place that queries the shifts table. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class ShiftsRepository {
  constructor(@InjectRepository(Shift) private readonly repo: Repository<Shift>) {}

  private r(tx?: EntityManager): Repository<Shift> {
    return tx ? tx.getRepository(Shift) : this.repo;
  }

  findById(id: string): Promise<Shift | null> {
    return this.repo.findOne({ where: { id } });
  }

  findFor(staffId: string, date: string, tx?: EntityManager): Promise<Shift | null> {
    return this.r(tx).findOne({ where: { staffId, shiftDate: date } });
  }

  findRange(staffId: string, from: string, to: string): Promise<Shift[]> {
    return this.repo.find({
      where: { staffId, shiftDate: Between(from, to) },
      order: { shiftDate: 'ASC' },
    });
  }

  async insert(row: Shift, tx?: EntityManager): Promise<void> {
    await this.r(tx).insert(row);
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: ShiftChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.r(tx).update(
      { id, version: expectedVersion },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }

  async delete(id: string, tx?: EntityManager): Promise<void> {
    await this.r(tx).delete({ id });
  }
}
