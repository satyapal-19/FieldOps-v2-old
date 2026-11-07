import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, LessThan, MoreThan, Not, Repository } from 'typeorm';
import { ConversationParticipant } from './entities/conversation-participant.entity';
import { Conversation } from './entities/conversation.entity';
import { Message } from './entities/message.entity';

/** The only place that queries conversations, participants and messages. */
@Injectable()
export class ChatRepository {
  constructor(
    @InjectRepository(Conversation) private readonly conversations: Repository<Conversation>,
    @InjectRepository(ConversationParticipant)
    private readonly participants: Repository<ConversationParticipant>,
    @InjectRepository(Message) private readonly messages: Repository<Message>,
  ) {}

  findConversation(id: string): Promise<Conversation | null> {
    return this.conversations.findOne({ where: { id, deletedAt: IsNull() } });
  }

  findByKey(key: string): Promise<Conversation | null> {
    return this.conversations.findOne({ where: { conversationKey: key, deletedAt: IsNull() } });
  }

  async insertConversation(row: Conversation): Promise<void> {
    await this.conversations.insert(row);
  }

  findParticipant(
    conversationId: string,
    staffId: string,
  ): Promise<ConversationParticipant | null> {
    return this.participants.findOne({ where: { conversationId, staffId } });
  }

  async addParticipant(row: ConversationParticipant): Promise<void> {
    await this.participants.insert(row);
  }

  async reactivate(conversationId: string, staffId: string, at: Date): Promise<void> {
    await this.participants.update(
      { conversationId, staffId },
      { isActive: true, joinedAt: at, leftAt: null },
    );
  }

  /** Conversations the person is an active member of, newest activity first. */
  async myConversations(
    staffId: string,
  ): Promise<{ conversation: Conversation; lastReadAt: Date | null }[]> {
    const mine = await this.participants.find({ where: { staffId, isActive: true } });
    if (mine.length === 0) return [];
    const rows = await this.conversations.find({
      where: { id: In(mine.map((p) => p.conversationId)), deletedAt: IsNull() },
    });
    const read = new Map(mine.map((p) => [p.conversationId, p.lastReadAt]));
    return rows
      .map((conversation) => ({ conversation, lastReadAt: read.get(conversation.id) ?? null }))
      .sort(
        (a, b) =>
          (b.conversation.lastMessageAt?.getTime() ?? 0) -
          (a.conversation.lastMessageAt?.getTime() ?? 0),
      );
  }

  activeMembers(conversationId: string): Promise<ConversationParticipant[]> {
    return this.participants.find({ where: { conversationId, isActive: true } });
  }

  /** Messages from others since the person last read the conversation. */
  unreadCount(conversationId: string, staffId: string, since: Date | null): Promise<number> {
    return this.messages.count({
      where: {
        conversationId,
        senderId: Not(staffId),
        deletedAt: IsNull(),
        ...(since ? { createdAt: MoreThan(since) } : {}),
      },
    });
  }

  async markRead(conversationId: string, staffId: string, at: Date): Promise<void> {
    await this.participants.update({ conversationId, staffId }, { lastReadAt: at });
  }

  /** A page of messages, newest first; `before` pages back. */
  page(conversationId: string, before: Date | undefined, take: number): Promise<Message[]> {
    return this.messages.find({
      where: {
        conversationId,
        deletedAt: IsNull(),
        ...(before ? { createdAt: LessThan(before) } : {}),
      },
      order: { createdAt: 'DESC' },
      take,
    });
  }

  findMessage(id: string): Promise<Message | null> {
    return this.messages.findOne({ where: { id, deletedAt: IsNull() } });
  }

  findMessageByClientUuid(clientUuid: string): Promise<Message | null> {
    return this.messages.findOne({ where: { clientUuid } });
  }

  async insertMessage(row: Message): Promise<void> {
    await this.messages.insert(row);
    await this.conversations.update({ id: row.conversationId }, { lastMessageAt: row.createdAt });
  }

  /** Squad chats of days before `today` become read-only. Returns how many were archived. */
  async archiveSquadsBefore(today: string): Promise<number> {
    const result = await this.conversations.update(
      { convType: 'SQUAD_TEAM', isArchived: false, shiftDate: LessThan(today) },
      { isArchived: true },
    );
    return result.affected ?? 0;
  }
}
