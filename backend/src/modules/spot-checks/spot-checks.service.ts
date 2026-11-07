import { Injectable, Logger } from '@nestjs/common';
import { createHmac } from 'node:crypto';
import { AuditWriter } from '../../shared/audit/audit-writer';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { addDays, istDate } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { dedupeKey } from '../alerts/alerts.policy';
import { AlertsService } from '../alerts/alerts.service';
import { AttendanceService, type OnDuty } from '../attendance/attendance.service';
import { NotificationsService } from '../notifications/notifications.service';
import { RostersService } from '../rosters/rosters.service';
import { StaffService } from '../staff/staff.service';
import type {
  ListSpotChecksQueryDto,
  OrderSpotCheckDto,
  RespondSpotCheckDto,
  SpotCheckDto,
  SpotCheckPageDto,
} from './dto/spot-check.dto';
import type { SpotCheck } from './entities/spot-check.entity';
import {
  canCheck,
  fractionsFromDigest,
  planRandomCheck,
  SNOOZE_MINUTES,
  SPOT_WINDOW_MINUTES,
  SpotRuleError,
  spotTransition,
  type SpotAction,
} from './spot-checks.policy';
import { SpotChecksRepository, type SpotFilter } from './spot-checks.repository';

const MINUTE = 60_000;
const iso = (d: Date | null) => (d ? d.toISOString() : null);
const num = (v: unknown) => (v === null || v === undefined ? null : Number(v));

function toDto(c: SpotCheck): SpotCheckDto {
  return {
    id: c.id,
    staffId: c.staffId,
    wardId: c.wardId,
    date: c.shiftDate,
    trigger: c.triggerType,
    initiatedById: c.initiatedById,
    reason: c.reason,
    status: c.status,
    notifiedAt: iso(c.notifiedAt),
    dueAt: iso(c.dueAt),
    snoozed: Number(c.snoozeCount) > 0,
    respondedAt: iso(c.respondedAt),
    inGeofence: c.responseInGeofence === null ? null : Boolean(Number(c.responseInGeofence)),
    faceScore: num(c.faceScore),
    escalatedAt: iso(c.escalatedAt),
    version: Number(c.version),
  };
}

/**
 * Spot checks (action plan Phase 4): "prove you are here" during a shift. Random checks are
 * planned once per shift, notified at their time (push + SMS where configured, always the
 * in-app inbox), answered within 10 minutes with the same face and location proof as a punch,
 * snoozed at most once, and escalated as an alert when missed. Seniors can order one at once.
 */
@Injectable()
export class SpotChecksService {
  private readonly logger = new Logger(SpotChecksService.name);

