import { Module } from '@nestjs/common';
import { LoggerModule } from 'nestjs-pino';
import { AppConfig } from '../config/app-config';
import { resolveRequestId } from './request-id';

/**
 * Structured JSON logs (pino). Every line carries the request ID. Pretty output in
 * development; plain JSON elsewhere so PM2 / log tools can index it.
 * Never log OTPs, tokens, face data or passwords.
 */
@Module({
  imports: [
    LoggerModule.forRootAsync({
      inject: [AppConfig],
      useFactory: (config: AppConfig) => ({
        pinoHttp: {
          level: config.logLevel,
          genReqId: resolveRequestId,
          customProps: () => ({ env: config.nodeEnv }),
          redact: {
            paths: [
              'req.headers.authorization',
              'req.headers.cookie',
              'res.headers["set-cookie"]',
              'req.body.otp',
              'req.body.password',
              'req.body.faceEmbedding',
            ],
            censor: '[redacted]',
          },
          autoLogging: {
            ignore: (req) => (req.url ?? '').startsWith('/api/v1/health'),
          },
          transport: config.isDevelopment
            ? { target: 'pino-pretty', options: { singleLine: true, translateTime: 'SYS:standard' } }
            : undefined,
        },
      }),
    }),
  ],
})
export class LoggingModule {}
