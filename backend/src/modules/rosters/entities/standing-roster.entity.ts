import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  intColumn,
  timestampType,
  varcharType,
} from '../../../shared/database/column-types';

/**
 * The default squad: each worker belongs to one inspector in one ward, under that ward's
 * ward inspector. Daily assignments start from these rows.
 */
@Entity({ name: 'standing_rosters' })
export class StandingRoster {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'ward_id', type: varcharType(), length: 36 })
  wardId: string;

  @Column({ name: 'ward_inspector_id', type: varcharType(), length: 36 })
  wardInspectorId: string;

  @Column({ name: 'inspector_id', type: varcharType(), length: 36 })
  inspectorId: string;

  /** A worker is in at most one standing squad. */
  @Column({ name: 'worker_id', type: varcharType(), length: 36, unique: true })
  workerId: string;

  @Column({ name: 'is_active', ...booleanColumn(), default: 1 })
  isActive: boolean;

  @Column({ name: 'created_by_id', type: varcharType(), length: 36, nullable: true })
  createdById: string | null;

  /** Optimistic lock: every update must send the version it read. */
  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
