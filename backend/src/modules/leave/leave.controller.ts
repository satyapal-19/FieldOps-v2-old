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
  CancelRequestDto,
  CreateLeaveDto,
  CreateRegularizationDto,
  LeavePageDto,
  LeaveRequestDto,
  ListRequestsQueryDto,
  RegularizationPageDto,
  RegularizationRequestDto,
  ReviewRequestDto,
} from './dto/leave.dto';
import { LeaveService } from './leave.service';

const REVIEWERS: StaffRole[] = [Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR];

/**
 * HTTP only: maps requests to one service call. Staff ask for themselves; reviewers and
 * visibility follow leave.policy (out-of-scope requests answer 404).
 */
@ApiTags('leave')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
@Controller()
export class LeaveController {
  constructor(private readonly leave: LeaveService) {}

  @Get('leave')
  @ApiOperation({ summary: 'Leave requests: your own, plus those you review' })
  @ApiOkResponse({ type: LeavePageDto })
  listLeave(
    @CurrentUser() user: AuthUser,
    @Query() q: ListRequestsQueryDto,
  ): Promise<LeavePageDto> {
    return this.leave.listLeave(user, q);
  }

  @Get('leave/:id')
  @ApiOperation({ summary: 'One leave request' })
  @ApiOkResponse({ type: LeaveRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  getLeave(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<LeaveRequestDto> {
    return this.leave.getLeave(user, id);
  }

  @Post('leave')
  @ApiOperation({ summary: 'Ask for leave (for yourself; retry-safe with clientUuid)' })
  @ApiCreatedResponse({ type: LeaveRequestDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'LEAVE_OVERLAP' })
  requestLeave(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateLeaveDto,
  ): Promise<LeaveRequestDto> {
    return this.leave.requestLeave(user, dto);
  }

  @Post('leave/:id/review')
  @HttpCode(200)
  @Roles(...REVIEWERS)
  @ApiOperation({
    summary: 'Approve or reject a pending leave request (line manager; never your own)',
  })
  @ApiOkResponse({ type: LeaveRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  reviewLeave(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReviewRequestDto,
  ): Promise<LeaveRequestDto> {
    return this.leave.reviewLeave(user, id, dto);
  }

  @Post('leave/:id/cancel')
  @HttpCode(200)
  @ApiOperation({ summary: 'Withdraw your leave request (pending, or approved and not started)' })
  @ApiOkResponse({ type: LeaveRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  cancelLeave(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelRequestDto,
  ): Promise<LeaveRequestDto> {
    return this.leave.cancelLeave(user, id, dto.expectedVersion);
  }

  @Get('regularizations')
  @ApiOperation({ summary: 'Attendance regularization requests: your own, plus those you review' })
  @ApiOkResponse({ type: RegularizationPageDto })
  listRegularizations(
    @CurrentUser() user: AuthUser,
    @Query() q: ListRequestsQueryDto,
  ): Promise<RegularizationPageDto> {
    return this.leave.listRegularizations(user, q);
  }

  @Get('regularizations/:id')
  @ApiOperation({ summary: 'One regularization request' })
  @ApiOkResponse({ type: RegularizationRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  getRegularization(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<RegularizationRequestDto> {
    return this.leave.getRegularization(user, id);
  }

  @Post('regularizations')
  @ApiOperation({
    summary: 'Ask to correct one of the last 7 days (for yourself; retry-safe with clientUuid)',
  })
  @ApiCreatedResponse({ type: RegularizationRequestDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'REGULARIZATION_EXISTS' })
  requestRegularization(
    @CurrentUser() user: AuthUser,
    @Body() dto: CreateRegularizationDto,
  ): Promise<RegularizationRequestDto> {
    return this.leave.requestRegularization(user, dto);
  }

  @Post('regularizations/:id/review')
  @HttpCode(200)
  @Roles(...REVIEWERS)
  @ApiOperation({
    summary: 'Approve or reject a pending regularization (line manager; never your own)',
  })
  @ApiOkResponse({ type: RegularizationRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  reviewRegularization(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ReviewRequestDto,
  ): Promise<RegularizationRequestDto> {
    return this.leave.reviewRegularization(user, id, dto);
  }

  @Post('regularizations/:id/cancel')
  @HttpCode(200)
  @ApiOperation({ summary: 'Withdraw your pending regularization request' })
  @ApiOkResponse({ type: RegularizationRequestDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  cancelRegularization(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CancelRequestDto,
  ): Promise<RegularizationRequestDto> {
    return this.leave.cancelRegularization(user, id, dto.expectedVersion);
  }
}
