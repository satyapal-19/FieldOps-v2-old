import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { EntityManager, IsNull, LessThan, MoreThan, Repository } from 'typeorm';
import { AuthOtp } from './entities/auth-otp.entity';
import { AuthSession } from './entities/auth-session.entity';

/** The only place that queries auth_otps and auth_sessions. */
@Injectable()
export class AuthRepository {
  constructor(
    @InjectRepository(AuthOtp) private readonly otps: Repository<AuthOtp>,
    @InjectRepository(AuthSession) private readonly sessions: Repository<AuthSession>,
  ) {}

  private otpRepo(tx?: EntityManager): Repository<AuthOtp> {
    return tx ? tx.getRepository(AuthOtp) : this.otps;
  }

  private sessionRepo(tx?: EntityManager): Repository<AuthSession> {
    return tx ? tx.getRepository(AuthSession) : this.sessions;
  }

  // ---- OTPs ----

  countOtpsSince(phone: string, since: Date): Promise<number> {
    return this.otps.count({ where: { phone, createdAt: MoreThan(since) } });
  }

  findLatestOpenOtp(phone: string): Promise<AuthOtp | null> {
    return this.otps.findOne({ where: { phone, consumedAt: IsNull() }, order: { createdAt: 'DESC' } });
  }

  /** Closes every open code for the phone (a new code replaces older ones). */
  async closeOpenOtps(phone: string, at: Date, tx?: EntityManager): Promise<void> {
    await this.otpRepo(tx).update({ phone, consumedAt: IsNull() }, { consumedAt: at });
  }

  async insertOtp(otp: AuthOtp, tx?: EntityManager): Promise<void> {
    await this.otpRepo(tx).insert(otp);
  }

  /** Counts a wrong guess; conditional on the value read so concurrent guesses all count. */
  async incrementOtpAttempts(id: string, seenAttempts: number): Promise<number> {
    const result = await this.otps.update({ id, attempts: seenAttempts }, { attempts: seenAttempts + 1 });
    return result.affected ?? 0;
  }

  /** Marks a code used. Returns 0 if someone else used it first. */
  async consumeOtp(id: string, at: Date, tx?: EntityManager): Promise<number> {
    const result = await this.otpRepo(tx).update({ id, consumedAt: IsNull() }, { consumedAt: at });
    return result.affected ?? 0;
  }

  async deleteOtpsBefore(before: Date): Promise<number> {
    const result = await this.otps.delete({ createdAt: LessThan(before) });
    return result.affected ?? 0;
  }

  // ---- Sessions ----

  findSession(id: string): Promise<AuthSession | null> {
    return this.sessions.findOne({ where: { id } });
  }

  findActiveSessions(staffId: string, now: Date, tx?: EntityManager): Promise<AuthSession[]> {
    return this.sessionRepo(tx).find({
      where: { staffId, revokedAt: IsNull(), expiresAt: MoreThan(now) },
      order: { createdAt: 'ASC' },
    });
  }

  async insertSession(session: AuthSession, tx?: EntityManager): Promise<void> {
    await this.sessionRepo(tx).insert(session);
  }

  /** Swaps the refresh hash only if it is still the one presented. Returns 0 on a race or reuse. */
  async rotateRefresh(id: string, oldHash: string, newHash: string, at: Date): Promise<number> {
    const result = await this.sessions.update(
      { id, refreshHash: oldHash, revokedAt: IsNull() },
      { refreshHash: newHash, lastRefreshedAt: at },
    );
    return result.affected ?? 0;
  }

  async revokeSession(id: string, at: Date, reason: string, tx?: EntityManager): Promise<number> {
    const result = await this.sessionRepo(tx).update(
      { id, revokedAt: IsNull() },
      { revokedAt: at, revokeReason: reason },
    );
    return result.affected ?? 0;
  }

  async revokeAllSessions(staffId: string, at: Date, reason: string, tx?: EntityManager): Promise<number> {
    const result = await this.sessionRepo(tx).update(
      { staffId, revokedAt: IsNull() },
      { revokedAt: at, revokeReason: reason },
    );
    return result.affected ?? 0;
  }
}
