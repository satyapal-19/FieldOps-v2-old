import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  decimalColumn,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';

/**
 * A breadcrumb from the phone, sent every 10 minutes on duty (batched when offline).
 * The busiest table (~190k rows a day): rolled up nightly and purged after 90 days.
 */
@Entity({ name: 'location_pings' })
export class LocationPing {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** Idempotency key from the phone's outbox. */
  @Column({ name: 'client_uuid', type: varcharType(), length: 36, unique: true })
  clientUuid: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'attendance_id', type: varcharType(), length: 36, nullable: true })
  attendanceId: string | null;

  @Column({ ...decimalColumn(10, 7) })
  lat: number;

  @Column({ ...decimalColumn(10, 7) })
  lng: number;

  @Column({ name: 'accuracy_m', ...decimalColumn(8, 2), nullable: true })
  accuracyM: number | null;

  @Column({ name: 'battery_pct', ...intColumn(), nullable: true })
  batteryPct: number | null;

  /** Inside the assigned ward (25 m edge allowance); null when there was no ward to check. */
  @Column({ name: 'in_ward', ...booleanColumn(), nullable: true })
  inWard: boolean | null;

  @Column({ name: 'is_mocked', ...booleanColumn(), default: 0 })
  isMocked: boolean;

  @Column({ name: 'is_stationary', ...booleanColumn(), default: 0 })
  isStationary: boolean;

  @Column({ name: 'from_offline', ...booleanColumn(), default: 0 })
  fromOffline: boolean;

  /** Phone time of the fix (UTC). */
  @Column({ name: 'recorded_at', type: timestampType() })
  recordedAt: Date;

  /** Server time the ping arrived (UTC). */
  @Column({ name: 'received_at', type: timestampType() })
  receivedAt: Date;
}
