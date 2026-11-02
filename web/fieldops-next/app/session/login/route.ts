import { NextResponse, type NextRequest } from 'next/server';
import { problem, sameSiteWrite } from '@/server/api-proxy';
import { serverConfig } from '@/server/config';
import { forwardHeaders, setSessionCookies, type SessionTokens } from '@/server/session';

export const dynamic = 'force-dynamic';

/**
 * Password sign-in for the dashboard. The API's tokens go into httpOnly cookies; the page
 * gets only the staff profile. Errors pass through as problem+json.
 */
export async function POST(req: NextRequest) {
  const headers = forwardHeaders(req);
  const requestId = headers.get('x-request-id') ?? '';
  if (!sameSiteWrite(req)) return problem(403, 'FORBIDDEN', 'Cross-site request refused', requestId);
  headers.set('content-type', 'application/json');
  let upstream: Response;
  try {
    upstream = await fetch(`${serverConfig.apiUrl}/api/v1/auth/login`, {
      method: 'POST',
      headers,
      body: await req.text(),
      cache: 'no-store',
    });
  } catch {
    return problem(503, 'SERVICE_UNAVAILABLE', 'Could not reach the FieldOps API', requestId);
  }
  if (!upstream.ok) {
    return new NextResponse(upstream.body, {
      status: upstream.status,
      headers: { 'content-type': upstream.headers.get('content-type') ?? 'application/problem+json' },
    });
  }
  const tokens = (await upstream.json()) as SessionTokens;
  const res = NextResponse.json({ staff: tokens.staff });
  setSessionCookies(res, tokens);
  return res;
}
