import { Injectable } from '@nestjs/common';
import type { EntityManager } from 'typeorm';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { StaffService } from '../staff/staff.service';
import type {
  CreateLeaveDto,
  CreateRegularizationDto,
  LeavePageDto,
  LeaveRequestDto,
  ListRequestsQueryDto,
  RegularizationPageDto,
  RegularizationRequestDto,
  ReviewRequestDto,
} from './dto/leave.dto';
import { LeaveRequest, ReviewStatus } from './entities/leave-request.entity';
import { RegularizationRequest } from './entities/regularization-request.entity';
import {
  canReview,
  checkCancellable,
  checkLeaveDates,
  checkRegularizationDate,
  checkReviewable,
  LeaveRuleError,
  RequesterFacts,
  requestScope,
} from './leave.policy';
import { LeaveRepository, RequestFilter, ReviewChanges } from './leave.repository';

type Reviewable = Pick<
  LeaveRequest,
  | 'id'
  | 'staffId'
  | 'status'
  | 'reviewedById'
  | 'reviewedAt'
  | 'reviewNote'
  | 'version'
  | 'createdAt'
>;

function reviewFields(r: Reviewable) {
  return {
    id: r.id,
    staffId: r.staffId,
    status: r.status,
    reviewedById: r.reviewedById ?? null,
    reviewedAt: r.reviewedAt ? r.reviewedAt.toISOString() : null,
    reviewNote: r.reviewNote ?? null,
    version: Number(r.version),
    createdAt: r.createdAt.toISOString(),
  };
}

export function toLeaveDto(l: LeaveRequest): LeaveRequestDto {
  return {
    ...reviewFields(l),
    leaveType: l.leaveType,
    fromDate: l.fromDate,
    toDate: l.toDate,
    daysCount: Number(l.daysCount),
    reason: l.reason ?? null,
  };
}

export function toRegularizationDto(r: RegularizationRequest): RegularizationRequestDto {
  return {
    ...reviewFields(r),
    attendanceDate: r.attendanceDate,
    reasonType: r.reasonType,
    explanation: r.explanation,
  };
}

function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof LeaveRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/**
 * Leave and attendance-regularization requests: staff ask for themselves; the line manager
 * reviews (leave.policy). Approving a regularization records the decision; the attendance engine
 * (Phase 2) applies it to the day's attendance as REGULARIZED.
 */
