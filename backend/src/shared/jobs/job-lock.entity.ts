import { Column, Entity, PrimaryColumn } from 'typeorm';
import { timestampType, unicodeVarcharType, varcharType } from '../database/column-types';

export type JobStatus = 'RUNNING' | 'OK' | 'FAILED';

/** One row per scheduled job: who holds it, until when, and which slot ran last. */
@Entity({ name: 'job_locks' })
export class JobLock {
  @PrimaryColumn({ name: 'job_name', type: varcharType(), length: 50 })
  jobName: string;

  /** host:pid of the instance running it now. */
  @Column({ name: 'locked_by', type: varcharType(), length: 100, nullable: true })
  lockedBy: string | null;

  /** A crashed instance's lock lapses at this time. */
  @Column({ name: 'locked_until', type: timestampType(), nullable: true })
  lockedUntil: Date | null;

  /** The slot that last started (e.g. an IST date, or a 30-minute window): runs once per slot. */
  @Column({ name: 'last_run_key', type: varcharType(), length: 30, nullable: true })
  lastRunKey: string | null;

  @Column({ name: 'last_started_at', type: timestampType(), nullable: true })
  lastStartedAt: Date | null;

  @Column({ name: 'last_finished_at', type: timestampType(), nullable: true })
  lastFinishedAt: Date | null;

  @Column({ name: 'last_status', type: varcharType(), length: 10, nullable: true })
  lastStatus: JobStatus | null;

  /** What the run did ("closed 12 shifts") or its error message. */
  @Column({ name: 'last_result', type: unicodeVarcharType(), length: 500, nullable: true })
  lastResult: string | null;
}
