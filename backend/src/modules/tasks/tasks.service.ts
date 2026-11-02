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
import type { Staff } from '../staff/entities/staff.entity';
import { StaffService } from '../staff/staff.service';
import type {
  AssigneeUpdateDto,
  CreateTaskDto,
  ListTasksQueryDto,
  ReassignTaskDto,
  SupervisorActionDto,
  TaskDto,
  TaskPageDto,
  TaskUpdateDto,
} from './dto/task.dto';
import { TaskUpdate } from './entities/task-update.entity';
import { Task, TaskStatus } from './entities/task.entity';
import {
  canSeeTask,
  canSupervise,
  checkCanAssign,
  checkReassignable,
  nextStatus,
  PersonFacts,
  TaskFacts,
  TaskRuleError,
  taskScope,
} from './tasks.policy';
import { TaskChanges, TaskFilter, TasksRepository } from './tasks.repository';

const iso = (d: Date | null | undefined) => (d ? d.toISOString() : null);
const num = (v: number | null | undefined) => (v === null || v === undefined ? null : Number(v));

export function toTaskDto(t: Task): TaskDto {
  return {
    id: t.id,
    title: t.title,
    titleMr: t.titleMr ?? null,
    description: t.description ?? null,
    priority: t.priority,
    status: t.status,
    wardId: t.wardId ?? null,
    assignedToId: t.assignedToId ?? null,
    createdById: t.createdById,
    complaintId: t.complaintId ?? null,
    locationLat: num(t.locationLat),
    locationLng: num(t.locationLng),
    locationLabel: t.locationLabel ?? null,
    dueAt: iso(t.dueAt),
    startedAt: iso(t.startedAt),
    submittedAt: iso(t.submittedAt),
    closedAt: iso(t.closedAt),
    completionNote: t.completionNote ?? null,
    rejectionReason: t.rejectionReason ?? null,
    rejectionCount: Number(t.rejectionCount),
    version: Number(t.version),
    createdAt: t.createdAt.toISOString(),
  };
}

function toTaskUpdateDto(u: TaskUpdate): TaskUpdateDto {
  return {
    id: u.id,
    staffId: u.staffId,
    fromStatus: u.fromStatus,
    toStatus: u.toStatus,
    note: u.note ?? null,
    photoKey: u.photoKey ?? null,
    createdAt: u.createdAt.toISOString(),
  };
}

function facts(s: Staff): PersonFacts {
  return {
    id: s.id,
    role: s.role,
    homeWardId: s.homeWardId ?? null,
    reportsToId: s.reportsToId ?? null,
    isActive: Boolean(Number(s.isActive)),
  };
}

function taskFacts(t: Task): TaskFacts {
  return {
    wardId: t.wardId ?? null,
    assignedToId: t.assignedToId ?? null,
    createdById: t.createdById,
    status: t.status,
  };
}

function rule<T>(fn: () => T): T {
  try {
    return fn();
  } catch (error) {
    if (error instanceof TaskRuleError) {
      throw new AppError(ErrorCode.RULE_VIOLATION, error.message, { field: error.field });
    }
    throw error;
  }
}

/** Optional link and fields set by other modules (complaints) when they raise a task. */
export interface TaskOrigin {
  complaintId?: string;
}

/**
 * Field tasks (v4 §8). Rules: tasks.policy. Every status change also writes a task_updates row
 * (the history) in the same transaction; phone updates are retry-safe through its client UUID.
 */
