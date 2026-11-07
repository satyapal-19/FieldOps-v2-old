import { Injectable, Module } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Clock } from '../../shared/clock/clock';
import { istDate, IST_TIME_ZONE } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { JobRunner } from '../../shared/jobs/job-runner';
import { NotificationsModule } from '../notifications/notifications.module';
import { RostersModule } from '../rosters/rosters.module';
import { StaffModule } from '../staff/staff.module';
import { UploadsModule } from '../uploads/uploads.module';
import { ChatController } from './chat.controller';
import { ChatRepository } from './chat.repository';
import { ChatService } from './chat.service';
import { ConversationParticipant } from './entities/conversation-participant.entity';
import { Conversation } from './entities/conversation.entity';
import { Message } from './entities/message.entity';

/** Archives yesterday's squad chats just after midnight IST (retried at 00:45), once across instances. */
@Injectable()
export class ChatScheduler {
  constructor(
    private readonly chat: ChatService,
    private readonly runner: JobRunner,
    private readonly config: AppConfig,
    private readonly clock: Clock,
  ) {}

  @Cron('0 15,45 0 * * *', { name: 'chat-archive', timeZone: IST_TIME_ZONE })
  async archive(): Promise<void> {
    if (!this.config.jobs.enabled) return;
    try {
      await this.runner.run('chat-archive', istDate(this.clock.now()), 30, () =>
        this.chat.archiveOldSquads(),
      );
    } catch {
      // JobRunner logged it and recorded FAILED; the next firing retries.
    }
  }
}

/** Hierarchy-based chat: squad, ward and city channels, direct messages, voice notes. */
@Module({
  imports: [
    TypeOrmModule.forFeature([Conversation, ConversationParticipant, Message]),
    StaffModule,
    RostersModule,
    UploadsModule,
    NotificationsModule,
  ],
  controllers: [ChatController],
  providers: [ChatRepository, ChatService, ChatScheduler],
})
export class ChatModule {}
