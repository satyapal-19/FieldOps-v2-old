import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { CitizenComplaint, ComplaintStatus } from './entities/citizen-complaint.entity';

export type ComplaintChanges = Partial<
  Pick<CitizenComplaint, 'status' | 'wardId' | 'resolvedAt' | 'updatedAt'>
>;

/** The only place that queries citizen_complaints. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class ComplaintsRepository {
  constructor(
    @InjectRepository(CitizenComplaint) private readonly repo: Repository<CitizenComplaint>,
  ) {}

  private r(tx?: EntityManager): Repository<CitizenComplaint> {
    return tx ? tx.getRepository(CitizenComplaint) : this.repo;
  }

  findById(id: string): Promise<CitizenComplaint | null> {
    return this.repo.findOne({ where: { id } });
  }

  findByTrackingId(trackingId: string): Promise<CitizenComplaint | null> {
    return this.repo.findOne({ where: { trackingId } });
  }

  findByClientUuid(clientUuid: string): Promise<CitizenComplaint | null> {
    return this.repo.findOne({ where: { clientUuid } });
  }

  findPage(
    filter: { wardId?: string; status?: ComplaintStatus; unrouted?: boolean },
    skip: number,
    take: number,
  ): Promise<[CitizenComplaint[], number]> {
    const qb = this.repo.createQueryBuilder('c');
    if (filter.wardId) qb.andWhere('c.wardId = :wardId', { wardId: filter.wardId });
    if (filter.unrouted) qb.andWhere('c.wardId IS NULL');
    if (filter.status) qb.andWhere('c.status = :status', { status: filter.status });
    return qb.orderBy('c.createdAt', 'DESC').skip(skip).take(take).getManyAndCount();
  }

  async insert(row: CitizenComplaint, tx?: EntityManager): Promise<void> {
    await this.r(tx).insert(row);
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: ComplaintChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.r(tx).update(
      { id, version: expectedVersion },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }
}
