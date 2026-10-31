import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { AuthUser } from '../../shared/auth/auth-user';
import { IS_PUBLIC_KEY } from '../../shared/auth/decorators';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { AuthService } from './auth.service';

/** Global: every endpoint needs a valid bearer token unless marked @Public(). */
@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly auth: AuthService,
  ) {}

  async canActivate(ctx: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [ctx.getHandler(), ctx.getClass()]);
    if (isPublic) return true;

    const req = ctx.switchToHttp().getRequest<{ headers: Record<string, string | undefined>; user?: AuthUser }>();
    const header = req.headers.authorization ?? '';
    const match = /^Bearer ([A-Za-z0-9._-]{20,2048})$/.exec(header);
    if (!match) throw new AppError(ErrorCode.UNAUTHENTICATED);

    req.user = await this.auth.authenticate(match[1]);
    return true;
  }
}
