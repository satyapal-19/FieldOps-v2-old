import { ERROR_DEFINITIONS, ErrorCode } from './error-codes';

/**
 * The only error services and policies throw on purpose. The global filter turns it
 * into an RFC 7807 problem+json response carrying `code` and the request ID.
 */
export class AppError extends Error {
  constructor(
    public readonly code: ErrorCode,
    message?: string,
    public readonly details?: Record<string, unknown>,
  ) {
    super(message ?? ERROR_DEFINITIONS[code].title);
    this.name = 'AppError';
  }

  get status(): number {
    return ERROR_DEFINITIONS[this.code].status;
  }
}
