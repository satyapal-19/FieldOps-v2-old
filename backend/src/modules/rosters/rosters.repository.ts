import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { DailyAssignment } from './entities/daily-assignment.entity';
import { StandingRoster } from './entities/standing-roster.entity';

export type RosterChanges = Partial<
  Pick<StandingRoster, 'inspectorId' | 'wardInspectorId' | 'wardId' | 'isActive' | 'updatedAt'>
>;

/** Assignment list filters; `scope` is the caller's visibility, decided by the policy. */
export interface AssignmentFilter {
  date: string;
  wardId?: string;
  inspectorId?: string;
  staffId?: string;
  isApproved?: boolean;
}

/** The only place that queries standing_rosters and daily_assignments. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class RostersRepository {
  constructor(
    @InjectRepository(StandingRoster) private readonly rosters: Repository<StandingRoster>,
    @InjectRepository(DailyAssignment) private readonly assignments: Repository<DailyAssignment>,
  ) {}

  private rr(tx?: EntityManager): Repository<StandingRoster> {
    return tx ? tx.getRepository(StandingRoster) : this.rosters;
  }

  private ar(tx?: EntityManager): Repository<DailyAssignment> {
    return tx ? tx.getRepository(DailyAssignment) : this.assignments;
  }

  // ------------------------------------------------------------ Standing rosters

  findRoster(id: string): Promise<StandingRoster | null> {
    return this.rosters.findOne({ where: { id } });
  }

  findRosterPage(
    filter: { wardId?: string; inspectorId?: string; isActive?: boolean },
    skip: number,
    take: number,
  ): Promise<[StandingRoster[], number]> {
    return this.rosters.findAndCount({
      where: { wardId: filter.wardId, inspectorId: filter.inspectorId, isActive: filter.isActive },
      order: { wardId: 'ASC', inspectorId: 'ASC', workerId: 'ASC' },
      skip,
      take,
    });
  }

  findActiveRosters(): Promise<StandingRoster[]> {
    return this.rosters.find({ where: { isActive: true } });
  }

  async insertRoster(row: StandingRoster, tx?: EntityManager): Promise<void> {
    try {
      await this.rr(tx).insert(row);
    } catch (error) {
      if (isUniqueViolation(error))
        throw new AppError(ErrorCode.ROSTER_WORKER_TAKEN, undefined, { workerId: row.workerId });
      throw error;
    }
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateRosterVersioned(
    id: string,
    expectedVersion: number,
    changes: RosterChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.rr(tx).update(
      { id, version: expectedVersion },
      { ...changes, version: expectedVersion + 1 },
    );
    return result.affected ?? 0;
  }

  // ------------------------------------------------------------ Daily assignments

  findAssignment(id: string, tx?: EntityManager): Promise<DailyAssignment | null> {
    return this.ar(tx).findOne({ where: { id } });
  }

  findAssignmentFor(
    date: string,
    staffId: string,
    tx?: EntityManager,
  ): Promise<DailyAssignment | null> {
    return this.ar(tx).findOne({ where: { shiftDate: date, staffId } });
  }

  /** Approved placements of an IST date (for the daily ward summary). */
  findApprovedOn(date: string): Promise<DailyAssignment[]> {
    return this.ar().find({
      where: { shiftDate: date, isApproved: true },
      select: { id: true, staffId: true, wardId: true },
    });
  }

  findByClientUuid(clientUuid: string): Promise<DailyAssignment | null> {
    return this.assignments.findOne({ where: { clientUuid } });
  }

  findAssignments(
    filter: AssignmentFilter,
    skip: number,
    take: number,
  ): Promise<[DailyAssignment[], number]> {
    return this.assignments.findAndCount({
      where: {
        shiftDate: filter.date,
        wardId: filter.wardId,
        inspectorId: filter.inspectorId,
        staffId: filter.staffId,
        isApproved: filter.isApproved,
      },
      order: { wardId: 'ASC', inspectorId: 'ASC', staffRole: 'ASC', staffId: 'ASC' },
      skip,
      take,
    });
  }

  /** Who is already placed on a date (for the standing-roster generator). */
  async findPlacements(date: string, tx?: EntityManager): Promise<DailyAssignment[]> {
    return this.ar(tx).find({
      where: { shiftDate: date },
      select: { id: true, staffId: true, staffRole: true, wardId: true },
    });
  }

  async insertAssignments(rows: DailyAssignment[], tx?: EntityManager): Promise<void> {
    if (rows.length === 0) return;
    try {
      // Batches keep each INSERT well under driver bind-variable limits.
      for (let i = 0; i < rows.length; i += 500) await this.ar(tx).insert(rows.slice(i, i + 500));
    } catch (error) {
      if (isUniqueViolation(error)) throw new AppError(ErrorCode.ASSIGNMENT_EXISTS);
      throw error;
    }
  }

  async approve(
    id: string,
    expectedVersion: number,
    approvedById: string,
    at: Date,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.ar(tx).update(
      { id, version: expectedVersion, isApproved: false },
      {
        isApproved: true,
        approvedById,
        approvedAt: at,
        updatedAt: at,
        version: expectedVersion + 1,
      },
    );
    return result.affected ?? 0;
  }
}
