import './shared/config/load-env';
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { Logger } from 'nestjs-pino';
import { AppModule } from './app.module';
import { API_PREFIX, configureApp } from './app.setup';
import { AppConfig } from './shared/config/app-config';

async function bootstrap(): Promise<void> {
  const app = await NestFactory.create(AppModule, { bufferLogs: true });
  configureApp(app);

  const config = app.get(AppConfig);
  await app.listen(config.port);

  const logger = app.get(Logger);
  logger.log(
    `FieldOps API (${config.nodeEnv}) on http://localhost:${config.port}/${API_PREFIX}` +
      (config.swaggerEnabled ? ` - docs at /api/docs` : ''),
  );
  if (config.testLoginEnabled) {
    logger.warn('Test login is ENABLED (development/test only).');
  }
}

bootstrap().catch((error: unknown) => {
  // Logger may not exist yet (e.g. invalid configuration), so write to stderr directly.
  process.stderr.write(`FieldOps API failed to start:\n${error instanceof Error ? error.message : String(error)}\n`);
  process.exit(1);
});
