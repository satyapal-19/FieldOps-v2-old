/**
 * Loads `.env.<NODE_ENV>` into process.env before anything else is imported.
 *
 * Import this first in every entry point (main.ts, data-source.ts, test setup).
 * Real environment variables always win over the file, so production can set
 * secrets in the service configuration and never ship a file.
 */
import { config } from 'dotenv';
import { existsSync } from 'node:fs';
import { resolve } from 'node:path';

// All times in the process are UTC; IST is applied only when formatting dates.
process.env.TZ = 'UTC';
// Oracle (node-oracledb) session time zone, so TIMESTAMP columns hold UTC.
process.env.ORA_SDTZ = process.env.ORA_SDTZ ?? 'UTC';

const nodeEnv = process.env.NODE_ENV ?? 'development';
process.env.NODE_ENV = nodeEnv;

const envFile = resolve(process.cwd(), `.env.${nodeEnv}`);
if (existsSync(envFile)) {
  config({ path: envFile });
}

export {};
