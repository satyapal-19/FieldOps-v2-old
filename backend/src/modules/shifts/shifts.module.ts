import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { Shift } from './entities/shift.entity';
import { ShiftsController } from './shifts.controller';
import { ShiftsRepository } from './shifts.repository';
import { ShiftsService } from './shifts.service';

/** Per-day shift overrides. Attendance and spot checks use ShiftsService.effective(). */
@Module({
  imports: [TypeOrmModule.forFeature([Shift]), StaffModule],
  controllers: [ShiftsController],
  providers: [ShiftsRepository, ShiftsService],
  exports: [ShiftsService],
})
export class ShiftsModule {}
