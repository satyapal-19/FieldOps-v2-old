import { Injectable, Logger } from '@nestjs/common';
import { AppConfig } from '../../../shared/config/app-config';
import { smsText, type Channel, type OutgoingMessage } from '../notifications.policy';
import { NotificationChannel, type DeliveryResult, type Recipient } from './notification-channel';

/**
 * SMS or WhatsApp through SMKC's own gateway: a JSON POST {to, text, channel}, with an optional
 * bearer token. No provider is approved yet (working assumption), so both stay off until
 * NOTIFY_SMS_URL / NOTIFY_WHATSAPP_URL are set: a configuration change, not a code change.
 */
abstract class GatewayChannel extends NotificationChannel {
  private readonly logger = new Logger(`${this.constructor.name}`);

  constructor(protected readonly config: AppConfig) {
    super();
  }

  protected abstract url(): string | null;

  get enabled(): boolean {
    return this.url() !== null;
  }

  async send(to: Recipient, _id: string, message: OutgoingMessage): Promise<DeliveryResult> {
    const url = this.url();
    if (!url) return {};
    const token = this.config.notifications.gatewayToken;
    const res = await fetch(url, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        ...(token ? { authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify({ to: `+91${to.phone}`, text: smsText(message), channel: this.channel }),
    });
    if (!res.ok) this.logger.warn(`${this.channel} gateway answered ${res.status}`);
    return {};
  }
}

@Injectable()
export class SmsChannel extends GatewayChannel {
  // Own constructor: Nest reads injection metadata from the concrete class.
  constructor(config: AppConfig) {
    super(config);
  }

  readonly channel: Channel = 'SMS';
  protected url() {
    return this.config.notifications.smsUrl;
  }
}

@Injectable()
export class WhatsAppChannel extends GatewayChannel {
  // Own constructor: Nest reads injection metadata from the concrete class.
  constructor(config: AppConfig) {
    super(config);
  }

  readonly channel: Channel = 'WHATSAPP';
  protected url() {
    return this.config.notifications.whatsappUrl;
  }
}
