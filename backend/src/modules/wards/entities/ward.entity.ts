import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  intColumn,
  longTextType,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';
import type { Zone } from '../wards.policy';

@Entity({ name: 'wards' })
export class Ward {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ type: varcharType(), length: 20, unique: true })
  code: string;

  @Column({ type: unicodeVarcharType(), length: 100 })
  name: string;

  @Column({ name: 'name_mr', type: unicodeVarcharType(), length: 100 })
  nameMr: string;

  @Column({ type: varcharType(), length: 20 })
  zone: Zone;

  /** GeoJSON Polygon / MultiPolygon as text (portable; no PostGIS). */
  @Column({ name: 'boundary_geojson', type: longTextType() })
  boundaryGeojson: string;

  @Column({ name: 'is_active', ...booleanColumn(), default: 1 })
  isActive: boolean;

  /** Optimistic lock: every update must send the version it read. */
  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
