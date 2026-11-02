import { Injectable } from '@nestjs/common';
import { randomInt } from 'node:crypto';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { maskPhone } from '../staff/staff.policy';
import { TasksService } from '../tasks/tasks.service';
import { WardsService } from '../wards/wards.service';
import type {
  AssignComplaintDto,
  ComplaintDto,
  ComplaintPageDto,
  ComplaintStatusDto,
  ListComplaintsQueryDto,
  PublicComplaintDto,
  SubmitComplaintDto,
} from './dto/complaint.dto';
import { CitizenComplaint } from './entities/citizen-complaint.entity';
import {
  canManageComplaint,
  canSeeCitizenPhone,
  canSeeComplaint,
  ComplaintRuleError,
  complaintScope,
  formatTrackingId,
  nextComplaintStatus,
  normalizeTrackingId,
  publicStatus,
  TRACKING_ALPHABET,
  TRACKING_RANDOM_LENGTH,
} from './complaints.policy';
import { ComplaintChanges, ComplaintsRepository } from './complaints.repository';

const num = (v: number | null | undefined) => (v === null || v === undefined ? null : Number(v));

function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof ComplaintRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/**
 * Citizen complaints (v4 §10): a public, sign-in-free portal to file and track, and staff
 * routing that raises tasks. Rules: complaints.policy; the work itself happens in tasks.
 */
