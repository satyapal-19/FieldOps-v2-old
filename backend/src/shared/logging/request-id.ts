import type { IncomingMessage, ServerResponse } from 'node:http';
import { randomUUID } from 'node:crypto';

export const REQUEST_ID_HEADER = 'x-request-id';
const SAFE_ID = /^[A-Za-z0-9-]{8,64}$/;

/**
 * Uses the client's X-Request-Id when it looks safe, otherwise creates one, and echoes
 * it back. The same ID appears in every log line, audit row and error body.
 */
export function resolveRequestId(req: IncomingMessage, res: ServerResponse): string {
  const header = req.headers[REQUEST_ID_HEADER];
  const candidate = Array.isArray(header) ? header[0] : header;
  const id = candidate && SAFE_ID.test(candidate) ? candidate : randomUUID();
  res.setHeader('X-Request-Id', id);
  return id;
}

/** Reads the ID that pino-http attached to the request. */
export function readRequestId(req: unknown): string {
  const id = (req as { id?: unknown }).id;
  if (typeof id === 'string') return id;
  if (typeof id === 'number') return String(id);
  return '';
}
