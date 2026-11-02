import { Injectable } from '@nestjs/common';
import type { EntityManager } from 'typeorm';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { StaffService } from '../staff/staff.service';
import type { AlertDto, AlertPageDto, ListAlertsQueryDto } from './dto/alert.dto';
import { Alert, AlertSeverity, AlertType } from './entities/alert.entity';
import { alertScope, AlertRuleError, canHandleAlert, checkResolvable } from './alerts.policy';
import { AlertFilter, AlertsRepository } from './alerts.repository';

export function toAlertDto(a: Alert): AlertDto {
  return {
    id: a.id,
    alertType: a.alertType,
    severity: a.severity,
    staffId: a.staffId ?? null,
    wardId: a.wardId ?? null,
    message: a.message,
    messageMr: a.messageMr ?? null,
    details: a.detailsJson ? (JSON.parse(a.detailsJson) as Record<string, unknown>) : null,
    isResolved: Boolean(Number(a.isResolved)),
    triggeredAt: a.triggeredAt.toISOString(),
    resolvedAt: a.resolvedAt ? a.resolvedAt.toISOString() : null,
    resolvedById: a.resolvedById ?? null,
    resolutionNote: a.resolutionNote ?? null,
  };
}

/** What a producer (punch flow, scheduled job) passes to raise an alert. */
export interface RaiseAlert {
  alertType: AlertType;
  severity: AlertSeverity;
  message: string;
  messageMr?: string;
  staffId?: string;
  wardId?: string;
  details?: Record<string, unknown>;
  /** Same key = same alert: a re-run job or retried punch does not raise it twice. */
  dedupeKey?: string;
}

/**
 * Supervisor alerts. Phase 2 producers (punch flow, jobs) call raise(); supervisors list and
 * resolve them here. Rules: alerts.policy.
 */
@Injectable()
export class AlertsService {
  constructor(
    private readonly repo: AlertsRepository,
    private readonly staff: StaffService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  /** Idempotent by dedupeKey: returns the existing alert when it was already raised. */
  async raise(input: RaiseAlert, tx?: EntityManager): Promise<AlertDto> {
    if (input.dedupeKey) {
      const existing = await this.repo.findByDedupeKey(input.dedupeKey);
      if (existing) return toAlertDto(existing);
    }
    const row: Alert = {
      id: this.ids.next(),
      dedupeKey: input.dedupeKey ?? null,
      staffId: input.staffId ?? null,
      wardId: input.wardId ?? null,
      alertType: input.alertType,
      severity: input.severity,
      message: input.message,
      messageMr: input.messageMr ?? null,
      detailsJson: input.details ? JSON.stringify(input.details) : null,
      isResolved: false,
      triggeredAt: this.clock.now(),
      resolvedAt: null,
      resolvedById: null,
      resolutionNote: null,
    };
    try {
      await this.repo.insert(row, tx);
    } catch (error) {
      if (input.dedupeKey && isUniqueViolation(error) && !tx) {
        const winner = await this.repo.findByDedupeKey(input.dedupeKey);
        if (winner) return toAlertDto(winner);
      }
      throw error;
    }
    return toAlertDto(row);
  }

  async list(actor: AuthUser, q: ListAlertsQueryDto): Promise<AlertPageDto> {
    const scope = alertScope(actor);
    if (scope.kind === 'NONE') throw new AppError(ErrorCode.FORBIDDEN);
    const filter: AlertFilter = {
      isResolved: q.isResolved,
      alertType: q.alertType,
      severity: q.severity,
      from: q.from ? new Date(q.from) : undefined,
      to: q.to ? new Date(q.to) : undefined,
    };
    if (scope.kind === 'WARD') filter.wardId = scope.wardId;
    if (scope.kind === 'REPORTS')
      filter.staffIds = await this.staff.findIds({ reportsToId: scope.managerId });
    if (q.staffId) {
      if (filter.staffIds && !filter.staffIds.includes(q.staffId))
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.staffIds = [q.staffId];
    }
    const [items, total] = await this.repo.findPage(filter, (q.page - 1) * q.pageSize, q.pageSize);
    return { items: items.map(toAlertDto), page: q.page, pageSize: q.pageSize, total };
  }

  async get(actor: AuthUser, id: string): Promise<AlertDto> {
    return toAlertDto(await this.handled(actor, id));
  }

  async resolve(actor: AuthUser, id: string, note?: string): Promise<AlertDto> {
    const row = await this.handled(actor, id);
    try {
      checkResolvable(Boolean(Number(row.isResolved)));
    } catch (error) {
      if (error instanceof AlertRuleError) {
        throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
      }
      throw error;
    }
    await this.uow.run(async (tx) => {
      const n = await this.repo.resolve(
        id,
        actor.staffId,
        this.clock.now(),
        note?.trim() ?? null,
        tx,
      );
      if (n === 0) throw new AppError(ErrorCode.CONFLICT, 'Someone resolved this alert meanwhile');
      await this.audit.write(tx, {
        action: 'ALERT_RESOLVED',
        entityType: 'alert',
        entityId: id,
        details: { alertType: row.alertType, note: note?.trim() ?? null },
      });
    });
    return toAlertDto((await this.repo.findById(id))!);
  }

  /** The alert, if the caller may see and act on it (else 404). */
  private async handled(actor: AuthUser, id: string): Promise<Alert> {
    const row = await this.repo.findById(id);
    if (!row) throw this.notFound(id);
    const subject = row.staffId ? await this.staff.findById(row.staffId) : null;
    const ok = canHandleAlert(actor, {
      wardId: row.wardId ?? null,
      staffId: row.staffId ?? null,
      staffManagerId: subject?.reportsToId ?? null,
    });
    if (!ok) throw this.notFound(id);
    return row;
  }

  private notFound(id: string): AppError {
    return new AppError(ErrorCode.NOT_FOUND, 'Alert not found', { id });
  }
}
