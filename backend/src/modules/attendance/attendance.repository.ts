import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, EntityManager, In, IsNull, MoreThan, Repository } from 'typeorm';
import type { AttendanceStatus } from './attendance-types';
import { AttendanceLog } from './entities/attendance-log.entity';
import { LivenessChallenge } from './entities/liveness-challenge.entity';

export interface AttendanceFilter {
  /** Logs of these people; undefined = no restriction. */
  staffIds?: readonly string[];
  wardId?: string;
  status?: AttendanceStatus;
  /** Inclusive IST date range. */
  from?: string;
  to?: string;
}

/** The only place that queries attendance_logs and liveness_challenges. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class AttendanceRepository {
  constructor(
    @InjectRepository(AttendanceLog) private readonly logs: Repository<AttendanceLog>,
    @InjectRepository(LivenessChallenge)
    private readonly challenges: Repository<LivenessChallenge>,
  ) {}

  private lr(tx?: EntityManager): Repository<AttendanceLog> {
    return tx ? tx.getRepository(AttendanceLog) : this.logs;
  }

  findById(id: string): Promise<AttendanceLog | null> {
    return this.logs.findOne({ where: { id } });
  }

  /** The log a punch with this idempotency key created or closed, if any. */
  findByPunchUuid(clientUuid: string): Promise<AttendanceLog | null> {
    return this.logs.findOne({
      where: [{ checkinClientUuid: clientUuid }, { checkoutClientUuid: clientUuid }],
    });
  }

  findForDates(staffId: string, dates: string[]): Promise<AttendanceLog[]> {
    return this.logs.find({ where: { staffId, attendanceDate: In(dates) } });
  }

  /** Late check-ins of one person in an inclusive IST date range (the monthly late count). */
  countLate(staffId: string, from: string, to: string): Promise<number> {
    return this.logs
      .createQueryBuilder('l')
      .where('l.staffId = :staffId', { staffId })
      .andWhere('l.isLate = 1')
      .andWhere('l.attendanceDate >= :from', { from })
      .andWhere('l.attendanceDate <= :to', { to })
      .getCount();
  }

  findPage(
    filter: AttendanceFilter,
    skip: number,
    take: number,
  ): Promise<[AttendanceLog[], number]> {
    const qb = this.logs.createQueryBuilder('l');
    if (filter.staffIds) {
      if (filter.staffIds.length === 0) qb.andWhere('1 = 0');
      else {
        // Chunks of 1000: Oracle's IN-list limit.
        const ids = filter.staffIds;
        qb.andWhere(
          new Brackets((w) => {
            for (let i = 0; i < ids.length; i += 1000) {
              w.orWhere(`l.staffId IN (:...s${i})`, { [`s${i}`]: ids.slice(i, i + 1000) });
            }
          }),
        );
      }
    }
    if (filter.wardId) qb.andWhere('l.wardId = :wardId', { wardId: filter.wardId });
    if (filter.status) qb.andWhere('l.status = :status', { status: filter.status });
    if (filter.from) qb.andWhere('l.attendanceDate >= :from', { from: filter.from });
    if (filter.to) qb.andWhere('l.attendanceDate <= :to', { to: filter.to });
    return qb
      .orderBy('l.attendanceDate', 'DESC')
      .addOrderBy('l.checkinAt', 'DESC')
      .skip(skip)
      .take(take)
      .getManyAndCount();
  }

  async insert(row: AttendanceLog, tx: EntityManager): Promise<void> {
    await this.lr(tx).insert(row);
  }

  /**
   * Records the check-in on a log that exists without one (e.g. written ABSENT by the daily
   * job). Returns rows updated: 0 = someone checked in first.
   */
  async checkIn(
    id: string,
    version: number,
    fields: Partial<AttendanceLog>,
    tx: EntityManager,
  ): Promise<number> {
    const result = await this.lr(tx).update(
      { id, version, checkinAt: IsNull() },
      { ...fields, version: version + 1 },
    );
    return result.affected ?? 0;
  }

  /** Closes an open log. Returns rows updated: 0 = already checked out or changed meanwhile. */
  async checkOut(
    id: string,
    version: number,
    fields: Partial<AttendanceLog>,
    tx: EntityManager,
  ): Promise<number> {
    const result = await this.lr(tx).update(
      { id, version, checkoutAt: IsNull() },
      { ...fields, version: version + 1 },
    );
    return result.affected ?? 0;
  }

  // ------------------------------------------------------------ Liveness challenges

  async insertChallenge(row: LivenessChallenge): Promise<void> {
    await this.challenges.insert(row);
  }

  findChallenge(id: string): Promise<LivenessChallenge | null> {
    return this.challenges.findOne({ where: { id } });
  }

  /** Uses a challenge once. Returns rows updated: 0 = already used or expired. */
  async consumeChallenge(id: string, at: Date): Promise<number> {
    const result = await this.challenges.update(
      { id, usedAt: IsNull(), expiresAt: MoreThan(at) },
      { usedAt: at },
    );
    return result.affected ?? 0;
  }
}
