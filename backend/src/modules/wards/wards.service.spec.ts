import type { EntityManager } from 'typeorm';
import type { AuditEntry, AuditWriter } from '../../shared/audit/audit-writer';
import { FixedClock } from '../../shared/clock/clock';
import type { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { SequenceIdGenerator } from '../../shared/ids/id-generator';
import type { CreateWardDto } from './dto/ward.dto';
import { Ward } from './entities/ward.entity';
import { WardChanges, WardsRepository } from './wards.repository';
import { WardsService } from './wards.service';

/** In-memory stand-in for WardsRepository, with the same optimistic-lock behaviour. */
class FakeWardsRepository {
  readonly rows = new Map<string, Ward>();

  async findPage(skip: number, take: number): Promise<[Ward[], number]> {
    const all = [...this.rows.values()].sort((a, b) => a.code.localeCompare(b.code));
    return [all.slice(skip, skip + take).map((w) => ({ ...w })), all.length];
  }

  async findById(id: string): Promise<Ward | null> {
    const w = this.rows.get(id);
    return w ? { ...w } : null;
  }

  async findByCode(code: string): Promise<Ward | null> {
    return [...this.rows.values()].find((w) => w.code === code) ?? null;
  }

  async insert(ward: Ward): Promise<void> {
    this.rows.set(ward.id, { ...ward });
  }

  async updateVersioned(id: string, expectedVersion: number, changes: WardChanges): Promise<number> {
    const w = this.rows.get(id);
    if (!w || w.version !== expectedVersion) return 0;
    this.rows.set(id, { ...w, ...changes, version: expectedVersion + 1 });
    return 1;
  }
}

/** Runs the work directly; the fake repository ignores the transaction. */
const fakeUow = { run: <T>(work: (tx: EntityManager) => Promise<T>) => work({} as EntityManager) };

class RecordingAuditWriter {
  readonly entries: AuditEntry[] = [];
  async write(_tx: EntityManager, entry: AuditEntry): Promise<void> {
    this.entries.push(entry);
  }
}

const boundary = {
  type: 'Polygon',
  coordinates: [
    [
      [74.58, 16.85],
      [74.59, 16.85],
      [74.59, 16.86],
      [74.58, 16.86],
      [74.58, 16.85],
    ],
  ],
};

const createDto = (overrides: Partial<CreateWardDto> = {}): CreateWardDto => ({
  code: 'w04',
  name: 'Ward 4 - Vishrambag',
  nameMr: 'प्रभाग ४ - विश्रामबाग',
  zone: 'SANGLI',
  boundary,
  ...overrides,
});

async function expectAppError(promise: Promise<unknown>, code: ErrorCode): Promise<void> {
  await expect(promise).rejects.toBeInstanceOf(AppError);
  await expect(promise).rejects.toMatchObject({ code });
}

describe('WardsService', () => {
  let repo: FakeWardsRepository;
  let clock: FixedClock;
  let service: WardsService;
  let audit: RecordingAuditWriter;

  beforeEach(() => {
    repo = new FakeWardsRepository();
    clock = new FixedClock('2026-10-28T00:30:00Z');
    audit = new RecordingAuditWriter();
    service = new WardsService(
      repo as unknown as WardsRepository,
      clock,
      new SequenceIdGenerator('ward'),
      fakeUow as unknown as UnitOfWork,
      audit as unknown as AuditWriter,
    );
  });

  it('writes an audit entry for each change', async () => {
    const ward = await service.create(createDto());
    await service.update(ward.id, { expectedVersion: 1, name: 'Ward 4' });
    expect(audit.entries.map((e) => e.action)).toEqual(['WARD_CREATED', 'WARD_UPDATED']);
    expect(audit.entries[1].details).toEqual({ fields: ['name'] });
  });

  it('creates a ward with a normalised code, app-generated ID and clock time', async () => {
    const ward = await service.create(createDto());
    expect(ward).toMatchObject({
      id: 'ward-0001',
      code: 'W04',
      zone: 'SANGLI',
      isActive: true,
      version: 1,
      createdAt: '2026-10-28T00:30:00.000Z',
    });
    expect(ward.boundary).toEqual(boundary);
  });

  it('rejects a duplicate ward code', async () => {
    await service.create(createDto());
    await expectAppError(service.create(createDto({ code: 'W04' })), ErrorCode.WARD_CODE_TAKEN);
  });

  it('rejects an invalid boundary', async () => {
    await expectAppError(
      service.create(createDto({ boundary: { type: 'Point', coordinates: [74.58, 16.85] } })),
      ErrorCode.INVALID_BOUNDARY,
    );
  });

  it('updates with the right version and bumps it', async () => {
    const created = await service.create(createDto());
    clock.advanceMinutes(5);
    const updated = await service.update(created.id, { expectedVersion: 1, name: 'Ward 4' });
    expect(updated.name).toBe('Ward 4');
    expect(updated.version).toBe(2);
    expect(updated.updatedAt).toBe('2026-10-28T00:35:00.000Z');
  });

  it('refuses a stale version with VERSION_CONFLICT', async () => {
    const created = await service.create(createDto());
    await service.update(created.id, { expectedVersion: 1, name: 'First edit' });
    await expectAppError(
      service.update(created.id, { expectedVersion: 1, name: 'Second edit' }),
      ErrorCode.VERSION_CONFLICT,
    );
  });

  it('returns NOT_FOUND for an unknown ward', async () => {
    await expectAppError(service.get('missing'), ErrorCode.NOT_FOUND);
  });

  it('checks a location against the stored boundary', async () => {
    const created = await service.create(createDto());
    const inside = await service.checkLocation(created.id, { latitude: 16.855, longitude: 74.585 });
    const outside = await service.checkLocation(created.id, { latitude: 16.861, longitude: 74.585 });
    expect(inside).toMatchObject({ wardId: created.id, inside: true, withinTolerance: true });
    expect(outside).toMatchObject({ inside: false, withinTolerance: false });
  });

  it('lists wards by code with paging', async () => {
    await service.create(createDto({ code: 'W02' }));
    await service.create(createDto({ code: 'W01' }));
    await service.create(createDto({ code: 'W03' }));
    const page = await service.list(1, 2);
    expect(page.total).toBe(3);
    expect(page.items.map((w) => w.code)).toEqual(['W01', 'W02']);
  });
});
