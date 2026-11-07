import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { Clock } from '../../shared/clock/clock';
import { istDate, IST_TIME_ZONE } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { JobRunner } from '../../shared/jobs/job-runner';
import { UploadsService } from './uploads.service';

/** Nightly voice-note retention (03:15 IST, retried at 05:15), once across all instances. */
@Injectable()
export class UploadsScheduler {
  constructor(
    private readonly uploads: UploadsService,
    private readonly runner: JobRunner,
    private readonly config: AppConfig,
    private readonly clock: Clock,
  ) {}

  @Cron('0 15 3,5 * * *', { name: 'voice-note-retention', timeZone: IST_TIME_ZONE })
  async purge(): Promise<void> {
    if (!this.config.jobs.enabled) return;
    try {
      await this.runner.run('voice-note-retention', istDate(this.clock.now()), 60, () =>
        this.uploads.purgeVoiceNotes(),
      );
    } catch {
      // JobRunner logged it and recorded FAILED; the next firing retries.
    }
  }
}
