import { BadRequestException, ForbiddenException, InternalServerErrorException } from '@nestjs/common';
import { AppError } from './app-error';
import { ErrorCode } from './error-codes';
import { toProblemDetails } from './problem-details';

describe('toProblemDetails', () => {
  const rid = 'req-123';

  it('maps an AppError with its code, status, message and details', () => {
    const body = toProblemDetails(
      new AppError(ErrorCode.OUTSIDE_WARD, undefined, { distanceMeters: 140 }),
      rid,
    );
    expect(body).toEqual({
      type: 'urn:fieldops:error:OUTSIDE_WARD',
      code: ErrorCode.OUTSIDE_WARD,
      title: 'Location is outside the assigned ward',
      status: 422,
      requestId: rid,
      details: { distanceMeters: 140 },
    });
  });

  it('maps validation errors to VALIDATION_FAILED with the messages', () => {
    const body = toProblemDetails(
      new BadRequestException({ message: ['code must match pattern'], error: 'Bad Request' }),
      rid,
    );
    expect(body.code).toBe(ErrorCode.VALIDATION_FAILED);
    expect(body.status).toBe(400);
    expect(body.details).toEqual({ errors: ['code must match pattern'] });
  });

  it('maps other HTTP statuses to stable codes', () => {
    expect(toProblemDetails(new ForbiddenException(), rid).code).toBe(ErrorCode.FORBIDDEN);
  });

  it('hides internals for unknown and 5xx errors', () => {
    const unknown = toProblemDetails(new Error('db password is wrong'), rid);
    expect(unknown.code).toBe(ErrorCode.INTERNAL_ERROR);
    expect(unknown.title).not.toContain('password');
    expect(toProblemDetails(new InternalServerErrorException('boom'), rid).status).toBe(500);
  });
});
