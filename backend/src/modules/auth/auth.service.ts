import { Injectable, Logger } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcryptjs';
import type { EntityManager } from 'typeorm';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AccessTokenClaims, AuthUser } from '../../shared/auth/auth-user';
import { PASSWORD_LOGIN_ROLES } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { AppConfig } from '../../shared/config/app-config';
import { currentRequestContext } from '../../shared/context/request-context';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import type { Staff } from '../staff/entities/staff.entity';
import { toStaffProfileDto } from '../staff/staff.mapper';
import { maskPhone, normalizeEmployeeCode, normalizePhone, StaffRuleError } from '../staff/staff.policy';
import { StaffService } from '../staff/staff.service';
import {
  checkOtpUsable,
  formatRefreshToken,
  generateOtp,
  hashSecret,
  newRefreshSecret,
  parseRefreshToken,
  passwordProblems,
  sameHash,
  sessionsToEvict,
} from './auth.policy';
import { AuthRepository } from './auth.repository';
import type { OtpRequestedDto, SessionTokensDto } from './dto/auth.dto';
import { AuthSession } from './entities/auth-session.entity';
import { OtpSender } from './otp/otp-sender';

export type SignInMethod = 'OTP' | 'PASSWORD' | 'TEST';

export interface DeviceInfo {
  deviceId?: string;
  userAgent?: string;
}

const BCRYPT_ROUNDS = 12;
const OTP_WINDOW_MINUTES = 15;

/**
 * Sign-in, token rotation and sign-out. Every outcome that matters for security
 * (success, failure, revocation) is written to the audit log.
 */
@Injectable()
export class AuthService {
  private readonly logger = new Logger(AuthService.name);
  /** Compared when the account does not exist, so response time does not reveal it. */
  private dummyHash?: Promise<string>;

