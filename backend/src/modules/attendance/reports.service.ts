import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import { Clock } from '../../shared/clock/clock';
import { addDays, istDate } from '../../shared/clock/ist';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { RostersService } from '../rosters/rosters.service';
import { StaffService } from '../staff/staff.service';
import { WardsService } from '../wards/wards.service';
import { AttendanceRepository } from './attendance.repository';
import type {
  LiveDto,
  MusterQueryDto,
  LiveQueryDto,
  PublicWardAttendanceDto,
  ReportQueryDto,
  StaffReportDto,
  StaffReportQueryDto,
  WardDaysDto,
} from './dto/reports.dto';
import type { AttendanceLog } from './entities/attendance-log.entity';
import { checkReportRange, liveState, reportWard } from './reports.policy';
import { SummariesRepository } from './summaries.repository';
import { TrackingRepository } from './tracking.repository';
import { renderMusterPdf } from './muster.pdf';
import { buildMuster, monthDays, musterCsv } from './muster.policy';

const bool = (v: unknown): boolean => Boolean(Number(v));
const num = (v: unknown): number | null => (v === null || v === undefined ? null : Number(v));

/** Days of the citizens' ward page: the last week of nightly summaries. */
const PUBLIC_DAYS = 7;

/**
 * Read-only views for supervisors (action plan Phase 3): who is on duty where right now (live
 * map) and attendance reports from the nightly summaries and the day's logs, plus the
 * aggregate-only ward figures citizens see. Scope rules: reports.policy.
 */
@Injectable()
export class ReportsService {
  constructor(
    private readonly attendance: AttendanceRepository,
    private readonly tracking: TrackingRepository,
    private readonly summaries: SummariesRepository,
    private readonly staff: StaffService,
    private readonly rosters: RostersService,
    private readonly wards: WardsService,
    private readonly clock: Clock,
  ) {}

  /** Everyone checked in on a field shift (today's, or last night's) in the caller's scope. */
  async live(actor: AuthUser, q: LiveQueryDto): Promise<LiveDto> {
    const now = this.clock.now();
    const today = istDate(now);
    const yesterday = addDays(today, -1);
    let open = (await this.attendance.findOpen(today)).filter(
      (l) => l.wardId && l.attendanceDate >= yesterday,
    );
    open = await this.inScope(actor, open, q.wardId, yesterday, today);

    const since = new Date(Math.min(now.getTime(), ...open.map((l) => l.checkinAt!.getTime())));
    const latest = await this.tracking.latestPings(
      open.map((l) => l.staffId),
      since,
    );
    const silent = new Set((await this.tracking.findOpenSilentGaps()).map((g) => g.staffId));
    return {
      at: now.toISOString(),
      items: open.map((log) => {
        const ping = latest.get(log.staffId);
        const fresh = ping && ping.recordedAt >= log.checkinAt! ? ping : null;
        return {
          staffId: log.staffId,
          attendanceId: log.id,
          wardId: log.wardId!,
          date: log.attendanceDate,
          checkinAt: log.checkinAt!.toISOString(),
          state: liveState(fresh?.recordedAt ?? null, now, silent.has(log.staffId)),
          lastSeenAt: fresh ? fresh.recordedAt.toISOString() : null,
          latitude: fresh ? Number(fresh.lat) : num(log.checkinLat),
          longitude: fresh ? Number(fresh.lng) : num(log.checkinLng),
          accuracyM: fresh ? num(fresh.accuracyM) : num(log.checkinAccuracyM),
          inWard: fresh
            ? fresh.inWard === null
              ? null
              : bool(fresh.inWard)
            : bool(log.checkinInGeofence),
          isMocked: fresh ? bool(fresh.isMocked) : bool(log.checkinIsMocked),
        };
      }),
    };
  }

  /** One row per ward and day from the nightly summaries (yesterday and earlier). */
  async wardDays(actor: AuthUser, q: ReportQueryDto): Promise<WardDaysDto> {
    const ward = this.scope(actor, q);
    const rows = await this.summaries.findWardSummariesBetween(q.from, q.to, ward);
    return {
      items: rows.map((r) => ({
        date: r.summaryDate,
        wardId: r.wardId,
        assignedCount: Number(r.assignedCount),
        presentCount: Number(r.presentCount),
        lateCount: Number(r.lateCount),
        halfDayCount: Number(r.halfDayCount),
        absentCount: Number(r.absentCount),
        onLeaveCount: Number(r.onLeaveCount),
        proxyCount: Number(r.proxyCount),
        autoCheckoutCount: Number(r.autoCheckoutCount),
        suspiciousCount: Number(r.suspiciousCount),
        distanceM: Number(r.distanceM),
      })),
    };
  }

