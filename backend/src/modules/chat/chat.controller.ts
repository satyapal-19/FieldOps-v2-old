import {
  Body,
  Controller,
  Get,
  HttpCode,
  Param,
  ParseUUIDPipe,
  Post,
  Query,
  StreamableFile,
} from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiProduces,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Roles } from '../../shared/auth/decorators';
import { STAFF_ROLES } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { ChatService } from './chat.service';
import {
  ConversationDto,
  DirectDto,
  MessageDto,
  MessagesQueryDto,
  SendMessageDto,
} from './dto/chat.dto';

/** HTTP only. Channels, posting and direct-message rules: chat.policy. */
@ApiTags('chat')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@ApiNotFoundResponse({ type: ProblemDetailsDto })
@Controller('chat')
export class ChatController {
  constructor(private readonly chat: ChatService) {}

  @Get('conversations')
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: "My conversations (joins today's squad / ward channels), newest first" })
  @ApiOkResponse({ type: [ConversationDto] })
  list(@CurrentUser() user: AuthUser): Promise<ConversationDto[]> {
    return this.chat.list(user);
  }

  @Get('conversations/:id/messages')
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'Messages, newest first (page back with before)' })
  @ApiOkResponse({ type: [MessageDto] })
  messages(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Query() q: MessagesQueryDto,
  ): Promise<MessageDto[]> {
    return this.chat.messages(user, id, q);
  }

  @Post('conversations/:id/messages')
  @Roles(...STAFF_ROLES)
  @ApiOperation({
    summary: 'Send a text, voice note, photo or location (retry-safe with clientUuid)',
  })
  @ApiCreatedResponse({ type: MessageDto })
  @ApiForbiddenResponse({ type: ProblemDetailsDto, description: 'A broadcast you cannot post to' })
  send(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: SendMessageDto,
  ): Promise<MessageDto> {
    return this.chat.send(user, id, dto);
  }

  @Post('conversations/:id/read')
  @HttpCode(204)
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'Mark the conversation read up to now' })
  @ApiNoContentResponse()
  async read(@CurrentUser() user: AuthUser, @Param('id', ParseUUIDPipe) id: string): Promise<void> {
    await this.chat.markRead(user, id);
  }

  @Post('direct')
  @HttpCode(200)
  @Roles(...STAFF_ROLES)
  @ApiOperation({ summary: 'Open (or reuse) a direct conversation along the hierarchy' })
  @ApiOkResponse({ type: ConversationDto })
  @ApiForbiddenResponse({ type: ProblemDetailsDto })
  direct(@CurrentUser() user: AuthUser, @Body() dto: DirectDto): Promise<ConversationDto> {
    return this.chat.direct(user, dto.staffId);
  }

  @Get('messages/:id/media')
  @Roles(...STAFF_ROLES)
  @ApiProduces('audio/mp4', 'audio/ogg', 'audio/amr', 'image/jpeg', 'image/png')
  @ApiOperation({ summary: "A message's voice note or photo, for the conversation's members" })
  @ApiOkResponse({ schema: { type: 'string', format: 'binary' } })
  async media(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<StreamableFile> {
    const file = await this.chat.media(user, id);
    return new StreamableFile(file.bytes, { type: file.contentType, length: file.bytes.length });
  }
}
