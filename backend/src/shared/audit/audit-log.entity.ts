import { Column, Entity, PrimaryColumn } from 'typeorm';
import { longTextType, timestampType, varcharType } from '../database/column-types';

/**
 * Append-only record of every change and security event (SMKC: audit trail).
 * Written in the same transaction as the change it describes, so neither exists without the other.
 */
@Entity({ name: 'audit_log' })
export class AuditLog {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'occurred_at', type: timestampType() })
  occurredAt: Date;

  @Column({ name: 'actor_id', type: varcharType(), length: 36, nullable: true })
  actorId: string | null;

  @Column({ name: 'actor_role', type: varcharType(), length: 20, nullable: true })
  actorRole: string | null;

  /** e.g. STAFF_CREATED, LOGIN_SUCCEEDED, WARD_UPDATED */
  @Column({ type: varcharType(), length: 60 })
  action: string;

  @Column({ name: 'entity_type', type: varcharType(), length: 40 })
  entityType: string;

  @Column({ name: 'entity_id', type: varcharType(), length: 36, nullable: true })
  entityId: string | null;

  @Column({ name: 'request_id', type: varcharType(), length: 64, nullable: true })
  requestId: string | null;

  @Column({ type: varcharType(), length: 45, nullable: true })
  ip: string | null;

  /** Small JSON object: changed field names, reasons. Never secrets, OTPs or face data. */
  @Column({ name: 'details_json', type: longTextType(), nullable: true })
  detailsJson: string | null;
}
