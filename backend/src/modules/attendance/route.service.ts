import { Injectable } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { addDays, istDate } from '../../shared/clock/ist';
import { AppConfig } from '../../shared/config/app-config';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { RostersService } from '../rosters/rosters.service';
import { StaffService } from '../staff/staff.service';
import { routeAccess } from './attendance.policy';
import { AttendanceRepository } from './attendance.repository';
import { toRoutePing } from './attendance-jobs.service';
import type { RouteDto, RouteSummaryDto } from './dto/route.dto';
import type { RouteSummary } from './entities/route-summary.entity';
import { pingDate, pingWindow, retentionCutoff, routeStats } from './jobs.policy';
import { SummariesRepository } from './summaries.repository';
import { TrackingRepository } from './tracking.repository';

const iso = (d: Date | null): string | null => (d ? d.toISOString() : null);

function nightlyDto(s: RouteSummary): RouteSummaryDto {
  return {
    source: 'NIGHTLY',
    pingCount: Number(s.pingCount),
    distanceM: Number(s.distanceM),
    firstPingAt: iso(s.firstPingAt),
    lastPingAt: iso(s.lastPingAt),
    inWardPings: Number(s.inWardPings),
    outWardPings: Number(s.outWardPings),
    stationaryPings: Number(s.stationaryPings),
    mockedPings: Number(s.mockedPings),
    offlinePings: Number(s.offlinePings),
    maxGapMinutes: s.maxGapMinutes === null ? null : Number(s.maxGapMinutes),
    tamperEvents: Number(s.tamperEvents),
  };
}

/**
 * A person's route on one IST attendance date (action plan Phase 2): the raw points while
 * they are kept, the stored nightly summary after they are purged, and the day's tamper
 * events. Distance is computed in Node (geo.policy); access follows attendance.policy.
 */
@Injectable()
export class RouteService {
  constructor(
    private readonly tracking: TrackingRepository,
    private readonly attendance: AttendanceRepository,
    private readonly summaries: SummariesRepository,
    private readonly staff: StaffService,
    private readonly rosters: RostersService,
    private readonly config: AppConfig,
    private readonly clock: Clock,
  ) {}

  async route(actor: AuthUser, staffId: string, date: string): Promise<RouteDto> {
    const now = this.clock.now();
    const today = istDate(now);
    if (date > today) {
      throw new AppError(ErrorCode.RULE_VIOLATION, 'The date is in the future', { field: 'date' });
    }
    const subject = await this.staff.findById(staffId);
    const [log] = subject ? await this.attendance.findForDates(staffId, [date]) : [];
    const placement = subject ? await this.rosters.assignmentFor(date, staffId) : null;
    const access = subject
      ? routeAccess(
          actor,
          {
            id: subject.id,
            reportsToId: subject.reportsToId,
            homeWardId: subject.homeWardId,
            dayWardId: log?.wardId ?? null,
            dayInspectorId: placement?.inspectorId ?? null,
          },
          date,
          today,
        )
      : 'HIDDEN';
    if (access === 'HIDDEN') {
      throw new AppError(ErrorCode.NOT_FOUND, 'Staff member not found', { id: staffId });
    }
    if (access === 'DATE_NOT_ALLOWED') {
      throw new AppError(ErrorCode.FORBIDDEN, 'You can see only your route for today', {
        field: 'date',
      });
    }

    const window = pingWindow(date);
    const dates = new Map(log ? [[log.id, log.attendanceDate]] : []);
    const points = (await this.tracking.pingsFor(staffId, window.from, window.to))
      .map(toRoutePing)
      // Pings linked to another day's shift (the next morning's) are not this day's route.
      .filter((p) => pingDate(p, dates) === date && (!p.attendanceId || dates.has(p.attendanceId)));
    const dayStart = new Date(`${date}T00:00:00+05:30`);
    const tamper = await this.tracking.tamperFor(
      staffId,
      dayStart,
      new Date(`${addDays(date, 1)}T00:00:00+05:30`),
    );

    const stored = points.length === 0 ? await this.summaries.findRoute(staffId, date) : null;
    const summary: RouteSummaryDto = stored
      ? nightlyDto(stored)
      : (() => {
          const s = routeStats(points);
          return {
            source: 'LIVE' as const,
            ...s,
            firstPingAt: iso(s.firstPingAt),
            lastPingAt: iso(s.lastPingAt),
            tamperEvents: tamper.length,
          };
        })();

    return {
      staffId,
      date,
      shift: log
        ? {
            attendanceId: log.id,
            wardId: log.wardId,
            officeId: log.officeId,
            checkinAt: iso(log.checkinAt),
            checkoutAt: iso(log.checkoutAt),
          }
        : null,
      summary,
      points: points.map((p) => ({
        latitude: p.latitude,
        longitude: p.longitude,
        accuracyM: p.accuracyM,
        recordedAt: p.recordedAt.toISOString(),
        inWard: p.inWard,
        isStationary: p.isStationary,
        isMocked: p.isMocked,
        fromOffline: p.fromOffline,
      })),
      pointsPurged: window.to <= retentionCutoff(now, this.config.jobs.pingRetentionDays),
      tamperEvents: tamper.map((t) => ({
        eventType: t.eventType,
        source: t.source,
        startedAt: t.startedAt.toISOString(),
        resolvedAt: iso(t.resolvedAt),
      })),
    };
  }
}
