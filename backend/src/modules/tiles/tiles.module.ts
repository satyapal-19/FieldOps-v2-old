import { Module } from '@nestjs/common';
import { TilesController } from './tiles.controller';

/** Serves the offline OpenStreetMap tile pack (files only; no database). */
@Module({ controllers: [TilesController] })
export class TilesModule {}
