import 'server-only';
import type { NextRequest, NextResponse } from 'next/server';
import type { components } from '@/api/generated/schema';
import { ACCESS_COOKIE, REFRESH_COOKIE, ROLE_COOKIE } from '@/shared/auth/session-cookies';
import { serverConfig } from './config';

export type SessionTokens = components['schemas']['SessionTokensDto'];

/**
 * The web session lives in httpOnly cookies set by this server (backend-for-frontend):
 * the browser never holds a token. SameSite=Lax keeps cookies off cross-site POSTs; the
 * proxy also checks Origin and a custom header on every write (see api-proxy.ts).
 */
const base = () => ({
  httpOnly: true,
  sameSite: 'lax' as const,
  secure: serverConfig.cookieSecure,
  path: '/',
});

export function setSessionCookies(res: NextResponse, tokens: SessionTokens): void {
  const refreshExpires = new Date(tokens.refreshExpiresAt);
  res.cookies.set(ACCESS_COOKIE, tokens.accessToken, { ...base(), maxAge: tokens.expiresInSeconds });
  res.cookies.set(REFRESH_COOKIE, tokens.refreshToken, { ...base(), expires: refreshExpires });
  res.cookies.set(ROLE_COOKIE, tokens.staff.role, { ...base(), expires: refreshExpires });
}

export function clearSessionCookies(res: NextResponse): void {
  for (const name of [ACCESS_COOKIE, REFRESH_COOKIE, ROLE_COOKIE]) {
    res.cookies.set(name, '', { ...base(), maxAge: 0 });
  }
}

/** Headers passed through to the API: content negotiation, tracing and the caller's address. */
export function forwardHeaders(req: NextRequest): Headers {
  const out = new Headers();
  for (const name of ['content-type', 'accept', 'accept-language', 'user-agent', 'x-request-id']) {
    const value = req.headers.get(name);
    if (value) out.set(name, value);
  }
  // Rate limits and audit rows need the browser's address, not this server's (TRUST_PROXY).
  const forwarded = req.headers.get('x-forwarded-for');
  const realIp = req.headers.get('x-real-ip');
  if (forwarded || realIp) out.set('x-forwarded-for', forwarded ?? realIp ?? '');
  if (!out.has('x-request-id')) out.set('x-request-id', crypto.randomUUID());
  return out;
}

// Refresh tokens rotate and a reused one revokes the whole session, so requests that arrive
// together with the same old token must share one refresh. The result is kept briefly for
// requests that were already in flight with the old cookie.
const REFRESH_SHARE_MS = 30_000;
const inflight = new Map<string, Promise<SessionTokens | null>>();

export function refreshSession(refreshToken: string, headers: Headers): Promise<SessionTokens | null> {
  const existing = inflight.get(refreshToken);
  if (existing) return existing;
  const attempt = (async () => {
    const h = new Headers(headers);
    h.set('content-type', 'application/json');
    h.set('accept', 'application/json');
    const res = await fetch(`${serverConfig.apiUrl}/api/v1/auth/refresh`, {
      method: 'POST',
      headers: h,
      body: JSON.stringify({ refreshToken }),
      cache: 'no-store',
    });
    return res.ok ? ((await res.json()) as SessionTokens) : null;
  })().catch(() => null);
  inflight.set(refreshToken, attempt);
  setTimeout(() => inflight.delete(refreshToken), REFRESH_SHARE_MS).unref?.();
  return attempt;
}

/** Seconds until a JWT expires (from its unverified payload); 0 when unreadable. */
export function secondsLeft(jwt: string | undefined, nowMs = Date.now()): number {
  if (!jwt) return 0;
  try {
    const payload = JSON.parse(Buffer.from(jwt.split('.')[1] ?? '', 'base64url').toString('utf8')) as {
      exp?: number;
    };
    return payload.exp ? Math.max(0, payload.exp - Math.floor(nowMs / 1000)) : 0;
  } catch {
    return 0;
  }
}
