import { Inject, Injectable, Logger } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { StaffService } from '../staff/staff.service';
import { NOTIFICATION_CHANNELS, NotificationChannel } from './channels/notification-channel';
import type {
  InboxDto,
  InboxQueryDto,
  MarkReadDto,
  MarkedDto,
  NotificationDto,
  PushTokenDto,
} from './dto/notification.dto';
import type { Notification } from './entities/notification.entity';
import { channelsFor, type Channel, type OutgoingMessage } from './notifications.policy';
import { NotificationsRepository } from './notifications.repository';

const iso = (d: Date | null) => (d ? d.toISOString() : null);

function toDto(n: Notification): NotificationDto {
  return {
    id: n.id,
    kind: n.kind,
    priority: n.priority,
    title: n.title,
    titleMr: n.titleMr,
    body: n.body,
    bodyMr: n.bodyMr,
    refType: n.refType,
    refId: n.refId,
    createdAt: n.createdAt.toISOString(),
    readAt: iso(n.readAt),
  };
}

/**
 * One notification interface (action plan Phase 4): every message lands in the person's inbox
 * (which the app polls, so nothing depends on push), then goes out on whichever channels are
 * configured: FCM push, and for HIGH priority SMS / WhatsApp through SMKC's gateway. Sending
 * never fails the caller: a channel error is logged and the inbox still has the message.
 */
@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly repo: NotificationsRepository,
    private readonly staff: StaffService,
    @Inject(NOTIFICATION_CHANNELS) private readonly channels: NotificationChannel[],
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  /** Puts the message in each person's inbox and sends it on the configured channels. */
  async notify(staffIds: readonly string[], message: OutgoingMessage): Promise<void> {
    const people = [...new Set(staffIds)];
    if (people.length === 0) return;
    const now = this.clock.now();
    const rows: Notification[] = people.map((staffId) => ({
      id: this.ids.next(),
      staffId,
      kind: message.kind,
      priority: message.priority,
      title: message.title.slice(0, 150),
      titleMr: message.titleMr?.slice(0, 150) ?? null,
      body: message.body?.slice(0, 500) ?? null,
      bodyMr: message.bodyMr?.slice(0, 500) ?? null,
      refType: message.refType ?? null,
      refId: message.refId ?? null,
      createdAt: now,
      readAt: null,
    }));
    await this.repo.insertMany(rows);

    try {
      const enabled = new Set<Channel>(
        this.channels.filter((c) => c.enabled).map((c) => c.channel),
      );
      const use = channelsFor(message.priority, enabled);
      if (use.length === 0) return;
      const staff = new Map((await this.staff.findByIds(people)).map((s) => [s.id, s]));
      const tokens = use.includes('PUSH')
        ? await this.repo.tokensOf(people)
        : new Map<string, string[]>();
      for (const row of rows) {
        const person = staff.get(row.staffId);
        if (!person) continue;
        const to = {
          staffId: person.id,
          phone: person.phone,
          pushTokens: tokens.get(person.id) ?? [],
        };
        for (const channel of this.channels.filter((c) => use.includes(c.channel))) {
          try {
            const result = await channel.send(to, row.id, message);
            if (result.invalidTokens?.length) await this.repo.deleteTokens(result.invalidTokens);
          } catch (error) {
            this.logger.warn(
              { err: error, channel: channel.channel },
              'Notification channel failed',
            );
          }
        }
      }
    } catch (error) {
      this.logger.error({ err: error }, 'Could not send notifications (inbox kept them)');
    }
  }

  async inbox(actor: AuthUser, q: InboxQueryDto): Promise<InboxDto> {
    const [items, unreadCount] = await Promise.all([
      this.repo.page(actor.staffId, {
        unreadOnly: q.unreadOnly ?? false,
        before: q.before ? new Date(q.before) : undefined,
        limit: q.limit,
      }),
      this.repo.unreadCount(actor.staffId),
    ]);
    return { items: items.map(toDto), unreadCount };
  }

  async markRead(actor: AuthUser, dto: MarkReadDto): Promise<MarkedDto> {
    if (!dto.all && !dto.ids?.length) {
      throw new AppError(ErrorCode.VALIDATION_FAILED, 'Give ids, or all=true', { field: 'ids' });
    }
    return {
      marked: await this.repo.markRead(actor.staffId, dto.all ? 'ALL' : dto.ids!, this.clock.now()),
    };
  }

  /** Registers this phone for push. A token signed in by someone else now belongs to the caller. */
  async registerToken(actor: AuthUser, dto: PushTokenDto): Promise<void> {
    const now = this.clock.now();
    const existing = await this.repo.findToken(dto.token);
    if (existing) {
      await this.repo.updateToken(dto.token, {
        staffId: actor.staffId,
        platform: dto.platform,
        lastSeenAt: now,
      });
      return;
    }
    try {
      await this.repo.insertToken({
        id: this.ids.next(),
        staffId: actor.staffId,
        token: dto.token,
        platform: dto.platform,
        createdAt: now,
        lastSeenAt: now,
      });
    } catch (error) {
      if (!isUniqueViolation(error)) throw error;
      await this.repo.updateToken(dto.token, {
        staffId: actor.staffId,
        platform: dto.platform,
        lastSeenAt: now,
      });
    }
  }

  /** On sign-out: this phone stops receiving the caller's pushes. */
  async removeToken(actor: AuthUser, token: string): Promise<void> {
    await this.repo.deleteTokens([token], actor.staffId);
  }
}
