import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AlertsModule } from '../alerts/alerts.module';
import { FaceModule } from '../face/face.module';
import { LeaveModule } from '../leave/leave.module';
import { OfficesModule } from '../offices/offices.module';
import { RostersModule } from '../rosters/rosters.module';
import { ShiftsModule } from '../shifts/shifts.module';
import { StaffModule } from '../staff/staff.module';
import { WardsModule } from '../wards/wards.module';
import { AttendanceController } from './attendance.controller';
import { AttendanceRepository } from './attendance.repository';
import { AttendanceService } from './attendance.service';
import { AttendanceLog } from './entities/attendance-log.entity';
import { LivenessChallenge } from './entities/liveness-challenge.entity';

/** The attendance engine: liveness challenges and punches (pings and jobs follow). */
@Module({
  imports: [
    TypeOrmModule.forFeature([AttendanceLog, LivenessChallenge]),
    StaffModule,
    RostersModule,
    ShiftsModule,
    LeaveModule,
    WardsModule,
    OfficesModule,
    FaceModule,
    AlertsModule,
  ],
  controllers: [AttendanceController],
  providers: [AttendanceRepository, AttendanceService],
  exports: [AttendanceService],
})
export class AttendanceModule {}
