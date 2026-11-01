/**
 * Schema-level guarantees of the rosters / daily assignments / shifts migration, checked
 * against the real test database. Services add the business rules on top of these.
 */
import { randomUUID } from 'node:crypto';
import { DailyAssignment } from '../src/modules/rosters/entities/daily-assignment.entity';
import { StandingRoster } from '../src/modules/rosters/entities/standing-roster.entity';
import { Shift } from '../src/modules/shifts/entities/shift.entity';
import { Staff } from '../src/modules/staff/entities/staff.entity';
import { Ward } from '../src/modules/wards/entities/ward.entity';
import { Role } from '../src/shared/auth/roles';
import { isUniqueViolation } from '../src/shared/database/db-errors';
import { createTestApp, seedStaff, SQUARE_BOUNDARY, TestApp } from './helpers';

describe('rosters, daily assignments and shifts schema (e2e)', () => {
  let t: TestApp;
  let ward: Ward;
  let otherWard: Ward;
  let wardInspector: Staff;
  let inspector: Staff;
  let otherInspector: Staff;
  let worker: Staff;
  const date = '2026-11-02';

  async function seedWard(code: string): Promise<Ward> {
    const now = new Date();
    const w: Ward = {
      id: randomUUID(),
      code,
      name: `Ward ${code}`,
      nameMr: `प्रभाग ${code}`,
      zone: 'SANGLI',
      boundaryGeojson: JSON.stringify(SQUARE_BOUNDARY),
      isActive: true,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    await t.dataSource.getRepository(Ward).insert(w);
    return w;
  }

  function assignment(fields: Partial<DailyAssignment>): DailyAssignment {
    const now = new Date();
    return {
      id: randomUUID(),
      clientUuid: null,
      shiftDate: date,
      staffId: worker.id,
      staffRole: 'WORKER',
      wardId: ward.id,
      wardInspectorId: wardInspector.id,
      inspectorId: inspector.id,
      assignmentMode: 'ADMIN_ASSIGNED',
      isApproved: false,
      approvedById: null,
      approvedAt: null,
      assignedById: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  function shift(fields: Partial<Shift>): Shift {
    const now = new Date();
    return {
      id: randomUUID(),
      staffId: worker.id,
      shiftDate: date,
      shiftType: 'MORNING',
      startTime: '06:00',
      endTime: '14:00',
      createdById: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
      ...fields,
    };
  }

  const assignments = () => t.dataSource.getRepository(DailyAssignment);

  beforeAll(async () => {
    t = await createTestApp();
    ward = await seedWard('R01');
    otherWard = await seedWard('R02');
    wardInspector = await seedStaff(t.dataSource, {
      role: Role.WARD_INSPECTOR,
      employeeCode: 'R-WI',
    });
    inspector = await seedStaff(t.dataSource, { role: Role.INSPECTOR, employeeCode: 'R-IN1' });
    otherInspector = await seedStaff(t.dataSource, { role: Role.INSPECTOR, employeeCode: 'R-IN2' });
    worker = await seedStaff(t.dataSource, { role: Role.WORKER, employeeCode: 'R-WK1' });
  });

  afterEach(async () => {
    await t.dataSource.createQueryBuilder().delete().from(Shift).execute();
    await t.dataSource.createQueryBuilder().delete().from(DailyAssignment).execute();
    await t.dataSource.createQueryBuilder().delete().from(StandingRoster).execute();
  });

  afterAll(async () => {
    await t?.app.close();
  });

  describe('standing_rosters', () => {
    function roster(fields: Partial<StandingRoster>): StandingRoster {
      const now = new Date();
      return {
        id: randomUUID(),
        wardId: ward.id,
        wardInspectorId: wardInspector.id,
        inspectorId: inspector.id,
        workerId: worker.id,
        isActive: true,
        createdById: null,
        version: 1,
        createdAt: now,
        updatedAt: now,
        ...fields,
      };
    }

    it('stores a squad row and reads booleans back', async () => {
      const row = roster({});
      await t.dataSource.getRepository(StandingRoster).insert(row);
      const read = await t.dataSource.getRepository(StandingRoster).findOneByOrFail({ id: row.id });
      expect(read).toMatchObject({ workerId: worker.id, isActive: true, version: 1 });
    });

    it('puts a worker in at most one standing squad', async () => {
      await t.dataSource.getRepository(StandingRoster).insert(roster({}));
      const err = await t.dataSource
        .getRepository(StandingRoster)
        .insert(roster({ inspectorId: otherInspector.id }))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    it('refuses a worker who is their own inspector', async () => {
      await expect(
        t.dataSource.getRepository(StandingRoster).insert(roster({ inspectorId: worker.id })),
      ).rejects.toThrow();
    });
  });

  describe('daily_assignments', () => {
    it('defaults to unapproved and hydrates the date as YYYY-MM-DD', async () => {
      const row = assignment({});
      // Leave is_approved out of the INSERT so the column default applies.
      await assignments().insert({ ...row, isApproved: undefined });
      const read = await assignments().findOneByOrFail({ id: row.id });
      expect(read).toMatchObject({ shiftDate: date, isApproved: false, version: 1 });
    });

    it('allows one assignment per worker per day', async () => {
      await assignments().insert(assignment({}));
      const err = await assignments()
        .insert(assignment({ wardId: otherWard.id, inspectorId: otherInspector.id }))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
      await assignments().insert(assignment({ shiftDate: '2026-11-03' }));
    });

    it('allows one ward per inspector per day, while different inspectors share a date', async () => {
      const inspectorRow = (staff: Staff, wardId: string) =>
        assignment({ staffId: staff.id, staffRole: 'INSPECTOR', inspectorId: staff.id, wardId });
      await assignments().insert(inspectorRow(inspector, ward.id));
      await assignments().insert(inspectorRow(otherInspector, ward.id));
      const err = await assignments()
        .insert(inspectorRow(inspector, otherWard.id))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    // Factories, because the staff rows exist only after beforeAll.
    it.each<[string, () => Partial<DailyAssignment>]>([
      [
        'an inspector row led by someone else',
        () => ({ staffRole: 'INSPECTOR', staffId: otherInspector.id }),
      ],
      ['a worker row that leads itself', () => ({ inspectorId: worker.id })],
      ['an unknown assignment mode', () => ({ assignmentMode: 'SELF_SERVICE' as never })],
      ['an approval without a time', () => ({ isApproved: true, approvedAt: null })],
    ])('refuses %s', async (_label, fields) => {
      await expect(assignments().insert(assignment(fields()))).rejects.toThrow();
    });

    it('makes an offline retry with the same client UUID a duplicate', async () => {
      const clientUuid = randomUUID();
      await assignments().insert(assignment({ clientUuid }));
      const err = await assignments()
        .insert(assignment({ clientUuid, shiftDate: '2026-11-03' }))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    it('lets many web-created rows leave client_uuid empty', async () => {
      await assignments().insert(assignment({}));
      await assignments().insert(assignment({ shiftDate: '2026-11-03' }));
      expect(await assignments().countBy({ staffId: worker.id })).toBe(2);
    });
  });

  describe('shifts', () => {
    it('keeps one shift per staff member per day, including overnight shifts', async () => {
      await t.dataSource
        .getRepository(Shift)
        .insert(shift({ shiftType: 'NIGHT', startTime: '22:00', endTime: '06:00' }));
      const err = await t.dataSource
        .getRepository(Shift)
        .insert(shift({}))
        .catch((e: unknown) => e);
      expect(isUniqueViolation(err)).toBe(true);
    });

    it.each([
      ['an unknown shift type', { shiftType: 'SPLIT' as never }],
      ['a malformed start time', { startTime: '6:00' }],
      ['a zero-length shift', { startTime: '06:00', endTime: '06:00' }],
    ])('refuses %s', async (_label, fields) => {
      await expect(t.dataSource.getRepository(Shift).insert(shift(fields))).rejects.toThrow();
    });
  });
});
