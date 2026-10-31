import { randomUUID } from 'node:crypto';

/**
 * IDs are generated in the application (not the database) so PostgreSQL and Oracle
 * behave the same and offline mobile records can carry their ID before upload.
 * Stored as VARCHAR(36).
 */
export abstract class IdGenerator {
  abstract next(): string;
}

export class UuidGenerator extends IdGenerator {
  next(): string {
    return randomUUID();
  }
}

/** Deterministic IDs for tests: id-0001, id-0002, ... */
export class SequenceIdGenerator extends IdGenerator {
  private counter = 0;

  constructor(private readonly prefix = 'id') {
    super();
  }

  next(): string {
    this.counter += 1;
    return `${this.prefix}-${String(this.counter).padStart(4, '0')}`;
  }
}

export const UUID_PATTERN = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
