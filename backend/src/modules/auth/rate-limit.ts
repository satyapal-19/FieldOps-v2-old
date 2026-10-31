import { ExecutionContext, Injectable, SetMetadata } from '@nestjs/common';
import { ThrottlerGuard, ThrottlerModuleOptions } from '@nestjs/throttler';
import type { AuthUser } from '../../shared/auth/auth-user';
import type { AppConfig } from '../../shared/config/app-config';

const SIGN_IN_KEY = 'fieldops:signInEndpoint';

/** Marks sign-in endpoints for the stricter per-IP limit. */
export const SignInRateLimit = () => SetMetadata(SIGN_IN_KEY, true);

function isSignIn(ctx: ExecutionContext): boolean {
  return Reflect.getMetadata(SIGN_IN_KEY, ctx.getHandler()) === true;
}

/**
 * Two limits per minute: `default` for every request (per signed-in user, else per IP),
 * and a stricter `signIn` limit on sign-in endpoints (per IP).
 * Counters are in memory per process; with PM2 cluster each instance counts separately.
 */
export function rateLimitOptions(config: AppConfig): ThrottlerModuleOptions {
  const { perMinute, signInPerMinute } = config.rateLimits;
  return {
    throttlers: [
      { name: 'default', ttl: 60_000, limit: perMinute },
      { name: 'signIn', ttl: 60_000, limit: signInPerMinute, skipIf: (ctx) => !isSignIn(ctx) },
    ],
  };
}

@Injectable()
export class UserThrottlerGuard extends ThrottlerGuard {
  protected override async getTracker(req: Record<string, unknown>): Promise<string> {
    const user = req.user as AuthUser | undefined;
    return user ? `staff:${user.staffId}` : `ip:${String(req.ip ?? 'unknown')}`;
  }
}
