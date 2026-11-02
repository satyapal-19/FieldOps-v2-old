import { Injectable, Logger } from '@nestjs/common';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { istDate } from '../../shared/clock/ist';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { IdGenerator } from '../../shared/ids/id-generator';
import { dedupeKey } from '../alerts/alerts.policy';
import { AlertsService, RaiseAlert } from '../alerts/alerts.service';
import { StaffService } from '../staff/staff.service';
import type { GeoPoint, LocationCheck } from '../wards/wards.policy';
import { WardsService } from '../wards/wards.service';
import { isOutOfZone, logForPing, pingTimeAcceptable, tamperSeverity } from './attendance.policy';
import { AttendanceRepository } from './attendance.repository';
import type {
  PingBatchDto,
  PingBatchResultDto,
  RejectedItemDto,
  TamperBatchDto,
  TamperBatchResultDto,
} from './dto/tracking.dto';
import type { AttendanceLog } from './entities/attendance-log.entity';
import type { LocationPing } from './entities/location-ping.entity';
import type { TamperEvent } from './entities/tamper-event.entity';
import { isStationary } from './geo.policy';
import { TrackingRepository } from './tracking.repository';

function previousDay(date: string): string {
  const d = new Date(`${date}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() - 1);
  return d.toISOString().slice(0, 10);
}

/**
 * Breadcrumbs and device tamper reports from the phone (action plan Phase 2). Both arrive in
 * batches from the offline outbox, are idempotent by clientUuid, and are stored for the
 * caller only. Supervisors hear about them through alerts (OUT_OF_ZONE, TAMPER_DETECTED).
 */
@Injectable()
export class TrackingService {
  private readonly logger = new Logger(TrackingService.name);

  constructor(
    private readonly repo: TrackingRepository,
    private readonly attendance: AttendanceRepository,
    private readonly wards: WardsService,
    private readonly staff: StaffService,
    private readonly alerts: AlertsService,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  async recordPings(actor: AuthUser, dto: PingBatchDto): Promise<PingBatchResultDto> {
    const now = this.clock.now();
    const rejected: RejectedItemDto[] = [];
    const seen = new Set<string>();
    let duplicates = 0;
    const valid = dto.pings.filter((p) => {
      if (seen.has(p.clientUuid)) {
        duplicates++;
        return false;
      }
      seen.add(p.clientUuid);
      if (!pingTimeAcceptable(new Date(p.recordedAt), now)) {
        rejected.push({ clientUuid: p.clientUuid, reason: 'TIME_OUT_OF_RANGE' });
        return false;
      }
      return true;
    });

    const stored = await this.repo.existingPingUuids(valid.map((p) => p.clientUuid));
    duplicates += stored.size;
    const fresh = valid
      .filter((p) => !stored.has(p.clientUuid))
      .map((p) => ({ ...p, at: new Date(p.recordedAt) }))
      .sort((a, b) => a.at.getTime() - b.at.getTime());
    if (fresh.length === 0) return { accepted: 0, duplicates, rejected };

    const dates = new Set<string>();
    for (const p of fresh) {
      const d = istDate(p.at);
      dates.add(d);
      dates.add(previousDay(d)); // a night shift that began the day before
    }
    const logs = await this.attendance.findForDates(actor.staffId, [...dates]);
    const fences = new Map<string, ((point: GeoPoint) => LocationCheck) | null>();
    const fenceFor = async (wardId: string) => {
      if (!fences.has(wardId)) fences.set(wardId, await this.wards.geofence(wardId));
      return fences.get(wardId)!;
    };

    const previous = await this.repo.lastPingBefore(actor.staffId, fresh[0].at);
    let last: GeoPoint | null = previous
      ? { latitude: Number(previous.lat), longitude: Number(previous.lng) }
      : null;
    const rows: LocationPing[] = [];
    for (const p of fresh) {
      const point = { latitude: p.latitude, longitude: p.longitude };
      const log = logForPing(logs, p.at);
      const fence = log?.wardId ? await fenceFor(log.wardId) : null;
      rows.push({
        id: this.ids.next(),
        clientUuid: p.clientUuid,
        staffId: actor.staffId,
        attendanceId: log?.id ?? null,
        lat: p.latitude,
        lng: p.longitude,
        accuracyM: p.accuracyM ?? null,
        batteryPct: p.batteryPct ?? null,
        inWard: fence ? fence(point).withinTolerance : null,
        isMocked: Boolean(p.isMocked),
        isStationary: isStationary(last, point),
        fromOffline: Boolean(p.fromOffline),
        recordedAt: p.at,
        receivedAt: now,
      });
      last = point;
    }
    const accepted = await this.repo.insertPings(rows);
    duplicates += rows.length - accepted;

    await this.checkOutOfZone(actor.staffId, logs, rows, previous);
    if (rows.some((r) => r.isMocked)) {
      await this.raise({
        alertType: 'TAMPER_DETECTED',
        severity: 'HIGH',
        message: 'Location pings report a mock location',
        messageMr: 'लोकेशन पिंगमध्ये बनावट लोकेशन',
        staffId: actor.staffId,
        wardId: actor.homeWardId ?? undefined,
        details: { signal: 'MOCK_LOCATION', source: 'PING' },
        dedupeKey: dedupeKey('TAMPER_DETECTED', actor.staffId, `${istDate(now)}:MOCK`),
      });
    }
    return { accepted, duplicates, rejected };
  }

  async recordTamper(actor: AuthUser, dto: TamperBatchDto): Promise<TamperBatchResultDto> {
    const now = this.clock.now();
    const rejected: RejectedItemDto[] = [];
    let accepted = 0;
    let duplicates = 0;
    for (const e of dto.events) {
      const startedAt = new Date(e.startedAt);
      const resolvedAt = e.resolvedAt ? new Date(e.resolvedAt) : null;
      if (!pingTimeAcceptable(startedAt, now) || (resolvedAt && resolvedAt < startedAt)) {
        rejected.push({ clientUuid: e.clientUuid, reason: 'TIME_OUT_OF_RANGE' });
        continue;
      }
      const existing = await this.repo.findTamperByClientUuid(e.clientUuid);
      if (existing) {
        if (existing.staffId !== actor.staffId) {
          rejected.push({ clientUuid: e.clientUuid, reason: 'CLIENT_UUID_TAKEN' });
          continue;
        }
        if (resolvedAt && !existing.resolvedAt)
          await this.repo.resolveTamper(existing.id, resolvedAt);
        duplicates++;
        continue;
      }
      const row: TamperEvent = {
        id: this.ids.next(),
        clientUuid: e.clientUuid,
        staffId: actor.staffId,
        eventType: e.eventType,
        source: 'DEVICE',
        startedAt,
        resolvedAt,
        lastLat: e.lastLatitude ?? null,
        lastLng: e.lastLongitude ?? null,
        createdAt: now,
      };
      try {
        await this.repo.insertTamper(row);
      } catch (error) {
        if (!isUniqueViolation(error)) throw error;
        duplicates++;
        continue;
      }
      accepted++;
      await this.raise({
        alertType: 'TAMPER_DETECTED',
        severity: tamperSeverity(e.eventType),
        message: `Phone reported ${e.eventType.replace(/_/g, ' ').toLowerCase()}`,
        messageMr: `फोनवर छेडछाड: ${e.eventType}`,
        staffId: actor.staffId,
        wardId: actor.homeWardId ?? undefined,
        details: {
          tamperEventId: row.id,
          eventType: e.eventType,
          startedAt: startedAt.toISOString(),
          resolvedAt: resolvedAt ? resolvedAt.toISOString() : null,
        },
        dedupeKey: dedupeKey(
          'TAMPER_DETECTED',
          actor.staffId,
          `${istDate(startedAt)}:${e.eventType}`,
        ),
      });
    }
    return { accepted, duplicates, rejected };
  }

  /** Two outside pings in a row during an open ward shift raise one OUT_OF_ZONE per day. */
  private async checkOutOfZone(
    staffId: string,
    logs: AttendanceLog[],
    rows: LocationPing[],
    previous: LocationPing | null,
  ): Promise<void> {
    for (const log of logs) {
      if (!log.wardId || log.checkoutAt) continue;
      const own = rows.filter((r) => r.attendanceId === log.id).map((r) => r.inWard);
      if (own.length === 0) continue;
      const before = previous?.attendanceId === log.id ? [previous.inWard] : [];
      const flags = [...before, ...own].map((f) => (f === null ? null : Boolean(Number(f))));
      if (!isOutOfZone(flags)) continue;
      const person = await this.staff.findById(staffId);
      const name = person?.fullName ?? 'A staff member';
      await this.raise({
        alertType: 'OUT_OF_ZONE',
        severity: 'MEDIUM',
        message: `${name} is outside the assigned ward`,
        messageMr: `${person?.fullNameMr ?? name} नेमलेल्या प्रभागाबाहेर आहेत`,
        staffId,
        wardId: log.wardId,
        details: { attendanceId: log.id, date: log.attendanceDate },
        dedupeKey: dedupeKey('OUT_OF_ZONE', staffId, log.attendanceDate),
      });
    }
  }

  /** Alerts never fail an accepted batch: a failure is logged and the data stays stored. */
  private async raise(input: RaiseAlert): Promise<void> {
    try {
      await this.alerts.raise(input);
    } catch (error) {
      this.logger.error({ err: error, alertType: input.alertType }, 'Could not raise alert');
    }
  }
}
