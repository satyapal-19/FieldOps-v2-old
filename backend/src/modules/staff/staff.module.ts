import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Staff } from './entities/staff.entity';
import { StaffRepository } from './staff.repository';
import { StaffService } from './staff.service';

/**
 * Staff records. Other modules use StaffService (exported), never StaffRepository.
 * Phase 1B adds the controller for admin CRUD and hierarchy rules.
 */
@Module({
  imports: [TypeOrmModule.forFeature([Staff])],
  providers: [StaffRepository, StaffService],
  exports: [StaffService],
})
export class StaffModule {}
