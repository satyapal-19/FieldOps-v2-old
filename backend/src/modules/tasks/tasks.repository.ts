import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, EntityManager, Repository } from 'typeorm';
import { TaskUpdate } from './entities/task-update.entity';
import { Task, TaskStatus } from './entities/task.entity';

export interface TaskFilter {
  status?: TaskStatus;
  wardId?: string;
  assignedToId?: string;
  complaintId?: string;
  /** An inspector's view: tasks they created, hold, or that their team members hold. */
  team?: { inspectorId: string; memberIds: readonly string[] };
}

export type TaskChanges = Partial<
  Pick<
    Task,
    | 'status'
    | 'assignedToId'
    | 'wardId'
    | 'startedAt'
    | 'submittedAt'
    | 'closedAt'
    | 'afterPhotoKey'
    | 'completionNote'
    | 'rejectionReason'
    | 'rejectionCount'
    | 'updatedAt'
  >
>;

/** The only place that queries tasks and task_updates. Pass `tx` inside a UnitOfWork. */
@Injectable()
export class TasksRepository {
  constructor(
    @InjectRepository(Task) private readonly tasks: Repository<Task>,
    @InjectRepository(TaskUpdate) private readonly updates: Repository<TaskUpdate>,
  ) {}

  private tr(tx?: EntityManager): Repository<Task> {
    return tx ? tx.getRepository(Task) : this.tasks;
  }

  private ur(tx?: EntityManager): Repository<TaskUpdate> {
    return tx ? tx.getRepository(TaskUpdate) : this.updates;
  }

  findTask(id: string, tx?: EntityManager): Promise<Task | null> {
    return this.tr(tx).findOne({ where: { id } });
  }

  findByComplaint(complaintId: string): Promise<Task[]> {
    return this.tasks.find({ where: { complaintId }, order: { createdAt: 'ASC' } });
  }

  findPage(filter: TaskFilter, skip: number, take: number): Promise<[Task[], number]> {
    const qb = this.tasks.createQueryBuilder('t');
    if (filter.status) qb.andWhere('t.status = :status', { status: filter.status });
    if (filter.wardId) qb.andWhere('t.wardId = :wardId', { wardId: filter.wardId });
    if (filter.assignedToId)
      qb.andWhere('t.assignedToId = :assignedToId', { assignedToId: filter.assignedToId });
    if (filter.complaintId)
      qb.andWhere('t.complaintId = :complaintId', { complaintId: filter.complaintId });
    const team = filter.team;
    if (team) {
      qb.andWhere(
        new Brackets((w) => {
          w.where('t.createdById = :lead', { lead: team.inspectorId }).orWhere(
            't.assignedToId = :lead',
            {
              lead: team.inspectorId,
            },
          );
          // A team is one inspector's direct reports: a few dozen people, far below Oracle's IN limit.
          if (team.memberIds.length > 0)
            w.orWhere('t.assignedToId IN (:...members)', { members: [...team.memberIds] });
        }),
      );
    }
    return qb.orderBy('t.createdAt', 'DESC').skip(skip).take(take).getManyAndCount();
  }

  async insertTask(row: Task, tx?: EntityManager): Promise<void> {
    await this.tr(tx).insert(row);
  }

  /**
   * Applies changes only while the task is still in `fromStatus` (and, for supervisor edits,
   * still has `expectedVersion`). Returns rows updated (0 or 1).
   */
  async updateTask(
    id: string,
    fromStatus: TaskStatus,
    currentVersion: number,
    changes: TaskChanges,
    tx?: EntityManager,
  ): Promise<number> {
    const result = await this.tr(tx).update(
      { id, status: fromStatus, version: currentVersion },
      { ...changes, version: currentVersion + 1 },
    );
    return result.affected ?? 0;
  }

  findUpdateByClientUuid(clientUuid: string): Promise<TaskUpdate | null> {
    return this.updates.findOne({ where: { clientUuid } });
  }

  findUpdates(taskId: string): Promise<TaskUpdate[]> {
    return this.updates.find({ where: { taskId }, order: { createdAt: 'ASC' } });
  }

  async insertUpdate(row: TaskUpdate, tx?: EntityManager): Promise<void> {
    await this.ur(tx).insert(row);
  }
}
