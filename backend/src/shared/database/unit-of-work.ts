import { Injectable } from '@nestjs/common';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource, EntityManager } from 'typeorm';

/**
 * Runs a block in one database transaction. Services use it for any change that also
 * writes an audit row (or touches more than one table): pass `tx` to repositories.
 */
@Injectable()
export class UnitOfWork {
  constructor(@InjectDataSource() private readonly dataSource: DataSource) {}

  run<T>(work: (tx: EntityManager) => Promise<T>): Promise<T> {
    return this.dataSource.transaction(work);
  }

  /** The non-transactional manager, for reads. */
  get manager(): EntityManager {
    return this.dataSource.manager;
  }
}
