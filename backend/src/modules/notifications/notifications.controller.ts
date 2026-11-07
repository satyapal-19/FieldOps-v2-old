import { Body, Controller, Delete, Get, HttpCode, Post, Put, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Roles } from '../../shared/auth/decorators';
import { STAFF_ROLES } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import {
  InboxDto,
  InboxQueryDto,
  MarkedDto,
  MarkReadDto,
  PushTokenDto,
  RemovePushTokenDto,
} from './dto/notification.dto';
import { NotificationsService } from './notifications.service';

/** HTTP only: each person's own inbox and push registration. */
@ApiTags('notifications')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@Controller()
export class NotificationsController {
  constructor(private readonly notifications: NotificationsService) {}

  @Get('notifications')
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'My inbox, newest first, with the unread count (the app polls this)' })
  @ApiOkResponse({ type: InboxDto })
  inbox(@CurrentUser() user: AuthUser, @Query() q: InboxQueryDto): Promise<InboxDto> {
    return this.notifications.inbox(user, q);
  }

  @Post('notifications/read')
  @HttpCode(200)
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'Mark some or all of my messages read' })
  @ApiOkResponse({ type: MarkedDto })
  markRead(@CurrentUser() user: AuthUser, @Body() dto: MarkReadDto): Promise<MarkedDto> {
    return this.notifications.markRead(user, dto);
  }

  @Put('devices/push-token')
  @HttpCode(204)
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: "Register this phone's FCM token for my pushes (after sign-in)" })
  @ApiNoContentResponse()
  async register(@CurrentUser() user: AuthUser, @Body() dto: PushTokenDto): Promise<void> {
    await this.notifications.registerToken(user, dto);
  }

  @Delete('devices/push-token')
  @HttpCode(204)
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'Stop pushes to this phone (before sign-out)' })
  @ApiNoContentResponse()
  async remove(@CurrentUser() user: AuthUser, @Body() dto: RemovePushTokenDto): Promise<void> {
    await this.notifications.removeToken(user, dto.token);
  }
}
