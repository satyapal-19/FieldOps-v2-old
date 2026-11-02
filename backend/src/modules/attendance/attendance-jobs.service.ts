import { Injectable, Logger } from '@nestjs/common';
import { AuditWriter } from '../../shared/audit/audit-writer';
import { Clock } from '../../shared/clock/clock';
import { addDays, istDate } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { UnitOfWork } from '../../shared/database/unit-of-work';
import { IdGenerator } from '../../shared/ids/id-generator';
import { dedupeKey } from '../alerts/alerts.policy';
import { AlertsService, RaiseAlert } from '../alerts/alerts.service';
import { LeaveService } from '../leave/leave.service';
import { RostersService } from '../rosters/rosters.service';
import { ShiftsService } from '../shifts/shifts.service';
import type { Staff } from '../staff/entities/staff.entity';
import { StaffService } from '../staff/staff.service';
import { statusAtCheckout, workedMinutes } from './attendance.policy';
import { AttendanceRepository } from './attendance.repository';
import type { AttendanceLog } from './entities/attendance-log.entity';
import type { LocationPing } from './entities/location-ping.entity';
import type { TamperEvent } from './entities/tamper-event.entity';
import {
  autoCheckout,
  autoCheckoutDue,
  CHALLENGE_RETENTION_DAYS,
  isSilent,
  pingDate,
  pingWindow,
  retentionCutoff,
  rollupDates,
  RoutePing,
  routeStats,
  wardDayCounts,
} from './jobs.policy';
import { SummariesRepository } from './summaries.repository';
import { TrackingRepository } from './tracking.repository';

const bool = (v: unknown): boolean => Boolean(Number(v));

/** People per query while rolling up a day of pings (keeps memory flat at 4,000 staff). */
const ROLLUP_CHUNK = 200;

export function toRoutePing(p: LocationPing): RoutePing {
  return {
    attendanceId: p.attendanceId,
    latitude: Number(p.lat),
    longitude: Number(p.lng),
    accuracyM: p.accuracyM === null ? null : Number(p.accuracyM),
    inWard: p.inWard === null ? null : bool(p.inWard),
    isMocked: bool(p.isMocked),
    isStationary: bool(p.isStationary),
    fromOffline: bool(p.fromOffline),
    recordedAt: p.recordedAt,
  };
}

/** IST midnight of a date, and of the next day: the day's [from, to) window. */
function istDay(date: string): { from: Date; to: Date } {
  return {
    from: new Date(`${date}T00:00:00+05:30`),
    to: new Date(`${addDays(date, 1)}T00:00:00+05:30`),
  };
}

/**
 * The scheduled attendance jobs (action plan Phase 2). Each method is one run, safe to
 * repeat: the scheduler calls them through JobRunner so one instance runs each slot, and
 * tests call them directly with a frozen clock. Rules: jobs.policy. Each returns a one-line
 * result for job_locks.
 */
@Injectable()
export class AttendanceJobsService {
  private readonly logger = new Logger(AttendanceJobsService.name);

  constructor(
    private readonly attendance: AttendanceRepository,
    private readonly tracking: TrackingRepository,
    private readonly summaries: SummariesRepository,
    private readonly staff: StaffService,
    private readonly shifts: ShiftsService,
    private readonly rosters: RostersService,
    private readonly leave: LeaveService,
    private readonly alerts: AlertsService,
    private readonly config: AppConfig,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
    private readonly uow: UnitOfWork,
    private readonly audit: AuditWriter,
  ) {}

  // ------------------------------------------------------------ Auto-checkout (every 30 min)

  /** Closes shifts nobody checked out of, an hour after they were due to end. */
  async autoCheckout(): Promise<string> {
    const now = this.clock.now();
    const open = await this.attendance.findOpen(istDate(now));
    const people = await this.peopleOf(open);
    let closed = 0;
    for (const log of open) {
      const person = people.get(log.staffId);
      if (!person) continue;
      const shift = await this.shifts.shiftFor(person, log.attendanceDate);
      if (!autoCheckoutDue(shift, now)) continue;

      const kind = log.officeId ? 'OFFICE' : 'WARD';
      const checkinAt = log.checkinAt!;
      const lastSeen =
        kind === 'WARD'
          ? ((await this.tracking.lastPingBetween(log.staffId, checkinAt, shift.endsAt))
              ?.recordedAt ?? null)
          : null;
      const out = autoCheckout(kind, checkinAt, shift, lastSeen);
      const worked = workedMinutes(checkinAt, out.checkoutAt);
      const status = statusAtCheckout(log.status, worked, shift);

      closed += await this.uow.run(async (tx) => {
        const n = await this.attendance.checkOut(
          log.id,
          Number(log.version),
          {
            checkoutAt: out.checkoutAt,
            checkoutType: out.checkoutType,
            workedMinutes: worked,
            status,
            isSuspicious: bool(log.isSuspicious) || out.suspicious,
            updatedAt: now,
          },
          tx,
        );
        if (n === 0) return 0; // checked out by hand meanwhile
        await this.audit.write(tx, {
          action: 'ATTENDANCE_AUTO_CHECKOUT',
          entityType: 'attendance',
          entityId: log.id,
          actorRole: 'SYSTEM',
          details: {
            staffId: log.staffId,
            date: log.attendanceDate,
            checkoutType: out.checkoutType,
            checkoutAt: out.checkoutAt.toISOString(),
            workedMinutes: worked,
            status,
            noLocationAfterCheckin: out.suspicious,
          },
        });
        return n;
      });
    }
    return `closed ${closed} of ${open.length} open shifts`;
  }

