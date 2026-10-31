import { Injectable } from '@nestjs/common';
import type { EntityManager } from 'typeorm';
import { Clock } from '../clock/clock';
import { currentRequestContext } from '../context/request-context';
import { IdGenerator } from '../ids/id-generator';
import { AuditLog } from './audit-log.entity';
import { sanitizeAuditDetails } from './audit-details';

export interface AuditEntry {
  action: string;
  entityType: string;
  entityId?: string | null;
  details?: Record<string, unknown>;
  /** Set when there is no signed-in caller yet (e.g. a login). */
  actorId?: string | null;
  actorRole?: string | null;
}

/**
 * Writes audit rows. Always pass the transaction's EntityManager, so the audit row
 * commits or rolls back together with the change.
 */
@Injectable()
export class AuditWriter {
  constructor(
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  async write(tx: EntityManager, entry: AuditEntry): Promise<void> {
    const ctx = currentRequestContext();
    const row: AuditLog = {
      id: this.ids.next(),
      occurredAt: this.clock.now(),
      actorId: entry.actorId ?? ctx?.actor?.staffId ?? null,
      actorRole: entry.actorRole ?? ctx?.actor?.role ?? null,
      action: entry.action,
      entityType: entry.entityType,
      entityId: entry.entityId ?? null,
      requestId: ctx?.requestId || null,
      ip: ctx?.ip ?? null,
      detailsJson: sanitizeAuditDetails(entry.details),
    };
    await tx.getRepository(AuditLog).insert(row);
  }
}
