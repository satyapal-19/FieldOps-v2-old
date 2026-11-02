import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, EntityManager, Repository } from 'typeorm';
import type { StaffRole } from '../../shared/auth/roles';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { Staff } from './entities/staff.entity';

export type StaffChanges = Partial<Omit<Staff, 'id' | 'version' | 'createdAt'>>;

/** List filters. `visibleTo` is the caller's scope, already decided by the staff-admin policy. */
export interface StaffListFilter {
  role?: StaffRole;
  wardId?: string;
  officeId?: string;
  /** Direct reports of this manager. */
  reportsToId?: string;
  isActive?: boolean;
  /** Matches employee code or name, case-insensitive. */
  search?: string;
  visibleTo?: { wardId: string; roles?: readonly StaffRole[]; alsoStaffId?: string };
}

/** LIKE wildcards in user input match literally. */
function escapeLike(value: string): string {
  return value.replace(/[\\%_]/g, (c) => `\\${c}`);
}

/** The only place that queries the staff table. Pass `tx` when inside a UnitOfWork. */
@Injectable()
export class StaffRepository {
  constructor(@InjectRepository(Staff) private readonly repo: Repository<Staff>) {}

  private r(tx?: EntityManager): Repository<Staff> {
    return tx ? tx.getRepository(Staff) : this.repo;
  }

  findById(id: string, tx?: EntityManager): Promise<Staff | null> {
    return this.r(tx).findOne({ where: { id } });
  }

  findByPhone(phone: string): Promise<Staff | null> {
    return this.repo.findOne({ where: { phone } });
  }

  findByEmployeeCode(employeeCode: string): Promise<Staff | null> {
    return this.repo.findOne({ where: { employeeCode } });
  }

  /** Ids of the given staff that are active. Chunked: Oracle allows at most 1000 items in IN. */
  async findActiveIds(ids: readonly string[]): Promise<Set<string>> {
    const active = new Set<string>();
    for (let i = 0; i < ids.length; i += 1000) {
      const rows = await this.repo
        .createQueryBuilder('s')
        .select('s.id', 'id')
        .where('s.id IN (:...ids)', { ids: ids.slice(i, i + 1000) })
        .andWhere('s.isActive = 1')
        .getRawMany<{ id: string }>();
      rows.forEach((r) => active.add(r.id));
    }
    return active;
  }

  /** Ids of everyone matching the filter (scopes such as "my ward" are a few hundred people). */
  async findIds(filter: StaffListFilter): Promise<string[]> {
    const rows = await this.filtered(filter).select('s.id', 'id').getRawMany<{ id: string }>();
    return rows.map((r) => r.id);
  }

  findPage(filter: StaffListFilter, skip: number, take: number): Promise<[Staff[], number]> {
    return this.filtered(filter)
      .orderBy('s.employeeCode', 'ASC')
      .skip(skip)
      .take(take)
      .getManyAndCount();
  }

  private filtered(filter: StaffListFilter) {
    const qb = this.repo.createQueryBuilder('s');
    if (filter.role) qb.andWhere('s.role = :role', { role: filter.role });
    if (filter.wardId) qb.andWhere('s.homeWardId = :wardId', { wardId: filter.wardId });
    if (filter.officeId) qb.andWhere('s.officeId = :officeId', { officeId: filter.officeId });
    if (filter.reportsToId)
      qb.andWhere('s.reportsToId = :reportsToId', { reportsToId: filter.reportsToId });
    if (filter.isActive !== undefined)
      qb.andWhere('s.isActive = :isActive', { isActive: filter.isActive ? 1 : 0 });
    if (filter.search) {
      qb.andWhere(
        new Brackets((w) =>
          w
            // Explicit ESCAPE: Oracle has no default escape character.
            .where("UPPER(s.employeeCode) LIKE :search ESCAPE '\\'")
            .orWhere("UPPER(s.fullName) LIKE :search ESCAPE '\\'"),
        ),
        { search: `%${escapeLike(filter.search.toUpperCase())}%` },
      );
    }
    const scope = filter.visibleTo;
    if (scope) {
      qb.andWhere(
        new Brackets((w) => {
          w.where(
            new Brackets((inWard) => {
              inWard.where('s.homeWardId = :scopeWard', { scopeWard: scope.wardId });
              if (scope.roles)
                inWard.andWhere('s.role IN (:...scopeRoles)', { scopeRoles: [...scope.roles] });
            }),
          );
          if (scope.alsoStaffId) w.orWhere('s.id = :scopeSelf', { scopeSelf: scope.alsoStaffId });
        }),
      );
    }
    return qb;
  }

  async insert(staff: Staff, tx?: EntityManager): Promise<void> {
    try {
      await this.r(tx).insert(staff);
    } catch (error) {
      if (isUniqueViolation(error)) {
        // Which unique key clashed is checked by the service before insert; this is the race fallback.
        throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
      }
      throw error;
    }
  }

  async setPasswordHash(
    id: string,
    passwordHash: string,
    at: Date,
    tx?: EntityManager,
  ): Promise<void> {
    await this.r(tx).update({ id }, { passwordHash, updatedAt: at });
  }

  /** Applies changes only if the row still has `expectedVersion`. Returns rows updated (0 or 1). */
  async updateVersioned(
    id: string,
    expectedVersion: number,
    changes: StaffChanges,
    tx?: EntityManager,
  ): Promise<number> {
    try {
      const result = await this.r(tx).update(
        { id, version: expectedVersion },
        { ...changes, version: expectedVersion + 1 },
      );
      return result.affected ?? 0;
    } catch (error) {
      if (isUniqueViolation(error)) throw new AppError(ErrorCode.STAFF_IDENTITY_TAKEN);
      throw error;
    }
  }
}