@Injectable()
export class TasksService {
  constructor(
    private readonly repo: TasksRepository,
    private readonly staff: StaffService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  async list(actor: AuthUser, q: ListTasksQueryDto): Promise<TaskPageDto> {
    const filter: TaskFilter = { status: q.status, assignedToId: q.assignedToId };
    const scope = taskScope(actor);
    if (scope.kind === 'WARD') filter.wardId = scope.wardId;
    else if (scope.kind === 'TEAM') {
      filter.team = {
        inspectorId: scope.inspectorId,
        memberIds: await this.staff.findIds({ reportsToId: scope.inspectorId }),
      };
    } else if (scope.kind === 'MINE') {
      if (q.assignedToId && q.assignedToId !== actor.staffId)
        throw new AppError(ErrorCode.FORBIDDEN);
      filter.assignedToId = actor.staffId;
    }
    const [items, total] = await this.repo.findPage(filter, (q.page - 1) * q.pageSize, q.pageSize);
    return { items: items.map(toTaskDto), page: q.page, pageSize: q.pageSize, total };
  }

  async get(actor: AuthUser, id: string): Promise<TaskDto> {
    return toTaskDto((await this.visible(actor, id)).task);
  }

  async history(actor: AuthUser, id: string): Promise<TaskUpdateDto[]> {
    await this.visible(actor, id);
    return (await this.repo.findUpdates(id)).map(toTaskUpdateDto);
  }

  /** For other modules (complaints): the tasks raised for a complaint. */
  async tasksForComplaint(complaintId: string): Promise<TaskDto[]> {
    return (await this.repo.findByComplaint(complaintId)).map(toTaskDto);
  }

  async create(
    actor: AuthUser,
    dto: CreateTaskDto,
    origin: TaskOrigin = {},
    tx?: EntityManager,
  ): Promise<TaskDto> {
    const assignee = await this.person(dto.assignedToId, 'assignedToId');
    rule(() => checkCanAssign(actor, facts(assignee)));
    const dueAt = dto.dueAt ? new Date(dto.dueAt) : null;
    const now = this.clock.now();
    if (dueAt && dueAt <= now) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'dueAt must be in the future', {
        field: 'dueAt',
      });
    }
    const task: Task = {
      id: this.ids.next(),
      title: dto.title.trim(),
      titleMr: dto.titleMr?.trim() ?? null,
      description: dto.description?.trim() ?? null,
      priority: dto.priority ?? 'NORMAL',
      status: 'OPEN',
      wardId: assignee.homeWardId ?? null,
      assignedToId: assignee.id,
      createdById: actor.staffId,
      complaintId: origin.complaintId ?? null,
      locationLat: dto.locationLat ?? null,
      locationLng: dto.locationLng ?? null,
      locationLabel: dto.locationLabel?.trim() ?? null,
      dueAt,
      startedAt: null,
      submittedAt: null,
      closedAt: null,
      beforePhotoKey: null,
      afterPhotoKey: null,
      completionNote: null,
      rejectionReason: null,
      rejectionCount: 0,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    const work = async (t: EntityManager) => {
      await this.repo.insertTask(task, t);
      await this.audit.write(t, {
        action: 'TASK_CREATED',
        entityType: 'task',
        entityId: task.id,
        details: {
          assignedToId: task.assignedToId,
          wardId: task.wardId,
          complaintId: task.complaintId,
        },
      });
    };
    // Inside the caller's transaction when given (a complaint and its task commit together).
    await (tx ? work(tx) : this.uow.run(work));
    return toTaskDto(task);
  }

