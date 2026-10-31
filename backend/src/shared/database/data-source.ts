/**
 * Data source for the TypeORM CLI (migrations). Run after `npm run build`:
 *   npx cross-env NODE_ENV=test npm run migration:run
 */
import '../config/load-env';
import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { validateEnv } from '../config/env.validation';
import { buildDataSourceOptions } from './data-source-options';
import { databaseSettingsFromEnv } from './database-settings';

const env = validateEnv(process.env);

export default new DataSource(buildDataSourceOptions(databaseSettingsFromEnv(env)));
