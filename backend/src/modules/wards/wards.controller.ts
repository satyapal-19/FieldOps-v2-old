import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiUnauthorizedResponse,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnprocessableEntityResponse,
} from '@nestjs/swagger';
import { Roles } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import {
  CreateWardDto,
  ListWardsQueryDto,
  LocationCheckDto,
  LocationCheckResultDto,
  UpdateWardDto,
  WardDto,
  WardPageDto,
} from './dto/ward.dto';
import { WardsService } from './wards.service';

/**
 * HTTP only: maps requests to one service call.
 * Reads: any signed-in staff (ward maps are visible to all, v4 §4.1). Writes: ADMIN.
 */
@ApiTags('wards')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('wards')
export class WardsController {
  constructor(private readonly wards: WardsService) {}

  @Get()
  @ApiOperation({ summary: 'List wards (paged, by code)' })
  @ApiOkResponse({ type: WardPageDto })
  list(@Query() query: ListWardsQueryDto): Promise<WardPageDto> {
    return this.wards.list(query.page, query.pageSize);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one ward with its boundary' })
  @ApiOkResponse({ type: WardDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(@Param('id', ParseUUIDPipe) id: string): Promise<WardDto> {
    return this.wards.get(id);
  }

  @Post()
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Create a ward (ADMIN)' })
  @ApiCreatedResponse({ type: WardDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'WARD_CODE_TAKEN' })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'INVALID_BOUNDARY' })
  create(@Body() dto: CreateWardDto): Promise<WardDto> {
    return this.wards.create(dto);
  }

  @Patch(':id')
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Update a ward (ADMIN, optimistic locking via expectedVersion)' })
  @ApiOkResponse({ type: WardDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'INVALID_BOUNDARY' })
  update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateWardDto): Promise<WardDto> {
    return this.wards.update(id, dto);
  }

  @Post(':id/location-check')
  @HttpCode(200)
  @ApiOperation({ summary: 'Is a point inside the ward or within the 25 m edge allowance?' })
  @ApiOkResponse({ type: LocationCheckResultDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  checkLocation(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: LocationCheckDto,
  ): Promise<LocationCheckResultDto> {
    return this.wards.checkLocation(id, dto);
  }
}
