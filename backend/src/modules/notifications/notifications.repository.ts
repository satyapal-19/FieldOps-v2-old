import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { In, IsNull, LessThan, MoreThan, Repository } from 'typeorm';
import { Notification } from './entities/notification.entity';
import { PushToken } from './entities/push-token.entity';

const CHUNK = 100;

/** The only place that queries notifications and push_tokens. */
@Injectable()
export class NotificationsRepository {
  constructor(
    @InjectRepository(Notification) private readonly inbox: Repository<Notification>,
    @InjectRepository(PushToken) private readonly tokens: Repository<PushToken>,
  ) {}

  async insertMany(rows: Notification[]): Promise<void> {
    for (let i = 0; i < rows.length; i += CHUNK) await this.inbox.insert(rows.slice(i, i + CHUNK));
  }

  /** A person's inbox, newest first; `before` pages back through older messages. */
  page(
    staffId: string,
    opts: { unreadOnly: boolean; before?: Date; limit: number },
  ): Promise<Notification[]> {
    return this.inbox.find({
      where: {
        staffId,
        ...(opts.unreadOnly ? { readAt: IsNull() } : {}),
        ...(opts.before ? { createdAt: LessThan(opts.before) } : {}),
      },
      order: { createdAt: 'DESC' },
      take: opts.limit,
    });
  }

  unreadCount(staffId: string): Promise<number> {
    return this.inbox.count({ where: { staffId, readAt: IsNull() } });
  }

  /** Marks some (or all) of a person's unread messages read; only their own rows change. */
  async markRead(staffId: string, ids: readonly string[] | 'ALL', at: Date): Promise<number> {
    const where = { staffId, readAt: IsNull(), ...(ids === 'ALL' ? {} : { id: In([...ids]) }) };
    return (await this.inbox.update(where, { readAt: at })).affected ?? 0;
  }

  /** Messages created since `since` (the app's poll asks "anything new?"). */
  countSince(staffId: string, since: Date): Promise<number> {
    return this.inbox.count({ where: { staffId, createdAt: MoreThan(since) } });
  }

  findToken(token: string): Promise<PushToken | null> {
    return this.tokens.findOne({ where: { token } });
  }

  async insertToken(row: PushToken): Promise<void> {
    await this.tokens.insert(row);
  }

  async updateToken(token: string, changes: Partial<PushToken>): Promise<void> {
    await this.tokens.update({ token }, changes);
  }

  async deleteTokens(tokens: readonly string[], staffId?: string): Promise<void> {
    if (tokens.length === 0) return;
    await this.tokens.delete({ token: In([...tokens]), ...(staffId ? { staffId } : {}) });
  }

  async tokensOf(staffIds: readonly string[]): Promise<Map<string, string[]>> {
    const out = new Map<string, string[]>();
    for (let i = 0; i < staffIds.length; i += 1000) {
      const rows = await this.tokens.find({ where: { staffId: In(staffIds.slice(i, i + 1000)) } });
      rows.forEach((r) => out.set(r.staffId, [...(out.get(r.staffId) ?? []), r.token]));
    }
    return out;
  }
}
