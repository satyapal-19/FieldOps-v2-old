/**
 * Writes the OpenAPI contract to <repo>/openapi/openapi.json.
 * The web (TypeScript) and mobile (Dart) clients are generated from this file.
 * Needs a reachable database (it boots the real app). Run after `npm run build`:
 *   npm run openapi:export
 */
import '../shared/config/load-env';
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { mkdirSync, writeFileSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { AppModule } from '../app.module';
import { buildOpenApiDocument, configureApp } from '../app.setup';

async function exportOpenApi(): Promise<void> {
  const app = await NestFactory.create(AppModule, { logger: ['error', 'warn'], bufferLogs: true });
  configureApp(app);
  await app.init();

  const document = buildOpenApiDocument(app);
  const outDir = resolve(process.cwd(), '..', 'openapi');
  mkdirSync(outDir, { recursive: true });
  const outFile = join(outDir, 'openapi.json');
  writeFileSync(outFile, `${JSON.stringify(document, null, 2)}\n`, 'utf8');
  await app.close();
  process.stdout.write(`OpenAPI contract written to ${outFile}\n`);
}

exportOpenApi().catch((error: unknown) => {
  process.stderr.write(`OpenAPI export failed: ${error instanceof Error ? error.stack : String(error)}\n`);
  process.exit(1);
});
