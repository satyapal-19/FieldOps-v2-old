import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { HealthModule } from './health/health.module';
import { AuthModule } from './modules/auth/auth.module';
import { FaceModule } from './modules/face/face.module';
import { OfficesModule } from './modules/offices/offices.module';
import { StaffModule } from './modules/staff/staff.module';
import { WardsModule } from './modules/wards/wards.module';
import { AuditModule } from './shared/audit/audit.module';
import { RequestContextInterceptor } from './shared/context/request-context';
import { DatabaseModule } from './shared/database/database.module';
import { LoggingModule } from './shared/logging/logging.module';
import { SharedModule } from './shared/shared.module';

@Module({
  imports: [
    SharedModule,
    LoggingModule,
    DatabaseModule,
    AuditModule,
    HealthModule,
    // AuthModule registers the global guards: every endpoint needs a token unless @Public().
    AuthModule,
    // Feature modules
    StaffModule,
    WardsModule,
    OfficesModule,
    FaceModule,
  ],
  providers: [{ provide: APP_INTERCEPTOR, useClass: RequestContextInterceptor }],
})
export class AppModule {}