@Injectable()
export class ComplaintsService {
  constructor(
    private readonly repo: ComplaintsRepository,
    private readonly tasks: TasksService,
    private readonly wards: WardsService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  // ------------------------------------------------------------ Public

  async submit(dto: SubmitComplaintDto): Promise<PublicComplaintDto> {
    if (dto.clientUuid) {
      const previous = await this.repo.findByClientUuid(dto.clientUuid);
      if (previous) return this.toPublic(previous);
    }
    if ((dto.lat === undefined) !== (dto.lng === undefined)) {
      throw new AppError(ErrorCode.VALIDATION_FAILED, 'Send both lat and lng, or neither');
    }
    let wardId: string | null = null;
    if (dto.wardId) {
      if (!(await this.wards.exists(dto.wardId))) {
        throw new AppError(ErrorCode.RULE_VIOLATION, 'Ward not found', { field: 'wardId' });
      }
      wardId = dto.wardId;
    } else if (dto.lat !== undefined && dto.lng !== undefined) {
      wardId = (await this.wards.locate({ latitude: dto.lat, longitude: dto.lng }))?.id ?? null;
    }

    const now = this.clock.now();
    const year = Number(istDate(now).slice(0, 4));
    // A clash of the random part is very unlikely; retry a few times rather than use a sequence.
    for (let attempt = 0; attempt < 5; attempt++) {
      const row: CitizenComplaint = {
        id: this.ids.next(),
        trackingId: formatTrackingId(
          year,
          Array.from({ length: TRACKING_RANDOM_LENGTH }, () => randomInt(TRACKING_ALPHABET.length)),
        ),
        clientUuid: dto.clientUuid ?? null,
        citizenName: dto.citizenName?.trim() ?? null,
        citizenPhone: dto.citizenPhone ?? null,
        wardId,
        category: dto.category,
        description: dto.description.trim(),
        photoKey: null,
        lat: dto.lat ?? null,
        lng: dto.lng ?? null,
        status: 'RECEIVED',
        resolvedAt: null,
        version: 1,
        createdAt: now,
        updatedAt: now,
      };
      try {
        await this.uow.run(async (tx) => {
          await this.repo.insert(row, tx);
          await this.audit.write(tx, {
            action: 'COMPLAINT_SUBMITTED',
            entityType: 'complaint',
            entityId: row.id,
            actorId: null,
            actorRole: 'CITIZEN',
            details: { trackingId: row.trackingId, category: row.category, wardId },
          });
        });
        return this.toPublic(row);
      } catch (error) {
        if (!isUniqueViolation(error)) throw error;
        if (dto.clientUuid) {
          const winner = await this.repo.findByClientUuid(dto.clientUuid);
          if (winner) return this.toPublic(winner);
        }
      }
    }
    throw new AppError(ErrorCode.INTERNAL_ERROR, 'Could not allocate a tracking ID; try again');
  }

  async track(trackingId: string): Promise<PublicComplaintDto> {
    const id = normalizeTrackingId(trackingId);
    const row = id ? await this.repo.findByTrackingId(id) : null;
    if (!row) throw new AppError(ErrorCode.NOT_FOUND, 'No complaint with this tracking ID');
    return this.toPublic(row);
  }

  // ------------------------------------------------------------ Staff

  async list(actor: AuthUser, q: ListComplaintsQueryDto): Promise<ComplaintPageDto> {
    const scope = complaintScope(actor);
    if (scope.kind === 'NONE') throw new AppError(ErrorCode.FORBIDDEN);
    const filter: { wardId?: string; status?: CitizenComplaint['status']; unrouted?: boolean } = {
      wardId: q.wardId,
      status: q.status,
      unrouted: q.unrouted,
    };
    if (scope.kind === 'WARD') {
      if ((q.wardId && q.wardId !== scope.wardId) || q.unrouted)
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.wardId = scope.wardId;
    }
    const [items, total] = await this.repo.findPage(filter, (q.page - 1) * q.pageSize, q.pageSize);
    return {
      items: items.map((c) => this.toDto(actor, c)),
      page: q.page,
      pageSize: q.pageSize,
      total,
    };
  }

  async get(actor: AuthUser, id: string): Promise<ComplaintDto> {
    const row = await this.visible(actor, id);
    return { ...this.toDto(actor, row), tasks: await this.tasks.tasksForComplaint(id) };
  }

  /** Routes a complaint by raising a task for someone; the complaint takes the assignee's ward if it had none. */
  async assign(actor: AuthUser, id: string, dto: AssignComplaintDto): Promise<ComplaintDto> {
    const row = await this.managed(actor, id);
    this.checkVersion(row, dto.expectedVersion);
    const to = rule(() => nextComplaintStatus('ASSIGN', row.status, []));

    await this.uow.run(async (tx) => {
      const task = await this.tasks.create(
        actor,
        {
          title: `Complaint ${row.trackingId}: ${row.category.replace('_', ' ').toLowerCase()}`,
          description: row.description,
          priority: dto.priority,
          assignedToId: dto.assignedToId,
          dueAt: dto.dueAt,
          locationLat: num(row.lat) ?? undefined,
          locationLng: num(row.lng) ?? undefined,
        },
        { complaintId: row.id },
        tx,
      );
      const changes: ComplaintChanges = {
        status: to,
        wardId: row.wardId ?? task.wardId,
        updatedAt: this.clock.now(),
      };
      const n = await this.repo.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (n === 0) throw this.versionConflict(row.version, dto.expectedVersion);
      await this.audit.write(tx, {
        action: 'COMPLAINT_ASSIGNED',
        entityType: 'complaint',
        entityId: id,
        details: { taskId: task.id, assignedToId: dto.assignedToId },
      });
    });
    return this.get(actor, id);
  }

  async changeStatus(actor: AuthUser, id: string, dto: ComplaintStatusDto): Promise<ComplaintDto> {
    const row = await this.managed(actor, id);
    this.checkVersion(row, dto.expectedVersion);
    const taskStatuses = (await this.tasks.tasksForComplaint(id)).map((t) => t.status);
    const to = rule(() => nextComplaintStatus(dto.action, row.status, taskStatuses));
    const now = this.clock.now();
    const changes: ComplaintChanges = { status: to, updatedAt: now };
    if (to === 'RESOLVED') changes.resolvedAt = now;
    await this.uow.run(async (tx) => {
      const n = await this.repo.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (n === 0) throw this.versionConflict(row.version, dto.expectedVersion);
      await this.audit.write(tx, {
        action: `COMPLAINT_${dto.action}`,
        entityType: 'complaint',
        entityId: id,
        details: { from: row.status, to },
      });
    });
    return this.get(actor, id);
  }

  // ------------------------------------------------------------ helpers

  private async toPublic(c: CitizenComplaint): Promise<PublicComplaintDto> {
    const taskStatuses = (await this.tasks.tasksForComplaint(c.id)).map((t) => t.status);
    const wardCode = c.wardId ? (await this.wards.get(c.wardId)).code : null;
    return {
      trackingId: c.trackingId,
      category: c.category,
      status: publicStatus(c.status, taskStatuses),
      wardCode,
      createdAt: c.createdAt.toISOString(),
      resolvedAt: c.resolvedAt ? c.resolvedAt.toISOString() : null,
    };
  }

  private toDto(actor: AuthUser, c: CitizenComplaint): ComplaintDto {
    const phone = c.citizenPhone ?? null;
    return {
      id: c.id,
      trackingId: c.trackingId,
      category: c.category,
      description: c.description,
      status: c.status,
      wardId: c.wardId ?? null,
      citizenName: c.citizenName ?? null,
      citizenPhone: phone && !canSeeCitizenPhone(actor) ? maskPhone(phone) : phone,
      lat: num(c.lat),
      lng: num(c.lng),
      resolvedAt: c.resolvedAt ? c.resolvedAt.toISOString() : null,
      version: Number(c.version),
      createdAt: c.createdAt.toISOString(),
    };
  }

  private async visible(actor: AuthUser, id: string): Promise<CitizenComplaint> {
    const row = await this.repo.findById(id);
    if (!row || !canSeeComplaint(actor, row.wardId ?? null)) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Complaint not found', { id });
    }
    return row;
  }

  private async managed(actor: AuthUser, id: string): Promise<CitizenComplaint> {
    const row = await this.visible(actor, id);
    if (!canManageComplaint(actor, row.wardId ?? null)) throw new AppError(ErrorCode.FORBIDDEN);
    return row;
  }

  private checkVersion(row: CitizenComplaint, expectedVersion: number): void {
    if (Number(row.version) !== expectedVersion)
      throw this.versionConflict(row.version, expectedVersion);
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
      currentVersion: Number(currentVersion),
      expectedVersion,
    });
  }
}
