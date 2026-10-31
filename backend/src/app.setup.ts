import { INestApplication, ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import helmet from 'helmet';
import { Logger } from 'nestjs-pino';
import { APP_VERSION } from './app-version';
import { AppConfig } from './shared/config/app-config';
import { ProblemDetailsFilter } from './shared/errors/problem-details.filter';

export const API_PREFIX = 'api/v1';

/**
 * Applies the same pipeline everywhere the app runs (server, e2e tests, OpenAPI export),
 * so tests exercise exactly what production serves.
 */
export function configureApp(app: INestApplication): void {
  const config = app.get(AppConfig);

  app.useLogger(app.get(Logger));
  // Behind IIS / a reverse proxy, trust its X-Forwarded-For so audit rows and rate limits see real IPs.
  (app.getHttpAdapter().getInstance() as { set(key: string, value: unknown): void }).set(
    'trust proxy',
    config.trustProxy,
  );
  app.setGlobalPrefix(API_PREFIX);
  app.use(helmet({ contentSecurityPolicy: false }));
  app.enableCors({
    origin: config.corsOrigins,
    credentials: true,
    exposedHeaders: ['X-Request-Id'],
  });
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  app.useGlobalFilters(new ProblemDetailsFilter());
  app.enableShutdownHooks();

  if (config.swaggerEnabled) {
    SwaggerModule.setup('api/docs', app, buildOpenApiDocument(app));
  }
}

export function buildOpenApiDocument(app: INestApplication): OpenAPIObject {
  const options = new DocumentBuilder()
    .setTitle('FieldOps SMKMC API')
    .setDescription(
      'REST API for geo-tagged attendance and field presence. Errors are application/problem+json with a stable `code`.',
    )
    .setVersion(APP_VERSION)
    .addBearerAuth()
    .build();
  return SwaggerModule.createDocument(app, options);
}
