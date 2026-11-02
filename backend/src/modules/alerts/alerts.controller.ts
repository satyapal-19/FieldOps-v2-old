import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
  ApiUnprocessableEntityResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Roles } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { AlertDto, AlertPageDto, ListAlertsQueryDto, ResolveAlertDto } from './dto/alert.dto';
import { AlertsService } from './alerts.service';

/** HTTP only: supervisors' alert queue. Alerts are raised by the backend, never by clients. */
@ApiTags('alerts')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('alerts')
export class AlertsController {
  constructor(private readonly alerts: AlertsService) {}

  @Get()
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({
    summary: 'Alerts in your scope, newest first (admin all, ward inspector ward, inspector team)',
  })
  @ApiOkResponse({ type: AlertPageDto })
  list(@CurrentUser() user: AuthUser, @Query() q: ListAlertsQueryDto): Promise<AlertPageDto> {
    return this.alerts.list(user, q);
  }

  @Get(':id')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({ summary: 'One alert' })
  @ApiOkResponse({ type: AlertDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string): Promise<AlertDto> {
    return this.alerts.get(user, id);
  }

  @Post(':id/resolve')
  @HttpCode(200)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({
    summary: 'Resolve an open alert with an optional note (never one about yourself)',
  })
  @ApiOkResponse({ type: AlertDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'CONFLICT (resolved meanwhile)' })
  @ApiUnprocessableEntityResponse({
    type: ProblemDetailsDto,
    description: 'RULE_VIOLATION (already resolved)',
  })
  resolve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ResolveAlertDto,
  ): Promise<AlertDto> {
    return this.alerts.resolve(user, id, dto.note);
  }
}
