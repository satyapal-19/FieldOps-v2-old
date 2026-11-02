import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import type { Staff } from '../staff/entities/staff.entity';
import { StaffService } from '../staff/staff.service';
import { WardsService } from '../wards/wards.service';
import type {
  AssignmentDto,
  AssignmentPageDto,
  CreateAssignmentDto,
  CreateStandingRosterDto,
  GenerateAssignmentsResultDto,
  ListAssignmentsQueryDto,
  ListStandingRostersQueryDto,
  SelfAssignmentDto,
  StandingRosterDto,
  StandingRosterPageDto,
  UpdateStandingRosterDto,
} from './dto/rosters.dto';
import { DailyAssignment } from './entities/daily-assignment.entity';
import { StandingRoster } from './entities/standing-roster.entity';
import type { AssignableRole, AssignmentMode } from './roster-types';
import {
  AssignmentFacts,
  assignedMode,
  assignmentScope,
  canApprove,
  canManageWard,
  checkAssignmentDate,
  checkInspectorPlacement,
  checkStandingRoster,
  checkWorkerPlacement,
  PersonFacts,
  planFromStandingRosters,
  RosterRuleError,
  selfServiceMode,
} from './rosters.policy';
import { AssignmentFilter, RostersRepository } from './rosters.repository';

const bool = (v: unknown) => Boolean(Number(v));

export function toStandingRosterDto(r: StandingRoster): StandingRosterDto {
  return {
    id: r.id,
    wardId: r.wardId,
    wardInspectorId: r.wardInspectorId,
    inspectorId: r.inspectorId,
    workerId: r.workerId,
    isActive: bool(r.isActive),
    version: Number(r.version),
    createdAt: r.createdAt.toISOString(),
    updatedAt: r.updatedAt.toISOString(),
  };
}

export function toAssignmentDto(a: DailyAssignment): AssignmentDto {
  return {
    id: a.id,
    date: a.shiftDate,
    staffId: a.staffId,
    staffRole: a.staffRole,
    wardId: a.wardId,
    wardInspectorId: a.wardInspectorId,
    inspectorId: a.inspectorId,
    assignmentMode: a.assignmentMode,
    isApproved: bool(a.isApproved),
    approvedById: a.approvedById ?? null,
    approvedAt: a.approvedAt ? a.approvedAt.toISOString() : null,
    assignedById: a.assignedById ?? null,
    version: Number(a.version),
    createdAt: a.createdAt.toISOString(),
  };
}

function personFacts(s: Staff): PersonFacts {
  return { id: s.id, role: s.role, homeWardId: s.homeWardId ?? null, isActive: bool(s.isActive) };
}

function assignmentFacts(a: DailyAssignment): AssignmentFacts {
  return {
    id: a.id,
    staffId: a.staffId,
    staffRole: a.staffRole,
    wardId: a.wardId,
    wardInspectorId: a.wardInspectorId,
    inspectorId: a.inspectorId,
    isApproved: bool(a.isApproved),
  };
}

