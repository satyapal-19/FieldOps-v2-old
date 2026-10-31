import { Injectable } from '@nestjs/common';
import type { EntityManager } from 'typeorm';
import { Staff } from './entities/staff.entity';
import { StaffRepository } from './staff.repository';

/**
 * Staff use cases. Phase 1A: the lookups sign-in needs.
 * Phase 1B adds create / update / deactivate with v4 hierarchy rules.
 */
@Injectable()
export class StaffService {
  constructor(private readonly staff: StaffRepository) {}

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
