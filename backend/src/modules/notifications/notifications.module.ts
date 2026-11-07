import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { StaffModule } from '../staff/staff.module';
import { FcmChannel } from './channels/fcm.channel';
import { SmsChannel, WhatsAppChannel } from './channels/gateway.channel';
import { NOTIFICATION_CHANNELS } from './channels/notification-channel';
import { Notification } from './entities/notification.entity';
import { PushToken } from './entities/push-token.entity';
import { NotificationsController } from './notifications.controller';
import { NotificationsRepository } from './notifications.repository';
import { NotificationsService } from './notifications.service';

/** In-app inbox + push / SMS / WhatsApp. Other modules call NotificationsService.notify. */
@Module({
  imports: [TypeOrmModule.forFeature([Notification, PushToken]), StaffModule],
  controllers: [NotificationsController],
  providers: [
    NotificationsRepository,
    NotificationsService,
    FcmChannel,
    SmsChannel,
    WhatsAppChannel,
    {
      provide: NOTIFICATION_CHANNELS,
      useFactory: (fcm: FcmChannel, sms: SmsChannel, whatsapp: WhatsAppChannel) => [
        fcm,
        sms,
        whatsapp,
      ],
      inject: [FcmChannel, SmsChannel, WhatsAppChannel],
    },
  ],
  exports: [NotificationsService],
})
export class NotificationsModule {}
