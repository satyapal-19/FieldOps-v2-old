import { Column, Entity, PrimaryColumn } from 'typeorm';
import { timestampType, varcharType } from '../../../shared/database/column-types';

/** A one-time liveness challenge: valid for one punch of one subject, by one caller, briefly. */
@Entity({ name: 'liveness_challenges' })
export class LivenessChallenge {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  /** The person whose face will be checked. */
  @Column({ name: 'subject_id', type: varcharType(), length: 36 })
  subjectId: string;

  /** The caller who asked for it (the subject, or the inspector doing a proxy punch). */
  @Column({ name: 'issued_to_id', type: varcharType(), length: 36 })
  issuedToId: string;

  /** Comma-separated prompts, e.g. "BLINK,TURN_LEFT". */
  @Column({ type: varcharType(), length: 60 })
  actions: string;

  @Column({ name: 'issued_at', type: timestampType() })
  issuedAt: Date;

  @Column({ name: 'expires_at', type: timestampType() })
  expiresAt: Date;

  @Column({ name: 'used_at', type: timestampType(), nullable: true })
  usedAt: Date | null;
}
