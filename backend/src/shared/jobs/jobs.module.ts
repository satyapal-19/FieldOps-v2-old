import { Global, Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JobLock } from './job-lock.entity';
import { JobLockRepository } from './job-lock.repository';
import { JobRunner } from './job-runner';

/** The run-once lock for scheduled jobs, available to every module that schedules work. */
@Global()
@Module({
  imports: [TypeOrmModule.forFeature([JobLock])],
  providers: [JobLockRepository, JobRunner],
  exports: [JobRunner],
})
export class JobsModule {}
