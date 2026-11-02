import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, LessThan, Not, Repository } from 'typeorm';
import { isUniqueViolation } from '../database/db-errors';
import { JobLock, JobStatus } from './job-lock.entity';

/** The only place that queries job_locks. Each statement commits on its own. */
@Injectable()
export class JobLockRepository {
  constructor(@InjectRepository(JobLock) private readonly locks: Repository<JobLock>) {}

  find(jobName: string): Promise<JobLock | null> {
    return this.locks.findOne({ where: { jobName } });
  }

  /** Creates the row on a job's first run; another instance creating it first is fine. */
  async ensure(jobName: string): Promise<void> {
    if (await this.locks.exists({ where: { jobName } })) return;
    try {
      await this.locks.insert({ jobName });
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
    }
  }

  /**
   * Takes the lock for one slot. Succeeds only when nobody holds a live lock and this slot has
   * not run yet, or its run failed or died (RUNNING with an expired lock), so of several
   * instances firing together exactly one gets 1 row, and a failed slot is retried.
   */
  async acquire(
    jobName: string,
    runKey: string,
    owner: string,
    now: Date,
    lockedUntil: Date,
  ): Promise<boolean> {
    const free = [{ lockedUntil: IsNull() }, { lockedUntil: LessThan(now) }];
    const newSlot = [
      { lastRunKey: IsNull() },
      { lastRunKey: Not(runKey) },
      { lastStatus: In<JobStatus>(['FAILED', 'RUNNING']) },
    ];
    const result = await this.locks.update(
      free.flatMap((f) => newSlot.map((k) => ({ jobName, ...f, ...k }))),
      {
        lockedBy: owner,
        lockedUntil,
        lastRunKey: runKey,
        lastStartedAt: now,
        lastStatus: 'RUNNING',
        lastResult: null,
      },
    );
    return (result.affected ?? 0) === 1;
  }

  /** Releases the lock if this instance still holds it. */
  async release(
    jobName: string,
    owner: string,
    now: Date,
    status: JobStatus,
    result: string,
  ): Promise<void> {
    await this.locks.update(
      { jobName, lockedBy: owner },
      {
        lockedBy: null,
        lockedUntil: null,
        lastFinishedAt: now,
        lastStatus: status,
        lastResult: result.slice(0, 500),
      },
    );
  }
}
