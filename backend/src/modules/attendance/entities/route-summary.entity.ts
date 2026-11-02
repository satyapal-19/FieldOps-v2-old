import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';

/**
 * One person's movement on one IST attendance date, rolled up nightly from the raw pings.
 * Aggregates only (no coordinates): it outlives the 90-day ping purge without keeping
 * anyone's location history.
 */
@Entity({ name: 'route_summaries' })
@Unique('uq_route_staff_date', ['staffId', 'summaryDate'])
export class RouteSummary {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'summary_date', type: dateType() })
  summaryDate: string;

  @Column({ name: 'attendance_id', type: varcharType(), length: 36, nullable: true })
  attendanceId: string | null;

  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  @Column({ name: 'ping_count', ...intColumn(), default: 0 })
  pingCount: number;

  @Column({ name: 'distance_m', ...intColumn(), default: 0 })
  distanceM: number;

  @Column({ name: 'first_ping_at', type: timestampType(), nullable: true })
  firstPingAt: Date | null;

  @Column({ name: 'last_ping_at', type: timestampType(), nullable: true })
  lastPingAt: Date | null;

  @Column({ name: 'in_ward_pings', ...intColumn(), default: 0 })
  inWardPings: number;

  @Column({ name: 'out_ward_pings', ...intColumn(), default: 0 })
  outWardPings: number;

  @Column({ name: 'stationary_pings', ...intColumn(), default: 0 })
  stationaryPings: number;

  @Column({ name: 'mocked_pings', ...intColumn(), default: 0 })
  mockedPings: number;

  @Column({ name: 'offline_pings', ...intColumn(), default: 0 })
  offlinePings: number;

  @Column({ name: 'max_gap_minutes', ...intColumn(), nullable: true })
  maxGapMinutes: number | null;

  /** Device and server tamper events that started that day. */
  @Column({ name: 'tamper_events', ...intColumn(), default: 0 })
  tamperEvents: number;

  @Column({ name: 'computed_at', type: timestampType() })
  computedAt: Date;
}
