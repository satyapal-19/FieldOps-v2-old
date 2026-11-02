import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
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
import { Role, type StaffRole } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import {
  AssigneeUpdateDto,
  CreateTaskDto,
  ListTasksQueryDto,
  ReassignTaskDto,
  SupervisorActionDto,
  TaskDto,
  TaskPageDto,
  TaskUpdateDto,
} from './dto/task.dto';
import { TasksService } from './tasks.service';

const SUPERVISORS: StaffRole[] = [Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR];

/** HTTP only: maps requests to one service call. Scope and the status machine live in tasks.policy. */
@ApiTags('tasks')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
@Controller('tasks')
export class TasksController {
  constructor(private readonly tasks: TasksService) {}

  @Get()
  @ApiOperation({ summary: 'Tasks in your scope (assigned to you, your team, your ward, or all)' })
  @ApiOkResponse({ type: TaskPageDto })
  list(@CurrentUser() user: AuthUser, @Query() q: ListTasksQueryDto): Promise<TaskPageDto> {
    return this.tasks.list(user, q);
  }

  @Get(':id')
  @ApiOperation({ summary: 'One task' })
  @ApiOkResponse({ type: TaskDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string): Promise<TaskDto> {
    return this.tasks.get(user, id);
  }

  @Get(':id/history')
  @ApiOperation({ summary: "A task's status changes, oldest first" })
  @ApiOkResponse({ type: [TaskUpdateDto] })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  history(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<TaskUpdateDto[]> {
    return this.tasks.history(user, id);
  }

  @Post()
  @Roles(...SUPERVISORS)
  @ApiOperation({ summary: 'Assign a task down the hierarchy' })
  @ApiCreatedResponse({ type: TaskDto })
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateTaskDto): Promise<TaskDto> {
    return this.tasks.create(user, dto);
  }

  @Post(':id/updates')
  @HttpCode(200)
  @ApiOperation({
    summary: 'START or SUBMIT your task from the phone (retry-safe with clientUuid)',
  })
  @ApiOkResponse({ type: TaskDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  assigneeUpdate(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AssigneeUpdateDto,
  ): Promise<TaskDto> {
    return this.tasks.assigneeUpdate(user, id, dto);
  }

  @Post(':id/review')
  @HttpCode(200)
  @Roles(...SUPERVISORS)
  @ApiOperation({
    summary: 'APPROVE, REJECT (with reason), ESCALATE or CLOSE a task you supervise',
  })
  @ApiOkResponse({ type: TaskDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  supervise(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SupervisorActionDto,
  ): Promise<TaskDto> {
    return this.tasks.supervise(user, id, dto);
  }

  @Post(':id/reassign')
  @HttpCode(200)
  @Roles(...SUPERVISORS)
  @ApiOperation({ summary: 'Give an unfinished task to someone else; it restarts as OPEN' })
  @ApiOkResponse({ type: TaskDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  reassign(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReassignTaskDto,
  ): Promise<TaskDto> {
    return this.tasks.reassign(user, id, dto);
  }
}
