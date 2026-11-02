import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Holiday } from './entities/holiday.entity';
import { HolidaysController } from './holidays.controller';
import { HolidaysRepository } from './holidays.repository';
import { HolidaysService } from './holidays.service';

/** The holiday calendar. Attendance and spot checks use HolidaysService.isHoliday(). */
@Module({
  imports: [TypeOrmModule.forFeature([Holiday])],
  controllers: [HolidaysController],
  providers: [HolidaysRepository, HolidaysService],
  exports: [HolidaysService],
})
export class HolidaysModule {}
