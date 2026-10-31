import type { DbType, Env } from '../config/env.validation';

export interface DatabaseSettings {
  type: DbType;
  host: string;
  port: number;
  username: string;
  password: string;
  /** PostgreSQL database name. */
  database?: string;
  /** Oracle service name. */
  serviceName?: string;
  poolMax: number;
  slowQueryMs: number;
  ssl: boolean;
}

export function databaseSettingsFromEnv(env: Env): DatabaseSettings {
  return {
    type: env.DB_TYPE,
    host: env.DB_HOST,
    port: env.DB_PORT,
    username: env.DB_USERNAME,
    password: env.DB_PASSWORD,
    database: env.DB_NAME,
    serviceName: env.DB_SERVICE_NAME,
    poolMax: env.DB_POOL_MAX,
    slowQueryMs: env.DB_SLOW_QUERY_MS,
    ssl: env.DB_SSL,
  };
}
