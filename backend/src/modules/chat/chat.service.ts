import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { NotificationsService } from '../notifications/notifications.service';
import { RostersService } from '../rosters/rosters.service';
import { StaffService } from '../staff/staff.service';
import { UploadsService } from '../uploads/uploads.service';
import {
  canMessageDirectly,
  canPost,
  channelsFor,
  directKey,
  type ChannelSpec,
} from './chat.policy';
import { ChatRepository } from './chat.repository';
import type { ConversationDto, MessageDto, MessagesQueryDto, SendMessageDto } from './dto/chat.dto';
import type { Conversation } from './entities/conversation.entity';
import type { Message } from './entities/message.entity';

const iso = (d: Date | null) => (d ? d.toISOString() : null);
const num = (v: unknown) => (v === null || v === undefined ? null : Number(v));
const bool = (v: unknown) => Boolean(Number(v));

function toMessageDto(m: Message): MessageDto {
  return {
    id: m.id,
    conversationId: m.conversationId,
    senderId: m.senderId,
    type: m.msgType,
    text: m.body,
    hasMedia: !!m.storageKey,
    durationSec: num(m.durationSec),
    latitude: num(m.lat),
    longitude: num(m.lng),
    createdAt: m.createdAt.toISOString(),
  };
}

const TITLES: Record<ChannelSpec['type'], string> = {
  SQUAD_TEAM: 'Squad',
  WARD_BROADCAST: 'Ward broadcast',
  CITY_BROADCAST: 'SMKMC broadcast',
};

/**
 * Hierarchy-based chat (action plan Phase 4). A person's channels follow the day's placement:
 * opening the chat list makes sure they exist and that the person is a member. Squad chats of
 * past days are archived (read-only); history is never deleted. Voice notes and photos are
 * uploads, readable only by the conversation's members. Rules: chat.policy.
 */
