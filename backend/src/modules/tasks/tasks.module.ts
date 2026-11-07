import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { TaskUpdate } from './entities/task-update.entity';
import { Task } from './entities/task.entity';
import { TasksController } from './tasks.controller';
import { TasksRepository } from './tasks.repository';
import { UploadsModule } from '../uploads/uploads.module';
import { TasksService } from './tasks.service';

/** Field tasks and their history. Complaints raise tasks through TasksService. */
@Module({
  imports: [TypeOrmModule.forFeature([Task, TaskUpdate]), StaffModule, UploadsModule],
  controllers: [TasksController],
  providers: [TasksRepository, TasksService],
  exports: [TasksService],
})
export class TasksModule {}
