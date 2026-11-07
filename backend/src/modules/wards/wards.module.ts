import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Ward } from './entities/ward.entity';
import { PublicWardsController } from './public-wards.controller';
import { WardsController } from './wards.controller';
import { WardsRepository } from './wards.repository';
import { WardsService } from './wards.service';

/**
 * Reference module: copy this layout for every new feature.
 * Other modules use WardsService (exported), never WardsRepository.
 */
@Module({
  imports: [TypeOrmModule.forFeature([Ward])],
  controllers: [WardsController, PublicWardsController],
  providers: [WardsRepository, WardsService],
  exports: [WardsService],
})
export class WardsModule {}
