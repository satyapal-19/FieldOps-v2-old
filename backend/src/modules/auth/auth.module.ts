import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { ThrottlerModule } from '@nestjs/throttler';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppConfig } from '../../shared/config/app-config';
import { StaffModule } from '../staff/staff.module';
import { AuthController } from './auth.controller';
import { AuthGuard } from './auth.guard';
import { AuthRepository } from './auth.repository';
import { AuthService } from './auth.service';
import { AuthOtp } from './entities/auth-otp.entity';
import { AuthSession } from './entities/auth-session.entity';
import { DisabledOtpSender, HttpSmsOtpSender, LogOtpSender, OtpSender } from './otp/otp-sender';
import { rateLimitOptions, UserThrottlerGuard } from './rate-limit';
import { RolesGuard } from './roles.guard';

/**
 * Authentication and authorisation. Registers three global guards, in this order:
 * AuthGuard (who are you) -> RolesGuard (may your role call this) -> rate limit.
 */
@Module({
  imports: [
    TypeOrmModule.forFeature([AuthOtp, AuthSession]),
    StaffModule,
    JwtModule.registerAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({ secret: config.auth.accessSecret }),
    }),
    ThrottlerModule.forRootAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => rateLimitOptions(config),
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthRepository,
    AuthService,
    {
      provide: OtpSender,
      inject: [AppConfig],
      useFactory: (config: AppConfig): OtpSender => {
        const auth = config.auth;
        if (auth.otpSender === 'log') return new LogOtpSender();
        if (auth.otpSender === 'sms_http') return new HttpSmsOtpSender(auth.sms);
        return new DisabledOtpSender();
      },
    },
    { provide: APP_GUARD, useClass: AuthGuard },
    { provide: APP_GUARD, useClass: RolesGuard },
    { provide: APP_GUARD, useClass: UserThrottlerGuard },
  ],
  exports: [AuthService],
})
export class AuthModule {}
