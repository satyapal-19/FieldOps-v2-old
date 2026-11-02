import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, EntityManager, ObjectLiteral, Repository, SelectQueryBuilder } from 'typeorm';
import { LeaveRequest, ReviewStatus } from './entities/leave-request.entity';
import { RegularizationRequest } from './entities/regularization-request.entity';

export interface RequestFilter {
  /** Restrict to these requesters (a caller's scope); undefined = everyone. */
  staffIds?: readonly string[];
  status?: ReviewStatus;
  /** Inclusive IST date window on the request's day(s). */
  from?: string;
  to?: string;
}

export type ReviewChanges = {
  status: ReviewStatus;
  reviewedById?: string | null;
  reviewedAt?: Date | null;
  reviewNote?: string | null;
  updatedAt: Date;
};

/** `col IN (...)` in chunks of 1000 joined by OR (Oracle's IN-list limit). */
function whereIn<T extends ObjectLiteral>(
  qb: SelectQueryBuilder<T>,
  column: string,
  ids: readonly string[],
): void {
  if (ids.length === 0) {
    qb.andWhere('1 = 0');
    return;
  }
  qb.andWhere(
    new Brackets((w) => {
      for (let i = 0; i < ids.length; i += 1000) {
        w.orWhere(`${column} IN (:...ids${i})`, { [`ids${i}`]: ids.slice(i, i + 1000) });
      }
    }),
  );
}

/** The only place that queries leave_requests and regularization_requests. */
@Injectable()
export class LeaveRepository {
  constructor(
    @InjectRepository(LeaveRequest) private readonly leave: Repository<LeaveRequest>,
    @InjectRepository(RegularizationRequest)
    private readonly regs: Repository<RegularizationRequest>,
  ) {}

  private lr(tx?: EntityManager): Repository<LeaveRequest> {
    return tx ? tx.getRepository(LeaveRequest) : this.leave;
  }

  private rr(tx?: EntityManager): Repository<RegularizationRequest> {
    return tx ? tx.getRepository(RegularizationRequest) : this.regs;
  }

  // ------------------------------------------------------------ Leave

  findLeave(id: string): Promise<LeaveRequest | null> {
    return this.leave.findOne({ where: { id } });
  }

  findLeaveByClientUuid(clientUuid: string): Promise<LeaveRequest | null> {
    return this.leave.findOne({ where: { clientUuid } });
  }

  /** Pending or approved leave of this person that touches [from, to]. */
  findOverlappingLeave(
    staffId: string,
    from: string,
    to: string,
    tx?: EntityManager,
  ): Promise<LeaveRequest | null> {
    return this.lr(tx)
      .createQueryBuilder('l')
      .where('l.staffId = :staffId', { staffId })
      .andWhere('l.status IN (:...open)', { open: ['PENDING', 'APPROVED'] })
      .andWhere('l.fromDate <= :to', { to })
      .andWhere('l.toDate >= :from', { from })
      .getOne();
  }

  /** Approved leave of this person covering `date`. */
  findApprovedLeaveOn(staffId: string, date: string): Promise<LeaveRequest | null> {
    return this.leave
      .createQueryBuilder('l')
      .where('l.staffId = :staffId', { staffId })
      .andWhere('l.status = :approved', { approved: 'APPROVED' })
      .andWhere('l.fromDate <= :date', { date })
      .andWhere('l.toDate >= :date', { date })
      .getOne();
  }

  /** Everyone on approved leave on an IST date. */
  async findStaffOnLeave(date: string): Promise<Set<string>> {
    const rows = await this.leave
      .createQueryBuilder('l')
      .select('l.staffId', 'staffId')
      .where('l.status = :approved', { approved: 'APPROVED' })
      .andWhere('l.fromDate <= :date', { date })
      .andWhere('l.toDate >= :date', { date })
      .getRawMany<{ staffId: string }>();
    return new Set(rows.map((r) => r.staffId));
  }

  findLeavePage(
    filter: RequestFilter,
    skip: number,
    take: number,
  ): Promise<[LeaveRequest[], number]> {
    const qb = this.leave.createQueryBuilder('l');
    if (filter.staffIds) whereIn(qb, 'l.staffId', filter.staffIds);
    if (filter.status) qb.andWhere('l.status = :status', { status: filter.status });
    if (filter.from) qb.andWhere('l.toDate >= :from', { from: filter.from });
    if (filter.to) qb.andWhere('l.fromDate <= :to', { to: filter.to });
    return qb
      .orderBy('l.fromDate', 'DESC')
      .addOrderBy('l.createdAt', 'DESC')
      .skip(skip)
      .take(take)
      .getManyAndCount();
  }

  async insertLeave(row: LeaveRequest, tx?: EntityManager): Promise<void> {
    await this.lr(tx).insert(row);
  }

  /** Applies the change only if the row still has `expectedVersion` and `fromStatus`. */
  async updateLeave(
    id: string,
    expectedVersion: number,
    fromStatus: ReviewStatus,
    changes: ReviewChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.lr(tx).update(
      { id, version: expectedVersion, status: fromStatus },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }

  // ------------------------------------------------------------ Regularization

  findRegularization(id: string): Promise<RegularizationRequest | null> {
    return this.regs.findOne({ where: { id } });
  }

  findRegularizationByClientUuid(clientUuid: string): Promise<RegularizationRequest | null> {
    return this.regs.findOne({ where: { clientUuid } });
  }

  /** A pending or approved request for this person and day, if any. */
  findOpenRegularization(
    staffId: string,
    date: string,
    tx?: EntityManager,
  ): Promise<RegularizationRequest | null> {
    return this.rr(tx)
      .createQueryBuilder('r')
      .where('r.staffId = :staffId', { staffId })
      .andWhere('r.attendanceDate = :date', { date })
      .andWhere('r.status IN (:...open)', { open: ['PENDING', 'APPROVED'] })
      .getOne();
  }

  findRegularizationPage(
    filter: RequestFilter,
    skip: number,
    take: number,
  ): Promise<[RegularizationRequest[], number]> {
    const qb = this.regs.createQueryBuilder('r');
    if (filter.staffIds) whereIn(qb, 'r.staffId', filter.staffIds);
    if (filter.status) qb.andWhere('r.status = :status', { status: filter.status });
    if (filter.from) qb.andWhere('r.attendanceDate >= :from', { from: filter.from });
    if (filter.to) qb.andWhere('r.attendanceDate <= :to', { to: filter.to });
    return qb
      .orderBy('r.attendanceDate', 'DESC')
      .addOrderBy('r.createdAt', 'DESC')
      .skip(skip)
      .take(take)
      .getManyAndCount();
  }

  async insertRegularization(row: RegularizationRequest, tx?: EntityManager): Promise<void> {
    await this.rr(tx).insert(row);
  }

  async updateRegularization(
    id: string,
    expectedVersion: number,
    fromStatus: ReviewStatus,
    changes: ReviewChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.rr(tx).update(
      { id, version: expectedVersion, status: fromStatus },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }
}
