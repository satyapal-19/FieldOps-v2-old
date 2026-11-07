import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
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
import {
  ListSpotChecksQueryDto,
  OrderSpotCheckDto,
  RespondSpotCheckDto,
  SpotCheckDto,
  SpotCheckPageDto,
} from './dto/spot-check.dto';
import { SpotChecksService } from './spot-checks.service';

const FIELD = [Role.WARD_INSPECTOR, Role.INSPECTOR, Role.WORKER] as const;
const SENIORS = [Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR] as const;

/** HTTP only. States and scope: spot-checks.policy. */
@ApiTags('spot-checks')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('spot-checks')
export class SpotChecksController {
  constructor(private readonly checks: SpotChecksService) {}

  @Get('mine')
  @Roles(...FIELD)
  @ApiOperation({ summary: 'My spot checks waiting for an answer (poll while on duty)' })
  @ApiOkResponse({ type: [SpotCheckDto] })
  mine(@CurrentUser() user: AuthUser): Promise<SpotCheckDto[]> {
    return this.checks.mine(user);
  }

  @Post(':id/snooze')
  @HttpCode(200)
  @Roles(...FIELD)
  @ApiOperation({ summary: 'Ask for 10 more minutes, once' })
  @ApiOkResponse({ type: SpotCheckDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiUnprocessableEntityResponse({
    type: ProblemDetailsDto,
    description: 'SPOT_CHECK_CLOSED / RULE_VIOLATION',
  })
  snooze(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<SpotCheckDto> {
    return this.checks.snooze(user, id);
  }

  @Post(':id/respond')
  @HttpCode(200)
  @Roles(...FIELD)
  @ApiOperation({
    summary: 'Answer: a fresh challenge, the face and where you are (same proof as a punch)',
    description:
      'A face mismatch can be retried until the deadline; outside the ward is recorded and escalated.',
  })
  @ApiOkResponse({ type: SpotCheckDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiUnprocessableEntityResponse({
    type: ProblemDetailsDto,
    description: 'SPOT_CHECK_CLOSED / FACE_MISMATCH / ...',
  })
  respond(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: RespondSpotCheckDto,
  ): Promise<SpotCheckDto> {
    return this.checks.respond(user, id, dto);
  }

  @Post()
  @Roles(...SENIORS)
  @ApiOperation({ summary: 'Order a spot check now for someone on duty in your scope' })
  @ApiCreatedResponse({ type: SpotCheckDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'One is already waiting' })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'NOT_CHECKED_IN' })
  order(@CurrentUser() user: AuthUser, @Body() dto: OrderSpotCheckDto): Promise<SpotCheckDto> {
    return this.checks.order(user, dto);
  }

  @Get()
  @Roles(...SENIORS)
  @ApiOperation({
    summary: 'Spot checks in your scope (admin all, ward inspector ward, inspector team)',
  })
  @ApiOkResponse({ type: SpotCheckPageDto })
  list(
    @CurrentUser() user: AuthUser,
    @Query() q: ListSpotChecksQueryDto,
  ): Promise<SpotCheckPageDto> {
    return this.checks.list(user, q);
  }
}
