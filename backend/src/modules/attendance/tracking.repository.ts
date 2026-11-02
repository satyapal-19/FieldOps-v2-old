import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Between, In, IsNull, LessThan, MoreThan, Repository } from 'typeorm';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { LocationPing } from './entities/location-ping.entity';
import { TamperEvent } from './entities/tamper-event.entity';

/** Oracle's IN-list limit, and a safe size for one multi-row insert. */
const CHUNK = 1000;
const INSERT_CHUNK = 100;

/** The only place that queries location_pings and tamper_events. */
@Injectable()
export class TrackingRepository {
  constructor(
    @InjectRepository(LocationPing) private readonly pings: Repository<LocationPing>,
    @InjectRepository(TamperEvent) private readonly tamper: Repository<TamperEvent>,
  ) {}

  /** Which of these ping idempotency keys are already stored. */
  async existingPingUuids(uuids: string[]): Promise<Set<string>> {
    const found = new Set<string>();
    for (let i = 0; i < uuids.length; i += CHUNK) {
      const rows = await this.pings.find({
        select: { clientUuid: true },
        where: { clientUuid: In(uuids.slice(i, i + CHUNK)) },
      });
      rows.forEach((r) => found.add(r.clientUuid));
    }
    return found;
  }

  /** The person's last ping before `before`, for the stationary and out-of-zone checks. */
  lastPingBefore(staffId: string, before: Date): Promise<LocationPing | null> {
    return this.pings.findOne({
      where: { staffId, recordedAt: LessThan(before) },
      order: { recordedAt: 'DESC' },
    });
  }

  /**
   * Bulk insert in chunks. A chunk that hits a duplicate (the same batch sent twice at once)
   * is retried row by row, skipping the duplicates. Returns how many rows were inserted.
   */
  async insertPings(rows: LocationPing[]): Promise<number> {
    let inserted = 0;
    for (let i = 0; i < rows.length; i += INSERT_CHUNK) {
      const chunk = rows.slice(i, i + INSERT_CHUNK);
      try {
        await this.pings.insert(chunk);
        inserted += chunk.length;
      } catch (error) {
        if (!isUniqueViolation(error)) throw error;
        for (const row of chunk) {
          try {
            await this.pings.insert(row);
            inserted++;
          } catch (e) {
            if (!isUniqueViolation(e)) throw e;
          }
        }
      }
    }
    return inserted;
  }

  findTamperByClientUuid(clientUuid: string): Promise<TamperEvent | null> {
    return this.tamper.findOne({ where: { clientUuid } });
  }

  async insertTamper(row: TamperEvent): Promise<void> {
    await this.tamper.insert(row);
  }

  /** Records when an open event ended (the phone re-sends it once resolved). */
  async resolveTamper(id: string, resolvedAt: Date): Promise<void> {
    await this.tamper.update({ id, resolvedAt: IsNull() }, { resolvedAt });
  }

  // ------------------------------------------------------------ Jobs and route history

  /** Each person's latest ping recorded at or after `since` (silent-gap detection). */
  async lastPingTimes(staffIds: readonly string[], since: Date): Promise<Map<string, Date>> {
    const last = new Map<string, Date>();
    for (let i = 0; i < staffIds.length; i += CHUNK) {
      const rows = await this.pings
        .createQueryBuilder('p')
        .select('p.staffId', 'staffId')
        .addSelect('MAX(p.recordedAt)', 'lastAt')
        .where('p.staffId IN (:...ids)', { ids: staffIds.slice(i, i + CHUNK) })
        .andWhere('p.recordedAt >= :since', { since })
        .groupBy('p.staffId')
        .getRawMany<{ staffId: string; lastAt: Date | string }>();
      rows.forEach((r) => last.set(r.staffId, new Date(r.lastAt)));
    }
    return last;
  }

  /** The person's last ping in an inclusive time range (auto-checkout's "last seen"). */
  lastPingBetween(staffId: string, from: Date, to: Date): Promise<LocationPing | null> {
    return this.pings.findOne({
      where: { staffId, recordedAt: Between(from, to) },
      order: { recordedAt: 'DESC' },
    });
  }

