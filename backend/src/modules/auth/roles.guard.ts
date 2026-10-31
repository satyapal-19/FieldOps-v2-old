import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import type { AuthUser } from '../../shared/auth/auth-user';
import { ROLES_KEY } from '../../shared/auth/decorators';
import type { StaffRole } from '../../shared/auth/roles';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';

/** Global: enforces @Roles(...). Runs after AuthGuard. */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(ctx: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<StaffRole[] | undefined>(ROLES_KEY, [
      ctx.getHandler(),
      ctx.getClass(),
    ]);
    if (!roles || roles.length === 0) return true;
    const user = ctx.switchToHttp().getRequest<{ user?: AuthUser }>().user;
    if (!user) throw new AppError(ErrorCode.UNAUTHENTICATED);
    if (!roles.includes(user.role)) {
      throw new AppError(ErrorCode.FORBIDDEN, undefined, { requiredRoles: roles });
    }
    return true;
  }
}
