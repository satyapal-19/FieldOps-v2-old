import { Column, Entity, PrimaryColumn, Unique } from 'typeorm';
import {
  dateType,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';

/** Attendance counts of one ward on one IST date, written nightly; dashboards read these. */
@Entity({ name: 'ward_daily_summaries' })
@Unique('uq_ward_summary_date', ['wardId', 'summaryDate'])
export class WardDailySummary {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'ward_id', type: varcharType(), length: 36 })
  wardId: string;

  @Column({ name: 'summary_date', type: dateType() })
  summaryDate: string;

  @Column({ name: 'assigned_count', ...intColumn(), default: 0 })
  assignedCount: number;

  @Column({ name: 'present_count', ...intColumn(), default: 0 })
  presentCount: number;

  @Column({ name: 'late_count', ...intColumn(), default: 0 })
  lateCount: number;

  @Column({ name: 'half_day_count', ...intColumn(), default: 0 })
  halfDayCount: number;

  @Column({ name: 'absent_count', ...intColumn(), default: 0 })
  absentCount: number;

  @Column({ name: 'on_leave_count', ...intColumn(), default: 0 })
  onLeaveCount: number;

  @Column({ name: 'proxy_count', ...intColumn(), default: 0 })
  proxyCount: number;

  @Column({ name: 'auto_checkout_count', ...intColumn(), default: 0 })
  autoCheckoutCount: number;

  @Column({ name: 'suspicious_count', ...intColumn(), default: 0 })
  suspiciousCount: number;

  /** Total trusted distance walked by the ward's staff (from route_summaries). */
  @Column({ name: 'distance_m', ...intColumn(), default: 0 })
  distanceM: number;

  @Column({ name: 'computed_at', type: timestampType() })
  computedAt: Date;
}
