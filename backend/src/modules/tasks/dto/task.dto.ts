import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsISO8601,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';
import type { TaskPriority, TaskStatus } from '../entities/task.entity';

const PRIORITIES: TaskPriority[] = ['URGENT', 'NORMAL', 'LOW'];
const STATUSES: TaskStatus[] = [
  'OPEN',
  'IN_PROGRESS',
  'SUBMITTED',
  'APPROVED',
  'REJECTED',
  'ESCALATED',
  'CLOSED',
];
const ASSIGNEE_ACTIONS = ['START', 'SUBMIT'] as const;
const SUPERVISOR_ACTIONS = ['APPROVE', 'REJECT', 'ESCALATE', 'CLOSE'] as const;

export class CreateTaskDto {
  @ApiProperty({ example: 'Clear blocked drain near Ganpati temple' })
  @IsString()
  @Length(3, 200)
  title: string;

  @ApiPropertyOptional({ example: 'गणपती मंदिराजवळील तुंबलेली गटार साफ करा' })
  @IsOptional()
  @IsString()
  @Length(1, 200)
  titleMr?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(1, 1000)
  description?: string;

  @ApiPropertyOptional({ enum: PRIORITIES, default: 'NORMAL' })
  @IsOptional()
  @IsIn(PRIORITIES)
  priority?: TaskPriority;

  @ApiProperty({ format: 'uuid', description: 'Someone below you in your scope' })
  @IsUUID()
  assignedToId: string;

  @ApiPropertyOptional({ format: 'date-time', example: '2026-11-03T06:30:00.000Z' })
  @IsOptional()
  @IsISO8601({ strict: true })
  dueAt?: string;

  @ApiPropertyOptional({ example: 16.8524 })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  locationLat?: number;

  @ApiPropertyOptional({ example: 74.5815 })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  locationLng?: number;

  @ApiPropertyOptional({ example: 'Near Ganpati temple, lane 3' })
  @IsOptional()
  @IsString()
  @Length(1, 200)
  locationLabel?: string;
}

export class AssigneeUpdateDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Idempotency key from the phone; a retry changes nothing',
  })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ enum: ASSIGNEE_ACTIONS })
  @IsIn(ASSIGNEE_ACTIONS)
  action: (typeof ASSIGNEE_ACTIONS)[number];

  @ApiPropertyOptional({ description: 'Required to SUBMIT unless a photo is attached' })
  @IsOptional()
  @IsString()
  @Length(1, 1000)
  note?: string;

  @ApiPropertyOptional({
    description: 'Storage key from the upload endpoint (after-photo on SUBMIT)',
  })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  photoKey?: string;

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

export class SupervisorActionDto {
  @ApiProperty({ example: 3 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiProperty({ enum: SUPERVISOR_ACTIONS })
  @IsIn(SUPERVISOR_ACTIONS)
  action: (typeof SUPERVISOR_ACTIONS)[number];

  @ApiPropertyOptional({ description: 'Required to REJECT' })
  @IsOptional()
  @IsString()
  @Length(3, 500)
  reason?: string;
}

export class ReassignTaskDto {
  @ApiProperty({ example: 2 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  assignedToId: string;
}

export class ListTasksQueryDto {
  @ApiPropertyOptional({ enum: STATUSES })
  @IsOptional()
  @IsIn(STATUSES)
  status?: TaskStatus;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  assignedToId?: string;

  @ApiPropertyOptional({ type: 'integer', default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ type: 'integer', default: 50, minimum: 1, maximum: 200 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(200)
  pageSize = 50;
}

export class TaskDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty() title: string;
  @ApiProperty({ nullable: true, type: String }) titleMr: string | null;
  @ApiProperty({ nullable: true, type: String }) description: string | null;
  @ApiProperty({ enum: PRIORITIES }) priority: TaskPriority;
  @ApiProperty({ enum: STATUSES }) status: TaskStatus;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) assignedToId: string | null;
  @ApiProperty({ format: 'uuid' }) createdById: string;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) complaintId: string | null;
  @ApiProperty({ nullable: true, type: Number }) locationLat: number | null;
  @ApiProperty({ nullable: true, type: Number }) locationLng: number | null;
  @ApiProperty({ nullable: true, type: String }) locationLabel: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) dueAt: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) startedAt: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) submittedAt: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) closedAt: string | null;
  @ApiProperty({ nullable: true, type: String }) completionNote: string | null;
  @ApiProperty({ nullable: true, type: String }) rejectionReason: string | null;
  @ApiProperty() rejectionCount: number;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
}

export class TaskPageDto {
  @ApiProperty({ type: [TaskDto] }) items: TaskDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

export class TaskUpdateDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ enum: STATUSES }) fromStatus: TaskStatus;
  @ApiProperty({ enum: STATUSES }) toStatus: TaskStatus;
  @ApiProperty({ nullable: true, type: String }) note: string | null;
  @ApiProperty({ nullable: true, type: String }) photoKey: string | null;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
}
