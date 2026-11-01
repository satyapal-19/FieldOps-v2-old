import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Put,
  Query,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiNoContentResponse,
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
  EffectiveShiftDto,
  EffectiveShiftQueryDto,
  PutShiftDto,
  ShiftDto,
  ShiftRangeQueryDto,
} from './dto/shifts.dto';
import { ShiftsService } from './shifts.service';

/** HTTP only: maps requests to one service call. Scope checks live in the service / policies. */
@ApiTags('shifts')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@ApiNotFoundResponse({ type: ProblemDetailsDto })
@Controller('shifts')
export class ShiftsController {
  constructor(private readonly shifts: ShiftsService) {}

  @Get()
  @ApiOperation({
    summary: "A person's shift overrides in a date range (yourself, or staff in your scope)",
  })
  @ApiOkResponse({ type: [ShiftDto] })
  list(@CurrentUser() user: AuthUser, @Query() q: ShiftRangeQueryDto): Promise<ShiftDto[]> {
    return this.shifts.list(user, q.staffId, q.from, q.to);
  }

  @Get('effective')
  @ApiOperation({
    summary: 'The shift that applies on a day: the override, else the staff defaults',
  })
  @ApiOkResponse({ type: EffectiveShiftDto })
  effective(
    @CurrentUser() user: AuthUser,
    @Query() q: EffectiveShiftQueryDto,
  ): Promise<EffectiveShiftDto> {
    return this.shifts.effectiveFor(user, q.staffId, q.date);
  }

  @Put()
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({
    summary: "Set a person's shift for a day (ADMIN; ward inspector for their ward's staff)",
  })
  @ApiOkResponse({ type: ShiftDto })
  @ApiConflictResponse({ type: ProblemDetailsDto, description: 'VERSION_CONFLICT' })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'RULE_VIOLATION' })
  put(@CurrentUser() user: AuthUser, @Body() dto: PutShiftDto): Promise<ShiftDto> {
    return this.shifts.put(user, dto);
  }

  @Delete(':id')
  @HttpCode(204)
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR)
  @ApiOperation({ summary: 'Remove an override for today or a coming day (defaults apply again)' })
  @ApiNoContentResponse()
  remove(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string): Promise<void> {
    return this.shifts.remove(user, id);
  }
}