  constructor(
    private readonly repo: SpotChecksRepository,
    private readonly attendance: AttendanceService,
    private readonly staff: StaffService,
    private readonly rosters: RostersService,
    private readonly alerts: AlertsService,
    private readonly notifications: NotificationsService,
    private readonly config: AppConfig,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  // ------------------------------------------------------------ The job (every 5 minutes)

  /** Plans random checks for people newly on duty, notifies due ones, escalates missed ones. */
  async runCycle(): Promise<string> {
    const now = this.clock.now();
    const onDuty = await this.attendance.onDuty();
    const planned = await this.planRandom(onDuty, now);
    const working = new Set(onDuty.map((d) => d.staffId));

    let notified = 0;
    let cancelled = 0;
    for (const check of await this.repo.findDueScheduled(now)) {
      if (!working.has(check.staffId)) {
        cancelled += await this.move(check, 'CANCEL', {}, now);
        continue;
      }
      const moved = await this.move(
        check,
        'NOTIFY',
        { notifiedAt: now, dueAt: new Date(now.getTime() + SPOT_WINDOW_MINUTES * MINUTE) },
        now,
      );
      if (moved) {
        notified++;
        await this.tellWorker(check);
      }
    }

    let missed = 0;
    for (const check of await this.repo.findOverdue(now)) {
      if (await this.move(check, 'EXPIRE', { escalatedAt: now }, now)) {
        missed++;
        await this.escalate(check);
      }
    }
    return `planned ${planned}, notified ${notified}, missed ${missed}, cancelled ${cancelled}`;
  }

  /**
   * One decision per shift, from a keyed hash of the shift (not a fresh roll each run), so the
   * rate holds however often the job runs and nobody can work out their own check time.
   */
  private async planRandom(onDuty: OnDuty[], now: Date): Promise<number> {
    const rate = this.config.spotCheckDailyRate;
    if (rate <= 0 || onDuty.length === 0) return 0;
    let planned = 0;
    for (const date of new Set(onDuty.map((d) => d.date))) {
      const today = onDuty.filter((d) => d.date === date);
      const already = await this.repo.withRandomOn(
        date,
        today.map((d) => d.staffId),
      );
      for (const duty of today.filter((d) => !already.has(d.staffId))) {
        const digest = createHmac('sha256', this.config.auth.refreshSecret)
          .update(`spot:${duty.attendanceId}`)
          .digest();
        const [pick, at] = fractionsFromDigest(digest);
        const when = planRandomCheck(pick, at, rate, duty.checkinAt, duty.shiftEndsAt, now);
        if (!when) continue;
        try {
          await this.repo.insert(this.newCheck(duty, 'RANDOM', when, now));
          planned++;
        } catch (error) {
          if (!isUniqueViolation(error)) throw error;
        }
      }
    }
    return planned;
  }

  // ------------------------------------------------------------ Seniors

  /** A senior orders a check now for someone on duty in their scope. */
  async order(actor: AuthUser, dto: OrderSpotCheckDto): Promise<SpotCheckDto> {
    const now = this.clock.now();
    const duty = (await this.attendance.onDuty()).find((d) => d.staffId === dto.staffId);
    const target = await this.staff.findById(dto.staffId);
    if (!target)
      throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: dto.staffId });
    if (!duty)
      throw new AppError(ErrorCode.NOT_CHECKED_IN, 'This person is not on a field shift now');
    const placement = await this.rosters.assignmentFor(duty.date, duty.staffId);
    const allowed = canCheck(actor, {
      id: target.id,
      homeWardId: target.homeWardId ?? null,
      reportsToId: target.reportsToId ?? null,
      dayWardId: duty.wardId,
      dayInspectorId: placement?.inspectorId ?? null,
    });
    if (!allowed) throw new AppError(ErrorCode.FORBIDDEN);
    if ((await this.repo.findOpenFor(target.id)).length > 0) {
      throw new AppError(ErrorCode.CONFLICT, 'A spot check is already waiting for this person');
    }
    const row: SpotCheck = {
      ...this.newCheck(duty, 'SENIOR_MANUAL', now, now),
      initiatedById: actor.staffId,
      reason: dto.reason?.trim() || null,
      status: 'NOTIFIED',
      notifiedAt: now,
      dueAt: new Date(now.getTime() + SPOT_WINDOW_MINUTES * MINUTE),
    };
    await this.uow.run(async (tx) => {
      await this.repo.insert(row, tx);
      await this.audit.write(tx, {
        action: 'SPOT_CHECK_ORDERED',
        entityType: 'spot_check',
        entityId: row.id,
        details: { staffId: row.staffId, reason: row.reason },
      });
    });
    await this.tellWorker(row);
    return toDto(row);
  }

  async list(actor: AuthUser, q: ListSpotChecksQueryDto): Promise<SpotCheckPageDto> {
    const filter: SpotFilter = { date: q.date, status: q.status };
    if (actor.role === Role.WARD_INSPECTOR) {
      if (!actor.homeWardId) throw new AppError(ErrorCode.FORBIDDEN);
      filter.wardId = actor.homeWardId;
    } else if (actor.role === Role.INSPECTOR) {
      const today = istDate(this.clock.now());
      const placed = await this.rosters.placementsUnder(actor.staffId, addDays(today, -31), today);
      filter.staffIds = [
        ...new Set([
          ...(await this.staff.findIds({ reportsToId: actor.staffId })),
          ...placed.map((p) => p.staffId),
        ]),
      ];
    } else if (actor.role !== Role.ADMIN) {
      throw new AppError(ErrorCode.FORBIDDEN);
    }
    const [items, total] = await this.repo.findPage(filter, (q.page - 1) * q.pageSize, q.pageSize);
    return { items: items.map(toDto), page: q.page, pageSize: q.pageSize, total };
  }

  // ------------------------------------------------------------ The worker's phone

  /** My checks waiting for an answer (the app shows the full-screen prompt from these). */
  async mine(actor: AuthUser): Promise<SpotCheckDto[]> {
    const now = this.clock.now();
    return (await this.repo.findOpenFor(actor.staffId))
      .filter((c) => !c.dueAt || c.dueAt >= now)
      .map(toDto);
  }

  async snooze(actor: AuthUser, id: string): Promise<SpotCheckDto> {
    const now = this.clock.now();
    const check = await this.own(actor, id);
    const changes = {
      snoozeCount: 1,
      dueAt: new Date(check.dueAt!.getTime() + SNOOZE_MINUTES * MINUTE),
    };
    if (!(await this.move(check, 'SNOOZE', changes, now, true))) throw this.changed();
    return toDto({ ...check, ...changes, status: 'SNOOZED' });
  }

  /**
   * The answer: the same proof as a punch. A face that does not match can be retried with a new
   * challenge until the deadline; being outside the ward is recorded and escalated.
   */
  async respond(actor: AuthUser, id: string, dto: RespondSpotCheckDto): Promise<SpotCheckDto> {
    const earlier = await this.repo.findByResponseUuid(dto.clientUuid);
    if (earlier) {
      if (earlier.id !== id || earlier.staffId !== actor.staffId) {
        throw new AppError(ErrorCode.CONFLICT, 'This clientUuid was already used', {
          field: 'clientUuid',
        });
      }
      return toDto(earlier);
    }
    const now = this.clock.now();
    const check = await this.own(actor, id);
    this.rule(() =>
      spotTransition(
        { status: check.status, snoozeCount: Number(check.snoozeCount), dueAt: check.dueAt },
        'RESPOND',
        now,
      ),
    );
    const proof = await this.attendance.provePresence(actor, dto);
    const status = proof.inGeofence ? 'VERIFIED' : 'OUT_OF_GEOFENCE';
    const changes: Partial<SpotCheck> = {
      status,
      responseClientUuid: dto.clientUuid,
      respondedAt: now,
      responseLat: dto.latitude,
      responseLng: dto.longitude,
      responseAccuracyM: dto.accuracyM,
      responseInGeofence: proof.inGeofence,
      faceScore: proof.faceScore,
      updatedAt: now,
    };
    const moved = await this.uow.run(async (tx) => {
      const n = await this.repo.update(check, changes, tx);
      if (n === 0) return 0;
      await this.audit.write(tx, {
        action: 'SPOT_CHECK_ANSWERED',
        entityType: 'spot_check',
        entityId: check.id,
        details: { status, distanceM: proof.distanceM },
      });
      return n;
    });
    if (!moved) throw this.changed();
    if (status === 'OUT_OF_GEOFENCE') {
      await this.raise(
        check,
        'OUT_OF_ZONE',
        'Answered a spot check from outside the ward',
        'अचानक तपासणीला प्रभागाबाहेरून उत्तर',
        {
          distanceM: proof.distanceM,
        },
      );
    }
    return toDto({ ...check, ...changes, version: Number(check.version) + 1 });
  }

  // ------------------------------------------------------------ Helpers

  private newCheck(
    duty: OnDuty,
    trigger: SpotCheck['triggerType'],
    when: Date,
    now: Date,
  ): SpotCheck {
    return {
      id: this.ids.next(),
      staffId: duty.staffId,
      wardId: duty.wardId,
      shiftDate: duty.date,
      triggerType: trigger,
      initiatedById: null,
      reason: null,
      status: 'SCHEDULED',
      scheduledAt: when,
      notifiedAt: null,
      dueAt: null,
      snoozeCount: 0,
      responseClientUuid: null,
      respondedAt: null,
      responseLat: null,
      responseLng: null,
      responseAccuracyM: null,
      responseInGeofence: null,
      faceScore: null,
      escalatedAt: null,
      version: 1,
      createdAt: now,
      updatedAt: now,
    };
  }

  private async own(actor: AuthUser, id: string): Promise<SpotCheck> {
    const check = await this.repo.findById(id);
    if (!check || check.staffId !== actor.staffId) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Spot check not found', { id });
    }
    return check;
  }

  /** Applies a transition (versioned). Returns 1 when it moved, 0 when the rule or a race stopped it. */
  private async move(
    check: SpotCheck,
    action: SpotAction,
    changes: Partial<SpotCheck>,
    now: Date,
    strict = false,
  ): Promise<number> {
    const transition = () =>
      spotTransition(
        { status: check.status, snoozeCount: Number(check.snoozeCount), dueAt: check.dueAt },
        action,
        now,
      );
    let status;
    if (strict) {
      status = this.rule(transition);
    } else {
      try {
        status = transition();
      } catch (error) {
        if (error instanceof SpotRuleError) return 0; // a later run or a race got there first
        throw error;
      }
    }
    return this.repo.update(check, { ...changes, status, updatedAt: now });
  }

  private rule<T>(fn: () => T): T {
    try {
      return fn();
    } catch (error) {
      if (!(error instanceof SpotRuleError)) throw error;
      if (error.reason === 'CLOSED') throw new AppError(ErrorCode.SPOT_CHECK_CLOSED);
      throw new AppError(
        ErrorCode.RULE_VIOLATION,
        error.reason === 'SNOOZE_USED' ? 'The one snooze is used' : 'Not notified yet',
        {
          reason: error.reason,
        },
      );
    }
  }

  private changed(): AppError {
    return new AppError(ErrorCode.VERSION_CONFLICT);
  }

  private async tellWorker(check: SpotCheck): Promise<void> {
    await this.notifications.notify([check.staffId], {
      kind: 'SPOT_CHECK',
      priority: 'HIGH',
      title: 'Spot check: confirm you are at work',
      titleMr: 'अचानक तपासणी: तुम्ही कामावर असल्याची खात्री करा',
      body: `Open FieldOps and answer within ${SPOT_WINDOW_MINUTES} minutes`,
      bodyMr: `FieldOps उघडा आणि ${SPOT_WINDOW_MINUTES} मिनिटांत उत्तर द्या`,
      refType: 'SPOT_CHECK',
      refId: check.id,
    });
  }

  private async escalate(check: SpotCheck): Promise<void> {
    await this.raise(
      check,
      'MISSED_SPOT_CHECK',
      'Did not answer a spot check in time',
      'अचानक तपासणीला वेळेत उत्तर दिले नाही',
      {},
    );
  }

  private async raise(
    check: SpotCheck,
    alertType: 'MISSED_SPOT_CHECK' | 'OUT_OF_ZONE',
    message: string,
    messageMr: string,
    details: Record<string, unknown>,
  ): Promise<void> {
    try {
      await this.alerts.raise({
        alertType,
        severity: 'HIGH',
        message,
        messageMr,
        staffId: check.staffId,
        wardId: check.wardId ?? undefined,
        details: { spotCheckId: check.id, date: check.shiftDate, ...details },
        dedupeKey: dedupeKey(alertType, check.staffId, `SPOT:${check.id}`),
      });
    } catch (error) {
      this.logger.error({ err: error }, 'Could not raise the spot-check alert');
    }
  }
}
