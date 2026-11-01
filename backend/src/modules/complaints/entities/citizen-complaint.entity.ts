import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  decimalColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type ComplaintCategory =
  'GARBAGE' | 'DRAIN' | 'ROAD' | 'WATER' | 'TREE' | 'STRAY_ANIMAL' | 'OTHER';
export type ComplaintStatus =
  'RECEIVED' | 'ASSIGNED' | 'IN_PROGRESS' | 'RESOLVED' | 'CLOSED' | 'REJECTED';

/** A complaint from the public citizen portal; work on it happens through linked tasks. */
@Entity({ name: 'citizen_complaints' })
export class CitizenComplaint {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** Public reference such as SMK-2026-7K3QX9, generated in Node. */
  @Column({ name: 'tracking_id', type: varcharType(), length: 20, unique: true })
  trackingId: string;

  /** Makes a re-submitted portal form a duplicate. */
  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'citizen_name', type: unicodeVarcharType(), length: 100, nullable: true })
  citizenName: string | null;

  /** Personal data: never returned by public endpoints. */
  @Column({ name: 'citizen_phone', type: varcharType(), length: 10, nullable: true })
  citizenPhone: string | null;

  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  @Column({ type: varcharType(), length: 20 })
  category: ComplaintCategory;

  @Column({ type: unicodeVarcharType(), length: 1000 })
  description: string;

  @Column({ name: 'photo_key', type: varcharType(), length: 100, nullable: true })
  photoKey: string | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lat: number | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lng: number | null;

  @Column({ type: varcharType(), length: 20, default: 'RECEIVED' })
  status: ComplaintStatus;

  @Column({ name: 'resolved_at', type: timestampType(), nullable: true })
  resolvedAt: Date | null;

  @Column({ ...intColumn(), default: 1 })
  version: number;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'updated_at', type: timestampType() })
  updatedAt: Date;
}