  /** The person's first ping after an instant (the end of a silent gap). */
  firstPingAfter(staffId: string, after: Date): Promise<LocationPing | null> {
    return this.pings.findOne({
      where: { staffId, recordedAt: MoreThan(after) },
      order: { recordedAt: 'ASC' },
    });
  }

  /** One person's pings in [from, to), oldest first. */
  pingsFor(staffId: string, from: Date, to: Date): Promise<LocationPing[]> {
    return this.pings
      .createQueryBuilder('p')
      .where('p.staffId = :staffId', { staffId })
      .andWhere('p.recordedAt >= :from', { from })
      .andWhere('p.recordedAt < :to', { to })
      .orderBy('p.recordedAt', 'ASC')
      .getMany();
  }

  /** Everyone with at least one ping in [from, to) (the roll-up works through them in chunks). */
  async staffWithPings(from: Date, to: Date): Promise<string[]> {
    const rows = await this.pings
      .createQueryBuilder('p')
      .select('p.staffId', 'staffId')
      .where('p.recordedAt >= :from', { from })
      .andWhere('p.recordedAt < :to', { to })
      .groupBy('p.staffId')
      .getRawMany<{ staffId: string }>();
    return rows.map((r) => r.staffId);
  }

  /** The pings of several people in [from, to), ordered by person then time. */
  async pingsOfStaff(staffIds: readonly string[], from: Date, to: Date): Promise<LocationPing[]> {
    const rows: LocationPing[] = [];
    for (let i = 0; i < staffIds.length; i += CHUNK) {
      rows.push(
        ...(await this.pings
          .createQueryBuilder('p')
          .where('p.staffId IN (:...ids)', { ids: staffIds.slice(i, i + CHUNK) })
          .andWhere('p.recordedAt >= :from', { from })
          .andWhere('p.recordedAt < :to', { to })
          .orderBy('p.staffId', 'ASC')
          .addOrderBy('p.recordedAt', 'ASC')
          .getMany()),
      );
    }
    return rows;
  }

  /**
   * Deletes pings recorded before the cut-off, `batch` rows per statement so the purge never
   * holds one huge transaction (no Oracle Partitioning). Returns how many were deleted.
   */
  async deletePingsBefore(cutoff: Date, batch = CHUNK): Promise<number> {
    let deleted = 0;
    for (;;) {
      const ids = (
        await this.pings.find({
          select: { id: true },
          where: { recordedAt: LessThan(cutoff) },
          take: batch,
        })
      ).map((r) => r.id);
      if (ids.length === 0) return deleted;
      await this.pings.delete({ id: In(ids) });
      deleted += ids.length;
    }
  }

  /** Unresolved silent gaps found by the server. */
  findOpenSilentGaps(): Promise<TamperEvent[]> {
    return this.tamper.find({
      where: { eventType: 'SILENT_GAP', source: 'SERVER', resolvedAt: IsNull() },
    });
  }

  /** Tamper events of one person that started in [from, to), oldest first. */
  tamperFor(staffId: string, from: Date, to: Date): Promise<TamperEvent[]> {
    return this.tamper
      .createQueryBuilder('t')
      .where('t.staffId = :staffId', { staffId })
      .andWhere('t.startedAt >= :from', { from })
      .andWhere('t.startedAt < :to', { to })
      .orderBy('t.startedAt', 'ASC')
      .getMany();
  }

  /** How many tamper events each person had starting in [from, to). */
  async tamperCounts(from: Date, to: Date): Promise<Map<string, number>> {
    const rows = await this.tamper
      .createQueryBuilder('t')
      .select('t.staffId', 'staffId')
      .addSelect('COUNT(*)', 'n')
      .where('t.startedAt >= :from', { from })
      .andWhere('t.startedAt < :to', { to })
      .groupBy('t.staffId')
      .getRawMany<{ staffId: string; n: number | string }>();
    return new Map(rows.map((r) => [r.staffId, Number(r.n)]));
  }
}
