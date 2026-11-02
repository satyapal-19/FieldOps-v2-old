import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, LessThan, Repository } from 'typeorm';
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
}
