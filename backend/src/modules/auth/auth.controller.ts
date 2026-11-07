import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post } from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBearerAuth,
  ApiBadRequestResponse,
  ApiForbiddenResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Public, Roles, UserAgent } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { StaffProfileDto } from '../staff/dto/staff-profile.dto';
import { AuthService } from './auth.service';
import {
  ChangePasswordDto,
  LogoutDto,
  OtpRequestDto,
  OtpRequestedDto,
  OtpVerifyDto,
  PasswordLoginDto,
  RefreshDto,
  RevokedCountDto,
  SessionTokensDto,
  TestLoginDto,
} from './dto/auth.dto';
import { SignInRateLimit } from './rate-limit';

/**
 * Sign-in for the mobile app (OTP) and web dashboard (password), token refresh and sign-out.
 * D3: OTP only for now; device binding after delivery. Test login exists only in dev/test.
 */
@ApiTags('auth')
@ApiBadRequestResponse({ type: ProblemDetailsDto })
@ApiTooManyRequestsResponse({ type: ProblemDetailsDto, description: 'RATE_LIMITED / AUTH_OTP_RATE_LIMITED' })
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Public()
  @SignInRateLimit()
  @Post('otp/request')
  @HttpCode(202)
  @ApiOperation({ summary: 'Send a 6-digit sign-in code by SMS (same answer for unknown numbers)' })
  @ApiAcceptedResponse({ type: OtpRequestedDto })
  @ApiServiceUnavailableResponse({ type: ProblemDetailsDto, description: 'AUTH_OTP_DELIVERY_UNAVAILABLE' })
  requestOtp(@Body() dto: OtpRequestDto): Promise<OtpRequestedDto> {
    return this.auth.requestOtp(dto.phone);
  }

  @Public()
  @SignInRateLimit()
  @Post('otp/verify')
  @HttpCode(200)
  @ApiOperation({ summary: 'Exchange the SMS code for tokens' })
  @ApiOkResponse({ type: SessionTokensDto })
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto, description: 'AUTH_OTP_INVALID / AUTH_OTP_EXPIRED' })
  verifyOtp(@Body() dto: OtpVerifyDto, @UserAgent() userAgent?: string): Promise<SessionTokensDto> {
    return this.auth.verifyOtp(dto.phone, dto.code, { deviceId: dto.deviceId, userAgent });
  }

  @Public()
  @SignInRateLimit()
  @Post('login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Web dashboard sign-in (ADMIN, WARD_INSPECTOR, OFFICE_STAFF)' })
  @ApiOkResponse({ type: SessionTokensDto })
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto, description: 'AUTH_INVALID_CREDENTIALS' })
  login(@Body() dto: PasswordLoginDto, @UserAgent() userAgent?: string): Promise<SessionTokensDto> {
    return this.auth.passwordLogin(dto.identifier, dto.password, { deviceId: dto.deviceId, userAgent });
  }

  @Public()
  @SignInRateLimit()
  @Post('test-login')
  @HttpCode(200)
  @ApiOperation({ summary: 'Development / test only: sign in without OTP. 404 in production.' })
  @ApiOkResponse({ type: SessionTokensDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  testLogin(@Body() dto: TestLoginDto, @UserAgent() userAgent?: string): Promise<SessionTokensDto> {
    return this.auth.testLogin(dto.identifier, { deviceId: dto.deviceId, userAgent });
  }

  @Public()
  @SignInRateLimit()
  @Post('refresh')
  @HttpCode(200)
  @ApiOperation({ summary: 'Swap a refresh token for a new pair (rotation; reuse revokes the session)' })
  @ApiOkResponse({ type: SessionTokensDto })
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto, description: 'AUTH_SESSION_REVOKED' })
  refresh(@Body() dto: RefreshDto): Promise<SessionTokensDto> {
    return this.auth.refresh(dto.refreshToken);
  }

  @Post('logout')
  @HttpCode(204)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Sign out this device (or every device)' })
  @ApiNoContentResponse()
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto })
  async logout(@CurrentUser() user: AuthUser, @Body() dto: LogoutDto): Promise<void> {
    await this.auth.logout(user, dto.everywhere ?? false);
  }

  @Get('me')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'The signed-in staff member' })
  @ApiOkResponse({ type: StaffProfileDto })
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto })
  me(@CurrentUser() user: AuthUser): Promise<StaffProfileDto> {
    return this.auth.me(user);
  }

  @Post('change-password')
  @HttpCode(204)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change own web password; signs out other devices' })
  @ApiNoContentResponse()
  @ApiUnauthorizedResponse({ type: ProblemDetailsDto })
  async changePassword(@CurrentUser() user: AuthUser, @Body() dto: ChangePasswordDto): Promise<void> {
    await this.auth.changePassword(user, dto.currentPassword, dto.newPassword);
  }

  @Post('staff/:staffId/revoke-sessions')
  @HttpCode(200)
  @Roles(Role.ADMIN)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Sign a staff member out of every device (ADMIN)' })
  @ApiOkResponse({ type: RevokedCountDto })
  @ApiForbiddenResponse({ type: ProblemDetailsDto })
  async revokeSessions(@Param('staffId', ParseUUIDPipe) staffId: string): Promise<RevokedCountDto> {
    return { revoked: await this.auth.revokeAllFor(staffId, 'ADMIN') };
  }
}
