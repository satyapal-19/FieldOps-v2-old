import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AlertsModule } from '../alerts/alerts.module';
import { FaceModule } from '../face/face.module';
import { HolidaysModule } from '../holidays/holidays.module';
import { LeaveModule } from '../leave/leave.module';
import { OfficesModule } from '../offices/offices.module';
import { RostersModule } from '../rosters/rosters.module';
import { ShiftsModule } from '../shifts/shifts.module';
import { StaffModule } from '../staff/staff.module';
import { WardsModule } from '../wards/wards.module';
import { AttendanceJobsService } from './attendance-jobs.service';
import { AttendanceController } from './attendance.controller';
import { AttendanceRepository } from './attendance.repository';
import { AttendanceScheduler } from './attendance.scheduler';
import { AttendanceService } from './attendance.service';
import { AttendanceLog } from './entities/attendance-log.entity';
import { LivenessChallenge } from './entities/liveness-challenge.entity';
import { LocationPing } from './entities/location-ping.entity';
import { RouteSummary } from './entities/route-summary.entity';
import { TamperEvent } from './entities/tamper-event.entity';
import { WardDailySummary } from './entities/ward-daily-summary.entity';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';
import { RouteController } from './route.controller';
import { RouteService } from './route.service';
import { SummariesRepository } from './summaries.repository';
import { TrackingRepository } from './tracking.repository';
import { TrackingService } from './tracking.service';

/**
 * The attendance engine: liveness challenges, punches, location pings, tamper reports, route
 * history and the scheduled jobs (auto-checkout, silent gaps, nightly roll-ups, purge).
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([
      AttendanceLog,
      LivenessChallenge,
      LocationPing,
      TamperEvent,
      RouteSummary,
      WardDailySummary,
    ]),
    StaffModule,
    RostersModule,
    ShiftsModule,
    LeaveModule,
    HolidaysModule,
    WardsModule,
    OfficesModule,
    FaceModule,
    AlertsModule,
  ],
  controllers: [AttendanceController, RouteController, ReportsController],
  providers: [
    AttendanceRepository,
    AttendanceService,
    TrackingRepository,
    TrackingService,
    SummariesRepository,
    RouteService,
    ReportsService,
    AttendanceJobsService,
    AttendanceScheduler,
  ],
  exports: [AttendanceService, AttendanceJobsService],
})
export class AttendanceModule {}
