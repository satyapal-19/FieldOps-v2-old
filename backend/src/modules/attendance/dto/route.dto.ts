import { ApiProperty } from '@nestjs/swagger';
import { Matches } from 'class-validator';
import { TAMPER_EVENT_TYPES, type TamperEventType } from '../attendance-types';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

export class RouteQueryDto {
  @ApiProperty({ example: '2026-11-02', description: 'IST attendance date' })
  @Matches(DATE)
  date: string;
}

export class RoutePointDto {
  @ApiProperty() latitude: number;
  @ApiProperty() longitude: number;
  @ApiProperty({ nullable: true, type: Number }) accuracyM: number | null;
  @ApiProperty({ format: 'date-time' }) recordedAt: string;
  @ApiProperty({ nullable: true, type: Boolean, description: 'Null before check-in' })
  inWard: boolean | null;
  @ApiProperty() isStationary: boolean;
  @ApiProperty() isMocked: boolean;
  @ApiProperty({ description: 'Buffered on the phone and uploaded later' }) fromOffline: boolean;
}

export class RouteSummaryDto {
  @ApiProperty({
    enum: ['LIVE', 'NIGHTLY'],
    description: 'LIVE = computed now from the raw points; NIGHTLY = the stored roll-up',
  })
  source: 'LIVE' | 'NIGHTLY';
  @ApiProperty() pingCount: number;
  @ApiProperty({ description: 'Trusted distance (no mocked or > 50 m fixes), metres' })
  distanceM: number;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) firstPingAt: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) lastPingAt: string | null;
  @ApiProperty() inWardPings: number;
  @ApiProperty() outWardPings: number;
  @ApiProperty() stationaryPings: number;
  @ApiProperty() mockedPings: number;
  @ApiProperty() offlinePings: number;
  @ApiProperty({ nullable: true, type: Number }) maxGapMinutes: number | null;
  @ApiProperty() tamperEvents: number;
}

export class RouteTamperEventDto {
  @ApiProperty({ enum: TAMPER_EVENT_TYPES }) eventType: TamperEventType;
  @ApiProperty({ enum: ['DEVICE', 'SERVER'] }) source: 'DEVICE' | 'SERVER';
  @ApiProperty({ format: 'date-time' }) startedAt: string;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) resolvedAt: string | null;
}

export class RouteShiftDto {
  @ApiProperty({ format: 'uuid' }) attendanceId: string;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) officeId: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) checkinAt: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) checkoutAt: string | null;
}

export class RouteDto {
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ type: RouteShiftDto, nullable: true }) shift: RouteShiftDto | null;
  @ApiProperty({ type: RouteSummaryDto }) summary: RouteSummaryDto;
  @ApiProperty({ type: [RoutePointDto], description: 'Oldest first; empty once purged' })
  points: RoutePointDto[];
  @ApiProperty({ description: 'True when the raw points are past the retention period' })
  pointsPurged: boolean;
  @ApiProperty({ type: [RouteTamperEventDto] }) tamperEvents: RouteTamperEventDto[];
}
