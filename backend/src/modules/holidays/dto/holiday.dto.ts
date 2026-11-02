import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Length, Matches, Max, Min } from 'class-validator';
import type { HolidayType } from '../entities/holiday.entity';

const DATE = /^\d{4}-\d{2}-\d{2}$/;
const HOLIDAY_TYPES: HolidayType[] = ['GAZETTE', 'OPTIONAL'];

export class CreateHolidayDto {
  @ApiProperty({ example: '2026-11-08', description: 'IST date, today or later' })
  @Matches(DATE)
  date: string;

  @ApiProperty({ example: 'Diwali (Lakshmi Puja)' })
  @IsString()
  @Length(2, 100)
  name: string;

  @ApiPropertyOptional({ example: 'दिवाळी (लक्ष्मीपूजन)' })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  nameMr?: string;

  @ApiPropertyOptional({ enum: HOLIDAY_TYPES, default: 'GAZETTE' })
  @IsOptional()
  @IsIn(HOLIDAY_TYPES)
  holidayType?: HolidayType;
}

export class UpdateHolidayDto {
  @ApiProperty({ example: 1, description: 'The version you last read; stale versions get 409' })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiPropertyOptional({ example: '2026-11-09' })
  @IsOptional()
  @Matches(DATE)
  date?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 100)
  name?: string;

  @ApiPropertyOptional({ nullable: true, type: String })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  nameMr?: string | null;

  @ApiPropertyOptional({ enum: HOLIDAY_TYPES })
  @IsOptional()
  @IsIn(HOLIDAY_TYPES)
  holidayType?: HolidayType;
}

export class ListHolidaysQueryDto {
  @ApiProperty({ example: 2026 })
  @Type(() => Number)
  @IsInt()
  @Min(2020)
  @Max(2100)
  year: number;
}

export class HolidayDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ example: '2026-11-08' }) date: string;
  @ApiProperty() name: string;
  @ApiProperty({ nullable: true, type: String }) nameMr: string | null;
  @ApiProperty({ enum: HOLIDAY_TYPES }) holidayType: HolidayType;
  @ApiProperty() version: number;
}
