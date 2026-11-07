import { Controller, Get } from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { Public } from '../../shared/auth/decorators';
import { Clock } from '../../shared/clock/clock';
import { AppConfig } from '../../shared/config/app-config';
import { SILENT_GAP_MINUTES } from '../attendance/jobs.policy';

export class AppInfoDto {
  @ApiProperty({ description: 'Android versionCode below which the app must update before use' })
  minVersionCode: number;
  @ApiProperty({ description: 'Newest versionCode; above the minimum the update is optional' })
  latestVersionCode: number;
  @ApiPropertyOptional({ nullable: true, type: String }) updateUrl: string | null;
  @ApiProperty({ enum: ['local', 'aadhaar'], description: 'Which face capture flow to prepare' })
  faceProvider: 'local' | 'aadhaar';
  @ApiProperty({ description: 'Seconds between location pings while on duty' })
  pingIntervalSeconds: number;
  @ApiProperty({ description: 'No ping for this long during a shift raises a silent-gap alert' })
  silentGapMinutes: number;
  @ApiProperty({
    format: 'date-time',
    description: 'Server time (UTC): the app shows a wrong phone clock',
  })
  serverTime: string;
}

/** Ping cadence the app follows (about every 10 minutes; the silent-gap rule allows 30). */
const PING_INTERVAL_SECONDS = 600;

/**
 * What the mobile app reads at start-up, before sign-in: forced-update versions, the face flow,
 * the ping cadence and the server clock. Public, under the normal per-IP limit (not the
 * sign-in one: thousands of phones behind one carrier address start at 06:00).
 */
@ApiTags('public')
@Controller('public/app-config')
export class AppInfoController {
  constructor(
    private readonly config: AppConfig,
    private readonly clock: Clock,
  ) {}

  @Public()
  @Get()
  @ApiOperation({
    summary: 'Mobile start-up settings: minimum version, face flow, ping cadence, server time',
  })
  @ApiOkResponse({ type: AppInfoDto })
  get(): AppInfoDto {
    const mobile = this.config.mobile;
    return {
      minVersionCode: mobile.minVersionCode,
      latestVersionCode: mobile.latestVersionCode,
      updateUrl: mobile.updateUrl,
      faceProvider: this.config.faceProvider,
      pingIntervalSeconds: PING_INTERVAL_SECONDS,
      silentGapMinutes: SILENT_GAP_MINUTES,
      serverTime: this.clock.now().toISOString(),
    };
  }
}