/** Policy rule failures leave as 422 RULE_VIOLATION with the field that broke the rule. */
function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof RosterRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/** Standing squads and daily assignments (v4 §3). Rules: rosters.policy; storage: RostersRepository. */
@Injectable()
export class RostersService {
  constructor(
    private readonly repo: RostersRepository,
    private readonly staff: StaffService,
    private readonly wards: WardsService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  // ------------------------------------------------------------ Standing rosters

  async listRosters(
    actor: AuthUser,
    query: ListStandingRostersQueryDto,
  ): Promise<StandingRosterPageDto> {
    const filter = {
      wardId: query.wardId,
      inspectorId: query.inspectorId,
      isActive: query.isActive,
    };
    if (actor.role === Role.WARD_INSPECTOR) {
      if (!actor.homeWardId || (query.wardId && query.wardId !== actor.homeWardId))
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.wardId = actor.homeWardId;
    } else if (actor.role === Role.INSPECTOR) {
      if (query.inspectorId && query.inspectorId !== actor.staffId)
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.inspectorId = actor.staffId;
    } else if (actor.role !== Role.ADMIN) {
      throw new AppError(ErrorCode.FORBIDDEN);
    }
    const [items, total] = await this.repo.findRosterPage(
      filter,
      (query.page - 1) * query.pageSize,
      query.pageSize,
    );
    return {
      items: items.map(toStandingRosterDto),
      page: query.page,
      pageSize: query.pageSize,
      total,
    };
  }

  async createRoster(actor: AuthUser, dto: CreateStandingRosterDto): Promise<StandingRosterDto> {
    const [worker, inspector] = await Promise.all([
      this.person(dto.workerId),
      this.person(dto.inspectorId),
    ]);
    const wardId = rule(() => checkStandingRoster(personFacts(worker), personFacts(inspector)));
    if (!canManageWard(actor, wardId)) throw new AppError(ErrorCode.FORBIDDEN);
    const wardInspector = await this.wardInspectorOf(wardId);

    const now = this.clock.now();
    const row: StandingRoster = {
      id: this.ids.next(),
      wardId,
      wardInspectorId: wardInspector.id,
      inspectorId: inspector.id,
      workerId: worker.id,
      isActive: true,
      createdById: actor.staffId,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    await this.uow.run(async (tx) => {
      await this.repo.insertRoster(row, tx);
      await this.audit.write(tx, {
        action: 'ROSTER_CREATED',
        entityType: 'standing_roster',
        entityId: row.id,
        details: { wardId, inspectorId: row.inspectorId, workerId: row.workerId },
      });
    });
    return toStandingRosterDto(row);
  }

  async updateRoster(
    actor: AuthUser,
    id: string,
    dto: UpdateStandingRosterDto,
  ): Promise<StandingRosterDto> {
    const existing = await this.repo.findRoster(id);
    if (!existing) throw new AppError(ErrorCode.NOT_FOUND, 'Standing roster row not found', { id });
    if (!canManageWard(actor, existing.wardId)) throw new AppError(ErrorCode.FORBIDDEN);
    if (Number(existing.version) !== dto.expectedVersion)
      throw this.versionConflict(existing.version, dto.expectedVersion);

    const changes: Partial<StandingRoster> = { updatedAt: this.clock.now() };
    if (dto.inspectorId !== undefined && dto.inspectorId !== existing.inspectorId) {
      const [worker, inspector] = await Promise.all([
        this.person(existing.workerId),
        this.person(dto.inspectorId),
      ]);
      const wardId = rule(() => checkStandingRoster(personFacts(worker), personFacts(inspector)));
      if (!canManageWard(actor, wardId)) throw new AppError(ErrorCode.FORBIDDEN);
      changes.inspectorId = inspector.id;
      changes.wardId = wardId;
      changes.wardInspectorId = (await this.wardInspectorOf(wardId)).id;
    }
    if (dto.isActive !== undefined) changes.isActive = dto.isActive;

    const updated = await this.uow.run(async (tx) => {
      const count = await this.repo.updateRosterVersioned(id, dto.expectedVersion, changes, tx);
      if (count > 0) {
        await this.audit.write(tx, {
          action: 'ROSTER_UPDATED',
          entityType: 'standing_roster',
          entityId: id,
          details: { fields: Object.keys(changes).filter((k) => k !== 'updatedAt') },
        });
      }
      return count;
    });
    if (updated === 0) {
      const current = await this.repo.findRoster(id);
      throw this.versionConflict(current?.version ?? -1, dto.expectedVersion);
    }
    return toStandingRosterDto((await this.repo.findRoster(id))!);
  }

  // ------------------------------------------------------------ Daily assignments

  async listAssignments(
    actor: AuthUser,
    query: ListAssignmentsQueryDto,
  ): Promise<AssignmentPageDto> {
    const filter: AssignmentFilter = {
      date: query.date,
      wardId: query.wardId,
      inspectorId: query.inspectorId,
      isApproved: query.isApproved,
    };
    const scope = assignmentScope(actor);
    if (scope.kind === 'NONE') throw new AppError(ErrorCode.FORBIDDEN);
    if (scope.kind === 'WARD') {
      if (query.wardId && query.wardId !== scope.wardId) throw new AppError(ErrorCode.FORBIDDEN);
      filter.wardId = scope.wardId;
    } else if (scope.kind === 'TEAM') {
      if (query.inspectorId && query.inspectorId !== scope.inspectorId)
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.inspectorId = scope.inspectorId;
    } else if (scope.kind === 'SELF') {
      filter.staffId = scope.staffId;
    }
    const [items, total] = await this.repo.findAssignments(
      filter,
      (query.page - 1) * query.pageSize,
      query.pageSize,
    );
    return { items: items.map(toAssignmentDto), page: query.page, pageSize: query.pageSize, total };
  }

  /** A senior places someone: ADMIN anywhere, WARD_INSPECTOR in their ward. Approved at once. */
  async assign(actor: AuthUser, dto: CreateAssignmentDto): Promise<AssignmentDto> {
    rule(() => checkAssignmentDate(dto.date, this.today(), false));
    const person = await this.person(dto.staffId);
    const placement = await this.placement(person, dto.date, dto.wardId, dto.inspectorId);
    if (!canManageWard(actor, placement.wardId)) throw new AppError(ErrorCode.FORBIDDEN);
    const mode = rule(() => assignedMode(actor, placement.wardId));
    const row = this.newAssignment(dto.date, placement, mode, actor.staffId, null, true);
    await this.insertOne(row, 'ASSIGNMENT_CREATED');
    return toAssignmentDto(row);
  }

  /**
   * Self-service from the phone: an inspector picks a ward, a worker joins an inspector's team.
   * Starts unapproved. A retry with the same clientUuid returns the row it created.
   */
  async selfAssign(actor: AuthUser, dto: SelfAssignmentDto): Promise<AssignmentDto> {
    const previous = await this.repo.findByClientUuid(dto.clientUuid);
    if (previous) {
      if (previous.staffId !== actor.staffId)
        throw new AppError(ErrorCode.CONFLICT, 'This clientUuid is already used');
      return toAssignmentDto(previous);
    }
    const mode = rule(() => selfServiceMode(actor));
    rule(() => checkAssignmentDate(dto.date, this.today(), true));
    const person = await this.person(actor.staffId);
    const placement = await this.placement(person, dto.date, dto.wardId, dto.inspectorId);
    const row = this.newAssignment(dto.date, placement, mode, actor.staffId, dto.clientUuid, false);
    await this.insertOne(row, 'ASSIGNMENT_SELF_SERVICE');
    return toAssignmentDto(row);
  }

  async approve(actor: AuthUser, id: string, expectedVersion: number): Promise<AssignmentDto> {
    const row = await this.repo.findAssignment(id);
    if (!row) throw new AppError(ErrorCode.NOT_FOUND, 'Assignment not found', { id });
    if (!canApprove(actor, assignmentFacts(row))) throw new AppError(ErrorCode.FORBIDDEN);
    if (bool(row.isApproved)) return toAssignmentDto(row);
    if (Number(row.version) !== expectedVersion)
      throw this.versionConflict(row.version, expectedVersion);

    const now = this.clock.now();
    const updated = await this.uow.run(async (tx) => {
      const count = await this.repo.approve(id, expectedVersion, actor.staffId, now, tx);
      if (count > 0) {
        await this.audit.write(tx, {
          action: 'ASSIGNMENT_APPROVED',
          entityType: 'daily_assignment',
          entityId: id,
        });
      }
      return count;
    });
    const current = (await this.repo.findAssignment(id))!;
    if (updated === 0 && !bool(current.isApproved))
      throw this.versionConflict(current.version, expectedVersion);
    return toAssignmentDto(current);
  }

  /**
   * Materializes active standing squads into the day's assignments (approved, mode STANDING_ROSTER).
   * Safe to repeat: people already placed that day keep their placement.
   * ADMIN covers every ward; a WARD_INSPECTOR only their own.
   */
  async generate(actor: AuthUser, date: string): Promise<GenerateAssignmentsResultDto> {
    rule(() => checkAssignmentDate(date, this.today(), false));
    let rosters = await this.repo.findActiveRosters();
    if (actor.role !== Role.ADMIN) {
      if (actor.role !== Role.WARD_INSPECTOR || !actor.homeWardId)
        throw new AppError(ErrorCode.FORBIDDEN);
      rosters = rosters.filter((r) => r.wardId === actor.homeWardId);
    }
    const ids = [...new Set(rosters.flatMap((r) => [r.inspectorId, r.workerId]))];
    const active = await this.staff.findActiveIds(ids);

    const created = await this.uow.run(async (tx) => {
      const placed = new Map(
        (await this.repo.findPlacements(date, tx)).map((p) => [
          p.staffId,
          { wardId: p.wardId, staffRole: p.staffRole },
        ]),
      );
      const plan = planFromStandingRosters(rosters, placed, active);
      const rows = plan.map((p) =>
        this.newAssignment(date, p, 'STANDING_ROSTER', actor.staffId, null, true),
      );
      await this.repo.insertAssignments(rows, tx);
      await this.audit.write(tx, {
        action: 'ASSIGNMENTS_GENERATED',
        entityType: 'daily_assignment',
        details: {
          date,
          created: rows.length,
          wardId: actor.role === Role.ADMIN ? null : actor.homeWardId,
        },
      });
      return rows.length;
    });
    return { date, created };
  }

  // ------------------------------------------------------------ helpers

  /** Where a person goes for the day: an inspector to a ward, a worker into a placed inspector's team. */
  private async placement(
    person: Staff,
    date: string,
    wardId: string | undefined,
    inspectorId: string | undefined,
  ): Promise<{
    staffId: string;
    staffRole: AssignableRole;
    wardId: string;
    wardInspectorId: string;
    inspectorId: string;
  }> {
    if (person.role === Role.INSPECTOR) {
      rule(() => checkInspectorPlacement(personFacts(person)));
      if (!wardId)
        throw new AppError(ErrorCode.RULE_VIOLATION, 'wardId is required to place an inspector', {
          field: 'wardId',
        });
      if (!(await this.wards.exists(wardId))) {
        throw new AppError(ErrorCode.RULE_VIOLATION, 'Ward not found or inactive', {
          field: 'wardId',
        });
      }
      const wardInspector = await this.wardInspectorOf(wardId);
      return {
        staffId: person.id,
        staffRole: 'INSPECTOR',
        wardId,
        wardInspectorId: wardInspector.id,
        inspectorId: person.id,
      };
    }
    if (person.role === Role.WORKER) {
      if (!inspectorId) {
        throw new AppError(ErrorCode.RULE_VIOLATION, 'inspectorId is required to place a worker', {
          field: 'inspectorId',
        });
      }
      const leadRow = await this.repo.findAssignmentFor(date, inspectorId);
      const lead = rule(() =>
        checkWorkerPlacement(personFacts(person), leadRow ? assignmentFacts(leadRow) : null),
      );
      return {
        staffId: person.id,
        staffRole: 'WORKER',
        wardId: lead.wardId,
        wardInspectorId: lead.wardInspectorId,
        inspectorId: lead.staffId,
      };
    }
    throw new AppError(
      ErrorCode.RULE_VIOLATION,
      `A ${person.role} is not placed by daily assignments`,
      { field: 'staffId' },
    );
  }

  private newAssignment(
    date: string,
    p: {
      staffId: string;
      staffRole: AssignableRole;
      wardId: string;
      wardInspectorId: string;
      inspectorId: string;
    },
    mode: AssignmentMode,
    assignedById: string,
    clientUuid: string | null,
    approved: boolean,
  ): DailyAssignment {
    const now = this.clock.now();
    return {
      id: this.ids.next(),
      clientUuid,
      shiftDate: date,
      staffId: p.staffId,
      staffRole: p.staffRole,
      wardId: p.wardId,
      wardInspectorId: p.wardInspectorId,
      inspectorId: p.inspectorId,
      assignmentMode: mode,
      isApproved: approved,
      approvedById: approved ? assignedById : null,
      approvedAt: approved ? now : null,
      assignedById,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
  }

  private async insertOne(row: DailyAssignment, action: string): Promise<void> {
    await this.uow.run(async (tx) => {
      if (await this.repo.findAssignmentFor(row.shiftDate, row.staffId, tx)) {
        throw new AppError(ErrorCode.ASSIGNMENT_EXISTS, undefined, {
          date: row.shiftDate,
          staffId: row.staffId,
        });
      }
      await this.repo.insertAssignments([row], tx);
      await this.audit.write(tx, {
        action,
        entityType: 'daily_assignment',
        entityId: row.id,
        details: {
          date: row.shiftDate,
          staffId: row.staffId,
          wardId: row.wardId,
          mode: row.assignmentMode,
        },
      });
    });
  }

  /** For the attendance engine: a person's daily assignment on an IST date, if any. */
  assignmentFor(date: string, staffId: string): Promise<DailyAssignment | null> {
    return this.repo.findAssignmentFor(date, staffId);
  }

  /** Assignments that put people under this inspector between two IST dates (read scope). */
  async placementsUnder(
    inspectorId: string,
    from: string,
    to: string,
  ): Promise<{ assignmentId: string; staffId: string }[]> {
    return (await this.repo.findForInspector(inspectorId, from, to)).map((a) => ({
      assignmentId: a.id,
      staffId: a.staffId,
    }));
  }

  /** Who is approved to work where on an IST date (daily ward summary, day-close job). */
  async approvedPlacements(
    date: string,
  ): Promise<{ assignmentId: string; staffId: string; wardId: string }[]> {
    return (await this.repo.findApprovedOn(date)).map((a) => ({
      assignmentId: a.id,
      staffId: a.staffId,
      wardId: a.wardId,
    }));
  }

  private async person(id: string): Promise<Staff> {
    const s = await this.staff.findById(id);
    if (!s) throw new AppError(ErrorCode.RULE_VIOLATION, 'Staff member not found', { id });
    return s;
  }

  private async wardInspectorOf(wardId: string): Promise<Staff> {
    const wi = await this.staff.findWardInspector(wardId);
    if (!wi)
      throw new AppError(ErrorCode.RULE_VIOLATION, 'This ward has no active ward inspector', {
        field: 'wardId',
      });
    return wi;
  }

  private today(): string {
    return istDate(this.clock.now());
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, { currentVersion, expectedVersion });
  }
}
