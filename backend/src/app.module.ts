import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { ScheduleModule } from '@nestjs/schedule';
import { HealthModule } from './health/health.module';
import { AuthModule } from './modules/auth/auth.module';
import { FaceModule } from './modules/face/face.module';
import { HolidaysModule } from './modules/holidays/holidays.module';
import { LeaveModule } from './modules/leave/leave.module';
import { TasksModule } from './modules/tasks/tasks.module';
import { ComplaintsModule } from './modules/complaints/complaints.module';
import { AlertsModule } from './modules/alerts/alerts.module';
import { AttendanceModule } from './modules/attendance/attendance.module';
import { OfficesModule } from './modules/offices/offices.module';
import { RostersModule } from './modules/rosters/rosters.module';
import { ShiftsModule } from './modules/shifts/shifts.module';
import { StaffAdminModule } from './modules/staff-admin/staff-admin.module';
import { StaffModule } from './modules/staff/staff.module';
import { WardsModule } from './modules/wards/wards.module';
import { AuditModule } from './shared/audit/audit.module';
import { RequestContextInterceptor } from './shared/context/request-context';
import { DatabaseModule } from './shared/database/database.module';
import { JobsModule } from './shared/jobs/jobs.module';
import { LoggingModule } from './shared/logging/logging.module';
import { SharedModule } from './shared/shared.module';

@Module({
  imports: [
    SharedModule,
    LoggingModule,
    DatabaseModule,
    AuditModule,
    // Cron timers on every instance; JobsModule's database lock runs each slot once.
    ScheduleModule.forRoot(),
    JobsModule,
    HealthModule,
    // AuthModule registers the global guards: every endpoint needs a token unless @Public().
    AuthModule,
    // Feature modules
    StaffModule,
    StaffAdminModule,
    WardsModule,
    OfficesModule,
    RostersModule,
    ShiftsModule,
    HolidaysModule,
    LeaveModule,
    TasksModule,
    ComplaintsModule,
    AlertsModule,
    AttendanceModule,
    FaceModule,
  ],
  providers: [{ provide: APP_INTERCEPTOR, useClass: RequestContextInterceptor }],
})
export class AppModule {}
