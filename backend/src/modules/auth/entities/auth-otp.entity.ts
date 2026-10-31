import { Column, Entity, PrimaryColumn } from 'typeorm';
import { intColumn, timestampType, varcharType } from '../../../shared/database/column-types';

/** One-time sign-in codes. Only an HMAC of the code is stored. Purged after a day. */
@Entity({ name: 'auth_otps' })
export class AuthOtp {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ type: varcharType(), length: 10 })
  phone: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ name: 'code_hash', type: varcharType(), length: 64 })
  codeHash: string;

  @Column({ name: 'expires_at', type: timestampType() })
  expiresAt: Date;

  @Column({ ...intColumn(), default: 0 })
  attempts: number;

  @Column({ name: 'consumed_at', type: timestampType(), nullable: true })
  consumedAt: Date | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;
}
