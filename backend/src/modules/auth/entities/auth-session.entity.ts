import { Column, Entity, PrimaryColumn } from 'typeorm';
import { timestampType, unicodeVarcharType, varcharType } from '../../../shared/database/column-types';

/**
 * A signed-in device. The access token names this row; revoking it (logout, admin,
 * deactivation, refresh-token reuse) cuts the device off on its next request.
 */
@Entity({ name: 'auth_sessions' })
export class AuthSession {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  /** HMAC of the current refresh secret; replaced on every refresh (rotation). */
  @Column({ name: 'refresh_hash', type: varcharType(), length: 64 })
  refreshHash: string;

  /** OTP, PASSWORD or TEST. */
  @Column({ type: varcharType(), length: 10 })
  method: string;

  /** App-supplied install ID; device binding (D3) will check this after delivery. */
  @Column({ name: 'device_id', type: varcharType(), length: 100, nullable: true })
  deviceId: string | null;

  @Column({ name: 'user_agent', type: unicodeVarcharType(), length: 200, nullable: true })
  userAgent: string | null;

  @Column({ type: varcharType(), length: 45, nullable: true })
  ip: string | null;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'last_refreshed_at', type: timestampType(), nullable: true })
  lastRefreshedAt: Date | null;

  @Column({ name: 'expires_at', type: timestampType() })
  expiresAt: Date;

  @Column({ name: 'revoked_at', type: timestampType(), nullable: true })
  revokedAt: Date | null;

  /** LOGOUT, ADMIN, DEACTIVATED, REFRESH_REUSE, EVICTED, PASSWORD_CHANGED */
  @Column({ name: 'revoke_reason', type: varcharType(), length: 20, nullable: true })
  revokeReason: string | null;
}
