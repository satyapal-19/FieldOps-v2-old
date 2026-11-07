import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBase64,
  IsIn,
  IsInt,
  IsLatitude,
  IsLongitude,
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Matches,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import type { SpotCheckStatus, SpotCheckTrigger } from '../entities/spot-check.entity';

export const SPOT_STATUSES: SpotCheckStatus[] = [
  'SCHEDULED',
  'NOTIFIED',
  'SNOOZED',
  'VERIFIED',
  'MISSED',
  'FACE_MISMATCH',
  'OUT_OF_GEOFENCE',
  'UNREACHABLE',
  'CANCELLED',
];

export class SpotCheckDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ example: '2026-11-02' }) date: string;
  @ApiProperty({ enum: ['RANDOM', 'SENIOR_MANUAL'] }) trigger: SpotCheckTrigger;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) initiatedById: string | null;
  @ApiProperty({ nullable: true, type: String }) reason: string | null;
  @ApiProperty({ enum: SPOT_STATUSES }) status: SpotCheckStatus;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) notifiedAt: string | null;
  @ApiProperty({
    format: 'date-time',
    nullable: true,
    type: String,
    description: 'Answer by this time',
  })
  dueAt: string | null;
  @ApiProperty() snoozed: boolean;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) respondedAt: string | null;
  @ApiProperty({ nullable: true, type: Boolean }) inGeofence: boolean | null;
  @ApiProperty({ nullable: true, type: Number }) faceScore: number | null;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) escalatedAt: string | null;
  @ApiProperty() version: number;
}

export class SpotCheckPageDto {
  @ApiProperty({ type: [SpotCheckDto] }) items: SpotCheckDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

export class ListSpotChecksQueryDto {
  @ApiPropertyOptional({ example: '2026-11-02' })
  @IsOptional()
  @Matches(/^\d{4}-\d{2}-\d{2}$/)
  date?: string;

  @ApiPropertyOptional({ enum: SPOT_STATUSES })
  @IsOptional()
  @IsIn(SPOT_STATUSES)
  status?: SpotCheckStatus;

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

export class OrderSpotCheckDto {
  @ApiProperty({ format: 'uuid', description: 'Someone on duty in your scope' })
  @IsUUID()
  staffId: string;

  @ApiPropertyOptional({ example: 'Not seen at the market beat since 9' })
  @IsOptional()
  @IsString()
  @Length(1, 500)
  reason?: string;
}

/** The answer: same proof as a punch (a fresh challenge, the face, and where you are). */
export class RespondSpotCheckDto {
  @ApiProperty({ format: 'uuid', description: 'Retry-safe: the same one answers once' })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ format: 'uuid', description: 'From POST /attendance/challenges' })
  @IsUUID()
  challengeId: string;

  @ApiProperty() @IsLatitude() latitude: number;
  @ApiProperty() @IsLongitude() longitude: number;

  @ApiProperty({ description: 'GPS accuracy, metres' })
  @IsNumber()
  @Min(0)
  @Max(10_000)
  accuracyM: number;

  @ApiPropertyOptional({ description: 'JPEG face crop (FACE_PROVIDER=local)' })
  @IsOptional()
  @IsBase64()
  @MaxLength(100_000)
  faceImageBase64?: string;

  @ApiPropertyOptional({ description: 'Aadhaar FaceRD PID block (FACE_PROVIDER=aadhaar)' })
  @IsOptional()
  @IsString()
  @MaxLength(100_000)
  aadhaarPidXml?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @MaxLength(50)
  aadhaarTxn?: string;
}
