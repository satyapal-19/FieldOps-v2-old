import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsNumber,
  IsOptional,
  IsUUID,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';
import { DEVICE_TAMPER_TYPES, DeviceTamperType, MAX_PINGS_PER_BATCH } from '../attendance.policy';

export class PingDto {
  @ApiProperty({ format: 'uuid', description: 'Idempotency key from the phone outbox' })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ example: 16.8551 })
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude: number;

  @ApiProperty({ example: 74.5852 })
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude: number;

  @ApiPropertyOptional({ example: 8.5 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100_000)
  accuracyM?: number;

  @ApiPropertyOptional({ example: 64 })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(100)
  batteryPct?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  isMocked?: boolean;

  @ApiPropertyOptional({ description: 'Sent from the offline buffer' })
  @IsOptional()
  @IsBoolean()
  fromOffline?: boolean;

  @ApiProperty({ format: 'date-time', description: 'Phone time of the fix (UTC)' })
  @IsISO8601({ strict: true })
  recordedAt: string;
}

export class PingBatchDto {
  @ApiProperty({ type: [PingDto], maxItems: MAX_PINGS_PER_BATCH })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(MAX_PINGS_PER_BATCH)
  @ValidateNested({ each: true })
  @Type(() => PingDto)
  pings: PingDto[];
}

export class RejectedItemDto {
  @ApiProperty({ format: 'uuid' }) clientUuid: string;
  @ApiProperty({ example: 'TIME_OUT_OF_RANGE' }) reason: string;
}

export class PingBatchResultDto {
  @ApiProperty({ description: 'New pings stored' }) accepted: number;
  @ApiProperty({ description: 'Already stored earlier (safe retries)' }) duplicates: number;
  @ApiProperty({ type: [RejectedItemDto], description: 'Dropped; do not resend these' })
  rejected: RejectedItemDto[];
}

export class TamperEventDto {
  @ApiProperty({ format: 'uuid', description: 'Idempotency key; resend with resolvedAt once over' })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ enum: DEVICE_TAMPER_TYPES })
  @IsIn(DEVICE_TAMPER_TYPES)
  eventType: DeviceTamperType;

  @ApiProperty({ format: 'date-time' })
  @IsISO8601({ strict: true })
  startedAt: string;

  @ApiPropertyOptional({ format: 'date-time' })
  @IsOptional()
  @IsISO8601({ strict: true })
  resolvedAt?: string;

  @ApiPropertyOptional({ example: 16.8551 })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  lastLatitude?: number;

  @ApiPropertyOptional({ example: 74.5852 })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  lastLongitude?: number;
}

export class TamperBatchDto {
  @ApiProperty({ type: [TamperEventDto], maxItems: 50 })
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(50)
  @ValidateNested({ each: true })
  @Type(() => TamperEventDto)
  events: TamperEventDto[];
}

export class TamperBatchResultDto {
  @ApiProperty() accepted: number;
  @ApiProperty() duplicates: number;
  @ApiProperty({ type: [RejectedItemDto] }) rejected: RejectedItemDto[];
}