  /** START / SUBMIT from the assignee's phone. A retry with the same clientUuid changes nothing. */
  async assigneeUpdate(actor: AuthUser, id: string, dto: AssigneeUpdateDto): Promise<TaskDto> {
    const previous = await this.repo.findUpdateByClientUuid(dto.clientUuid);
    if (previous) return this.retried(actor, id, previous);

    const task = await this.repo.findTask(id);
    if (!task || task.assignedToId !== actor.staffId) {
      // Only the assignee updates from the phone; others may not even learn the task exists.
      if (task && canSeeTask(actor, taskFacts(task), null)) throw new AppError(ErrorCode.FORBIDDEN);
      throw this.notFound(id);
    }
    const to = rule(() => nextStatus(dto.action, task.status));
    if (dto.action === 'SUBMIT' && !dto.note?.trim() && !dto.photoKey) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'Add a note or a photo when submitting', {
        field: 'note',
      });
    }
    const now = this.clock.now();
    const changes: TaskChanges = { status: to, updatedAt: now };
    if (dto.action === 'START' && !task.startedAt) changes.startedAt = now;
    if (dto.action === 'SUBMIT') {
      changes.submittedAt = now;
      changes.completionNote = dto.note?.trim() ?? null;
      if (dto.photoKey) changes.afterPhotoKey = dto.photoKey;
    }
    try {
      await this.transition(task, changes, actor, `TASK_${dto.action}`, {
        clientUuid: dto.clientUuid,
        note: dto.note?.trim() ?? null,
        photoKey: dto.photoKey ?? null,
        lat: dto.lat ?? null,
        lng: dto.lng ?? null,
      });
    } catch (error) {
      if (isUniqueViolation(error)) {
        const winner = await this.repo.findUpdateByClientUuid(dto.clientUuid);
        if (winner) return this.retried(actor, id, winner);
      }
      throw error;
    }
    return toTaskDto((await this.repo.findTask(id))!);
  }

  /** APPROVE / REJECT / ESCALATE / CLOSE by a supervisor of the task. */
  async supervise(actor: AuthUser, id: string, dto: SupervisorActionDto): Promise<TaskDto> {
    const { task } = await this.supervised(actor, id);
    this.checkVersion(task, dto.expectedVersion);
    const to = rule(() => nextStatus(dto.action, task.status));
    const now = this.clock.now();
    const changes: TaskChanges = { status: to, updatedAt: now };
    if (dto.action === 'REJECT') {
      if (!dto.reason?.trim()) {
        throw new AppError(ErrorCode.RULE_VIOLATION, 'Give a reason when rejecting', {
          field: 'reason',
        });
      }
      changes.rejectionReason = dto.reason.trim();
      changes.rejectionCount = Number(task.rejectionCount) + 1;
    }
    if (dto.action === 'CLOSE') changes.closedAt = now;
    await this.transition(task, changes, actor, `TASK_${dto.action}`, {
      note: dto.reason?.trim() ?? null,
    });
    return toTaskDto((await this.repo.findTask(id))!);
  }

  /** Hands an unfinished task to someone else in the supervisor's scope; it starts again as OPEN. */
  async reassign(actor: AuthUser, id: string, dto: ReassignTaskDto): Promise<TaskDto> {
    const { task } = await this.supervised(actor, id);
    this.checkVersion(task, dto.expectedVersion);
    rule(() => checkReassignable(task.status));
    const assignee = await this.person(dto.assignedToId, 'assignedToId');
    rule(() => checkCanAssign(actor, facts(assignee)));
    const changes: TaskChanges = {
      status: 'OPEN',
      assignedToId: assignee.id,
      wardId: assignee.homeWardId ?? null,
      startedAt: null,
      updatedAt: this.clock.now(),
    };
    await this.transition(task, changes, actor, 'TASK_REASSIGNED', {
      note: `Reassigned to ${assignee.employeeCode}`,
    });
    return toTaskDto((await this.repo.findTask(id))!);
  }

  // ------------------------------------------------------------ helpers

  /** One transaction: the guarded task update, its history row and the audit row. */
  private async transition(
    task: Task,
    changes: TaskChanges,
    actor: AuthUser,
    action: string,
    update: {
      clientUuid?: string;
      note: string | null;
      photoKey?: string | null;
      lat?: number | null;
      lng?: number | null;
    },
  ): Promise<void> {
    await this.uow.run(async (tx: EntityManager) => {
      const n = await this.repo.updateTask(task.id, task.status, Number(task.version), changes, tx);
      if (n === 0) {
        throw new AppError(ErrorCode.VERSION_CONFLICT, 'The task changed meanwhile; reload it', {
          currentVersion: Number(task.version),
        });
      }
      await this.repo.insertUpdate(
        {
          id: this.ids.next(),
          clientUuid: update.clientUuid ?? null,
          taskId: task.id,
          staffId: actor.staffId,
          fromStatus: task.status,
          toStatus: changes.status as TaskStatus,
          note: update.note,
          photoKey: update.photoKey ?? null,
          lat: update.lat ?? null,
          lng: update.lng ?? null,
          createdAt: changes.updatedAt!,
        },
        tx,
      );
      await this.audit.write(tx, {
        action,
        entityType: 'task',
        entityId: task.id,
        details: {
          from: task.status,
          to: changes.status,
          assignedToId: changes.assignedToId ?? task.assignedToId,
        },
      });
    });
  }

  private async retried(actor: AuthUser, id: string, previous: TaskUpdate): Promise<TaskDto> {
    if (previous.taskId !== id || previous.staffId !== actor.staffId) {
      throw new AppError(ErrorCode.CONFLICT, 'This clientUuid is already used');
    }
    return toTaskDto((await this.repo.findTask(id))!);
  }

  private async visible(
    actor: AuthUser,
    id: string,
  ): Promise<{ task: Task; assignee: PersonFacts | null }> {
    const task = await this.repo.findTask(id);
    if (!task) throw this.notFound(id);
    const assignee = task.assignedToId ? await this.staff.findById(task.assignedToId) : null;
    const assigneeFacts = assignee ? facts(assignee) : null;
    if (!canSeeTask(actor, taskFacts(task), assigneeFacts)) throw this.notFound(id);
    return { task, assignee: assigneeFacts };
  }

  private async supervised(actor: AuthUser, id: string): Promise<{ task: Task }> {
    const { task, assignee } = await this.visible(actor, id);
    if (!canSupervise(actor, taskFacts(task), assignee)) throw new AppError(ErrorCode.FORBIDDEN);
    return { task };
  }

  private async person(id: string, field: string): Promise<Staff> {
    const s = await this.staff.findById(id);
    if (!s) throw new AppError(ErrorCode.RULE_VIOLATION, 'Staff member not found', { field });
    return s;
  }

  private checkVersion(task: Task, expectedVersion: number): void {
    if (Number(task.version) !== expectedVersion) {
      throw new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
        currentVersion: Number(task.version),
        expectedVersion,
      });
    }
  }

  private notFound(id: string): AppError {
    return new AppError(ErrorCode.NOT_FOUND, 'Task not found', { id });
  }
}
