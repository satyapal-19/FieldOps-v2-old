import { Body, Controller, Get, HttpCode, Param, ParseUUIDPipe, Patch, Post } from '@nestjs/common';
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
} from '@nestjs/swagger';
import { Roles } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { LocationCheckDto } from '../wards/dto/ward.dto';
import { CreateOfficeDto, OfficeDto, OfficeLocationCheckResultDto, UpdateOfficeDto } from './dto/office.dto';
import { OfficesService } from './offices.service';

/** Reads: any signed-in staff (office maps are visible to all). Writes: ADMIN. */
@ApiTags('offices')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('offices')
export class OfficesController {
  constructor(private readonly offices: OfficesService) {}

  @Get()
  @ApiOperation({ summary: 'List corporation offices' })
  @ApiOkResponse({ type: [OfficeDto] })
  list(): Promise<OfficeDto[]> {
    return this.offices.list();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get one office with its premises' })
  @ApiOkResponse({ type: OfficeDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  get(@Param('id', ParseUUIDPipe) id: string): Promise<OfficeDto> {
    return this.offices.get(id);
  }

  @Post()
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Create an office (ADMIN)' })
  @ApiCreatedResponse({ type: OfficeDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'OFFICE_CODE_TAKEN' })
  create(@Body() dto: CreateOfficeDto): Promise<OfficeDto> {
    return this.offices.create(dto);
  }

  @Patch(':id')
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Update an office (ADMIN, optimistic locking)' })
  @ApiOkResponse({ type: OfficeDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: UpdateOfficeDto): Promise<OfficeDto> {
    return this.offices.update(id, dto);
  }

  @Post(':id/location-check')
  @HttpCode(200)
  @ApiOperation({ summary: 'Is a point inside the office premises or its buffer?' })
  @ApiOkResponse({ type: OfficeLocationCheckResultDto })
  checkLocation(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: LocationCheckDto,
  ): Promise<OfficeLocationCheckResultDto> {
    return this.offices.checkLocation(id, dto);
  }
}