  // ------------------------------------------------------------ Silent gaps (every 15 min)

  /**
   * Records a SERVER tamper event when a checked-in field phone stops sending pings, and
   * closes it when pings resume (offline pings uploaded later count) or the shift ends.
   */
  async detectSilentGaps(): Promise<string> {
    const now = this.clock.now();
    const open = (await this.attendance.findOpen(istDate(now))).filter((l) => l.wardId);
    const gaps = new Map<string, TamperEvent>(
      (await this.tracking.findOpenSilentGaps()).map((g) => [g.staffId, g]),
    );
    const people = await this.peopleOf(open);
    const since = new Date(Math.min(now.getTime(), ...open.map((l) => l.checkinAt!.getTime())));
    const lastPings = await this.tracking.lastPingTimes(
      open.map((l) => l.staffId),
      since,
    );

    let found = 0;
    let resolved = 0;
    const onShift = new Set<string>();
    for (const log of open) {
      onShift.add(log.staffId);
      const ping = lastPings.get(log.staffId);
      const lastSeen = ping && ping > log.checkinAt! ? ping : log.checkinAt!;
      const gap = gaps.get(log.staffId);
      if (gap) {
        if (lastSeen > gap.startedAt && (await this.resolveGap(gap, null))) resolved++;
        continue;
      }
      const person = people.get(log.staffId);
      if (!person) continue;
      const shift = await this.shifts.shiftFor(person, log.attendanceDate);
      if (!isSilent(lastSeen, shift, now)) continue;
      await this.openGap(log, person, lastSeen, now);
      found++;
    }

    // Gaps of people whose shift has closed since: they end at the check-out at the latest.
    for (const gap of gaps.values()) {
      if (onShift.has(gap.staffId)) continue;
      const date = istDate(gap.startedAt);
      const logs = await this.attendance.findForDates(gap.staffId, [addDays(date, -1), date]);
      const closedAt = logs
        .map((l) => l.checkoutAt)
        .filter((at): at is Date => at !== null && at >= gap.startedAt)
        .sort((a, b) => a.getTime() - b.getTime())[0];
      if (await this.resolveGap(gap, closedAt ?? now)) resolved++;
    }
    return `opened ${found} silent gaps, closed ${resolved}`;
  }

  /** Ends a gap at the first ping after it began, or at `fallback` if that is earlier. */
  private async resolveGap(gap: TamperEvent, fallback: Date | null): Promise<boolean> {
    const first = (await this.tracking.firstPingAfter(gap.staffId, gap.startedAt))?.recordedAt;
    const ends = [first, fallback].filter((d): d is Date => Boolean(d));
    if (ends.length === 0) return false;
    const end = new Date(Math.min(...ends.map((d) => d.getTime())));
    await this.tracking.resolveTamper(gap.id, end < gap.startedAt ? gap.startedAt : end);
    return true;
  }

  private async openGap(
    log: AttendanceLog,
    person: Staff,
    lastSeen: Date,
    now: Date,
  ): Promise<void> {
    const lastPing = await this.tracking.lastPingBefore(
      log.staffId,
      new Date(lastSeen.getTime() + 1),
    );
    const row: TamperEvent = {
      id: this.ids.next(),
      clientUuid: null,
      staffId: log.staffId,
      eventType: 'SILENT_GAP',
      source: 'SERVER',
      startedAt: lastSeen,
      resolvedAt: null,
      lastLat: lastPing ? Number(lastPing.lat) : null,
      lastLng: lastPing ? Number(lastPing.lng) : null,
      createdAt: now,
    };
    await this.tracking.insertTamper(row);
    const minutes = Math.floor((now.getTime() - lastSeen.getTime()) / 60_000);
    await this.raise({
      alertType: 'TAMPER_DETECTED',
      severity: 'MEDIUM',
      message: `${person.fullName}'s phone has sent no location for ${minutes} minutes`,
      messageMr: `${person.fullNameMr ?? person.fullName} यांच्या फोनवरून ${minutes} मिनिटे लोकेशन आले नाही`,
      staffId: log.staffId,
      wardId: log.wardId ?? undefined,
      details: {
        tamperEventId: row.id,
        eventType: 'SILENT_GAP',
        attendanceId: log.id,
        lastSeenAt: lastSeen.toISOString(),
      },
      dedupeKey: dedupeKey(
        'TAMPER_DETECTED',
        log.staffId,
        `${log.attendanceDate}:GAP:${lastSeen.toISOString().slice(11, 16)}`,
      ),
    });
  }

