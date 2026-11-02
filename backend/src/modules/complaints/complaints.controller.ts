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
  AssignComplaintDto,
  ComplaintDto,
  ComplaintPageDto,
  ComplaintStatusDto,
  ListComplaintsQueryDto,
  PublicComplaintDto,
  SubmitComplaintDto,
} from './dto/complaint.dto';
import { ComplaintsService } from './complaints.service';

/**
 * The citizen portal: no sign-in, read-only apart from filing, and on the stricter per-IP rate
 * limit (the same one sign-in uses). Responses carry no personal data.
 */
@ApiTags('public')
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiTooManyRequestsResponse({ type: ProblemDetailsDto })
@Controller('public/complaints')
export class PublicComplaintsController {
  constructor(private readonly complaints: ComplaintsService) {}

  @Post()
  @Public()
  @SignInRateLimit()
  @ApiOperation({ summary: 'File a civic complaint (no sign-in); returns the tracking ID' })
  @ApiCreatedResponse({ type: PublicComplaintDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  submit(@Body() dto: SubmitComplaintDto): Promise<PublicComplaintDto> {
    return this.complaints.submit(dto);
  }

  @Get(':trackingId')
  @Public()
  @SignInRateLimit()
  @ApiOperation({ summary: 'Track a complaint by its tracking ID (no sign-in)' })
  @ApiOkResponse({ type: PublicComplaintDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  track(@Param('trackingId') trackingId: string): Promise<PublicComplaintDto> {
    return this.complaints.track(trackingId);
  }
}

/** Staff side: scoped reads, routing (raises a task) and status changes. */
@ApiTags('complaints')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
@Controller('complaints')
export class ComplaintsController {
  constructor(private readonly complaints: ComplaintsService) {}

  @Get()
  @Roles(Role.ADMIN, Role.OFFICE_STAFF, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({
    summary: 'Complaints in your scope (admin and office staff: all; ward supervisors: ward)',
  })
  @ApiOkResponse({ type: ComplaintPageDto })
  list(
    @CurrentUser() user: AuthUser,
    @Query() q: ListComplaintsQueryDto,
  ): Promise<ComplaintPageDto> {
    return this.complaints.list(user, q);
  }

  @Get(':id')
  @Roles(Role.ADMIN, Role.OFFICE_STAFF, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({ summary: 'One complaint with its linked tasks' })
  @ApiOkResponse({ type: ComplaintDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<ComplaintDto> {
    return this.complaints.get(user, id);
  }

  @Post(':id/assign')
  @HttpCode(200)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({
    summary: 'Route a complaint by raising a task (admin; ward inspector of its ward)',
  })
  @ApiOkResponse({ type: ComplaintDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  assign(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: AssignComplaintDto,
  ): Promise<ComplaintDto> {
    return this.complaints.assign(user, id, dto);
  }

  @Post(':id/status')
  @HttpCode(200)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({
    summary: 'RESOLVE (after an approved task), REJECT (from RECEIVED) or CLOSE a complaint',
  })
  @ApiOkResponse({ type: ComplaintDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  changeStatus(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: ComplaintStatusDto,
  ): Promise<ComplaintDto> {
    return this.complaints.changeStatus(user, id, dto);
  }
}
