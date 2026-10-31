import { ArgumentsHost, Catch, ExceptionFilter, Logger } from '@nestjs/common';
import type { Request, Response } from 'express';
import { readRequestId } from '../logging/request-id';
import { toProblemDetails } from './problem-details';

/** Global filter: every error leaves the API in one shape, with the request ID. */
@Catch()
export class ProblemDetailsFilter implements ExceptionFilter {
  private readonly logger = new Logger('Errors');

  catch(exception: unknown, host: ArgumentsHost): void {
    const http = host.switchToHttp();
    const request = http.getRequest<Request>();
    const response = http.getResponse<Response>();
    const requestId = readRequestId(request);
    const body = toProblemDetails(exception, requestId);

    if (body.status >= 500) {
      const stack = exception instanceof Error ? exception.stack : String(exception);
      this.logger.error(`${request.method} ${request.originalUrl} failed [${requestId}]`, stack);
    }

    response.status(body.status).type('application/problem+json').json(body);
  }
}
