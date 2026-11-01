import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { WardsModule } from '../wards/wards.module';
import { DailyAssignment } from './entities/daily-assignment.entity';
import { StandingRoster } from './entities/standing-roster.entity';
import { RostersController } from './rosters.controller';
import { RostersRepository } from './rosters.repository';
import { RostersService } from './rosters.service';

/**
 * Standing squads and daily assignments. Other modules (attendance, chat) use RostersService,
 * never RostersRepository.
 */
@Module({
  imports: [TypeOrmModule.forFeature([StandingRoster, DailyAssignment]), StaffModule, WardsModule],
  controllers: [RostersController],
  providers: [RostersRepository, RostersService],
  exports: [RostersService],
})
export class RostersModule {}
