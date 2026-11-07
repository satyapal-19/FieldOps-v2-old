import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsUUID, Matches, Max, Min } from 'class-validator';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

// ------------------------------------------------------------------ Live map

export class LiveQueryDto {
  @ApiPropertyOptional({
    format: 'uuid',
    description: 'One ward (admins); ward inspectors see their own',
  })
  @IsOptional()
  @IsUUID()
  wardId?: string;
}

export class LivePositionDto {
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ format: 'uuid' }) attendanceId: string;
  @ApiProperty({ format: 'uuid' }) wardId: string;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ format: 'date-time' }) checkinAt: string;
  @ApiProperty({ enum: ['ACTIVE', 'STALE', 'SILENT', 'NO_SIGNAL'] })
  state: 'ACTIVE' | 'STALE' | 'SILENT' | 'NO_SIGNAL';
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) lastSeenAt: string | null;
  @ApiProperty({ nullable: true, type: Number, description: 'Last ping, else the check-in point' })
  latitude: number | null;
  @ApiProperty({ nullable: true, type: Number }) longitude: number | null;
  @ApiProperty({ nullable: true, type: Number }) accuracyM: number | null;
  @ApiProperty({ nullable: true, type: Boolean }) inWard: boolean | null;
  @ApiProperty() isMocked: boolean;
}

export class LiveDto {
  @ApiProperty({ format: 'date-time', description: 'Server time of this snapshot' }) at: string;
  @ApiProperty({ type: [LivePositionDto] }) items: LivePositionDto[];
}

// ------------------------------------------------------------------ Reports

export class ReportQueryDto {
  @ApiProperty({ example: '2026-10-01', description: 'IST date, inclusive' })
  @Matches(DATE)
  from: string;

  @ApiProperty({ example: '2026-10-31', description: 'IST date, inclusive (at most 92 days)' })
  @Matches(DATE)
  to: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'One ward (admins); ward inspectors see their own',
  })
  @IsOptional()
  @IsUUID()
  wardId?: string;
}

export class StaffReportQueryDto extends ReportQueryDto {
  @ApiPropertyOptional({ type: 'integer', default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ type: 'integer', default: 100, minimum: 1, maximum: 500 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(500)
  pageSize = 100;
}

export class WardDayReportDto {
  @ApiProperty({ example: '2026-11-01' }) date: string;
  @ApiProperty({ format: 'uuid' }) wardId: string;
  @ApiProperty() assignedCount: number;
  @ApiProperty() presentCount: number;
  @ApiProperty() lateCount: number;
  @ApiProperty() halfDayCount: number;
  @ApiProperty() absentCount: number;
  @ApiProperty() onLeaveCount: number;
  @ApiProperty() proxyCount: number;
  @ApiProperty() autoCheckoutCount: number;
  @ApiProperty() suspiciousCount: number;
  @ApiProperty({ description: 'Trusted distance walked by the ward team, metres' })
  distanceM: number;
}

export class WardDaysDto {
  @ApiProperty({
    type: [WardDayReportDto],
    description: 'Newest first; from the nightly summaries',
  })
  items: WardDayReportDto[];
}

export class StaffReportRowDto {
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ description: 'Days with an attendance row' }) days: number;
  @ApiProperty({ description: 'Days with a check-in' }) present: number;
  @ApiProperty() late: number;
  @ApiProperty() lateMinutes: number;
  @ApiProperty() halfDay: number;
  @ApiProperty() absent: number;
  @ApiProperty() onLeave: number;
  @ApiProperty() regularized: number;
  @ApiProperty() autoCheckout: number;
  @ApiProperty() suspicious: number;
}

export class StaffReportDto {
  @ApiProperty({ type: [StaffReportRowDto], description: 'Most late days first' })
  items: StaffReportRowDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

// ------------------------------------------------------------------ Muster roll

export class MusterQueryDto {
  @ApiProperty({ example: '2026-11', description: 'Calendar month (IST)' })
  @Matches(/^\d{4}-(0[1-9]|1[0-2])$/)
  month: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Required for admins; ward inspectors get their own',
  })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ enum: ['csv', 'pdf'], default: 'csv' })
  @IsOptional()
  @IsIn(['csv', 'pdf'])
  format: 'csv' | 'pdf' = 'csv';
}

// ------------------------------------------------------------------ Public (citizens)

export class PublicWardDayDto {
  @ApiProperty({ example: '2026-11-01' }) date: string;
  @ApiProperty() assignedCount: number;
  @ApiProperty() presentCount: number;
  @ApiProperty() onLeaveCount: number;
}

export class PublicWardAttendanceDto {
  @ApiProperty({ format: 'uuid' }) wardId: string;
  @ApiProperty({
    type: [PublicWardDayDto],
    description: 'The last 7 summarised days, newest first',
  })
  days: PublicWardDayDto[];
}
