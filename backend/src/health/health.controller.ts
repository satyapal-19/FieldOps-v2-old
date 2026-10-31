import { Controller, Get } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiProperty, ApiServiceUnavailableResponse, ApiTags } from '@nestjs/swagger';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { Clock } from '../shared/clock/clock';
import { AppConfig } from '../shared/config/app-config';
import { AppError } from '../shared/errors/app-error';
import { ErrorCode } from '../shared/errors/error-codes';
import { ProblemDetailsDto } from '../shared/errors/problem-details.dto';
import { APP_VERSION } from '../app-version';
import { Public } from '../shared/auth/decorators';

export class HealthDto {
  @ApiProperty({ example: 'ok' }) status: string;
  @ApiProperty({ example: 'development' }) environment: string;
  @ApiProperty({ example: '0.1.0' }) version: string;
  @ApiProperty({ example: 42 }) uptimeSeconds: number;
  @ApiProperty({ example: '2026-10-28T00:30:00.000Z' }) time: string;
}

export class ReadyDto {
  @ApiProperty({ example: 'ready' }) status: string;
  @ApiProperty({ example: 'postgres' }) database: string;
  @ApiProperty({ example: false }) pendingMigrations: boolean;
}

/** Open to load balancers and monitoring: no token needed. */
@ApiTags('health')
@Public()
@Controller()
export class HealthController {
  private readonly startedAt: number;

  constructor(
    private readonly config: AppConfig,
    private readonly clock: Clock,
    @InjectDataSource() private readonly dataSource: DataSource,
  ) {
    this.startedAt = clock.now().getTime();
  }

  @Get('health')
  @ApiOperation({ summary: 'Liveness: the process is up' })
  @ApiOkResponse({ type: HealthDto })
  health(): HealthDto {
    const now = this.clock.now();
    return {
      status: 'ok',
      environment: this.config.nodeEnv,
      version: APP_VERSION,
      uptimeSeconds: Math.round((now.getTime() - this.startedAt) / 1000),
      time: now.toISOString(),
    };
  }

  @Get('ready')
  @ApiOperation({ summary: 'Readiness: database reachable and all migrations applied' })
  @ApiOkResponse({ type: ReadyDto })
  @ApiServiceUnavailableResponse({ type: ProblemDetailsDto })
  async ready(): Promise<ReadyDto> {
    const database = this.config.database.type;
    try {
      const probe = database === 'oracle' ? 'SELECT 1 FROM DUAL' : 'SELECT 1';
      await this.dataSource.query(probe);
    } catch {
      throw new AppError(ErrorCode.SERVICE_UNAVAILABLE, 'Database is not reachable', { database });
    }
    const pendingMigrations = await this.dataSource.showMigrations();
    if (pendingMigrations) {
      throw new AppError(ErrorCode.SERVICE_UNAVAILABLE, 'Database migrations are pending', {
        database,
        hint: 'Run npm run migration:run',
      });
    }
    return { status: 'ready', database, pendingMigrations };
  }
}
