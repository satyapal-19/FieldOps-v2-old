import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  decimalColumn,
  intColumn,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type MessageType = 'TEXT' | 'VOICE' | 'IMAGE' | 'LOCATION';

/** A chat message. Soft-deleted only; voice clips are purged from storage after 90 days. */
@Entity({ name: 'messages' })
export class Message {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** Idempotency key from the phone's outbox. */
  @Column({ name: 'client_uuid', type: varcharType(), length: 36, nullable: true, unique: true })
  clientUuid: string | null;

  @Column({ name: 'conversation_id', type: varcharType(), length: 36 })
  conversationId: string;

  @Column({ name: 'sender_id', type: varcharType(), length: 36 })
  senderId: string;

  @Column({ name: 'msg_type', type: varcharType(), length: 10, default: 'TEXT' })
  msgType: MessageType;

  @Column({ type: unicodeVarcharType(), length: 2000, nullable: true })
  body: string | null;

  /** Key in backend storage for VOICE / IMAGE; served through signed, expiring links. */
  @Column({ name: 'storage_key', type: varcharType(), length: 100, nullable: true })
  storageKey: string | null;

  @Column({ name: 'mime_type', type: varcharType(), length: 50, nullable: true })
  mimeType: string | null;

  @Column({ name: 'size_bytes', ...intColumn(), nullable: true })
  sizeBytes: number | null;

  @Column({ name: 'duration_sec', ...intColumn(), nullable: true })
  durationSec: number | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lat: number | null;

  @Column({ ...decimalColumn(10, 7), nullable: true })
  lng: number | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'deleted_at', type: timestampType(), nullable: true })
  deletedAt: Date | null;
}
