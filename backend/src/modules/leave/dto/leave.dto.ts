import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';
import type { LeaveType, ReviewStatus } from '../entities/leave-request.entity';
import type { RegularizationReason } from '../entities/regularization-request.entity';

const DATE = /^\d{4}-\d{2}-\d{2}$/;
const LEAVE_TYPES: LeaveType[] = ['CASUAL', 'SICK', 'EARNED', 'WEEKLY_OFF'];
const REVIEW_STATUSES: ReviewStatus[] = ['PENDING', 'APPROVED', 'REJECTED', 'CANCELLED'];
const DECISIONS = ['APPROVED', 'REJECTED'] as const;
const REASONS: RegularizationReason[] = [
  'BATTERY_DEAD',
  'APP_CRASH',
  'FIELD_RESCUE_DUTY',
  'OUT_OF_NETWORK',
  'OTHER',
];

export class CreateLeaveDto {
  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Idempotency key from the phone; a retry returns the same request',
  })
  @IsOptional()
  @IsUUID()
  clientUuid?: string;

  @ApiProperty({ enum: LEAVE_TYPES })
  @IsIn(LEAVE_TYPES)
  leaveType: LeaveType;

  @ApiProperty({
    example: '2026-11-05',
    description: 'IST date; today or later (SICK: up to 7 days back)',
  })
  @Matches(DATE)
  fromDate: string;

  @ApiProperty({ example: '2026-11-06', description: 'Inclusive; at most 31 days in one request' })
  @Matches(DATE)
  toDate: string;

  @ApiPropertyOptional({ example: 'Family function' })
  @IsOptional()
  @IsString()
  @Length(1, 500)
  reason?: string;
}

export class CreateRegularizationDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  clientUuid?: string;

  @ApiProperty({ example: '2026-11-01', description: 'One of the last 7 days (IST)' })
  @Matches(DATE)
  attendanceDate: string;

  @ApiProperty({ enum: REASONS })
  @IsIn(REASONS)
  reasonType: RegularizationReason;

  @ApiProperty({ example: 'Phone battery died at 07:10; worked the full shift in Ward 4.' })
  @IsString()
  @Length(10, 1000)
  explanation: string;
}

export class ReviewRequestDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiProperty({ enum: DECISIONS })
  @IsIn(DECISIONS)
  decision: (typeof DECISIONS)[number];

  @ApiPropertyOptional({ example: 'Approved; inform the inspector.' })
  @IsOptional()
  @IsString()
  @Length(1, 500)
  note?: string;
}

export class CancelRequestDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  expectedVersion: number;
}

export class ListRequestsQueryDto {
  @ApiPropertyOptional({ enum: REVIEW_STATUSES })
  @IsOptional()
  @IsIn(REVIEW_STATUSES)
  status?: ReviewStatus;

  @ApiPropertyOptional({ format: 'uuid', description: 'One requester (must be in your scope)' })
  @IsOptional()
  @IsUUID()
  staffId?: string;

  @ApiPropertyOptional({ example: '2026-11-01' })
  @IsOptional()
  @Matches(DATE)
  from?: string;

  @ApiPropertyOptional({ example: '2026-11-30' })
  @IsOptional()
  @Matches(DATE)
  to?: string;

  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ default: 50, minimum: 1, maximum: 200 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(200)
  pageSize = 50;
}

class ReviewFieldsDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ enum: REVIEW_STATUSES }) status: ReviewStatus;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) reviewedById: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) reviewedAt: string | null;
  @ApiProperty({ nullable: true, type: String }) reviewNote: string | null;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
}

export class LeaveRequestDto extends ReviewFieldsDto {
  @ApiProperty({ enum: LEAVE_TYPES }) leaveType: LeaveType;
  @ApiProperty({ example: '2026-11-05' }) fromDate: string;
  @ApiProperty({ example: '2026-11-06' }) toDate: string;
  @ApiProperty({ description: 'Calendar days, both ends counted' }) daysCount: number;
  @ApiProperty({ nullable: true, type: String }) reason: string | null;
}

export class RegularizationRequestDto extends ReviewFieldsDto {
  @ApiProperty({ example: '2026-11-01' }) attendanceDate: string;
  @ApiProperty({ enum: REASONS }) reasonType: RegularizationReason;
  @ApiProperty() explanation: string;
}

export class LeavePageDto {
  @ApiProperty({ type: [LeaveRequestDto] }) items: LeaveRequestDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

export class RegularizationPageDto {
  @ApiProperty({ type: [RegularizationRequestDto] }) items: RegularizationRequestDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}