@Injectable()
export class ChatService {
  constructor(
    private readonly repo: ChatRepository,
    private readonly staff: StaffService,
    private readonly rosters: RostersService,
    private readonly uploads: UploadsService,
    private readonly notifications: NotificationsService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  /** My conversations (today's channels joined first), newest activity first, with unread counts. */
  async list(actor: AuthUser): Promise<ConversationDto[]> {
    await this.joinTodaysChannels(actor);
    const mine = await this.repo.myConversations(actor.staffId);
    return Promise.all(
      mine.map(async ({ conversation, lastReadAt }) =>
        this.toDto(
          conversation,
          actor,
          await this.repo.unreadCount(conversation.id, actor.staffId, lastReadAt),
        ),
      ),
    );
  }

  async messages(
    actor: AuthUser,
    conversationId: string,
    q: MessagesQueryDto,
  ): Promise<MessageDto[]> {
    await this.member(actor, conversationId);
    return (
      await this.repo.page(conversationId, q.before ? new Date(q.before) : undefined, q.limit)
    ).map(toMessageDto);
  }

  async markRead(actor: AuthUser, conversationId: string): Promise<void> {
    await this.member(actor, conversationId);
    await this.repo.markRead(conversationId, actor.staffId, this.clock.now());
  }

  async send(actor: AuthUser, conversationId: string, dto: SendMessageDto): Promise<MessageDto> {
    const earlier = await this.repo.findMessageByClientUuid(dto.clientUuid);
    if (earlier) {
      if (earlier.senderId !== actor.staffId || earlier.conversationId !== conversationId) {
        throw new AppError(ErrorCode.CONFLICT, 'This clientUuid was already used', {
          field: 'clientUuid',
        });
      }
      return toMessageDto(earlier);
    }
    const conversation = await this.member(actor, conversationId, true);
    if (bool(conversation.isArchived)) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'This squad chat is archived (read-only)');
    }
    if (!canPost(conversation.convType, actor.role)) {
      throw new AppError(ErrorCode.FORBIDDEN, 'Only the sender of this broadcast can post');
    }
    const now = this.clock.now();
    const row: Message = {
      id: this.ids.next(),
      clientUuid: dto.clientUuid,
      conversationId,
      senderId: actor.staffId,
      msgType: dto.type,
      body: null,
      storageKey: null,
      mimeType: null,
      sizeBytes: null,
      durationSec: null,
      lat: null,
      lng: null,
      createdAt: now,
      deletedAt: null,
    };
    if (dto.type === 'TEXT') {
      if (!dto.text?.trim())
        throw new AppError(ErrorCode.VALIDATION_FAILED, 'text is required', { field: 'text' });
      row.body = dto.text.trim();
    } else if (dto.type === 'LOCATION') {
      if (dto.latitude === undefined || dto.longitude === undefined) {
        throw new AppError(ErrorCode.VALIDATION_FAILED, 'latitude and longitude are required', {
          field: 'latitude',
        });
      }
      row.lat = dto.latitude;
      row.lng = dto.longitude;
    } else {
      if (!dto.uploadId)
        throw new AppError(ErrorCode.VALIDATION_FAILED, 'uploadId is required', {
          field: 'uploadId',
        });
      const upload = await this.uploads.ownedOfKind(
        actor.staffId,
        dto.uploadId,
        dto.type === 'VOICE' ? 'VOICE_NOTE' : 'TASK_PHOTO',
        'uploadId',
      );
      row.storageKey = upload.id;
      row.mimeType = upload.contentType;
      row.sizeBytes = Number(upload.sizeBytes);
      row.durationSec = dto.type === 'VOICE' ? (dto.durationSec ?? null) : null;
      row.body = dto.text?.trim() || null;
    }
    try {
      await this.repo.insertMessage(row);
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
      return toMessageDto((await this.repo.findMessageByClientUuid(dto.clientUuid))!);
    }
    await this.repo.markRead(conversationId, actor.staffId, now);
    await this.tellMembers(conversation, actor, row);
    return toMessageDto(row);
  }

  /** The voice note or photo of a message, for members of its conversation. */
  async media(actor: AuthUser, messageId: string): Promise<{ contentType: string; bytes: Buffer }> {
    const message = await this.repo.findMessage(messageId);
    if (!message || !message.storageKey)
      throw new AppError(ErrorCode.NOT_FOUND, 'Message not found', { id: messageId });
    await this.member(actor, message.conversationId);
    const { row, bytes } = await this.uploads.read(
      message.storageKey,
      message.msgType === 'VOICE' ? 'VOICE_NOTE' : 'TASK_PHOTO',
    );
    return { contentType: row.contentType, bytes };
  }

  /** A direct conversation with someone the hierarchy lets the caller reach (opened once per pair). */
  async direct(actor: AuthUser, staffId: string): Promise<ConversationDto> {
    const [me, target] = await Promise.all([
      this.staff.findById(actor.staffId),
      this.staff.findById(staffId),
    ]);
    if (!me || !target || !Number(target.isActive)) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: staffId });
    }
    const allowed = canMessageDirectly(
      {
        staffId: me.id,
        role: me.role,
        homeWardId: me.homeWardId ?? null,
        reportsToId: me.reportsToId ?? null,
      },
      {
        id: target.id,
        role: target.role,
        homeWardId: target.homeWardId ?? null,
        reportsToId: target.reportsToId ?? null,
      },
    );
    if (!allowed)
      throw new AppError(
        ErrorCode.FORBIDDEN,
        'Message this person through your squad or supervisor',
      );
    const conversation = await this.ensure(
      directKey(me.id, target.id),
      { type: 'DIRECT', wardId: null, inspectorId: null, shiftDate: null, title: null },
      [me.id, target.id],
      me.id,
    );
    return this.toDto(conversation, actor, 0);
  }

  /** Nightly: yesterday's squad chats become read-only. */
  async archiveOldSquads(): Promise<string> {
    const n = await this.repo.archiveSquadsBefore(istDate(this.clock.now()));
    return `archived ${n} squad chats`;
  }

  // ------------------------------------------------------------ Helpers

  private async joinTodaysChannels(actor: AuthUser): Promise<void> {
    const today = istDate(this.clock.now());
    const me = await this.staff.findById(actor.staffId);
    if (!me) return;
    const placement =
      me.role === Role.INSPECTOR || me.role === Role.WORKER
        ? await this.rosters.assignmentFor(today, me.id)
        : null;
    const approved = placement && bool(placement.isApproved) ? placement : null;
    const specs = channelsFor(
      {
        staffId: me.id,
        role: me.role,
        homeWardId: me.homeWardId ?? null,
        dayWardId: approved?.wardId ?? null,
        dayInspectorId: me.role === Role.WORKER ? (approved?.inspectorId ?? null) : null,
      },
      today,
    );
    for (const spec of specs) {
      const existing = await this.repo.findByKey(spec.key);
      if (existing) {
        await this.join(existing.id, me.id);
        continue;
      }
      await this.ensure(
        spec.key,
        { ...spec, title: TITLES[spec.type] },
        await this.membersOf(spec),
        me.id,
      );
    }
  }

  /** Everyone who belongs in a channel when it is first opened (later members join on their own). */
  private async membersOf(spec: ChannelSpec): Promise<string[]> {
    switch (spec.type) {
      case 'SQUAD_TEAM': {
        const team = await this.rosters.placementsUnder(
          spec.inspectorId!,
          spec.shiftDate!,
          spec.shiftDate!,
        );
        return [spec.inspectorId!, ...team.map((p) => p.staffId)];
      }
      case 'WARD_BROADCAST': {
        const wi = await this.staff.findWardInspector(spec.wardId!);
        const inspectors = await this.staff.findIds({
          role: Role.INSPECTOR,
          wardId: spec.wardId!,
          isActive: true,
        });
        return [...(wi ? [wi.id] : []), ...inspectors];
      }
      case 'CITY_BROADCAST':
        return [
          ...(await this.staff.findIds({ role: Role.ADMIN, isActive: true })),
          ...(await this.staff.findIds({ role: Role.WARD_INSPECTOR, isActive: true })),
        ];
    }
  }

  private async ensure(
    key: string,
    spec: Pick<Conversation, 'wardId' | 'inspectorId' | 'shiftDate' | 'title'> & {
      type: Conversation['convType'];
    },
    members: string[],
    creatorId: string,
  ): Promise<Conversation> {
    const now = this.clock.now();
    let conversation = await this.repo.findByKey(key);
    if (!conversation) {
      const row: Conversation = {
        id: this.ids.next(),
        conversationKey: key,
        convType: spec.type,
        title: spec.title,
        wardId: spec.wardId,
        inspectorId: spec.inspectorId,
        shiftDate: spec.shiftDate,
        isArchived: false,
        createdById: creatorId,
        lastMessageAt: null,
        createdAt: now,
        deletedAt: null,
      };
      try {
        await this.repo.insertConversation(row);
        conversation = row;
      } catch (error) {
        if (!isUniqueViolation(error)) throw error;
        conversation = (await this.repo.findByKey(key))!; // opened by someone else at the same time
      }
    }
    for (const id of new Set([...members, creatorId])) await this.join(conversation.id, id);
    return conversation;
  }

  private async join(conversationId: string, staffId: string): Promise<void> {
    const now = this.clock.now();
    const existing = await this.repo.findParticipant(conversationId, staffId);
    if (existing) {
      if (!bool(existing.isActive)) await this.repo.reactivate(conversationId, staffId, now);
      return;
    }
    try {
      await this.repo.addParticipant({
        conversationId,
        staffId,
        isActive: true,
        joinedAt: now,
        leftAt: null,
        lastReadAt: null,
      });
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
    }
  }

  /** The conversation, if the caller is (or was) a member; else 404 so ids cannot be probed. */
  private async member(
    actor: AuthUser,
    conversationId: string,
    mustBeActive = false,
  ): Promise<Conversation> {
    const conversation = await this.repo.findConversation(conversationId);
    const me = conversation ? await this.repo.findParticipant(conversationId, actor.staffId) : null;
    if (!conversation || !me || (mustBeActive && !bool(me.isActive))) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Conversation not found', { id: conversationId });
    }
    return conversation;
  }

  private async toDto(c: Conversation, actor: AuthUser, unread: number): Promise<ConversationDto> {
    const members = await this.repo.activeMembers(c.id);
    return {
      id: c.id,
      type: c.convType,
      title: c.title,
      wardId: c.wardId,
      inspectorId: c.inspectorId,
      date: c.shiftDate,
      archived: bool(c.isArchived),
      canPost: !bool(c.isArchived) && canPost(c.convType, actor.role),
      memberIds: members.map((m) => m.staffId),
      lastMessageAt: iso(c.lastMessageAt),
      unread,
    };
  }

  private async tellMembers(c: Conversation, actor: AuthUser, m: Message): Promise<void> {
    const others = (await this.repo.activeMembers(c.id))
      .map((p) => p.staffId)
      .filter((id) => id !== actor.staffId);
    const sender = await this.staff.findById(actor.staffId);
    const preview =
      m.msgType === 'TEXT'
        ? (m.body ?? '').slice(0, 120)
        : m.msgType === 'VOICE'
          ? 'Voice message'
          : m.msgType === 'IMAGE'
            ? 'Photo'
            : 'Location';
    await this.notifications.notify(others, {
      kind: 'CHAT',
      priority: 'NORMAL',
      title: sender ? sender.fullName : 'New message',
      titleMr: sender?.fullNameMr ?? null,
      body: preview,
      refType: 'CONVERSATION',
      refId: c.id,
    });
  }
}
