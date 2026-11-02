import 'server-only';
import { NextResponse, type NextRequest } from 'next/server';
import { ACCESS_COOKIE, REFRESH_COOKIE } from '@/shared/auth/session-cookies';
import { serverConfig } from './config';
import {
  clearSessionCookies,
  forwardHeaders,
  refreshSession,
  secondsLeft,
  setSessionCookies,
  type SessionTokens,
} from './session';

/** Refresh a little before the access token runs out, so most calls never see a 401. */
const REFRESH_AHEAD_SECONDS = 60;
/** Header every browser write must carry: a cross-site form cannot set it. */
export const CSRF_HEADER = 'x-requested-with';
export const CSRF_VALUE = 'fieldops-web';

const SAFE_METHODS = new Set(['GET', 'HEAD', 'OPTIONS']);

/** A problem+json answer produced by this layer (same shape as the API's). */
export function problem(status: number, code: string, title: string, requestId: string): NextResponse {
  return NextResponse.json(
    { type: `urn:fieldops:error:${code}`, code, title, status, requestId },
    { status, headers: { 'content-type': 'application/problem+json', 'x-request-id': requestId } },
  );
}

/**
 * A write must come from this site: the custom header, and an Origin (when sent) whose host is
 * the one the browser asked for (behind IIS that is X-Forwarded-Host, not this server's own).
 */
export function sameSiteWrite(req: NextRequest): boolean {
  if (SAFE_METHODS.has(req.method)) return true;
  if (req.headers.get(CSRF_HEADER) !== CSRF_VALUE) return false;
  const origin = req.headers.get('origin');
  if (!origin) return true;
  const host = req.headers.get('x-forwarded-host') ?? req.headers.get('host');
  try {
    return new URL(origin).host === host;
  } catch {
    return false;
  }
}

/**
 * Forwards /api/v1/<path> to the NestJS API with the bearer token from the session cookie,
 * refreshing it when it is about to expire or the API answers 401. Only the API decides
 * access; this layer only carries the session.
 */
export async function proxyToApi(req: NextRequest, path: string[]): Promise<NextResponse> {
  const headers = forwardHeaders(req);
  const requestId = headers.get('x-request-id') ?? '';
  if (!sameSiteWrite(req)) {
    return problem(403, 'FORBIDDEN', 'Cross-site request refused', requestId);
  }

  const target = `${serverConfig.apiUrl}/api/v1/${path.map(encodeURIComponent).join('/')}${req.nextUrl.search}`;
  const body = SAFE_METHODS.has(req.method) ? undefined : await req.arrayBuffer();
  let access = req.cookies.get(ACCESS_COOKIE)?.value;
  const refresh = req.cookies.get(REFRESH_COOKIE)?.value;
  let renewed: SessionTokens | null = null;
  let refreshFailed = false;

  const renew = async () => {
    if (!refresh) return false;
    renewed = await refreshSession(refresh, headers);
    refreshFailed = !renewed;
    access = renewed?.accessToken;
    return !!renewed;
  };

  if (refresh && secondsLeft(access) < REFRESH_AHEAD_SECONDS) await renew();

  const call = () => {
    const h = new Headers(headers);
    if (access) h.set('authorization', `Bearer ${access}`);
    return fetch(target, { method: req.method, headers: h, body, cache: 'no-store', redirect: 'manual' });
  };

  let upstream: Response;
  try {
    upstream = await call();
    if (upstream.status === 401 && !renewed && !refreshFailed && (await renew())) {
      upstream = await call();
    }
  } catch {
    return problem(503, 'SERVICE_UNAVAILABLE', 'Could not reach the FieldOps API', requestId);
  }

  const out = new NextResponse(upstream.status === 204 ? null : upstream.body, {
    status: upstream.status,
  });
  for (const name of ['content-type', 'content-disposition', 'x-request-id', 'retry-after', 'cache-control']) {
    const value = upstream.headers.get(name);
    if (value) out.headers.set(name, value);
  }
  if (renewed) setSessionCookies(out, renewed);
  else if (refreshFailed || (upstream.status === 401 && !refresh)) clearSessionCookies(out);
  return out;
}
