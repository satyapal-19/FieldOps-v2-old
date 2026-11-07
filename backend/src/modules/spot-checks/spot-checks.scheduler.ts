import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { Clock } from '../../shared/clock/clock';
import { AppConfig } from '../../shared/config/app-config';
import { JobRunner } from '../../shared/jobs/job-runner';
import { slotKey } from '../attendance/jobs.policy';
import { SpotChecksService } from './spot-checks.service';

/** Every 5 minutes, once across all instances (JobRunner's lock): plan, notify, escalate. */
@Injectable()
export class SpotChecksScheduler {
  constructor(
    private readonly checks: SpotChecksService,
    private readonly runner: JobRunner,
    private readonly config: AppConfig,
    private readonly clock: Clock,
  ) {}

  @Cron('30 */5 * * * *', { name: 'spot-checks' })
  async cycle(): Promise<void> {
    if (!this.config.jobs.enabled) return;
    try {
      await this.runner.run('spot-checks', slotKey(this.clock.now(), 5), 4, () =>
        this.checks.runCycle(),
      );
    } catch {
      // JobRunner logged it and recorded FAILED; the next slot tries again.
    }
  }
}
