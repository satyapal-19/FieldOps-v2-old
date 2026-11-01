/**
 * Schema-level guarantees of the tasks / complaints / leave / holidays / alerts migration,
 * checked against the real test database.
 */
import { randomUUID } from 'node:crypto';
import { Alert } from '../src/modules/alerts/entities/alert.entity';
import { CitizenComplaint } from '../src/modules/complaints/entities/citizen-complaint.entity';
import { Holiday } from '../src/modules/holidays/entities/holiday.entity';
import { LeaveRequest } from '../src/modules/leave/entities/leave-request.entity';
import { RegularizationRequest } from '../src/modules/leave/entities/regularization-request.entity';
import { Staff } from '../src/modules/staff/entities/staff.entity';
import { TaskUpdate } from '../src/modules/tasks/entities/task-update.entity';
import { Task } from '../src/modules/tasks/entities/task.entity';
import { Role } from '../src/shared/auth/roles';
import { isUniqueViolation } from '../src/shared/database/db-errors';
import { createTestApp, seedStaff, TestApp } from './helpers';

describe('tasks, complaints, leave, holidays and alerts schema (e2e)', () => {
  let t: TestApp;
  let worker: Staff;
  let inspector: Staff;
  const now = new Date('2026-11-02T04:00:00.000Z');

  const repo = <T extends object>(entity: new () => T) => t.dataSource.getRepository(entity);
  const duplicate = (promise: Promise<unknown>) =>
    promise.then(
      () => false,
      (e: unknown) => isUniqueViolation(e),
    );

  function complaint(fields: Partial<CitizenComplaint> = {}): Partial<CitizenComplaint> {
    return {
      id: randomUUID(),
      trackingId: `SMK-2026-${randomUUID().slice(0, 6).toUpperCase()}`,
      category: 'GARBAGE',
      description: 'कचरा उचलला नाही',
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  function task(fields: Partial<Task> = {}): Partial<Task> {
    return {
      id: randomUUID(),
      title: 'Clear drain',
      createdById: inspector.id,
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  function leave(fields: Partial<LeaveRequest> = {}): Partial<LeaveRequest> {
    return {
      id: randomUUID(),
      staffId: worker.id,
      leaveType: 'CASUAL',
      fromDate: '2026-11-05',
      toDate: '2026-11-06',
      daysCount: 2,
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  function alert(fields: Partial<Alert> = {}): Partial<Alert> {
    return {
      id: randomUUID(),
      staffId: worker.id,
      alertType: 'LATE_CHECKIN',
      severity: 'MEDIUM',
      message: 'Late check-in',
      triggeredAt: now,
      ...fields,
    };
  }

  beforeAll(async () => {
    t = await createTestApp();
    worker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'T-WK1' });
    inspector = await seedStaff(t.dataSource, { role: Role.INSPECTOR, employeeCode: 'T-IN1' });
  });

  afterEach(async () => {
    for (const entity of [
      Alert,
      Holiday,
      RegularizationRequest,
      LeaveRequest,
      TaskUpdate,
      Task,
      CitizenComplaint,
    ]) {
      await t.dataSource.createQueryBuilder().delete().from(entity).execute();
    }
  });

  afterAll(async () => {
    await t?.app.close();
  });

  it('stores a Marathi complaint, links a task to it, and keeps tracking IDs unique', async () => {
    const c = complaint();
    await repo(CitizenComplaint).insert(c);
    const tk = task({
      complaintId: c.id!,
      assignedToId: worker.id,
      locationLat: 16.85,
      locationLng: 74.58,
    });
    await repo(Task).insert(tk);
    expect(await repo(CitizenComplaint).findOneByOrFail({ id: c.id! })).toMatchObject({
      description: 'कचरा उचलला नाही',
      status: 'RECEIVED',
    });
    expect(await repo(Task).findOneByOrFail({ id: tk.id! })).toMatchObject({
      status: 'OPEN',
      priority: 'NORMAL',
      locationLat: 16.85,
    });
    expect(
      await duplicate(repo(CitizenComplaint).insert(complaint({ trackingId: c.trackingId }))),
    ).toBe(true);
  });

  it('makes a retried task update from the phone a duplicate', async () => {
    const tk = task();
    await repo(Task).insert(tk);
    const update = (): Partial<TaskUpdate> => ({
      id: randomUUID(),
      clientUuid,
      taskId: tk.id!,
      staffId: worker.id,
      fromStatus: 'OPEN',
      toStatus: 'IN_PROGRESS',
      createdAt: now,
    });
    const clientUuid = randomUUID();
    await repo(TaskUpdate).insert(update());
    expect(await duplicate(repo(TaskUpdate).insert(update()))).toBe(true);
  });

  it.each<[string, () => Promise<unknown>]>([
    ['a task with an unknown status', () => repo(Task).insert(task({ status: 'DONE' as never }))],
    [
      'a complaint with an unknown category',
      () => repo(CitizenComplaint).insert(complaint({ category: 'NOISE' as never })),
    ],
    [
      'leave ending before it starts',
      () => repo(LeaveRequest).insert(leave({ toDate: '2026-11-04' })),
    ],
    ['leave of zero days', () => repo(LeaveRequest).insert(leave({ daysCount: 0 }))],
    [
      'approved leave without a reviewer',
      () => repo(LeaveRequest).insert(leave({ status: 'APPROVED' })),
    ],
    ['a resolved alert without a time', () => repo(Alert).insert(alert({ isResolved: true }))],
    [
      'a regularization with an unknown reason',
      () =>
        repo(RegularizationRequest).insert({
          id: randomUUID(),
          staffId: worker.id,
          attendanceDate: '2026-11-02',
          reasonType: 'FORGOT' as never,
          explanation: 'x',
          createdAt: now,
          updatedAt: now,
        }),
    ],
  ])('refuses %s', async (_label, insert) => {
    await expect(insert()).rejects.toThrow();
  });

  it('accepts reviewed leave', async () => {
    const row = leave({ status: 'APPROVED', reviewedById: inspector.id, reviewedAt: now });
    await repo(LeaveRequest).insert(row);
    expect(await repo(LeaveRequest).findOneByOrFail({ id: row.id! })).toMatchObject({
      fromDate: '2026-11-05',
    });
  });

  it('allows one holiday per date', async () => {
    const holiday = (): Partial<Holiday> => ({
      id: randomUUID(),
      holidayDate: '2026-11-08',
      name: 'Diwali',
      createdAt: now,
      updatedAt: now,
    });
    await repo(Holiday).insert(holiday());
    expect(await duplicate(repo(Holiday).insert(holiday()))).toBe(true);
  });

  it('stops a re-run job raising the same alert twice, while alerts without a key never clash', async () => {
    const dedupeKey = `LATE_CHECKIN:${worker.id}:2026-11-02`;
    await repo(Alert).insert(alert({ dedupeKey, detailsJson: '{"lateMinutes":22}' }));
    expect(await duplicate(repo(Alert).insert(alert({ dedupeKey })))).toBe(true);
    await repo(Alert).insert([alert(), alert()]);
    expect(await repo(Alert).countBy({ staffId: worker.id })).toBe(3);
  });
});
