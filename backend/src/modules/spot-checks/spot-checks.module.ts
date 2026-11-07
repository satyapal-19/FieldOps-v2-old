import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AlertsModule } from '../alerts/alerts.module';
import { AttendanceModule } from '../attendance/attendance.module';
import { NotificationsModule } from '../notifications/notifications.module';
import { RostersModule } from '../rosters/rosters.module';
import { StaffModule } from '../staff/staff.module';
import { SpotCheck } from './entities/spot-check.entity';
import { SpotChecksController } from './spot-checks.controller';
import { SpotChecksRepository } from './spot-checks.repository';
import { SpotChecksScheduler } from './spot-checks.scheduler';
import { SpotChecksService } from './spot-checks.service';

/** Random and senior-ordered "prove you are here" checks during a shift. */
@Module({
  imports: [
    TypeOrmModule.forFeature([SpotCheck]),
    AttendanceModule,
    StaffModule,
    RostersModule,
    AlertsModule,
    NotificationsModule,
  ],
  controllers: [SpotChecksController],
  providers: [SpotChecksRepository, SpotChecksService, SpotChecksScheduler],
  exports: [SpotChecksService],
})
export class SpotChecksModule {}
