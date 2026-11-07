import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { Upload } from './entities/upload.entity';
import { UploadsController } from './uploads.controller';
import { UploadsRepository } from './uploads.repository';
import { UploadsScheduler } from './uploads.scheduler';
import { UploadsService } from './uploads.service';

/** Photos staff upload (task evidence). Other modules use UploadsService.assertOwnedBy. */
@Module({
  imports: [TypeOrmModule.forFeature([Upload]), StaffModule],
  controllers: [UploadsController],
  providers: [UploadsRepository, UploadsService, UploadsScheduler],
  exports: [UploadsService],
})
export class UploadsModule {}
