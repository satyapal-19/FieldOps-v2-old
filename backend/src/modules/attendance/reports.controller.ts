import { Controller, Get, Param, ParseUUIDPipe, Query, StreamableFile } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProduces,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
  ApiUnprocessableEntityResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Public, Roles } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { SignInRateLimit } from '../auth/rate-limit';
import {
  LiveDto,
  LiveQueryDto,
  MusterQueryDto,
  PublicWardAttendanceDto,
  ReportQueryDto,
  StaffReportDto,
  StaffReportQueryDto,
  WardDaysDto,
} from './dto/reports.dto';
import { ReportsService } from './reports.service';

/** HTTP only. Who sees which ward: reports.policy. */
@ApiTags('reports')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller()
export class ReportsController {
  constructor(private readonly reports: ReportsService) {}

  @Get('live/positions')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({
    summary: 'Who is checked in on a field shift right now, with their latest position',
    description:
      'Admin all wards (or one), ward inspector their ward, inspector their team and placements. ' +
      'Poll every 30 s; state ACTIVE / STALE / SILENT / NO_SIGNAL from the last ping.',
  })
  @ApiOkResponse({ type: LiveDto })
  live(@CurrentUser() user: AuthUser, @Query() q: LiveQueryDto): Promise<LiveDto> {
    return this.reports.live(user, q);
  }

  @Get('reports/ward-days')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({ summary: 'Daily attendance per ward from the nightly summaries (up to 92 days)' })
  @ApiOkResponse({ type: WardDaysDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'Bad date range' })
  wardDays(@CurrentUser() user: AuthUser, @Query() q: ReportQueryDto): Promise<WardDaysDto> {
    return this.reports.wardDays(user, q);
  }

  @Get('reports/staff-days')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({ summary: 'Per-person late marks, absences, leave and corrections over a range' })
  @ApiOkResponse({ type: StaffReportDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'Bad date range' })
  staffDays(
    @CurrentUser() user: AuthUser,
    @Query() q: StaffReportQueryDto,
  ): Promise<StaffReportDto> {
    return this.reports.staffDays(user, q);
  }

  @Get('reports/muster-roll')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiProduces('text/csv', 'application/pdf')
  @ApiOperation({ summary: "A ward's monthly muster roll: CSV (Marathi names) or printable PDF" })
  @ApiOkResponse({ schema: { type: 'string', format: 'binary' } })
  async musterRoll(
    @CurrentUser() user: AuthUser,
    @Query() q: MusterQueryDto,
  ): Promise<StreamableFile> {
    const file = await this.reports.musterRoll(user, q);
    return new StreamableFile(file.body, {
      type: file.contentType,
      disposition: `attachment; filename="${file.fileName}"`,
      length: file.body.length,
    });
  }

  @Public()
  @SignInRateLimit()
  @Get('public/wards/:id/attendance')
  @ApiOperation({
    summary: 'Citizens: staff placed and present in a ward over the last week (counts only)',
  })
  @ApiOkResponse({ type: PublicWardAttendanceDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiTooManyRequestsResponse({ type: ProblemDetailsDto })
  publicWard(@Param('id', ParseUUIDPipe) id: string): Promise<PublicWardAttendanceDto> {
    return this.reports.publicWard(id);
  }
}
