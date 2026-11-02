import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { RouteSummary } from './entities/route-summary.entity';
import { WardDailySummary } from './entities/ward-daily-summary.entity';

/** The only place that queries route_summaries and ward_daily_summaries. */
@Injectable()
export class SummariesRepository {
  constructor(
    @InjectRepository(RouteSummary) private readonly routes: Repository<RouteSummary>,
    @InjectRepository(WardDailySummary) private readonly wards: Repository<WardDailySummary>,
  ) {}

  findRoute(staffId: string, date: string): Promise<RouteSummary | null> {
    return this.routes.findOne({ where: { staffId, summaryDate: date } });
  }

  /**
   * Writes a person's summary for a day, replacing an earlier one (the roll-up recomputes
   * a day until it is final). Insert-or-update without ON CONFLICT, which Oracle lacks.
   */
  async saveRoute(row: Omit<RouteSummary, 'id'>, newId: string): Promise<void> {
    const key = { staffId: row.staffId, summaryDate: row.summaryDate };
    if (((await this.routes.update(key, row)).affected ?? 0) > 0) return;
    try {
      await this.routes.insert({ ...row, id: newId });
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
      await this.routes.update(key, row); // another run inserted it first
    }
  }

  /** Trusted distance per ward on a day, summed from the route summaries. */
  async distanceByWard(date: string): Promise<Map<string, number>> {
    const rows = await this.routes
      .createQueryBuilder('r')
      .select('r.wardId', 'wardId')
      .addSelect('SUM(r.distanceM)', 'total')
      .where('r.summaryDate = :date', { date })
      .andWhere('r.wardId IS NOT NULL')
      .groupBy('r.wardId')
      .getRawMany<{ wardId: string; total: number | string }>();
    return new Map(rows.map((r) => [r.wardId, Number(r.total)]));
  }

  findWardSummaries(date: string, wardIds?: readonly string[]): Promise<WardDailySummary[]> {
    return this.wards.find({
      where: wardIds ? { summaryDate: date, wardId: In([...wardIds]) } : { summaryDate: date },
    });
  }

  /** Same insert-or-update as saveRoute, for one ward's day. */
  async saveWard(row: Omit<WardDailySummary, 'id'>, newId: string): Promise<void> {
    const key = { wardId: row.wardId, summaryDate: row.summaryDate };
    if (((await this.wards.update(key, row)).affected ?? 0) > 0) return;
    try {
      await this.wards.insert({ ...row, id: newId });
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
      await this.wards.update(key, row);
    }
  }
}
