import { createParamDecorator, ExecutionContext, SetMetadata } from '@nestjs/common';
import { AppError } from '../errors/app-error';
import { ErrorCode } from '../errors/error-codes';
import type { AuthUser } from './auth-user';
import type { StaffRole } from './roles';

export const IS_PUBLIC_KEY = 'fieldops:isPublic';
export const ROLES_KEY = 'fieldops:roles';

/** Open endpoint (health, sign-in). Everything else requires a valid access token. */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

/**
 * Only these roles may call the endpoint. Without @Roles any signed-in staff may call it;
 * finer rules (same ward, own team) live in each module's policy.
 */
export const Roles = (...roles: StaffRole[]) => SetMetadata(ROLES_KEY, roles);

/** Injects the signed-in caller. */
export const CurrentUser = createParamDecorator((_data: unknown, ctx: ExecutionContext): AuthUser => {
  const user = ctx.switchToHttp().getRequest<{ user?: AuthUser }>().user;
  if (!user) throw new AppError(ErrorCode.UNAUTHENTICATED);
  return user;
});
