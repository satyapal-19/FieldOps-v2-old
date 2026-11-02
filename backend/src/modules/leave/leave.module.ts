import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { LeaveRequest } from './entities/leave-request.entity';
import { RegularizationRequest } from './entities/regularization-request.entity';
import { LeaveController } from './leave.controller';
import { LeaveRepository } from './leave.repository';
import { LeaveService } from './leave.service';

/** Leave and attendance-regularization requests. Attendance (Phase 2) reads decisions via LeaveService. */
@Module({
  imports: [TypeOrmModule.forFeature([LeaveRequest, RegularizationRequest]), StaffModule],
  controllers: [LeaveController],
  providers: [LeaveRepository, LeaveService],
  exports: [LeaveService],
})
export class LeaveModule {}
