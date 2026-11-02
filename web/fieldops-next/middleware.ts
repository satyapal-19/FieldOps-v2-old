import { NextResponse, type NextRequest } from 'next/server';
import { canOpen, homeFor, isPublicPath, isWebRole, safeNext } from '@/shared/auth/route-table';
import { REFRESH_COOKIE, ROLE_COOKIE } from '@/shared/auth/session-cookies';

/**
 * Route protection from the one route table. A signed-in user has a refresh cookie and a role
 * cookie (both httpOnly); the proxy renews the access token on the next API call. This only
 * steers navigation; the API checks the token on every request.
 */
export function middleware(req: NextRequest) {
  const { pathname, search } = req.nextUrl;
  const role = req.cookies.get(ROLE_COOKIE)?.value;
  const signedIn = !!req.cookies.get(REFRESH_COOKIE)?.value && isWebRole(role);

  if (pathname === '/login') {
    if (signedIn) {
      const target = safeNext(role, req.nextUrl.searchParams.get('next'));
      return NextResponse.redirect(new URL(target, req.url));
    }
    return NextResponse.next();
  }
  if (isPublicPath(pathname)) return NextResponse.next();

  if (!signedIn) {
    const login = new URL('/login', req.url);
    login.searchParams.set('next', `${pathname}${search}`);
    return NextResponse.redirect(login);
  }
  if (!canOpen(role, pathname)) {
    return NextResponse.redirect(new URL(homeFor(role), req.url));
  }
  return NextResponse.next();
}

export const config = {
  // Pages only: the API proxy, session handlers and static files handle their own access.
  matcher: ['/((?!api/|session/|_next/|favicon.ico|.*\\.[a-zA-Z0-9]+$).*)'],
};
