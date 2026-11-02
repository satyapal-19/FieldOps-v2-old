import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';
import type { TaskPriority } from '../../tasks/entities/task.entity';
import { TaskDto } from '../../tasks/dto/task.dto';
import type { ComplaintCategory, ComplaintStatus } from '../entities/citizen-complaint.entity';

const CATEGORIES: ComplaintCategory[] = [
  'GARBAGE',
  'DRAIN',
  'ROAD',
  'WATER',
  'TREE',
  'STRAY_ANIMAL',
  'OTHER',
];
const STATUSES: ComplaintStatus[] = [
  'RECEIVED',
  'ASSIGNED',
  'IN_PROGRESS',
  'RESOLVED',
  'CLOSED',
  'REJECTED',
];
const PRIORITIES: TaskPriority[] = ['URGENT', 'NORMAL', 'LOW'];
const STATUS_ACTIONS = ['RESOLVE', 'REJECT', 'CLOSE'] as const;

// ---------------------------------------------------------------- Public (citizen portal)

export class SubmitComplaintDto {
  @ApiPropertyOptional({ format: 'uuid', description: 'Makes a double-submitted form a duplicate' })
  @IsOptional()
  @IsUUID()
  clientUuid?: string;

  @ApiProperty({ enum: CATEGORIES })
  @IsIn(CATEGORIES)
  category: ComplaintCategory;

  @ApiProperty({ example: 'Garbage not collected for 3 days near the bus stand.' })
  @IsString()
  @Length(10, 1000)
  description: string;

  @ApiPropertyOptional({ example: 'Ramesh Jadhav' })
  @IsOptional()
  @IsString()
  @Length(2, 100)
  citizenName?: string;

  @ApiPropertyOptional({
    example: '9812345678',
    description: 'For a call-back; never shown publicly',
  })
  @IsOptional()
  @Matches(/^[6-9]\d{9}$/, { message: 'citizenPhone must be a 10-digit Indian mobile number' })
  citizenPhone?: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'If known; otherwise found from the location',
  })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ example: 16.8524 })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  lat?: number;

  @ApiPropertyOptional({ example: 74.5815 })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  lng?: number;
}

/** What the public may know about a complaint: no names, phones or exact location. */
export class PublicComplaintDto {
  @ApiProperty({ example: 'SMK-2026-7K3QX9' }) trackingId: string;
  @ApiProperty({ enum: CATEGORIES }) category: ComplaintCategory;
  @ApiProperty({ enum: STATUSES }) status: ComplaintStatus;
  @ApiProperty({ example: 'W04', nullable: true, type: String }) wardCode: string | null;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) resolvedAt: string | null;
}

// ---------------------------------------------------------------- Staff

export class ListComplaintsQueryDto {
  @ApiPropertyOptional({ enum: STATUSES })
  @IsOptional()
  @IsIn(STATUSES)
  status?: ComplaintStatus;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ description: 'Only complaints with no ward yet (admin routing queue)' })
  @IsOptional()
  @Transform(({ value }) => (value === 'true' ? true : value === 'false' ? false : value))
  @IsBoolean()
  unrouted?: boolean;

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

export class AssignComplaintDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiProperty({
    format: 'uuid',
    description: 'Who does the work (assignment rules of tasks apply)',
  })
  @IsUUID()
  assignedToId: string;

  @ApiPropertyOptional({ enum: PRIORITIES, default: 'NORMAL' })
  @IsOptional()
  @IsIn(PRIORITIES)
  priority?: TaskPriority;

  @ApiPropertyOptional({ format: 'date-time' })
  @IsOptional()
  @IsISO8601({ strict: true })
  dueAt?: string;
}

export class ComplaintStatusDto {
  @ApiProperty({ example: 2 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiProperty({ enum: STATUS_ACTIONS })
  @IsIn(STATUS_ACTIONS)
  action: (typeof STATUS_ACTIONS)[number];
}

export class ComplaintDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ example: 'SMK-2026-7K3QX9' }) trackingId: string;
  @ApiProperty({ enum: CATEGORIES }) category: ComplaintCategory;
  @ApiProperty() description: string;
  @ApiProperty({ enum: STATUSES }) status: ComplaintStatus;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ nullable: true, type: String }) citizenName: string | null;
  @ApiProperty({ nullable: true, type: String, description: 'Masked unless you may call back' })
  citizenPhone: string | null;
  @ApiProperty({ nullable: true, type: Number }) lat: number | null;
  @ApiProperty({ nullable: true, type: Number }) lng: number | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) resolvedAt: string | null;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiPropertyOptional({
    type: [TaskDto],
    description: 'Linked tasks (single-complaint view only)',
  })
  tasks?: TaskDto[];
}

export class ComplaintPageDto {
  @ApiProperty({ type: [ComplaintDto] }) items: ComplaintDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}
