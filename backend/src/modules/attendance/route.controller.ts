import { Controller, Get, Param, ParseUUIDPipe, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
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
import { RouteDto, RouteQueryDto } from './dto/route.dto';
import { RouteService } from './route.service';

/** HTTP only. Who may see whose route is decided in attendance.policy (routeAccess). */
@ApiTags('attendance')
@ApiBearerAuth()
@ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Validation failed' })
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiForbiddenResponse({ type: ProblemDetailsDto })
@Controller('staff')
export class RouteController {
  constructor(private readonly routes: RouteService) {}

  @Get(':id/route')
  @Roles(Role.ADMIN, Role.WARD_INSPECTOR, Role.INSPECTOR, Role.WORKER, Role.OFFICE_STAFF)
  @ApiOperation({
    summary: "A person's route on an IST date: points, distance, gaps and tamper events",
    description:
      'Raw points while they are kept (PING_RETENTION_DAYS), then only the nightly summary. ' +
      "Supervisors see their scope; everyone else only their own route for today's shift.",
  })
  @ApiOkResponse({ type: RouteDto })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  @ApiUnprocessableEntityResponse({ type: ProblemDetailsDto, description: 'Date in the future' })
  route(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Query() q: RouteQueryDto,
  ): Promise<RouteDto> {
    return this.routes.route(user, id, q.date);
  }
}
