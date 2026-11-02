import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { DatabaseSettings } from '../database/database-settings';
import type { Env, FaceProvider, LogLevel, NodeEnv, OtpSenderKind } from './env.validation';

/** Typed access to validated configuration. Inject this, never read process.env directly. */
@Injectable()
export class AppConfig {
  constructor(private readonly config: ConfigService<Env, true>) {}

  get nodeEnv(): NodeEnv {
    return this.config.get('NODE_ENV', { infer: true });
  }

  get isProduction(): boolean {
    return this.nodeEnv === 'production';
  }

  get isDevelopment(): boolean {
    return this.nodeEnv === 'development';
  }

  get isTest(): boolean {
    return this.nodeEnv === 'test';
  }

  get port(): number {
    return this.config.get('PORT', { infer: true });
  }

  get logLevel(): LogLevel {
    return this.config.get('LOG_LEVEL', { infer: true });
  }

  get corsOrigins(): string[] {
    return this.config
      .get('CORS_ORIGINS', { infer: true })
      .split(',')
      .map((o) => o.trim())
      .filter((o) => o.length > 0);
  }

  get swaggerEnabled(): boolean {
    return this.config.get('SWAGGER_ENABLED', { infer: true });
  }

  get testLoginEnabled(): boolean {
    return this.config.get('AUTH_TEST_LOGIN_ENABLED', { infer: true });
  }

  get jobs(): { enabled: boolean; pingRetentionDays: number } {
    return {
      enabled: this.config.get('JOBS_ENABLED', { infer: true }),
      pingRetentionDays: this.config.get('PING_RETENTION_DAYS', { infer: true }),
    };
  }

  /** Development / test only: password the sample seed sets for web sign-in roles. */
  get seedWebPassword(): string | undefined {
    return this.config.get('SEED_WEB_PASSWORD', { infer: true }) || undefined;
  }

  get auth(): {
    accessSecret: string;
    refreshSecret: string;
    accessTtlSeconds: number;
    refreshTtlDays: number;
    maxSessionsPerStaff: number;
    otpSender: OtpSenderKind;
    otpTtlSeconds: number;
    otpMaxAttempts: number;
    otpMaxPerWindow: number;
    sms: {
      urlTemplate: string;
      method: 'GET' | 'POST';
      messageTemplate: string;
      senderId: string;
      templateId: string;
      timeoutMs: number;
    };
  } {
    const c = this.config;
    return {
      accessSecret: c.get('JWT_ACCESS_SECRET', { infer: true }),
      refreshSecret: c.get('JWT_REFRESH_SECRET', { infer: true }),
      accessTtlSeconds: c.get('JWT_ACCESS_TTL_SECONDS', { infer: true }),
      refreshTtlDays: c.get('AUTH_REFRESH_TTL_DAYS', { infer: true }),
      maxSessionsPerStaff: c.get('AUTH_MAX_SESSIONS_PER_STAFF', { infer: true }),
      otpSender: c.get('OTP_SENDER', { infer: true }),
      otpTtlSeconds: c.get('OTP_TTL_SECONDS', { infer: true }),
      otpMaxAttempts: c.get('OTP_MAX_ATTEMPTS', { infer: true }),
      otpMaxPerWindow: c.get('OTP_MAX_PER_15_MIN', { infer: true }),
      sms: {
        urlTemplate: c.get('SMS_GATEWAY_URL', { infer: true }) ?? '',
        method: c.get('SMS_GATEWAY_METHOD', { infer: true }),
        messageTemplate: c.get('SMS_OTP_MESSAGE', { infer: true }),
        senderId: c.get('SMS_SENDER_ID', { infer: true }),
        templateId: c.get('SMS_DLT_TEMPLATE_ID', { infer: true }),
        timeoutMs: c.get('SMS_TIMEOUT_MS', { infer: true }),
      },
    };
  }

  get rateLimits(): { perMinute: number; signInPerMinute: number } {
    return {
      perMinute: this.config.get('RATE_LIMIT_PER_MINUTE', { infer: true }),
      signInPerMinute: this.config.get('SIGN_IN_RATE_LIMIT_PER_MINUTE', { infer: true }),
    };
  }

  /** Express 'trust proxy' value: false, true or a hop count. */
  get trustProxy(): boolean | number {
    const raw = this.config.get('TRUST_PROXY', { infer: true });
    if (raw === 'true') return true;
    if (raw === 'false') return false;
    return Number(raw);
  }

  get faceProvider(): FaceProvider {
    return this.config.get('FACE_PROVIDER', { infer: true });
  }

  get localFace(): { matchThreshold: number; livenessThreshold: number } {
    return {
      matchThreshold: this.config.get('FACE_MATCH_THRESHOLD', { infer: true }),
      livenessThreshold: this.config.get('FACE_LIVENESS_THRESHOLD', { infer: true }),
    };
  }

  /** Aadhaar settings; values are validated as present when FACE_PROVIDER=aadhaar. */
  get aadhaar(): {
    env: string;
    apiVersion: string;
    pidVersion: string;
    language: string;
    auaCode: string;
    subAuaCode: string;
    licenseKey: string;
    asaLicenseKey: string;
    asaUrlTemplate: string;
    signingKeyPath: string;
    signingCertPath: string;
    udc?: string;
    timeoutMs: number;
  } {
    const get = (key: keyof Env): string => String(this.config.get(key, { infer: true }) ?? '');
    return {
      env: get('AADHAAR_ENV'),
      apiVersion: get('AADHAAR_API_VERSION'),
      pidVersion: get('AADHAAR_PID_VERSION'),
      language: get('AADHAAR_LANGUAGE'),
      auaCode: get('AADHAAR_AUA_CODE'),
      subAuaCode: get('AADHAAR_SUB_AUA_CODE'),
      licenseKey: get('AADHAAR_LICENSE_KEY'),
      asaLicenseKey: get('AADHAAR_ASA_LICENSE_KEY'),
      asaUrlTemplate: get('AADHAAR_ASA_URL_TEMPLATE'),
      signingKeyPath: get('AADHAAR_SIGNING_KEY_PATH'),
      signingCertPath: get('AADHAAR_SIGNING_CERT_PATH'),
      udc: this.config.get('AADHAAR_DEVICE_UDC', { infer: true }),
      timeoutMs: this.config.get('AADHAAR_TIMEOUT_MS', { infer: true }),
    };
  }

  get database(): DatabaseSettings {
    return {
      type: this.config.get('DB_TYPE', { infer: true }),
      host: this.config.get('DB_HOST', { infer: true }),
      port: this.config.get('DB_PORT', { infer: true }),
      username: this.config.get('DB_USERNAME', { infer: true }),
      password: this.config.get('DB_PASSWORD', { infer: true }),
      database: this.config.get('DB_NAME', { infer: true }),
      serviceName: this.config.get('DB_SERVICE_NAME', { infer: true }),
      poolMax: this.config.get('DB_POOL_MAX', { infer: true }),
      slowQueryMs: this.config.get('DB_SLOW_QUERY_MS', { infer: true }),
      ssl: this.config.get('DB_SSL', { infer: true }),
    };
  }
}
