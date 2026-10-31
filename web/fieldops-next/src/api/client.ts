import createClient, { type Middleware } from 'openapi-fetch';
import type { components, paths } from './generated/schema';

export type ProblemDetails = components['schemas']['ProblemDetailsDto'];

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL ?? 'http://localhost:3000';

/** Every call carries a request ID, so a failure can be traced in the server logs. */
const requestIdMiddleware: Middleware = {
  onRequest({ request }) {
    if (!request.headers.has('X-Request-Id')) {
      request.headers.set('X-Request-Id', crypto.randomUUID());
    }
    return request;
  },
};

/**
 * The one API client, typed from the generated OpenAPI schema.
 * Phase 3 adds token refresh here; pages never call fetch directly.
 */
export const api = createClient<paths>({ baseUrl: API_BASE_URL, credentials: 'include' });
api.use(requestIdMiddleware);

/** Typed error carrying the server's problem+json body. */
export class ApiError extends Error {
  constructor(public readonly problem: ProblemDetails) {
    super(problem.title);
    this.name = 'ApiError';
  }
}

export function toApiError(error: unknown, fallbackStatus = 500): ApiError {
  if (error && typeof error === 'object' && 'code' in error && 'title' in error) {
    return new ApiError(error as ProblemDetails);
  }
  return new ApiError({
    type: 'urn:fieldops:error:INTERNAL_ERROR',
    code: 'INTERNAL_ERROR',
    title: 'Could not reach the FieldOps API',
    status: fallbackStatus,
    requestId: '',
  });
}
