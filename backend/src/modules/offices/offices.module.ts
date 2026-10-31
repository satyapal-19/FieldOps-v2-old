import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CorporationOffice } from './entities/corporation-office.entity';
import { OfficesController } from './offices.controller';
import { OfficesRepository } from './offices.repository';
import { OfficesService } from './offices.service';

@Module({
  imports: [TypeOrmModule.forFeature([CorporationOffice])],
  controllers: [OfficesController],
  providers: [OfficesRepository, OfficesService],
  exports: [OfficesService],
})
export class OfficesModule {}
