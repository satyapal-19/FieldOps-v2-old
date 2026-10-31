import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppConfig } from '../config/app-config';
import { buildDataSourceOptions } from './data-source-options';

@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({
        ...buildDataSourceOptions(config.database),
        // Fail fast in tests; keep retrying briefly elsewhere (e.g. DB restarting).
        retryAttempts: config.isTest ? 1 : 9,
        retryDelay: 3000,
      }),
    }),
  ],
})
export class DatabaseModule {}
