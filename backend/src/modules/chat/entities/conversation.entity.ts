import { Column, Entity, PrimaryColumn } from 'typeorm';
import {
  booleanColumn,
  dateType,
  timestampType,
  unicodeVarcharType,
  varcharType,
} from '../../../shared/database/column-types';

export type ConversationType = 'DIRECT' | 'SQUAD_TEAM' | 'WARD_BROADCAST' | 'CITY_BROADCAST';

/** A chat thread. Soft-deleted only: chat history is permanent. */
@Entity({ name: 'conversations' })
export class Conversation {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /**
   * Built in Node so a thread is never created twice: "D:<staffA>:<staffB>" (ids sorted) for
   * direct threads, "S:<inspectorId>:<date>" for squads. Null for broadcasts.
   */
  @Column({
    name: 'conversation_key',
    type: varcharType(),
    length: 80,
    nullable: true,
    unique: true,
  })
  conversationKey: string | null;

  @Column({ name: 'conv_type', type: varcharType(), length: 20 })
  convType: ConversationType;

  @Column({ type: unicodeVarcharType(), length: 150, nullable: true })
  title: string | null;

  @Column({ name: 'ward_id', type: varcharType(), length: 36, nullable: true })
  wardId: string | null;

  @Column({ name: 'inspector_id', type: varcharType(), length: 36, nullable: true })
  inspectorId: string | null;

  /** IST date of a squad thread, YYYY-MM-DD. */
  @Column({ name: 'shift_date', type: dateType(), nullable: true })
  shiftDate: string | null;

  /** Yesterday's squads are archived, read-only. */
  @Column({ name: 'is_archived', ...booleanColumn(), default: 0 })
  isArchived: boolean;

  @Column({ name: 'created_by_id', type: varcharType(), length: 36, nullable: true })
  createdById: string | null;

  @Column({ name: 'last_message_at', type: timestampType(), nullable: true })
  lastMessageAt: Date | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'deleted_at', type: timestampType(), nullable: true })
  deletedAt: Date | null;
}
