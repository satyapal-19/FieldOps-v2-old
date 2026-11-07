import { Injectable, Logger } from '@nestjs/common';
import { createSign } from 'node:crypto';
import { AppConfig } from '../../../shared/config/app-config';
import { pushData, type OutgoingMessage } from '../notifications.policy';
import { NotificationChannel, type DeliveryResult, type Recipient } from './notification-channel';

const TOKEN_URL = 'https://oauth2.googleapis.com/token';
const SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';

const b64url = (v: string | Buffer) => Buffer.from(v).toString('base64url');

/**
 * Firebase Cloud Messaging (HTTP v1) with a service account: signs its own OAuth token (RS256,
 * Node crypto) and sends data-only messages: ids and kinds, never names, places or photos.
 * Off unless FCM_PROJECT_ID / FCM_CLIENT_EMAIL / FCM_PRIVATE_KEY are set.
 */
@Injectable()
export class FcmChannel extends NotificationChannel {
  readonly channel = 'PUSH' as const;
  private readonly logger = new Logger(FcmChannel.name);
  private access: { token: string; expiresAt: number } | null = null;

  constructor(private readonly config: AppConfig) {
    super();
  }

  get enabled(): boolean {
    return this.config.notifications.fcm !== null;
  }

  async send(
    to: Recipient,
    notificationId: string,
    message: OutgoingMessage,
  ): Promise<DeliveryResult> {
    const fcm = this.config.notifications.fcm;
    if (!fcm || to.pushTokens.length === 0) return {};
    const bearer = await this.accessToken(fcm);
    const invalid: string[] = [];
    for (const token of to.pushTokens) {
      const res = await fetch(
        `https://fcm.googleapis.com/v1/projects/${fcm.projectId}/messages:send`,
        {
          method: 'POST',
          headers: { authorization: `Bearer ${bearer}`, 'content-type': 'application/json' },
          body: JSON.stringify({
            message: {
              token,
              data: pushData(notificationId, message),
              android: { priority: message.priority === 'HIGH' ? 'HIGH' : 'NORMAL', ttl: '600s' },
            },
          }),
        },
      );
      if (res.status === 404 || res.status === 400) {
        const text = await res.text();
        if (text.includes('UNREGISTERED') || text.includes('INVALID_ARGUMENT')) invalid.push(token);
        else this.logger.warn(`FCM refused a message (${res.status})`);
      } else if (!res.ok) {
        this.logger.warn(`FCM send failed (${res.status})`);
      }
    }
    return { invalidTokens: invalid };
  }

  /** A cached OAuth access token for the service account (valid one hour; renewed early). */
  private async accessToken(fcm: { clientEmail: string; privateKey: string }): Promise<string> {
    const now = Math.floor(Date.now() / 1000);
    if (this.access && this.access.expiresAt - 300 > now) return this.access.token;
    const header = b64url(JSON.stringify({ alg: 'RS256', typ: 'JWT' }));
    const claims = b64url(
      JSON.stringify({
        iss: fcm.clientEmail,
        scope: SCOPE,
        aud: TOKEN_URL,
        iat: now,
        exp: now + 3600,
      }),
    );
    const signature = createSign('RSA-SHA256').update(`${header}.${claims}`).sign(fcm.privateKey);
    const res = await fetch(TOKEN_URL, {
      method: 'POST',
      headers: { 'content-type': 'application/x-www-form-urlencoded' },
      body: new URLSearchParams({
        grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        assertion: `${header}.${claims}.${b64url(signature)}`,
      }),
    });
    if (!res.ok) throw new Error(`FCM OAuth token request failed (${res.status})`);
    const body = (await res.json()) as { access_token: string; expires_in: number };
    this.access = { token: body.access_token, expiresAt: now + body.expires_in };
    return body.access_token;
  }
}
