/**
 * Loads the sample data into the database of NODE_ENV (development or test). Run after
 * migrations:  npm run db:seed:dev   (or db:seed:test)
 */
import '../../shared/config/load-env';
import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../../app.module';
import { AlreadySeededError, seedSampleData } from './sample-data';

async function run(): Promise<void> {
  const app = await NestFactory.createApplicationContext(AppModule, { logger: ['error', 'warn'] });
  try {
    const summary = await seedSampleData(app);
    process.stdout.write(`Sample data loaded:\n${JSON.stringify(summary, null, 2)}\n`);
    process.stdout.write(
      'Sign in with POST /api/v1/auth/test-login {"identifier": "<employee code>"}\n',
    );
  } finally {
    await app.close();
  }
}

run().catch((error: unknown) => {
  if (error instanceof AlreadySeededError) {
    process.stdout.write(`${error.message}\n`);
    process.exit(0);
  }
  process.stderr.write(`Seed failed: ${error instanceof Error ? error.stack : String(error)}\n`);
  process.exit(1);
});
