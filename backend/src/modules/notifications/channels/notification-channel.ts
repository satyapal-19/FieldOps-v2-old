import type { Channel, OutgoingMessage } from '../notifications.policy';

export interface Recipient {
  staffId: string;
  /** 10-digit mobile number (SMS / WhatsApp). */
  phone: string;
  /** FCM registration tokens of the person's signed-in phones. */
  pushTokens: string[];
}

export interface DeliveryResult {
  /** Push tokens the provider says are gone (app uninstalled): the service deletes them. */
  invalidTokens?: string[];
}

/**
 * One way to reach a phone besides the in-app inbox. Each implementation is off unless its
 * settings are present, so a fresh SMKC install works with the inbox alone.
 */
export abstract class NotificationChannel {
  abstract readonly channel: Channel;
  abstract readonly enabled: boolean;
  abstract send(
    to: Recipient,
    notificationId: string,
    message: OutgoingMessage,
  ): Promise<DeliveryResult>;
}

/** Injection token for the list of channels. */
export const NOTIFICATION_CHANNELS = Symbol('NOTIFICATION_CHANNELS');
