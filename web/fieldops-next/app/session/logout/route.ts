import { NextResponse, type NextRequest } from 'next/server';
import { problem, sameSiteWrite } from '@/server/api-proxy';
import { serverConfig } from '@/server/config';
import { clearSessionCookies, forwardHeaders, refreshSession, secondsLeft } from '@/server/session';
import { ACCESS_COOKIE, REFRESH_COOKIE } from '@/shared/auth/session-cookies';

export const dynamic = 'force-dynamic';

/** Signs out: revokes the session in the API (best effort) and always clears the cookies. */
export async function POST(req: NextRequest) {
  const headers = forwardHeaders(req);
  if (!sameSiteWrite(req)) {
    return problem(403, 'FORBIDDEN', 'Cross-site request refused', headers.get('x-request-id') ?? '');
  }
  let access = req.cookies.get(ACCESS_COOKIE)?.value;
  const refresh = req.cookies.get(REFRESH_COOKIE)?.value;
  try {
    if (refresh && secondsLeft(access) < 30) access = (await refreshSession(refresh, headers))?.accessToken;
    if (access) {
      headers.set('authorization', `Bearer ${access}`);
      headers.set('content-type', 'application/json');
      await fetch(`${serverConfig.apiUrl}/api/v1/auth/logout`, {
        method: 'POST',
        headers,
        body: JSON.stringify({ everywhere: false }),
        cache: 'no-store',
      });
    }
  } catch {
    // The cookies are cleared anyway; the server session then simply expires.
  }
  const res = new NextResponse(null, { status: 204 });
  clearSessionCookies(res);
  return res;
}
