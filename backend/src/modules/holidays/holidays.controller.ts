import {
  Body,
  Controller,
  Delete,
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
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
  ApiUnprocessableEntityResponse,
} from '@nestjs/swagger';
import { Roles } from '../../shared/auth/decorators';
import { Role } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import {
  CreateHolidayDto,
  HolidayDto,
  ListHolidaysQueryDto,
  UpdateHolidayDto,
} from './dto/holiday.dto';
import { HolidaysService } from './holidays.service';

/** HTTP only: maps requests to one service call. Reads: any signed-in staff. Writes: ADMIN. */
@ApiTags('holidays')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('holidays')
export class HolidaysController {
  constructor(private readonly holidays: HolidaysService) {}

  @Get()
  @ApiOperation({ summary: 'Holidays in a calendar year, by date' })
  @ApiOkResponse({ type: [HolidayDto] })
  list(@Query() query: ListHolidaysQueryDto): Promise<HolidayDto[]> {
    return this.holidays.list(query.year);
  }

  @Post()
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Add a holiday (ADMIN, today or later)' })
  @ApiCreatedResponse({ type: HolidayDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'HOLIDAY_DATE_TAKEN' })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  create(@Body() dto: CreateHolidayDto): Promise<HolidayDto> {
    return this.holidays.create(dto);
  }

  @Patch(':id')
  @Roles(Role.ADMIN)
  @ApiOperation({
    summary: 'Change a coming holiday (ADMIN, optimistic locking via expectedVersion)',
  })
  @ApiOkResponse({ type: HolidayDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiConflictResponse({
    type: ProblemDetailsDto,
    description: 'VERSION_CONFLICT or HOLIDAY_DATE_TAKEN',
  })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateHolidayDto,
  ): Promise<HolidayDto> {
    return this.holidays.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  @Roles(Role.ADMIN)
  @ApiOperation({ summary: 'Remove a coming holiday (ADMIN)' })
  @ApiNoContentResponse()
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  remove(@Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.holidays.remove(id);
  }
}