  constructor(
    private readonly repo: AuthRepository,
    private readonly staff: StaffService,
    private readonly jwt: JwtService,
    private readonly otpSender: OtpSender,
    private readonly config: AppConfig,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  // ---------------------------------------------------------------- OTP

  /**
   * Sends a code if the phone belongs to an active staff member. The answer is the same
   * either way, so the endpoint cannot be used to discover who is staff.
   */
  async requestOtp(rawPhone: string): Promise<OtpRequestedDto> {
    const phone = this.phoneOrThrow(rawPhone);
    const settings = this.config.auth;
    const now = this.clock.now();
    const answer: OtpRequestedDto = { sent: true, expiresInSeconds: settings.otpTtlSeconds };

    const since = new Date(now.getTime() - OTP_WINDOW_MINUTES * 60_000);
    if ((await this.repo.countOtpsSince(phone, since)) >= settings.otpMaxPerWindow) {
      throw new AppError(ErrorCode.AUTH_OTP_RATE_LIMITED, undefined, { retryAfterMinutes: OTP_WINDOW_MINUTES });
    }

    const staff = await this.staff.findByPhone(phone);
    if (!staff || !isActive(staff)) {
      await this.uow.run((tx) =>
        this.audit.write(tx, {
          action: 'OTP_REQUESTED_UNKNOWN',
          entityType: 'auth',
          details: { phone: maskPhone(phone) },
        }),
      );
      return answer;
    }

    const code = generateOtp();
    await this.uow.run(async (tx) => {
      await this.repo.closeOpenOtps(phone, now, tx);
      await this.repo.insertOtp(
        {
          id: this.ids.next(),
          phone,
          staffId: staff.id,
          codeHash: this.otpHash(phone, code),
          expiresAt: new Date(now.getTime() + settings.otpTtlSeconds * 1000),
          attempts: 0,
          consumedAt: null,
          createdAt: now,
        },
        tx,
      );
      await this.audit.write(tx, {
        action: 'OTP_REQUESTED',
        entityType: 'staff',
        entityId: staff.id,
        actorId: staff.id,
        actorRole: staff.role,
        details: { via: this.otpSender.name },
      });
    });

    try {
      await this.otpSender.send({ phone, code, validMinutes: Math.ceil(settings.otpTtlSeconds / 60) });
    } catch (error) {
      await this.repo.closeOpenOtps(phone, this.clock.now());
      throw error;
    }
    return answer;
  }

  async verifyOtp(rawPhone: string, code: string, device: DeviceInfo): Promise<SessionTokensDto> {
    const phone = this.phoneOrThrow(rawPhone);
    const settings = this.config.auth;
    const now = this.clock.now();

    const otp = await this.repo.findLatestOpenOtp(phone);
    if (!otp) throw new AppError(ErrorCode.AUTH_OTP_INVALID);

    const state = checkOtpUsable(otp, now, settings.otpMaxAttempts);
    if (state === 'expired') throw new AppError(ErrorCode.AUTH_OTP_EXPIRED);
    if (state === 'too_many_attempts') throw new AppError(ErrorCode.AUTH_OTP_TOO_MANY_ATTEMPTS);
    if (state === 'consumed') throw new AppError(ErrorCode.AUTH_OTP_INVALID);

    // Every guess, right or wrong, spends an attempt first, atomically.
    if ((await this.repo.claimOtpAttempt(otp.id, settings.otpMaxAttempts)) === 0) {
      throw new AppError(ErrorCode.AUTH_OTP_TOO_MANY_ATTEMPTS);
    }
    if (!sameHash(otp.codeHash, this.otpHash(phone, code))) {
      const attemptsLeft = Math.max(0, settings.otpMaxAttempts - otp.attempts - 1);
      await this.auditFailure(otp.staffId, 'OTP', 'wrong code');
      throw new AppError(ErrorCode.AUTH_OTP_INVALID, undefined, { attemptsLeft });
    }

    const staff = await this.staff.findById(otp.staffId);
    if (!staff || !isActive(staff)) throw new AppError(ErrorCode.AUTH_ACCOUNT_INACTIVE);

    return this.uow.run(async (tx) => {
      if ((await this.repo.consumeOtp(otp.id, now, tx)) === 0) throw new AppError(ErrorCode.AUTH_OTP_INVALID);
      return this.startSession(tx, staff, 'OTP', device);
    });
  }

  // ----------------------------------------------------------- Password

  /** Web dashboard sign-in for ADMIN, WARD_INSPECTOR and OFFICE_STAFF. */
  async passwordLogin(identifier: string, password: string, device: DeviceInfo): Promise<SessionTokensDto> {
    const staff = await this.findByIdentifier(identifier);
    this.dummyHash ??= bcrypt.hash('fieldops-timing-equaliser', BCRYPT_ROUNDS);
    const hash = staff?.passwordHash ?? (await this.dummyHash);
    const matches = await bcrypt.compare(password, hash);

    if (!staff || !staff.passwordHash || !matches || !PASSWORD_LOGIN_ROLES.includes(staff.role)) {
      if (staff) await this.auditFailure(staff.id, 'PASSWORD', 'bad credentials');
      throw new AppError(ErrorCode.AUTH_INVALID_CREDENTIALS);
    }
    if (!isActive(staff)) throw new AppError(ErrorCode.AUTH_ACCOUNT_INACTIVE);

    return this.uow.run((tx) => this.startSession(tx, staff, 'PASSWORD', device));
  }

  async changePassword(user: AuthUser, currentPassword: string, newPassword: string): Promise<void> {
    const staff = await this.staff.findById(user.staffId);
    if (!staff) throw new AppError(ErrorCode.UNAUTHENTICATED);
    if (!staff.passwordHash || !(await bcrypt.compare(currentPassword, staff.passwordHash))) {
      throw new AppError(ErrorCode.AUTH_INVALID_CREDENTIALS);
    }
    const problems = passwordProblems(newPassword, staff);
    if (problems.length > 0) throw new AppError(ErrorCode.AUTH_WEAK_PASSWORD, undefined, { problems });

    const hash = await bcrypt.hash(newPassword, BCRYPT_ROUNDS);
    const now = this.clock.now();
    await this.uow.run(async (tx) => {
      await this.staff.setPasswordHash(staff.id, hash, now, tx);
      // Sign out every other device; keep this one.
      for (const s of await this.repo.findActiveSessions(staff.id, now, tx)) {
        if (s.id !== user.sessionId) await this.repo.revokeSession(s.id, now, 'PASSWORD_CHANGED', tx);
      }
      await this.audit.write(tx, { action: 'PASSWORD_CHANGED', entityType: 'staff', entityId: staff.id });
    });
  }

  /** Hashes a password for storage (used by staff admin in phase 1B and the seed). */
  hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, BCRYPT_ROUNDS);
  }

  // --------------------------------------------------------- Test login

  /** Development / test only: sign in as any active staff without OTP (D3). */
  async testLogin(identifier: string, device: DeviceInfo): Promise<SessionTokensDto> {
    if (!this.config.testLoginEnabled || this.config.isProduction) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Not found');
    }
    const staff = await this.findByIdentifier(identifier);
    if (!staff) throw new AppError(ErrorCode.NOT_FOUND, 'No staff with this phone or employee code');
    if (!isActive(staff)) throw new AppError(ErrorCode.AUTH_ACCOUNT_INACTIVE);
    return this.uow.run((tx) => this.startSession(tx, staff, 'TEST', device));
  }

  // ------------------------------------------------------ Refresh/logout

  /**
   * Swaps a refresh token for a new pair. Presenting an already-used token means it was
   * copied: the whole session is revoked and the user must sign in again.
   */
  async refresh(refreshToken: string): Promise<SessionTokensDto> {
    const parsed = parseRefreshToken(refreshToken);
    if (!parsed) throw new AppError(ErrorCode.AUTH_SESSION_REVOKED);
    const now = this.clock.now();

    const session = await this.repo.findSession(parsed.sessionId);
    if (!session || session.revokedAt || session.expiresAt.getTime() <= now.getTime()) {
      throw new AppError(ErrorCode.AUTH_SESSION_REVOKED);
    }

    const presented = this.refreshHash(parsed.secret);
    const newSecret = newRefreshSecret();
    const rotated = sameHash(session.refreshHash, presented)
      ? await this.repo.rotateRefresh(session.id, presented, this.refreshHash(newSecret), now)
      : 0;

    if (rotated === 0) {
      await this.uow.run(async (tx) => {
        await this.repo.revokeSession(session.id, now, 'REFRESH_REUSE', tx);
        await this.audit.write(tx, {
          action: 'REFRESH_TOKEN_REUSED',
          entityType: 'session',
          entityId: session.id,
          actorId: session.staffId,
        });
      });
      this.logger.warn(`Refresh token reuse; session ${session.id} revoked`);
      throw new AppError(ErrorCode.AUTH_SESSION_REVOKED);
    }

    const staff = await this.staff.findById(session.staffId);
    if (!staff || !isActive(staff)) throw new AppError(ErrorCode.AUTH_ACCOUNT_INACTIVE);
    return this.tokensFor(staff, session, newSecret);
  }

  async logout(user: AuthUser, everywhere: boolean): Promise<void> {
    const now = this.clock.now();
    await this.uow.run(async (tx) => {
      if (everywhere) await this.repo.revokeAllSessions(user.staffId, now, 'LOGOUT', tx);
      else await this.repo.revokeSession(user.sessionId, now, 'LOGOUT', tx);
      await this.audit.write(tx, {
        action: everywhere ? 'LOGOUT_ALL' : 'LOGOUT',
        entityType: 'session',
        entityId: user.sessionId,
      });
    });
  }

  /** Signs a person out of every device (admin action; also used on deactivation in 1B). */
  async revokeAllFor(staffId: string, reason: 'ADMIN' | 'DEACTIVATED', tx?: EntityManager): Promise<number> {
    const now = this.clock.now();
    const work = async (t: EntityManager) => {
      const count = await this.repo.revokeAllSessions(staffId, now, reason, t);
      await this.audit.write(t, {
        action: 'SESSIONS_REVOKED',
        entityType: 'staff',
        entityId: staffId,
        details: { reason, count },
      });
      return count;
    };
    return tx ? work(tx) : this.uow.run(work);
  }

  async me(user: AuthUser) {
    const staff = await this.staff.findById(user.staffId);
    if (!staff) throw new AppError(ErrorCode.UNAUTHENTICATED);
    return toStaffProfileDto(staff, { showPhone: true });
  }

  // ------------------------------------------------- Request validation

  /**
   * Turns a bearer token into the caller, or throws 401. The session row is read on every
   * request, so a revoked session or deactivated account stops working immediately.
   */
  async authenticate(accessToken: string): Promise<AuthUser> {
    return this.sessionUser(await this.verifyAccessToken(accessToken));
  }

  /** Checks the token's signature, issuer, audience and expiry only (no database), or throws 401. */
  async verifyAccessToken(accessToken: string): Promise<AccessTokenClaims> {
    try {
      return await this.jwt.verifyAsync<AccessTokenClaims>(accessToken, {
        algorithms: ['HS256'],
        issuer: JWT_ISSUER,
        audience: JWT_AUDIENCE,
      });
    } catch {
      throw new AppError(ErrorCode.UNAUTHENTICATED);
    }
  }

  /** The caller behind verified claims, if the session is live and the account active, or throws 401. */
  async sessionUser(claims: AccessTokenClaims): Promise<AuthUser> {
    const now = this.clock.now();
    const session = await this.repo.findSession(claims.sid);
    if (
      !session ||
      session.staffId !== claims.sub ||
      session.revokedAt ||
      session.expiresAt.getTime() <= now.getTime()
    ) {
      throw new AppError(ErrorCode.AUTH_SESSION_REVOKED);
    }
    const staff = await this.staff.findById(claims.sub);
    if (!staff || !isActive(staff)) throw new AppError(ErrorCode.AUTH_ACCOUNT_INACTIVE);

    // Role and ward come from the database, so changes apply on the next request.
    return {
      staffId: staff.id,
      role: staff.role,
      sessionId: session.id,
      homeWardId: staff.homeWardId ?? null,
      officeId: staff.officeId ?? null,
    };
  }

  // ------------------------------------------------------------ helpers

  private async startSession(
    tx: EntityManager,
    staff: Staff,
    method: SignInMethod,
    device: DeviceInfo,
  ): Promise<SessionTokensDto> {
    const settings = this.config.auth;
    const now = this.clock.now();

    const active = await this.repo.findActiveSessions(staff.id, now, tx);
    for (const old of active.slice(0, sessionsToEvict(active.length, settings.maxSessionsPerStaff))) {
      await this.repo.revokeSession(old.id, now, 'EVICTED', tx);
    }

    const secret = newRefreshSecret();
    const ctx = currentRequestContext();
    const session: AuthSession = {
      id: this.ids.next(),
      staffId: staff.id,
      refreshHash: this.refreshHash(secret),
      method,
      deviceId: device.deviceId?.slice(0, 100) || null,
      userAgent: device.userAgent?.slice(0, 200) || null,
      ip: ctx?.ip ?? null,
      createdAt: now,
      lastRefreshedAt: null,
      expiresAt: new Date(now.getTime() + settings.refreshTtlDays * 86_400_000),
      revokedAt: null,
      revokeReason: null,
    };
    await this.repo.insertSession(session, tx);
    await this.audit.write(tx, {
      action: 'LOGIN_SUCCEEDED',
      entityType: 'session',
      entityId: session.id,
      actorId: staff.id,
      actorRole: staff.role,
      details: { method },
    });
    return this.tokensFor(staff, session, secret);
  }

  private async tokensFor(staff: Staff, session: AuthSession, refreshSecret: string): Promise<SessionTokensDto> {
    const settings = this.config.auth;
    const claims: AccessTokenClaims = { sub: staff.id, sid: session.id, role: staff.role };
    const accessToken = await this.jwt.signAsync(claims, {
      algorithm: 'HS256',
      expiresIn: settings.accessTtlSeconds,
      issuer: JWT_ISSUER,
      audience: JWT_AUDIENCE,
    });
    return {
      accessToken,
      tokenType: 'Bearer',
      expiresInSeconds: settings.accessTtlSeconds,
      refreshToken: formatRefreshToken(session.id, refreshSecret),
      refreshExpiresAt: session.expiresAt.toISOString(),
      staff: toStaffProfileDto(staff, { showPhone: true }),
    };
  }

  private async auditFailure(staffId: string, method: SignInMethod, reason: string): Promise<void> {
    await this.uow.run((tx) =>
      this.audit.write(tx, {
        action: 'LOGIN_FAILED',
        entityType: 'staff',
        entityId: staffId,
        actorId: null,
        details: { method, reason },
      }),
    );
  }

  private async findByIdentifier(identifier: string): Promise<Staff | null> {
    const value = identifier.trim();
    if (/^[+\d\s()-]{10,16}$/.test(value)) {
      try {
        return await this.staff.findByPhone(normalizePhone(value));
      } catch {
        // not a phone; fall through to employee code
      }
    }
    try {
      return await this.staff.findByEmployeeCode(normalizeEmployeeCode(value));
    } catch {
      return null;
    }
  }

  private phoneOrThrow(raw: string): string {
    try {
      return normalizePhone(raw);
    } catch (error) {
      if (error instanceof StaffRuleError) {
        throw new AppError(ErrorCode.VALIDATION_FAILED, undefined, { errors: [error.message] });
      }
      throw error;
    }
  }

  private otpHash(phone: string, code: string): string {
    return hashSecret(this.config.auth.refreshSecret, 'otp', `${phone}:${code}`);
  }

  private refreshHash(secret: string): string {
    return hashSecret(this.config.auth.refreshSecret, 'refresh', secret);
  }
}

export const JWT_ISSUER = 'fieldops-smkmc';
export const JWT_AUDIENCE = 'fieldops-api';

function isActive(staff: Staff): boolean {
  return Boolean(Number(staff.isActive));
}
