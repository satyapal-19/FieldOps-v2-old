import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, EntityManager, In, LessThan, LessThanOrEqual, Repository } from 'typeorm';
import { SpotCheck, type SpotCheckStatus } from './entities/spot-check.entity';

export interface SpotFilter {
  date?: string;
  status?: SpotCheckStatus;
  wardId?: string;
  /** Checks of these people (OR-ed with wardId when both are set: an inspector's team). */
  staffIds?: readonly string[];
}

const OPEN: SpotCheckStatus[] = ['NOTIFIED', 'SNOOZED'];

/** The only place that queries spot_checks. */
@Injectable()
export class SpotChecksRepository {
  constructor(@InjectRepository(SpotCheck) private readonly checks: Repository<SpotCheck>) {}

  private r(tx?: EntityManager): Repository<SpotCheck> {
    return tx ? tx.getRepository(SpotCheck) : this.checks;
  }

  findById(id: string): Promise<SpotCheck | null> {
    return this.checks.findOne({ where: { id } });
  }

  findByResponseUuid(clientUuid: string): Promise<SpotCheck | null> {
    return this.checks.findOne({ where: { responseClientUuid: clientUuid } });
  }

  /** People who already have a random check for that date (decided once per shift). */
  async withRandomOn(date: string, staffIds: readonly string[]): Promise<Set<string>> {
    const found = new Set<string>();
    for (let i = 0; i < staffIds.length; i += 1000) {
      const rows = await this.checks.find({
        where: { shiftDate: date, triggerType: 'RANDOM', staffId: In(staffIds.slice(i, i + 1000)) },
        select: { staffId: true },
      });
      rows.forEach((r) => found.add(r.staffId));
    }
    return found;
  }

  findDueScheduled(now: Date): Promise<SpotCheck[]> {
    return this.checks.find({ where: { status: 'SCHEDULED', scheduledAt: LessThanOrEqual(now) } });
  }

  findOverdue(now: Date): Promise<SpotCheck[]> {
    return this.checks.find({ where: { status: In(OPEN), dueAt: LessThan(now) } });
  }

  findOpenFor(staffId: string): Promise<SpotCheck[]> {
    return this.checks.find({ where: { staffId, status: In(OPEN) }, order: { dueAt: 'ASC' } });
  }

  findPage(filter: SpotFilter, skip: number, take: number): Promise<[SpotCheck[], number]> {
    const qb = this.checks.createQueryBuilder('s');
    if (filter.date) qb.andWhere('s.shiftDate = :date', { date: filter.date });
    if (filter.status) qb.andWhere('s.status = :status', { status: filter.status });
    if (filter.wardId || filter.staffIds) {
      qb.andWhere(
        new Brackets((w) => {
          if (filter.wardId) w.orWhere('s.wardId = :wardId', { wardId: filter.wardId });
          const ids = filter.staffIds ?? [];
          for (let i = 0; i < ids.length; i += 1000) {
            w.orWhere(`s.staffId IN (:...p${i})`, { [`p${i}`]: ids.slice(i, i + 1000) });
          }
          if (!filter.wardId && ids.length === 0) w.where('1 = 0');
        }),
      );
    }
    return qb.orderBy('s.scheduledAt', 'DESC').skip(skip).take(take).getManyAndCount();
  }

  async insert(row: SpotCheck, tx?: EntityManager): Promise<void> {
    await this.r(tx).insert(row);
  }

  /** Versioned update. Returns rows changed: 0 = someone else changed it first. */
  async update(row: SpotCheck, changes: Partial<SpotCheck>, tx?: EntityManager): Promise<number> {
    const version = Number(row.version);
    const result = await this.r(tx).update(
      { id: row.id, version },
      { ...changes, version: version + 1 },
    );
    return result.affected ?? 0;
  }
}
