import { Column, Entity, PrimaryColumn } from 'typeorm';
import { timestampType, varcharType } from '../../../shared/database/column-types';

export type PushPlatform = 'ANDROID' | 'IOS';

/** An FCM registration token of a signed-in phone. A token moves with whoever signs in on it. */
@Entity({ name: 'push_tokens' })
export class PushToken {
  @PrimaryColumn({ type: varcharType(), length: 36 })
  id: string;

  @Column({ name: 'staff_id', type: varcharType(), length: 36 })
  staffId: string;

  @Column({ type: varcharType(), length: 255, unique: true })
  token: string;

  @Column({ type: varcharType(), length: 10 })
  platform: PushPlatform;

  @Column({ name: 'created_at', type: timestampType() })
  createdAt: Date;

  @Column({ name: 'last_seen_at', type: timestampType() })
  lastSeenAt: Date;
}
