import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  intColumn,
  longTextType,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';
import type { Zone } from '../../wards/wards.policy';

/**
 * SMKMC office premises (v4 §4.2): head office Sangli, Miraj and Kupwad divisional offices.
 * OFFICE_STAFF check in here. The buffer is applied when checking, not stored as a shape,
 * so no PostGIS buffer function is needed.
 */
@Entity({ name: 'corporation_offices' })
export class CorporationOffice {
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

  /** GeoJSON Polygon of the premises, [longitude, latitude]. */
  @Column({ name: 'premises_geojson', type: longTextType() })
  premisesGeojson: string;

  /** GPS allowance around the premises (concrete buildings weaken GPS). v4 default 100 m. */
  @Column({ name: 'buffer_meters', ...intColumn(), default: 100 })
  bufferMeters: number;

  @Column({ name: 'is_active', ...booleanColumn(), default: 1 })
  isActive: boolean;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
