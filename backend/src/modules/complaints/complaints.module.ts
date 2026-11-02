import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TasksModule } from '../tasks/tasks.module';
import { WardsModule } from '../wards/wards.module';
import { ComplaintsController, PublicComplaintsController } from './complaints.controller';
import { ComplaintsRepository } from './complaints.repository';
import { ComplaintsService } from './complaints.service';
import { CitizenComplaint } from './entities/citizen-complaint.entity';

/** Citizen complaints: the public portal and staff routing through tasks. */
@Module({
  imports: [TypeOrmModule.forFeature([CitizenComplaint]), TasksModule, WardsModule],
  controllers: [PublicComplaintsController, ComplaintsController],
  providers: [ComplaintsRepository, ComplaintsService],
})
export class ComplaintsModule {}
