import { Logger } from '@nestjs/common';
import { AppError } from '../../../shared/errors/app-error';
import { ErrorCode } from '../../../shared/errors/error-codes';
import { maskPhone } from '../../staff/staff.policy';

export interface OtpMessage {
  phone: string;
  code: string;
  validMinutes: number;
}

/**
 * Delivers sign-in codes. Chosen by OTP_SENDER:
 * - log: writes the code to the server log (development / test only; refused in production)
 * - sms_http: calls SMKC's SMS gateway (URL template in SMS_GATEWAY_URL)
 * - disabled: OTP sign-in is off; web users sign in with a password
 */
export abstract class OtpSender {
  abstract readonly name: string;
  abstract send(message: OtpMessage): Promise<void>;
}

export class LogOtpSender extends OtpSender {
  readonly name = 'log';
  private readonly logger = new Logger('OtpSender');

  async send({ phone, code, validMinutes }: OtpMessage): Promise<void> {
    // Development / test only: config validation refuses OTP_SENDER=log in production.
    this.logger.warn(`DEV OTP for ${maskPhone(phone)}: ${code} (valid ${validMinutes} min)`);
  }
}

export class DisabledOtpSender extends OtpSender {
  readonly name = 'disabled';

  async send(): Promise<void> {
    throw new AppError(ErrorCode.AUTH_OTP_DELIVERY_UNAVAILABLE);
  }
}

export interface SmsGatewaySettings {
  urlTemplate: string;
  method: 'GET' | 'POST';
  messageTemplate: string;
  senderId: string;
  templateId: string;
  timeoutMs: number;
}

/** Fills {phone} {message} {senderId} {templateId} (URL-encoded) in a gateway URL template. */
export function buildSmsUrl(settings: SmsGatewaySettings, phone: string, message: string): string {
  const values: Record<string, string> = {
    phone: `91${phone}`,
    message,
    senderId: settings.senderId,
    templateId: settings.templateId,
  };
  return settings.urlTemplate.replace(/\{(phone|message|senderId|templateId)\}/g, (_m, key: string) =>
    encodeURIComponent(values[key] ?? ''),
  );
}

export function buildOtpText(template: string, code: string, validMinutes: number): string {
  return template.replace('{otp}', code).replace('{minutes}', String(validMinutes));
}

/**
 * Generic HTTP SMS gateway (NIC, MSG91 and most Indian DLT gateways take a URL with
 * query parameters). The message text must match SMKC's DLT-registered template.
 */
export class HttpSmsOtpSender extends OtpSender {
  readonly name = 'sms_http';
  private readonly logger = new Logger('OtpSender');

  constructor(private readonly settings: SmsGatewaySettings) {
    super();
  }

  async send({ phone, code, validMinutes }: OtpMessage): Promise<void> {
    const text = buildOtpText(this.settings.messageTemplate, code, validMinutes);
    const url = buildSmsUrl(this.settings, phone, text);
    try {
      const res = await fetch(url, {
        method: this.settings.method,
        signal: AbortSignal.timeout(this.settings.timeoutMs),
      });
      if (!res.ok) throw new Error(`gateway answered ${res.status}`);
    } catch (error) {
      // Never log the URL: it contains the code.
      this.logger.error(`SMS to ${maskPhone(phone)} failed: ${(error as Error).message}`);
      throw new AppError(ErrorCode.AUTH_OTP_DELIVERY_UNAVAILABLE);
    }
  }
}