@Injectable()
export class LeaveService {
  constructor(
    private readonly repo: LeaveRepository,
    private readonly staff: StaffService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  /** For the attendance engine: is this person on approved leave on an IST date? */
  async isOnApprovedLeave(staffId: string, date: string): Promise<boolean> {
    return (await this.repo.findApprovedLeaveOn(staffId, date)) !== null;
  }

  /** For the day-close job: approved corrections of attendance dates in [from, to]. */
  approvedRegularizations(from: string, to: string): Promise<{ staffId: string; attendanceDate: string }[]> {
    return this.repo.findApprovedRegularizations(from, to);
  }

  /** For the daily ward summary: everyone on approved leave on an IST date. */
  staffOnLeave(date: string): Promise<Set<string>> {
    return this.repo.findStaffOnLeave(date);
  }

  // ------------------------------------------------------------ Leave

  async listLeave(actor: AuthUser, q: ListRequestsQueryDto): Promise<LeavePageDto> {
    const filter = await this.filterFor(actor, q);
    const [items, total] = await this.repo.findLeavePage(
      filter,
      (q.page - 1) * q.pageSize,
      q.pageSize,
    );
    return { items: items.map(toLeaveDto), page: q.page, pageSize: q.pageSize, total };
  }

  async getLeave(actor: AuthUser, id: string): Promise<LeaveRequestDto> {
    const row = await this.repo.findLeave(id);
    if (!row || !(await this.canSee(actor, row.staffId))) throw this.notFound(id);
    return toLeaveDto(row);
  }

  async requestLeave(actor: AuthUser, dto: CreateLeaveDto): Promise<LeaveRequestDto> {
    if (dto.clientUuid) {
      const previous = await this.repo.findLeaveByClientUuid(dto.clientUuid);
      if (previous) return toLeaveDto(this.ownRetry(actor, previous));
    }
    const daysCount = rule(() =>
      checkLeaveDates(dto.leaveType, dto.fromDate, dto.toDate, this.today()),
    );
    const now = this.clock.now();
    const row: LeaveRequest = {
      id: this.ids.next(),
      clientUuid: dto.clientUuid ?? null,
      staffId: actor.staffId,
      leaveType: dto.leaveType,
      fromDate: dto.fromDate,
      toDate: dto.toDate,
      daysCount,
      reason: dto.reason?.trim() ?? null,
      status: 'PENDING',
      reviewedById: null,
      reviewedAt: null,
      reviewNote: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    try {
      await this.uow.run(async (tx) => {
        const clash = await this.repo.findOverlappingLeave(
          actor.staffId,
          dto.fromDate,
          dto.toDate,
          tx,
        );
        if (clash) {
          throw new AppError(ErrorCode.LEAVE_OVERLAP, undefined, {
            existingId: clash.id,
            status: clash.status,
          });
        }
        await this.repo.insertLeave(row, tx);
        await this.audit.write(tx, {
          action: 'LEAVE_REQUESTED',
          entityType: 'leave_request',
          entityId: row.id,
          details: {
            leaveType: row.leaveType,
            fromDate: row.fromDate,
            toDate: row.toDate,
            daysCount,
          },
        });
      });
    } catch (error) {
      // Two sends of the same offline request raced: the first one won.
      if (dto.clientUuid && isUniqueViolation(error)) {
        const winner = await this.repo.findLeaveByClientUuid(dto.clientUuid);
        if (winner) return toLeaveDto(this.ownRetry(actor, winner));
      }
      throw error;
    }
    return toLeaveDto(row);
  }

  async reviewLeave(actor: AuthUser, id: string, dto: ReviewRequestDto): Promise<LeaveRequestDto> {
    const row = await this.repo.findLeave(id);
    if (!row) throw this.notFound(id);
    await this.authorizeReview(actor, row.staffId, id);
    rule(() => checkReviewable(row.status));
    const changes = this.decision(actor, dto);
    await this.apply(
      row,
      dto.expectedVersion,
      changes,
      (tx) => this.repo.updateLeave(id, dto.expectedVersion, row.status, changes, tx),
      `LEAVE_${dto.decision}`,
      'leave_request',
    );
    return toLeaveDto((await this.repo.findLeave(id))!);
  }

  async cancelLeave(
    actor: AuthUser,
    id: string,
    expectedVersion: number,
  ): Promise<LeaveRequestDto> {
    const row = await this.repo.findLeave(id);
    if (!row || !(await this.canSee(actor, row.staffId))) throw this.notFound(id);
    if (row.staffId !== actor.staffId)
      throw new AppError(ErrorCode.FORBIDDEN, 'Only the requester can cancel');
    rule(() => checkCancellable(row.status, row.fromDate, this.today()));
    const changes: ReviewChanges = { status: 'CANCELLED', updatedAt: this.clock.now() };
    await this.apply(
      row,
      expectedVersion,
      changes,
      (tx) => this.repo.updateLeave(id, expectedVersion, row.status, changes, tx),
      'LEAVE_CANCELLED',
      'leave_request',
    );
    return toLeaveDto((await this.repo.findLeave(id))!);
  }

  // ------------------------------------------------------------ Regularization

  async listRegularizations(
    actor: AuthUser,
    q: ListRequestsQueryDto,
  ): Promise<RegularizationPageDto> {
    const filter = await this.filterFor(actor, q);
    const [items, total] = await this.repo.findRegularizationPage(
      filter,
      (q.page - 1) * q.pageSize,
      q.pageSize,
    );
    return { items: items.map(toRegularizationDto), page: q.page, pageSize: q.pageSize, total };
  }

  async getRegularization(actor: AuthUser, id: string): Promise<RegularizationRequestDto> {
    const row = await this.repo.findRegularization(id);
    if (!row || !(await this.canSee(actor, row.staffId))) throw this.notFound(id);
    return toRegularizationDto(row);
  }

  async requestRegularization(
    actor: AuthUser,
    dto: CreateRegularizationDto,
  ): Promise<RegularizationRequestDto> {
    if (dto.clientUuid) {
      const previous = await this.repo.findRegularizationByClientUuid(dto.clientUuid);
      if (previous) return toRegularizationDto(this.ownRetry(actor, previous));
    }
    rule(() => checkRegularizationDate(dto.attendanceDate, this.today()));
    const now = this.clock.now();
    const row: RegularizationRequest = {
      id: this.ids.next(),
      clientUuid: dto.clientUuid ?? null,
      staffId: actor.staffId,
      attendanceDate: dto.attendanceDate,
      reasonType: dto.reasonType,
      explanation: dto.explanation.trim(),
      status: 'PENDING',
      reviewedById: null,
      reviewedAt: null,
      reviewNote: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    try {
      await this.uow.run(async (tx) => {
        const open = await this.repo.findOpenRegularization(actor.staffId, dto.attendanceDate, tx);
        if (open)
          throw new AppError(ErrorCode.REGULARIZATION_EXISTS, undefined, { existingId: open.id });
        await this.repo.insertRegularization(row, tx);
        await this.audit.write(tx, {
          action: 'REGULARIZATION_REQUESTED',
          entityType: 'regularization_request',
          entityId: row.id,
          details: { attendanceDate: row.attendanceDate, reasonType: row.reasonType },
        });
      });
    } catch (error) {
      if (dto.clientUuid && isUniqueViolation(error)) {
        const winner = await this.repo.findRegularizationByClientUuid(dto.clientUuid);
        if (winner) return toRegularizationDto(this.ownRetry(actor, winner));
      }
      throw error;
    }
    return toRegularizationDto(row);
  }

  async reviewRegularization(
    actor: AuthUser,
    id: string,
    dto: ReviewRequestDto,
  ): Promise<RegularizationRequestDto> {
    const row = await this.repo.findRegularization(id);
    if (!row) throw this.notFound(id);
    await this.authorizeReview(actor, row.staffId, id);
    rule(() => checkReviewable(row.status));
    const changes = this.decision(actor, dto);
    await this.apply(
      row,
      dto.expectedVersion,
      changes,
      (tx) => this.repo.updateRegularization(id, dto.expectedVersion, row.status, changes, tx),
      `REGULARIZATION_${dto.decision}`,
      'regularization_request',
    );
    return toRegularizationDto((await this.repo.findRegularization(id))!);
  }

  async cancelRegularization(
    actor: AuthUser,
    id: string,
    expectedVersion: number,
  ): Promise<RegularizationRequestDto> {
    const row = await this.repo.findRegularization(id);
    if (!row || !(await this.canSee(actor, row.staffId))) throw this.notFound(id);
    if (row.staffId !== actor.staffId)
      throw new AppError(ErrorCode.FORBIDDEN, 'Only the requester can cancel');
    // Only pending regularizations can be withdrawn (an approved one has corrected attendance).
    rule(() => checkCancellable(row.status, null, this.today()));
    const changes: ReviewChanges = { status: 'CANCELLED', updatedAt: this.clock.now() };
    await this.apply(
      row,
      expectedVersion,
      changes,
      (tx) => this.repo.updateRegularization(id, expectedVersion, row.status, changes, tx),
      'REGULARIZATION_CANCELLED',
      'regularization_request',
    );
    return toRegularizationDto((await this.repo.findRegularization(id))!);
  }

  // ------------------------------------------------------------ helpers

  /** The requester filter for lists: the caller's scope, narrowed to one person if asked. */
  private async filterFor(actor: AuthUser, q: ListRequestsQueryDto): Promise<RequestFilter> {
    const scope = requestScope(actor);
    let staffIds: string[] | undefined;
    if (scope.kind === 'WARD')
      staffIds = [...(await this.staff.findIds({ wardId: scope.wardId })), actor.staffId];
    else if (scope.kind === 'REPORTS') {
      staffIds = [...(await this.staff.findIds({ reportsToId: scope.managerId })), actor.staffId];
    } else if (scope.kind === 'SELF') staffIds = [actor.staffId];

    if (q.staffId) {
      if (staffIds && !staffIds.includes(q.staffId)) throw new AppError(ErrorCode.FORBIDDEN);
      staffIds = [q.staffId];
    }
    return { staffIds, status: q.status, from: q.from, to: q.to };
  }

  /** The requester themself, or anyone who could review their requests. */
  private async canSee(actor: AuthUser, requesterId: string): Promise<boolean> {
    if (requesterId === actor.staffId) return true;
    const requester = await this.requesterFacts(requesterId);
    return requester !== null && canReview(actor, requester);
  }

  private async authorizeReview(actor: AuthUser, requesterId: string, id: string): Promise<void> {
    if (requesterId === actor.staffId) {
      throw new AppError(ErrorCode.FORBIDDEN, 'You cannot review your own request');
    }
    const requester = await this.requesterFacts(requesterId);
    if (!requester || !canReview(actor, requester)) throw this.notFound(id);
  }

  private async requesterFacts(id: string): Promise<RequesterFacts | null> {
    const s = await this.staff.findById(id);
    return s
      ? {
          id: s.id,
          role: s.role,
          homeWardId: s.homeWardId ?? null,
          reportsToId: s.reportsToId ?? null,
        }
      : null;
  }

  private decision(actor: AuthUser, dto: ReviewRequestDto): ReviewChanges {
    const now = this.clock.now();
    return {
      status: dto.decision,
      reviewedById: actor.staffId,
      reviewedAt: now,
      reviewNote: dto.note?.trim() ?? null,
      updatedAt: now,
    };
  }

  /** Runs a status change with its audit row in one transaction; 0 rows = someone got there first. */
  private async apply(
    row: { id: string; version: number; status: ReviewStatus },
    expectedVersion: number,
    changes: ReviewChanges,
    update: (tx: EntityManager) => Promise<number>,
    action: string,
    entityType: string,
  ): Promise<void> {
    if (Number(row.version) !== expectedVersion)
      throw this.versionConflict(row.version, expectedVersion);
    const count = await this.uow.run(async (tx) => {
      const n = await update(tx);
      if (n > 0) {
        await this.audit.write(tx, {
          action,
          entityType,
          entityId: row.id,
          details: { from: row.status, to: changes.status, note: changes.reviewNote ?? null },
        });
      }
      return n;
    });
    if (count === 0) throw this.versionConflict(row.version, expectedVersion);
  }

  private ownRetry<T extends { staffId: string }>(actor: AuthUser, previous: T): T {
    if (previous.staffId !== actor.staffId)
      throw new AppError(ErrorCode.CONFLICT, 'This clientUuid is already used');
    return previous;
  }

  private today(): string {
    return istDate(this.clock.now());
  }

  private notFound(id: string): AppError {
    return new AppError(ErrorCode.NOT_FOUND, 'Request not found', { id });
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
      currentVersion: Number(currentVersion),
      expectedVersion,
    });
  }
}
