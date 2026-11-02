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
  ApiServiceUnavailableResponse,
  ApiTags,
  ApiUnauthorizedResponse,
  ApiUnprocessableEntityResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Roles } from '../../shared/auth/decorators';
import { Role, type StaffRole } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { AttendanceService } from './attendance.service';
import {
  AttendanceLogDto,
  AttendancePageDto,
  ChallengeDto,
  CreateChallengeDto,
  CreatePunchDto,
  ListAttendanceQueryDto,
  PunchResultDto,
} from './dto/attendance.dto';

const STAFF: StaffRole[] = [
  Role.ADMIN,
  Role.WARD_INSPECTOR,
  Role.INSPECTOR,
  Role.WORKER,
  Role.OFFICE_STAFF,
];

/** HTTP only: maps requests to one service call. Every rule lives in attendance.policy. */
@ApiTags('attendance')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('attendance')
export class AttendanceController {
  constructor(private readonly attendance: AttendanceService) {}

  @Post('challenges')
  @Roles(...STAFF)
  @ApiOperation({
    summary: 'One-time liveness challenge for the next punch (yourself, or a team member)',
  })
  @ApiCreatedResponse({ type: ChallengeDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  challenge(@CurrentUser() user: AuthUser, @Body() dto: CreateChallengeDto): Promise<ChallengeDto> {
    return this.attendance.issueChallenge(user, dto.staffId);
  }

  @Post('punches')
  @HttpCode(200)
  @Roles(...STAFF)
  @ApiOperation({
    summary: 'Check in or out (self or proxy): server time, geofence, hierarchy and face checks',
    description:
      'Idempotent by clientUuid: a retry returns the accepted punch with replayed = true. ' +
      'Errors: NO_ASSIGNMENT, ASSIGNMENT_NOT_APPROVED, OUTSIDE_GEOFENCE, LOCATION_TOO_INACCURATE, ' +
      'OUTSIDE_SHIFT_WINDOW, ON_LEAVE, NOT_CHECKED_IN, CHALLENGE_INVALID, CHALLENGE_EXPIRED, ' +
      'FACE_MISMATCH, FACE_NOT_ENROLLED (422); ALREADY_CHECKED_IN, ALREADY_CHECKED_OUT (409); ' +
      'FACE_PROVIDER_UNAVAILABLE (503).',
  })
  @ApiOkResponse({ type: PunchResultDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto })
  @ApiServiceUnavailableResponse({ type: ProblemDetailsDto })
  punch(@CurrentUser() user: AuthUser, @Body() dto: CreatePunchDto): Promise<PunchResultDto> {
    return this.attendance.punch(user, dto);
  }

  @Get()
  @Roles(...STAFF)
  @ApiOperation({ summary: 'Attendance in your scope (self, team, ward, or all)' })
  @ApiOkResponse({ type: AttendancePageDto })
  list(
    @CurrentUser() user: AuthUser,
    @Query() q: ListAttendanceQueryDto,
  ): Promise<AttendancePageDto> {
    return this.attendance.list(user, q);
  }

  @Get(':id')
  @Roles(...STAFF)
  @ApiOperation({ summary: 'One attendance record' })
  @ApiOkResponse({ type: AttendanceLogDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<AttendanceLogDto> {
    return this.attendance.get(user, id);
  }
}
