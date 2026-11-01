import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, IsString, IsUUID, Matches, Min } from 'class-validator';
import { SHIFT_TYPES, type ShiftType } from '../shift-types';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

export class PutShiftDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  staffId: string;

  @ApiProperty({ example: '2026-11-02', description: 'IST date, today up to 31 days ahead' })
  @Matches(DATE)
  date: string;

  @ApiProperty({ enum: SHIFT_TYPES })
  @IsIn(SHIFT_TYPES)
  shiftType: ShiftType;

  @ApiProperty({ example: '22:00', description: 'IST, 24-hour HH:MM' })
  @IsString()
  startTime: string;

  @ApiProperty({ example: '06:00', description: 'Before startTime only for NIGHT (ends next day)' })
  @IsString()
  endTime: string;

  @ApiPropertyOptional({ example: 1, description: 'Required when changing an existing override' })
  @IsOptional()
  @IsInt()
  @Min(1)
  expectedVersion?: number;
}

export class ShiftRangeQueryDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  staffId: string;

  @ApiProperty({ example: '2026-11-01' })
  @Matches(DATE)
  from: string;

  @ApiProperty({ example: '2026-11-30', description: 'At most 62 days after from' })
  @Matches(DATE)
  to: string;
}

export class EffectiveShiftQueryDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  staffId: string;

  @ApiProperty({ example: '2026-11-02' })
  @Matches(DATE)
  date: string;
}

export class ShiftDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ enum: SHIFT_TYPES }) shiftType: ShiftType;
  @ApiProperty({ example: '22:00' }) startTime: string;
  @ApiProperty({ example: '06:00' }) endTime: string;
  @ApiProperty() version: number;
  @ApiProperty({ format: 'date-time' }) updatedAt: string;
}

export class EffectiveShiftDto {
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ enum: SHIFT_TYPES, nullable: true, type: String }) shiftType: ShiftType | null;
  @ApiProperty({ example: '06:00' }) startTime: string;
  @ApiProperty({ example: '14:00' }) endTime: string;
  @ApiProperty({ format: 'date-time', description: 'UTC' }) startsAt: string;
  @ApiProperty({ format: 'date-time', description: 'UTC; next day for overnight shifts' })
  endsAt: string;
  @ApiProperty({ enum: ['OVERRIDE', 'DEFAULT'] }) source: 'OVERRIDE' | 'DEFAULT';
}
