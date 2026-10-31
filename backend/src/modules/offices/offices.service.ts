import { Injectable } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import { Clock } from '../../shared/clock/clock';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import type { LocationCheckDto } from '../wards/dto/ward.dto';
import type { CreateOfficeDto, OfficeDto, OfficeLocationCheckResultDto, UpdateOfficeDto } from './dto/office.dto';
import { CorporationOffice } from './entities/corporation-office.entity';
import {
  checkLocationAtOffice,
  DEFAULT_OFFICE_BUFFER_METERS,
  normalizeOfficeCode,
  parseOfficePremises,
} from './offices.policy';
import { OfficeChanges, OfficesRepository } from './offices.repository';

export function toOfficeDto(o: CorporationOffice): OfficeDto {
  return {
    id: o.id,
    code: o.code,
    name: o.name,
    nameMr: o.nameMr,
    zone: o.zone,
    premises: JSON.parse(o.premisesGeojson) as Record<string, unknown>,
    bufferMeters: Number(o.bufferMeters),
    isActive: Boolean(Number(o.isActive)),
    version: Number(o.version),
    createdAt: o.createdAt.toISOString(),
    updatedAt: o.updatedAt.toISOString(),
  };
}

/** Office premises: CRUD (admin) and the office-staff geofence check. */
@Injectable()
export class OfficesService {
  constructor(
    private readonly offices: OfficesRepository,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  async list(): Promise<OfficeDto[]> {
    return (await this.offices.findAll()).map(toOfficeDto);
  }

  async get(id: string): Promise<OfficeDto> {
    return toOfficeDto(await this.findOrThrow(id));
  }

  /** For other modules (staff links): does an active office with this id exist? */
  async exists(id: string): Promise<boolean> {
    const office = await this.offices.findById(id);
    return office !== null && Boolean(Number(office.isActive));
  }

  async create(dto: CreateOfficeDto): Promise<OfficeDto> {
    const code = normalizeOfficeCode(dto.code);
    if (await this.offices.findByCode(code)) throw new AppError(ErrorCode.OFFICE_CODE_TAKEN, undefined, { code });
    const now = this.clock.now();
    const office: CorporationOffice = {
      id: this.ids.next(),
      code,
      name: dto.name.trim(),
      nameMr: dto.nameMr.trim(),
      zone: dto.zone,
      premisesGeojson: JSON.stringify(parseOfficePremises(dto.premises)),
      bufferMeters: dto.bufferMeters ?? DEFAULT_OFFICE_BUFFER_METERS,
      isActive: true,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
    await this.uow.run(async (tx) => {
      await this.offices.insert(office, tx);
      await this.audit.write(tx, { action: 'OFFICE_CREATED', entityType: 'office', entityId: office.id, details: { code } });
    });
    return toOfficeDto(office);
  }

  async update(id: string, dto: UpdateOfficeDto): Promise<OfficeDto> {
    const existing = await this.findOrThrow(id);
    if (existing.version !== dto.expectedVersion) {
      throw new AppError(ErrorCode.VERSION_CONFLICT, undefined, {
        currentVersion: existing.version,
        expectedVersion: dto.expectedVersion,
      });
    }
    const changes: OfficeChanges = { updatedAt: this.clock.now() };
    if (dto.name !== undefined) changes.name = dto.name.trim();
    if (dto.nameMr !== undefined) changes.nameMr = dto.nameMr.trim();
    if (dto.zone !== undefined) changes.zone = dto.zone;
    if (dto.bufferMeters !== undefined) changes.bufferMeters = dto.bufferMeters;
    if (dto.isActive !== undefined) changes.isActive = dto.isActive;
    if (dto.premises !== undefined) changes.premisesGeojson = JSON.stringify(parseOfficePremises(dto.premises));

    await this.uow.run(async (tx) => {
      const updated = await this.offices.updateVersioned(id, dto.expectedVersion, changes, tx);
      if (updated === 0) {
        throw new AppError(ErrorCode.VERSION_CONFLICT, undefined, { expectedVersion: dto.expectedVersion });
      }
      await this.audit.write(tx, {
        action: 'OFFICE_UPDATED',
        entityType: 'office',
        entityId: id,
        details: { fields: Object.keys(changes).filter((k) => k !== 'updatedAt') },
      });
    });
    return this.get(id);
  }

  async checkLocation(id: string, point: LocationCheckDto): Promise<OfficeLocationCheckResultDto> {
    const office = await this.findOrThrow(id);
    const bufferMeters = Number(office.bufferMeters);
    const result = checkLocationAtOffice(parseOfficePremises(office.premisesGeojson), point, bufferMeters);
    return { officeId: office.id, ...result, bufferMeters };
  }

  private async findOrThrow(id: string): Promise<CorporationOffice> {
    const office = await this.offices.findById(id);
    if (!office) throw new AppError(ErrorCode.NOT_FOUND, 'Office not found', { id });
    return office;
  }
}
