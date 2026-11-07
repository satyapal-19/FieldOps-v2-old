import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { AlertsController } from './alerts.controller';
import { AlertsRepository } from './alerts.repository';
import { AlertsService } from './alerts.service';
import { NotificationsModule } from '../notifications/notifications.module';
import { Alert } from './entities/alert.entity';

/** Supervisor alerts. Attendance and the scheduled jobs (Phase 2) raise them via AlertsService. */
@Module({
  imports: [TypeOrmModule.forFeature([Alert]), StaffModule, NotificationsModule],
  controllers: [AlertsController],
  providers: [AlertsRepository, AlertsService],
  exports: [AlertsService],
})
export class AlertsModule {}
