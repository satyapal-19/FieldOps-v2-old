import createClient, { type Middleware } from 'openapi-fetch';
import type { components, paths } from './generated/schema';

export type ProblemDetails = components['schemas']['ProblemDetailsDto'];
export type Schemas = components['schemas'];

/** Must match CSRF_HEADER / CSRF_VALUE in src/server/api-proxy.ts. */
export const CSRF_HEADERS = { 'X-Requested-With': 'fieldops-web' } as const;

/** Every call carries a request ID (traceable in server logs) and the same-site header. */
const requestMiddleware: Middleware = {
  onRequest({ request }) {
    if (!request.headers.has('X-Request-Id')) {
      request.headers.set('X-Request-Id', crypto.randomUUID());
    }
    request.headers.set('X-Requested-With', CSRF_HEADERS['X-Requested-With']);
    return request;
  },
};

/** A 401 that survived the proxy's refresh means the session is over: back to sign-in. */
const sessionMiddleware: Middleware = {
  onResponse({ response }) {
    if (response.status === 401 && typeof window !== 'undefined') {
      const next = `${window.location.pathname}${window.location.search}`;
      window.location.assign(`/login?next=${encodeURIComponent(next)}`);
    }
    return response;
  },
};

/**
 * The one API client for client components, typed from the generated OpenAPI schema. It talks
 * to this app's /api/v1 pass-through (same origin), which adds the session from httpOnly
 * cookies. Pages never call fetch directly.
 */
export const api = createClient<paths>({ baseUrl: '', credentials: 'same-origin' });
api.use(requestMiddleware, sessionMiddleware);

/** Typed error carrying the server's problem+json body. */
export class ApiError extends Error {
  constructor(public readonly problem: ProblemDetails) {
    super(problem.title);
    this.name = 'ApiError';
  }
}

export function toApiError(error: unknown, status = 500, requestId?: string | null): ApiError {
  if (error && typeof error === 'object' && 'code' in error && 'title' in error) {
    return new ApiError(error as ProblemDetails);
  }
  return new ApiError({
    type: 'urn:fieldops:error:INTERNAL_ERROR',
    code: status === 503 ? 'SERVICE_UNAVAILABLE' : 'INTERNAL_ERROR',
    title: 'Could not reach the FieldOps API',
    status,
    requestId: requestId ?? '',
  });
}

/** Awaits an openapi-fetch call and returns its data, or throws an ApiError. */
export async function unwrap<T>(
  call: Promise<{ data?: T; error?: unknown; response: Response }>,
): Promise<T> {
  const { data, error, response } = await call;
  if (!response.ok || error !== undefined) {
    throw toApiError(error, response.status, response.headers.get('X-Request-Id'));
  }
  return data as T;
}
