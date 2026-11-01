import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Patch,
  Post,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
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
  ApproveAssignmentDto,
  AssignmentDto,
  AssignmentPageDto,
  CreateAssignmentDto,
  CreateStandingRosterDto,
  GenerateAssignmentsDto,
  GenerateAssignmentsResultDto,
  ListAssignmentsQueryDto,
  ListStandingRostersQueryDto,
  SelfAssignmentDto,
  StandingRosterDto,
  StandingRosterPageDto,
  UpdateStandingRosterDto,
} from './dto/rosters.dto';
import { RostersService } from './rosters.service';

/**
 * HTTP only: maps requests to one service call. Ward / team scope is checked in the service
 * through rosters.policy; @Roles only narrows who may call at all.
 */
@ApiTags('rosters')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
@Controller()
export class RostersController {
  constructor(private readonly rosters: RostersService) {}

  @Get('rosters/standing')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({
    summary: 'List standing squads (ADMIN all, ward inspector own ward, inspector own squad)',
  })
  @ApiOkResponse({ type: StandingRosterPageDto })
  listRosters(
    @CurrentUser() user: AuthUser,
    @Query() query: ListStandingRostersQueryDto,
  ): Promise<StandingRosterPageDto> {
    return this.rosters.listRosters(user, query);
  }

  @Post('rosters/standing')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({
    summary: "Put a worker in an inspector's standing squad (ward from the inspector)",
  })
  @ApiCreatedResponse({ type: StandingRosterDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'ROSTER_WORKER_TAKEN' })
  createRoster(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateStandingRosterDto,
  ): Promise<StandingRosterDto> {
    return this.rosters.createRoster(user, dto);
  }

  @Patch('rosters/standing/:id')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({ summary: 'Move a worker to another inspector, or (de)activate the row' })
  @ApiOkResponse({ type: StandingRosterDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  updateRoster(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateStandingRosterDto,
  ): Promise<StandingRosterDto> {
    return this.rosters.updateRoster(user, id, dto);
  }

  @Get('assignments')
  @ApiOperation({
    summary:
      "A day's assignments (ADMIN all, ward inspector own ward, inspector own team, worker self)",
  })
  @ApiOkResponse({ type: AssignmentPageDto })
  listAssignments(
    @CurrentUser() user: AuthUser,
    @Query() query: ListAssignmentsQueryDto,
  ): Promise<AssignmentPageDto> {
    return this.rosters.listAssignments(user, query);
  }

  @Post('assignments')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({
    summary: 'Place an inspector in a ward or a worker in a team for a day (approved at once)',
  })
  @ApiCreatedResponse({ type: AssignmentDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'ASSIGNMENT_EXISTS' })
  assign(@CurrentUser() user: AuthUser, @Body() dto: CreateAssignmentDto): Promise<AssignmentDto> {
    return this.rosters.assign(user, dto);
  }

  @Post('assignments/self')
  @Roles(Role.INSPECTOR, Role.WORKER)
  @ApiOperation({
    summary: 'Self-pick a ward (inspector) or self-join a team (worker); starts unapproved',
    description: 'Retry-safe: the same clientUuid returns the row it created.',
  })
  @ApiCreatedResponse({ type: AssignmentDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'ASSIGNMENT_EXISTS' })
  selfAssign(
    @CurrentUser() user: AuthUser,
    @Body() dto: SelfAssignmentDto,
  ): Promise<AssignmentDto> {
    return this.rosters.selfAssign(user, dto);
  }

  @Post('assignments/:id/approve')
  @HttpCode(200)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({ summary: 'Approve a self-service assignment (never your own)' })
  @ApiOkResponse({ type: AssignmentDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  approve(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ApproveAssignmentDto,
  ): Promise<AssignmentDto> {
    return this.rosters.approve(user, id, dto.expectedVersion);
  }

  @Post('assignments/generate')
  @HttpCode(200)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({ summary: "Create a day's assignments from the standing squads (safe to repeat)" })
  @ApiOkResponse({ type: GenerateAssignmentsResultDto })
  generate(
    @CurrentUser() user: AuthUser,
    @Body() dto: GenerateAssignmentsDto,
  ): Promise<GenerateAssignmentsResultDto> {
    return this.rosters.generate(user, dto.date);
  }
}
