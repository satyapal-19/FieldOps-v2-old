import { Global, Module } from '@nestjs/common';
import { UnitOfWork } from '../database/unit-of-work';
import { AuditWriter } from './audit-writer';

/** Transactions and audit writing, available to every module. */
@Global()
@Module({
  providers: [AuditWriter, UnitOfWork],
  exports: [AuditWriter, UnitOfWork],
})
export class AuditModule {}
