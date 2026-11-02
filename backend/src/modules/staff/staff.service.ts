import { Injectable } from '@nestjs/common';
import type { EntityManager } from 'typeorm';
import { Role } from '../../shared/auth/roles';
import { Staff } from './entities/staff.entity';
import { StaffChanges, StaffListFilter, StaffRepository } from './staff.repository';

/** Re-exported so other modules never import the repository. */
export type { StaffChanges, StaffListFilter };

/**
 * Staff records for other modules: the lookups sign-in needs, plus the storage calls the
 * staff-admin module (create / update / deactivate with v4 rules) builds on.
 */
@Injectable()
export class StaffService {
  constructor(private readonly staff: StaffRepository) {}

  findPage(filter: StaffListFilter, skip: number, take: number): Promise<[Staff[], number]> {
    return this.staff.findPage(filter, skip, take);
  }

  findByIds(ids: readonly string[]): Promise<Staff[]> {
    return this.staff.findByIds(ids);
  }

  findIds(filter: StaffListFilter): Promise<string[]> {
    return this.staff.findIds(filter);
  }

  findActiveIds(ids: readonly string[]): Promise<Set<string>> {
    return ids.length === 0 ? Promise.resolve(new Set()) : this.staff.findActiveIds(ids);
  }

  /** The active ward inspector of a ward, or null (v4: one fixed ward inspector per ward). */
  async findWardInspector(wardId: string): Promise<Staff | null> {
    const [rows] = await this.staff.findPage(
      { role: Role.WARD_INSPECTOR, wardId, isActive: true },
      0,
      1,
    );
    return rows[0] ?? null;
  }

  insert(staff: Staff, tx?: EntityManager): Promise<void> {
    return this.staff.insert(staff, tx);
  }

  /** Returns rows updated: 0 means the version moved on (optimistic lock). */
  updateVersioned(
    id: string,
    expectedVersion: number,
    changes: StaffChanges,
    tx?: EntityManager,
  ): Promise<number> {
    return this.staff.updateVersioned(id, expectedVersion, changes, tx);
  }

  findById(id: string, tx?: EntityManager): Promise<Staff | null> {
    return this.staff.findById(id, tx);
  }

  findByPhone(phone: string): Promise<Staff | null> {
    return this.staff.findByPhone(phone);
  }

  findByEmployeeCode(code: string): Promise<Staff | null> {
    return this.staff.findByEmployeeCode(code);
  }

  /** Stores a new bcrypt hash (the caller has checked the old password / admin rights). */
  setPasswordHash(id: string, passwordHash: string, at: Date, tx?: EntityManager): Promise<void> {
    return this.staff.setPasswordHash(id, passwordHash, at, tx);
  }
}
