import { HttpException } from '@nestjs/common';
import { AppError } from './app-error';
import { ERROR_DEFINITIONS, ErrorCode } from './error-codes';

/** RFC 7807 body returned for every error. */
export interface ProblemDetails {
  type: string;
  code: ErrorCode;
  title: string;
  status: number;
  requestId: string;
  details?: Record<string, unknown>;
}

const STATUS_TO_CODE: Record<number, ErrorCode> = {
  400: ErrorCode.VALIDATION_FAILED,
  401: ErrorCode.UNAUTHENTICATED,
  403: ErrorCode.FORBIDDEN,
  404: ErrorCode.NOT_FOUND,
  409: ErrorCode.CONFLICT,
  413: ErrorCode.PAYLOAD_TOO_LARGE,
  422: ErrorCode.RULE_VIOLATION,
  429: ErrorCode.RATE_LIMITED,
  503: ErrorCode.SERVICE_UNAVAILABLE,
};

function problem(
  code: ErrorCode,
  requestId: string,
  overrides: { status?: number; title?: string; details?: Record<string, unknown> } = {},
): ProblemDetails {
  const def = ERROR_DEFINITIONS[code];
  const body: ProblemDetails = {
    type: `urn:fieldops:error:${code}`,
    code,
    title: overrides.title ?? def.title,
    status: overrides.status ?? def.status,
    requestId,
  };
  if (overrides.details && Object.keys(overrides.details).length > 0) {
    body.details = overrides.details;
  }
  return body;
}

function validationMessages(response: unknown): string[] {
  if (typeof response === 'object' && response !== null && 'message' in response) {
    const message = (response as { message: unknown }).message;
    if (Array.isArray(message)) return message.map((m) => String(m));
    if (typeof message === 'string') return [message];
  }
  return typeof response === 'string' ? [response] : [];
}

/** Converts any thrown value into a problem body. Never leaks internals for 5xx. */
export function toProblemDetails(exception: unknown, requestId: string): ProblemDetails {
  if (exception instanceof AppError) {
    return problem(exception.code, requestId, {
      title: exception.message,
      details: exception.details,
    });
  }

  if (exception instanceof HttpException) {
    const status = exception.getStatus();
    if (status >= 500) {
      return problem(ErrorCode.INTERNAL_ERROR, requestId, { status });
    }
    if (status === 400) {
      const errors = validationMessages(exception.getResponse());
      return problem(ErrorCode.VALIDATION_FAILED, requestId, {
        details: errors.length > 0 ? { errors } : undefined,
      });
    }
    const code = STATUS_TO_CODE[status] ?? ErrorCode.HTTP_ERROR;
    return problem(code, requestId, { status });
  }

  return problem(ErrorCode.INTERNAL_ERROR, requestId);
}
