import { AsyncLocalStorage } from 'node:async_hooks';
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';
import type { AuthUser } from '../auth/auth-user';
import { readRequestId } from '../logging/request-id';

/** Who is acting and for which request. Read by the audit writer; never by business rules. */
export interface RequestContext {
  requestId: string;
  ip: string | null;
  actor: AuthUser | null;
}

const storage = new AsyncLocalStorage<RequestContext>();

export function currentRequestContext(): RequestContext | undefined {
  return storage.getStore();
}

/** Runs code with a given context (scripts, scheduled jobs, tests). */
export function runWithRequestContext<T>(context: RequestContext, fn: () => T): T {
  return storage.run(context, fn);
}

/**
 * Global interceptor: runs after the auth guard, so the caller is known, and keeps the
 * context for the whole handler, including transactions and audit writes.
 */
@Injectable()
export class RequestContextInterceptor implements NestInterceptor {
  intercept(ctx: ExecutionContext, next: CallHandler): Observable<unknown> {
    const req = ctx.switchToHttp().getRequest<{ user?: AuthUser; ip?: string }>();
    const context: RequestContext = {
      requestId: readRequestId(req),
      ip: req.ip ?? null,
      actor: req.user ?? null,
    };
    return new Observable((subscriber) =>
      storage.run(context, () => next.handle().subscribe(subscriber)),
    );
  }
}
