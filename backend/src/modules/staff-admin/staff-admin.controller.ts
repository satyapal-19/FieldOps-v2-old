import { Body, Controller, Get, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
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
import { StaffProfileDto } from '../staff/dto/staff-profile.dto';
import {
  CreateStaffDto,
  ListStaffQueryDto,
  StaffPageDto,
  UpdateStaffDto,
} from './dto/staff-admin.dto';
import { StaffAdminService } from './staff-admin.service';

/**
 * HTTP only: maps requests to one service call.
 * Reads: ADMIN (all), WARD_INSPECTOR (own ward), INSPECTOR (own ward's workers). Writes: ADMIN.
 */
@ApiTags('staff')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('staff')
export class StaffAdminController {
  constructor(private readonly staffAdmin: StaffAdminService) {}

  @Get()
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR)
  @ApiOperation({ summary: 'List staff in your scope (paged, by employee code)' })
  @ApiOkResponse({ type: StaffPageDto })
  list(@CurrentUser() user: AuthUser, @Query() query: ListStaffQueryDto): Promise<StaffPageDto> {
    return this.staffAdmin.list(user, query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one staff member (yourself, or someone in your scope)' })
  @ApiOkResponse({ type: StaffProfileDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<StaffProfileDto> {
    return this.staffAdmin.get(user, id);
  }

  @Post()
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Create a staff member (ADMIN)' })
  @ApiCreatedResponse({ type: StaffProfileDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'STAFF_IDENTITY_TAKEN' })
  @ApiUnprocessableEntityResponse({
    type: ProblemDetailsDto,
    description: 'RULE_VIOLATION (role links, reporting line) or AUTH_WEAK_PASSWORD',
  })
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateStaffDto): Promise<StaffProfileDto> {
    return this.staffAdmin.create(user, dto);
  }

  @Patch(':id')
  @Roles(Role.ADMIN)
  @ApiOperation({
    summary: 'Update or deactivate a staff member (ADMIN, optimistic locking via expectedVersion)',
    description:
      'Changing role, ward, office or phone, or deactivating, signs the person out everywhere.',
  })
  @ApiOkResponse({ type: StaffProfileDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({
    type: ProblemDetailsDto,
    description: 'VERSION_CONFLICT or STAFF_IDENTITY_TAKEN',
  })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  update(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateStaffDto,
  ): Promise<StaffProfileDto> {
    return this.staffAdmin.update(user, id, dto);
  }
}
