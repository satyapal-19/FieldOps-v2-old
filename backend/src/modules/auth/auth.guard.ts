import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { AccessTokenClaims, AuthUser } from '../../shared/auth/auth-user';
import { IS_PUBLIC_KEY } from '../../shared/auth/decorators';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { AuthService } from './auth.service';

/** What the auth guards leave on the request: verified claims first, then the caller. */
export interface AuthRequest {
  headers: Record<string, string | undefined>;
  tokenClaims?: AccessTokenClaims;
  user?: AuthUser;
}

function isPublic(reflector: Reflector, ctx: ExecutionContext): boolean {
  return reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [ctx.getHandler(), ctx.getClass()]) === true;
}

/**
 * Global, first: every endpoint needs a validly signed bearer token unless marked @Public().
 * Checks the token only (no database), so the rate limit that runs next can count by staff
 * member before any session lookup.
 */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly auth: AuthService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    if (isPublic(this.reflector, ctx)) return true;

    const req = ctx.switchToHttp().getRequest<AuthRequest>();
    const header = req.headers.authorization ?? '';
    const match = /^Bearer ([A-Za-z0-9._-]{20,2048})$/.exec(header);
    if (!match) throw new AppError(ErrorCode.UNAUTHENTICATED);

    req.tokenClaims = await this.auth.verifyAccessToken(match[1]);
    return true;
  }
}

/**
 * Global, after the rate limit: the session row and account are read on every request, so a
 * revoked session or deactivated account stops working immediately.
 */
@Injectable()
export class SessionGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly auth: AuthService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    if (isPublic(this.reflector, ctx)) return true;

    const req = ctx.switchToHttp().getRequest<AuthRequest>();
    if (!req.tokenClaims) throw new AppError(ErrorCode.UNAUTHENTICATED);
    req.user = await this.auth.sessionUser(req.tokenClaims);
    return true;
  }
}
