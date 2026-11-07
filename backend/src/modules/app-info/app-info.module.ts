import { Module } from '@nestjs/common';
import { AppInfoController } from './app-info.controller';

/** Public start-up settings for the mobile app (config only; no database). */
@Module({ controllers: [AppInfoController] })
export class AppInfoModule {}
