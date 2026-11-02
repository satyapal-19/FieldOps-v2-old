import { Injectable, Logger } from '@nestjs/common';
import { hostname } from 'node:os';
import { Clock } from '../clock/clock';
import { JobLockRepository } from './job-lock.repository';

export type JobOutcome = { ran: true; result: string } | { ran: false };

/**
 * Runs a scheduled job once per slot across all server instances (PM2 cluster, action plan
 * Phase 2). Every instance's scheduler fires; the database lock picks one. A job must be
 * idempotent anyway: if an instance dies mid-run, the lock lapses after `maxMinutes` and
 * the next slot repeats the work.
 */
@Injectable()
export class JobRunner {
  private readonly logger = new Logger(JobRunner.name);
  private readonly owner = `${hostname()}:${process.pid}`.slice(0, 100);

  constructor(
    private readonly locks: JobLockRepository,
    private readonly clock: Clock,
  ) {}

  /**
   * @param runKey  the slot, e.g. "2026-11-02" for a nightly job; the same key never runs twice
   * @param work    returns a one-line result for job_locks.last_result
   */
  async run(
    jobName: string,
    runKey: string,
    maxMinutes: number,
    work: () => Promise<string>,
  ): Promise<JobOutcome> {
    await this.locks.ensure(jobName);
    const now = this.clock.now();
    const until = new Date(now.getTime() + maxMinutes * 60_000);
    if (!(await this.locks.acquire(jobName, runKey, this.owner, now, until))) {
      return { ran: false };
    }
    try {
      const result = await work();
      await this.locks.release(jobName, this.owner, this.clock.now(), 'OK', result);
      this.logger.log({ job: jobName, runKey, result }, 'Job finished');
      return { ran: true, result };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      await this.locks.release(jobName, this.owner, this.clock.now(), 'FAILED', message);
      this.logger.error({ err: error, job: jobName, runKey }, 'Job failed');
      throw error;
    }
  }
}
