import { Column, Entity, PrimaryColumn } from 'typeorm';
import { decimalColumn, timestampType, varcharType } from '../../../shared/database/column-types';
import type { TamperEventType, TamperSource } from '../attendance-types';

/** GPS off, permission revoked, mock location, or a silent gap found by the server. */
@Entity({ name: 'tamper_events' })
export class TamperEvent {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** Idempotency key for phone reports; null for server-detected gaps. */
  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'event_type', type: varcharType(), length: 30 })
  eventType: TamperEventType;

  @Column({ type: varcharType(), length: 10 })
  source: TamperSource;

  @Column({ name: 'started_at', type: timestampType() })
  startedAt: Date;

  @Column({ name: 'resolved_at', type: timestampType(), nullable: true })
  resolvedAt: Date | null;

  @Column({ name: 'last_lat', ...decimalColumn(10, 7), nullable: true })
  lastLat: number | null;

  @Column({ name: 'last_lng', ...decimalColumn(10, 7), nullable: true })
  lastLng: number | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;
}
