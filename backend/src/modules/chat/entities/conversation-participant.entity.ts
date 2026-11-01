import { Column, Entity, PrimaryColumn } from 'typeorm';
import { booleanColumn, timestampType, varcharType } from '../../../shared/database/column-types';

/** Who may read and post in a thread. Rows are deactivated, never deleted. */
@Entity({ name: 'conversation_participants' })
export class ConversationParticipant {
  @PrimaryColumn({ name: 'conversation_id', type: varcharType(), length: 36 })
  conversationId: string;

  @PrimaryColumn({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'is_active', ...booleanColumn(), default: 1 })
  isActive: boolean;

  @Column({ name: 'joined_at', type: timestampType() })
  joinedAt: Date;

  @Column({ name: 'left_at', type: timestampType(), nullable: true })
  leftAt: Date | null;

  /** Messages after this time are unread for this participant. */
  @Column({ name: 'last_read_at', type: timestampType(), nullable: true })
  lastReadAt: Date | null;
}
