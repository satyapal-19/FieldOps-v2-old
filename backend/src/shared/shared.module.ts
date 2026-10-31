import { Global, Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { Clock, SystemClock } from './clock/clock';
import { AppConfig } from './config/app-config';
import { validateEnv } from './config/env.validation';
import { IdGenerator, UuidGenerator } from './ids/id-generator';

/**
 * Cross-cutting services every module may inject: AppConfig, Clock, IdGenerator.
 * Environment files are already loaded by load-env; here they are validated, and a
 * bad configuration stops the app at startup with a list of problems.
 */
@Global()
@Module({
  imports: [
    ConfigModule.forRoot({
      ignoreEnvFile: true,
      cache: true,
      validate: (raw: Record<string, unknown>) => ({ ...validateEnv(raw) }),
    }),
  ],
  providers: [
    AppConfig,
    { provide: Clock, useClass: SystemClock },
    { provide: IdGenerator, useClass: UuidGenerator },
  ],
  exports: [AppConfig, Clock, IdGenerator],
})
export class SharedModule {}
