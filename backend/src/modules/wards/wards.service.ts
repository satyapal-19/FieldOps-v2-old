import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import { Clock } from '../../shared/clock/clock';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import type {
  CreateWardDto,
  LocationCheckDto,
  LocationCheckResultDto,
  UpdateWardDto,
  WardDto,
  WardPageDto,
} from './dto/ward.dto';
import { Ward } from './entities/ward.entity';
import { checkLocationInWard, normalizeWardCode, parseWardBoundary } from './wards.policy';
import { WardChanges, WardsRepository } from './wards.repository';

export function toWardDto(ward: Ward): WardDto {
  return {
    id: ward.id,
    code: ward.code,
    name: ward.name,
    nameMr: ward.nameMr,
    zone: ward.zone,
    boundary: JSON.parse(ward.boundaryGeojson) as Record<string, unknown>,
    // After INSERT, TypeORM copies the raw DB default (0/1) back onto the entity.
    isActive: Boolean(Number(ward.isActive)),
    version: ward.version,
    createdAt: ward.createdAt.toISOString(),
    updatedAt: ward.updatedAt.toISOString(),
  };
}

/** Ward use cases. Rules come from wards.policy; storage from WardsRepository. */
@Injectable()
export class WardsService {
  constructor(
    private readonly wards: WardsRepository,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  async list(page: number, pageSize: number): Promise<WardPageDto> {
    const [items, total] = await this.wards.findPage((page - 1) * pageSize, pageSize);
    return { items: items.map(toWardDto), page, pageSize, total };
  }

  async get(id: string): Promise<WardDto> {
    return toWardDto(await this.findOrThrow(id));
  }

  /** For other modules (staff links, rosters): does an active ward with this id exist? */
  async exists(id: string): Promise<boolean> {
    const ward = await this.wards.findById(id);
    return ward !== null && Boolean(Number(ward.isActive));
  }

  async create(dto: CreateWardDto): Promise<WardDto> {
    const code = normalizeWardCode(dto.code);
    if (await this.wards.findByCode(code)) {
      throw new AppError(ErrorCode.WARD_CODE_TAKEN, undefined, { code });
    }
    const boundary = parseWardBoundary(dto.boundary);
    const now = this.clock.now();

    const ward = new Ward();
    ward.id = this.ids.next();
    ward.code = code;
    ward.name = dto.name.trim();
    ward.nameMr = dto.nameMr.trim();
    ward.zone = dto.zone;
    ward.boundaryGeojson = JSON.stringify(boundary);
    ward.isActive = true;
    ward.version = 1;
    ward.createdAt = now;
    ward.updatedAt = now;

    await this.uow.run(async (tx) => {
      await this.wards.insert(ward, tx);
      await this.audit.write(tx, {
        action: 'WARD_CREATED',
        entityType: 'ward',
        entityId: ward.id,
        details: { code },
      });
    });
    return toWardDto(ward);
  }

  async update(id: string, dto: UpdateWardDto): Promise<WardDto> {
    const existing = await this.findOrThrow(id);
    if (existing.version !== dto.expectedVersion) {
      throw this.versionConflict(existing.version, dto.expectedVersion);
    }

    const changes: WardChanges = { updatedAt: this.clock.now() };
    if (dto.name !== undefined) changes.name = dto.name.trim();
    if (dto.nameMr !== undefined) changes.nameMr = dto.nameMr.trim();
    if (dto.zone !== undefined) changes.zone = dto.zone;
    if (dto.isActive !== undefined) changes.isActive = dto.isActive;
    if (dto.boundary !== undefined) {
      changes.boundaryGeojson = JSON.stringify(parseWardBoundary(dto.boundary));
    }

    const updated = await this.uow.run(async (tx) => {
      const count = await this.wards.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (count > 0) {
        await this.audit.write(tx, {
          action: 'WARD_UPDATED',
          entityType: 'ward',
          entityId: id,
          details: { fields: Object.keys(changes).filter((k) => k !== 'updatedAt') },
        });
      }
      return count;
    });
    if (updated === 0) {
      // Someone else saved between our read and our write.
      const current = await this.findOrThrow(id);
      throw this.versionConflict(current.version, dto.expectedVersion);
    }
    return this.get(id);
  }

  async checkLocation(id: string, dto: LocationCheckDto): Promise<LocationCheckResultDto> {
    const ward = await this.findOrThrow(id);
    const result = checkLocationInWard(parseWardBoundary(ward.boundaryGeojson), dto);
    return { wardId: ward.id, ...result };
  }

  private async findOrThrow(id: string): Promise<Ward> {
    const ward = await this.wards.findById(id);
    if (!ward) throw new AppError(ErrorCode.NOT_FOUND, 'Ward not found', { id });
    return ward;
  }

  private versionConflict(currentVersion: number, expectedVersion: number): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT, undefined, { currentVersion, expectedVersion });
  }
}
