import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import { IsBoolean, IsInt, IsOptional, IsUUID, Matches, Max, Min } from 'class-validator';
import {
  ASSIGNABLE_ROLES,
  ASSIGNMENT_MODES,
  type AssignableRole,
  type AssignmentMode,
} from '../roster-types';

const DATE = /^\d{4}-\d{2}-\d{2}$/;
const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' ? true : value === 'false' ? false : value;

class PageQueryDto {
  @ApiPropertyOptional({ type: 'integer', default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ type: 'integer', default: 50, minimum: 1, maximum: 500 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(500)
  pageSize = 50;
}

// ---------------------------------------------------------------- Standing rosters

export class CreateStandingRosterDto {
  @ApiProperty({ format: 'uuid', description: 'An active WORKER' })
  @IsUUID()
  workerId: string;

  @ApiProperty({ format: 'uuid', description: 'An active INSPECTOR of the same home ward' })
  @IsUUID()
  inspectorId: string;
}

export class UpdateStandingRosterDto {
  @ApiProperty({ example: 1, description: 'The version you last read; stale versions get 409' })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiPropertyOptional({ format: 'uuid', description: 'Move the worker to another inspector' })
  @IsOptional()
  @IsUUID()
  inspectorId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class ListStandingRostersQueryDto extends PageQueryDto {
  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  inspectorId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  isActive?: boolean;
}

export class StandingRosterDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) wardId: string;
  @ApiProperty({ format: 'uuid' }) wardInspectorId: string;
  @ApiProperty({ format: 'uuid' }) inspectorId: string;
  @ApiProperty({ format: 'uuid' }) workerId: string;
  @ApiProperty() isActive: boolean;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiProperty({ format: 'date-time' }) updatedAt: string;
}

export class StandingRosterPageDto {
  @ApiProperty({ type: [StandingRosterDto] }) items: StandingRosterDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

// ---------------------------------------------------------------- Daily assignments

export class CreateAssignmentDto {
  @ApiProperty({ example: '2026-11-02', description: 'IST date, today up to 31 days ahead' })
  @Matches(DATE)
  date: string;

  @ApiProperty({ format: 'uuid', description: 'The INSPECTOR or WORKER being placed' })
  @IsUUID()
  staffId: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'Required when placing an INSPECTOR' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Required when placing a WORKER: an inspector already placed that day',
  })
  @IsOptional()
  @IsUUID()
  inspectorId?: string;
}

export class SelfAssignmentDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Idempotency key from the phone; a retry returns the same row',
  })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ example: '2026-11-02', description: 'IST date: today or tomorrow' })
  @Matches(DATE)
  date: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'INSPECTOR self-pick: the ward' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'WORKER self-join: the inspector whose team to join',
  })
  @IsOptional()
  @IsUUID()
  inspectorId?: string;
}

export class ApproveAssignmentDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  expectedVersion: number;
}

export class GenerateAssignmentsDto {
  @ApiProperty({ example: '2026-11-02', description: 'IST date, today up to 31 days ahead' })
  @Matches(DATE)
  date: string;
}

export class GenerateAssignmentsResultDto {
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ description: 'Rows created from standing squads' }) created: number;
}

export class ListAssignmentsQueryDto extends PageQueryDto {
  @ApiProperty({ example: '2026-11-02' })
  @Matches(DATE)
  date: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  inspectorId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  isApproved?: boolean;
}

export class AssignmentDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ enum: ASSIGNABLE_ROLES }) staffRole: AssignableRole;
  @ApiProperty({ format: 'uuid' }) wardId: string;
  @ApiProperty({ format: 'uuid' }) wardInspectorId: string;
  @ApiProperty({ format: 'uuid' }) inspectorId: string;
  @ApiProperty({ enum: ASSIGNMENT_MODES }) assignmentMode: AssignmentMode;
  @ApiProperty() isApproved: boolean;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) approvedById: string | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) approvedAt: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) assignedById: string | null;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
}

export class AssignmentPageDto {
  @ApiProperty({ type: [AssignmentDto] }) items: AssignmentDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}