  /** Per-person totals (late marks, absences, leave, corrections) over a date range. */
  async staffDays(actor: AuthUser, q: StaffReportQueryDto): Promise<StaffReportDto> {
    const wardId = this.scope(actor, q);
    const [items, total] = await this.attendance.staffTotals(
      { from: q.from, to: q.to, wardId },
      (q.page - 1) * q.pageSize,
      q.pageSize,
    );
    return { items, page: q.page, pageSize: q.pageSize, total };
  }

  /**
   * A ward's muster roll for a month (CSV with Marathi names, or a printable PDF): everyone with
   * a home in the ward or a day there, one code per day, and totals.
   */
  async musterRoll(
    actor: AuthUser,
    q: MusterQueryDto,
  ): Promise<{ fileName: string; contentType: string; body: Buffer }> {
    const days = monthDays(q.month);
    const today = istDate(this.clock.now());
    if (!days || days[0] > today) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'Choose this month or an earlier one', {
        field: 'month',
      });
    }
    const ward = reportWard(actor, q.wardId);
    if (ward === 'FORBIDDEN') throw new AppError(ErrorCode.FORBIDDEN);
    if (!ward.wardId) {
      throw new AppError(ErrorCode.VALIDATION_FAILED, 'Choose a ward', { field: 'wardId' });
    }
    const wardDto = await this.wards.get(ward.wardId);
    const logs = await this.attendance.findForWardBetween(
      ward.wardId,
      days[0],
      days[days.length - 1],
    );
    const ids = new Set([
      ...logs.map((l) => l.staffId),
      ...(await this.staff.findIds({ wardId: ward.wardId, isActive: true })),
    ]);
    const people = (await this.staff.findByIds([...ids]))
      .filter((p) => p.role !== Role.ADMIN && p.role !== Role.OFFICE_STAFF)
      .map((p) => ({
        staffId: p.id,
        employeeCode: p.employeeCode,
        name: q.format === 'pdf' ? p.fullName : (p.fullNameMr ?? p.fullName),
        role: p.role,
      }));
    const rows = buildMuster(
      days,
      people,
      logs.map((l) => ({ staffId: l.staffId, date: l.attendanceDate, status: l.status })),
    );
    const title = `SMKMC muster roll - ${wardDto.code} ${wardDto.name} - ${q.month}`;
    const base = `muster-roll_${wardDto.code}_${q.month}`;
    if (q.format === 'pdf') {
      return {
        fileName: `${base}.pdf`,
        contentType: 'application/pdf',
        body: await renderMusterPdf(title, days, rows),
      };
    }
    // The BOM lets Excel read the Marathi names as UTF-8.
    return {
      fileName: `${base}.csv`,
      contentType: 'text/csv; charset=utf-8',
      body: Buffer.from(`\ufeff${musterCsv(title, days, rows)}`, 'utf8'),
    };
  }

  /** Citizens: how many staff were placed and turned up in a ward over the last week. No names. */
  async publicWard(wardId: string): Promise<PublicWardAttendanceDto> {
    const ward = await this.wards.get(wardId); // 404 for an unknown ward
    if (!ward.isActive) throw new AppError(ErrorCode.NOT_FOUND, 'Ward not found', { id: wardId });
    const today = istDate(this.clock.now());
    const rows = await this.summaries.findWardSummariesBetween(
      addDays(today, -PUBLIC_DAYS),
      addDays(today, -1),
      wardId,
    );
    return {
      wardId,
      days: rows.map((r) => ({
        date: r.summaryDate,
        assignedCount: Number(r.assignedCount),
        presentCount: Number(r.presentCount),
        onLeaveCount: Number(r.onLeaveCount),
      })),
    };
  }

  private scope(actor: AuthUser, q: ReportQueryDto): string | null {
    const problem = checkReportRange(q.from, q.to, istDate(this.clock.now()));
    if (problem) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'The report dates are not valid', {
        field: 'from',
        problem,
      });
    }
    const ward = reportWard(actor, q.wardId);
    if (ward === 'FORBIDDEN') throw new AppError(ErrorCode.FORBIDDEN);
    return ward.wardId;
  }

  /** Live map scope: admin / ward inspector by ward; an inspector their reports and placements. */
  private async inScope(
    actor: AuthUser,
    logs: AttendanceLog[],
    wardId: string | undefined,
    from: string,
    to: string,
  ): Promise<AttendanceLog[]> {
    if (actor.role === Role.INSPECTOR) {
      const team = new Set(await this.staff.findIds({ reportsToId: actor.staffId }));
      const placed = new Set(
        (await this.rosters.placementsUnder(actor.staffId, from, to)).map((p) => p.assignmentId),
      );
      return logs.filter(
        (l) => team.has(l.staffId) || (l.assignmentId !== null && placed.has(l.assignmentId)),
      );
    }
    const ward = reportWard(actor, wardId);
    if (ward === 'FORBIDDEN') throw new AppError(ErrorCode.FORBIDDEN);
    return ward.wardId ? logs.filter((l) => l.wardId === ward.wardId) : logs;
  }
}