  // ------------------------------------------------------------ Nightly roll-up (01:30 IST)

  /** Rolls the last two IST days of pings into route summaries, then counts each ward's day. */
  async rollUp(): Promise<string> {
    const parts: string[] = [];
    for (const date of rollupDates(this.clock.now())) {
      const routes = await this.rollUpRoutes(date);
      const wards = await this.summarizeWards(date);
      parts.push(`${date}: ${routes} routes, ${wards} wards`);
    }
    return parts.join('; ');
  }

  /** Writes one route summary per person who sent pings counting towards `date`. */
  async rollUpRoutes(date: string): Promise<number> {
    const now = this.clock.now();
    const window = pingWindow(date);
    const day = istDay(date);
    const staffIds = await this.tracking.staffWithPings(window.from, window.to);
    const tamper = await this.tracking.tamperCounts(day.from, day.to);
    let written = 0;
    for (let i = 0; i < staffIds.length; i += ROLLUP_CHUNK) {
      const pings = await this.tracking.pingsOfStaff(
        staffIds.slice(i, i + ROLLUP_CHUNK),
        window.from,
        window.to,
      );
      const logIds = [...new Set(pings.map((p) => p.attendanceId).filter((id) => id !== null))];
      const logs = new Map((await this.attendance.findByIds(logIds)).map((l) => [l.id, l]));
      const dates = new Map([...logs.values()].map((l) => [l.id, l.attendanceDate]));

      const byStaff = new Map<string, RoutePing[]>();
      for (const p of pings) {
        const rp = toRoutePing(p);
        if (pingDate(rp, dates) !== date) continue;
        const list = byStaff.get(p.staffId) ?? [];
        list.push(rp);
        byStaff.set(p.staffId, list);
      }
      for (const [staffId, own] of byStaff) {
        const attendanceId = own.find((p) => p.attendanceId)?.attendanceId ?? null;
        await this.summaries.saveRoute(
          {
            staffId,
            summaryDate: date,
            attendanceId,
            wardId: (attendanceId && logs.get(attendanceId)?.wardId) || null,
            ...routeStats(own),
            tamperEvents: tamper.get(staffId) ?? 0,
            computedAt: now,
          },
          this.ids.next(),
        );
        written++;
      }
    }
    return written;
  }

  /** Writes one summary per ward that had placements or punches on `date`. */
  async summarizeWards(date: string): Promise<number> {
    const now = this.clock.now();
    const placements = await this.rosters.approvedPlacements(date);
    const logs = (await this.attendance.findForDate(date)).filter((l) => l.wardId);
    const onLeave = await this.leave.staffOnLeave(date);
    const distance = await this.summaries.distanceByWard(date);
    const wardIds = new Set([...placements.map((p) => p.wardId), ...logs.map((l) => l.wardId!)]);
    for (const wardId of wardIds) {
      const assigned = new Set(placements.filter((p) => p.wardId === wardId).map((p) => p.staffId));
      const counts = wardDayCounts(
        assigned,
        logs
          .filter((l) => l.wardId === wardId)
          .map((l) => ({
            staffId: l.staffId,
            status: l.status,
            checkinAt: l.checkinAt,
            isLate: bool(l.isLate),
            isSuspicious: bool(l.isSuspicious),
            checkinMode: l.checkinMode,
            checkoutType: l.checkoutType,
          })),
        onLeave,
      );
      await this.summaries.saveWard(
        {
          wardId,
          summaryDate: date,
          ...counts,
          distanceM: distance.get(wardId) ?? 0,
          computedAt: now,
        },
        this.ids.next(),
      );
    }
    return wardIds.size;
  }

  // ------------------------------------------------------------ Retention purge (02:30 IST)

  /** Deletes raw pings past the retention period and old liveness challenges. */
  async purge(): Promise<string> {
    const now = this.clock.now();
    const days = this.config.jobs.pingRetentionDays;
    const pings = await this.tracking.deletePingsBefore(retentionCutoff(now, days));
    const challenges = await this.attendance.deleteChallengesBefore(
      retentionCutoff(now, CHALLENGE_RETENTION_DAYS),
    );
    return `deleted ${pings} pings older than ${days} days and ${challenges} challenges`;
  }

  // ------------------------------------------------------------ Helpers

  private async peopleOf(logs: AttendanceLog[]): Promise<Map<string, Staff>> {
    const ids = [...new Set(logs.map((l) => l.staffId))];
    return new Map((await this.staff.findByIds(ids)).map((s) => [s.id, s]));
  }

  /** Alerts never fail a job run: a failure is logged and the job carries on. */
  private async raise(input: RaiseAlert): Promise<void> {
    try {
      await this.alerts.raise(input);
    } catch (error) {
      this.logger.error({ err: error, alertType: input.alertType }, 'Could not raise alert');
    }
  }
}
