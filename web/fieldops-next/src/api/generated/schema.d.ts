/**
 * GENERATED FILE - do not edit by hand.
 * Regenerate after any API change:  npm run api:types   (reads ../../openapi/openapi.json)
 *
 * This initial copy covers the health endpoints so the app compiles before the first
 * export; the first `npm run api:types` replaces it with the full contract.
 */

export interface paths {
  '/api/v1/health': {
    parameters: { query?: never; header?: never; path?: never; cookie?: never };
    get: operations['HealthController_health'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
  '/api/v1/ready': {
    parameters: { query?: never; header?: never; path?: never; cookie?: never };
    get: operations['HealthController_ready'];
    put?: never;
    post?: never;
    delete?: never;
    options?: never;
    head?: never;
    patch?: never;
    trace?: never;
  };
}

export type webhooks = Record<string, never>;

export interface components {
  schemas: {
    HealthDto: {
      status: string;
      environment: string;
      version: string;
      uptimeSeconds: number;
      time: string;
    };
    ReadyDto: {
      status: string;
      database: string;
      pendingMigrations: boolean;
    };
    ProblemDetailsDto: {
      type: string;
      code: string;
      title: string;
      status: number;
      requestId: string;
      details?: { [key: string]: unknown };
    };
  };
  responses: never;
  parameters: never;
  requestBodies: never;
  headers: never;
  pathItems: never;
}

export type $defs = Record<string, never>;

export interface operations {
  HealthController_health: {
    parameters: { query?: never; header?: never; path?: never; cookie?: never };
    requestBody?: never;
    responses: {
      200: {
        headers: { [name: string]: unknown };
        content: { 'application/json': components['schemas']['HealthDto'] };
      };
    };
  };
  HealthController_ready: {
    parameters: { query?: never; header?: never; path?: never; cookie?: never };
    requestBody?: never;
    responses: {
      200: {
        headers: { [name: string]: unknown };
        content: { 'application/json': components['schemas']['ReadyDto'] };
      };
      503: {
        headers: { [name: string]: unknown };
        content: { 'application/json': components['schemas']['ProblemDetailsDto'] };
      };
    };
  };
}
