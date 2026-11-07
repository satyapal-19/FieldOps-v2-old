import { Column, Entity, PrimaryColumn } from 'typeorm';
import { intColumn, timestampType, varcharType } from '../../../shared/database/column-types';

export const UPLOAD_KINDS = ['TASK_PHOTO', 'VOICE_NOTE'] as const;
export type UploadKind = (typeof UPLOAD_KINDS)[number];

/** One uploaded file's metadata; the bytes are on disk at storage_path (under UPLOAD_DIR). */
@Entity({ name: 'uploads' })
export class Upload {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'client_uuid', type: varcharType(), length: 36, unique: true })
  clientUuid: string;

  @Column({ name: 'owner_staff_id', type: varcharType(), length: 36 })
  ownerStaffId: string;

  @Column({ type: varcharType(), length: 20 })
  kind: UploadKind;

  @Column({ name: 'content_type', type: varcharType(), length: 30 })
  contentType: string;

  @Column({ name: 'size_bytes', ...intColumn() })
  sizeBytes: number;

  @Column({ type: varcharType(), length: 64 })
  sha256: string;

  /** Relative to UPLOAD_DIR, e.g. 2026/11/<id>.jpg. */
  @Column({ name: 'storage_path', type: varcharType(), length: 200 })
  storagePath: string;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;
}
