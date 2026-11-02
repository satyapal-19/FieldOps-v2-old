import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsInt,
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
import {
  ATTENDANCE_STATUSES,
  AttendanceStatus,
  CHECKOUT_TYPES,
  CheckoutType,
  PUNCH_MODES,
  PunchMode,
} from '../attendance-types';
import { LIVENESS_ACTIONS, LivenessAction } from '../attendance.policy';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

/**
 * Base64 of the face crop. The request body limit is 100 kB, so send a JPEG of at most
 * about 70 kB (a 320 px crop at quality 85 is 20-40 kB).
 */
export const MAX_FACE_IMAGE_BASE64 = 96_000;

export class CreateChallengeDto {
  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Whose face will be checked; omit for yourself (proxy punch: the team member)',
  })
  @IsOptional()
  @IsUUID()
  staffId?: string;
}

export class ChallengeDto {
  @ApiProperty({ format: 'uuid' }) challengeId: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({
    enum: LIVENESS_ACTIONS,
    isArray: true,
    description: 'Prompts for the ML Kit flow',
  })
  actions: LivenessAction[];
  @ApiProperty({ format: 'date-time' }) expiresAt: string;
}

export const PUNCH_TYPES = ['CHECK_IN', 'CHECK_OUT'] as const;
export type PunchType = (typeof PUNCH_TYPES)[number];

export class CreatePunchDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Idempotency key from the phone outbox; a retry returns the same result',
  })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ enum: PUNCH_TYPES })
  @IsIn(PUNCH_TYPES)
  type: PunchType;

  @ApiPropertyOptional({ format: 'uuid', description: 'Omit for yourself; set for a proxy punch' })
  @IsOptional()
  @IsUUID()
  staffId?: string;

  @ApiProperty({ format: 'uuid', description: 'From POST /attendance/challenges' })
  @IsUUID()
  challengeId: string;

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

  @ApiProperty({ example: 12.5, description: 'GPS accuracy in metres (field ≤ 25, office ≤ 100)' })
  @IsNumber()
  @Min(0)
  @Max(10_000)
  accuracyM: number;

  @ApiPropertyOptional({ description: 'The phone reported a mock location (recorded, flagged)' })
  @IsOptional()
  @IsBoolean()
  isMocked?: boolean;

  @ApiPropertyOptional({
    description: `Local face provider: base64 JPEG face crop (≤ ${MAX_FACE_IMAGE_BASE64} chars); never stored`,
  })
  @IsOptional()
  @IsString()
  @MaxLength(MAX_FACE_IMAGE_BASE64)
  faceImageBase64?: string;

  @ApiPropertyOptional({ description: 'Aadhaar face provider: PidData XML from FaceRD' })
  @IsOptional()
  @IsString()
  @MaxLength(20_000)
  aadhaarPidXml?: string;

  @ApiPropertyOptional({ description: 'Aadhaar face provider: the txn from capture-options' })
  @IsOptional()
  @IsString()
  @Length(1, 50)
  aadhaarTxn?: string;
}

export class ListAttendanceQueryDto {
  @ApiPropertyOptional({ example: '2026-11-01', description: 'IST date, inclusive' })
  @IsOptional()
  @Matches(DATE)
  from?: string;

  @ApiPropertyOptional({ example: '2026-11-02', description: 'IST date, inclusive' })
  @IsOptional()
  @Matches(DATE)
  to?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'One person in your scope' })
  @IsOptional()
  @IsUUID()
  staffId?: string;

  @ApiPropertyOptional({ enum: ATTENDANCE_STATUSES })
  @IsOptional()
  @IsIn(ATTENDANCE_STATUSES)
  status?: AttendanceStatus;

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

export class PunchDetailsDto {
  @ApiProperty({ format: 'date-time', description: 'Server time (UTC)' }) at: string;
  @ApiProperty() latitude: number;
  @ApiProperty() longitude: number;
  @ApiProperty({ nullable: true, type: Number }) accuracyM: number | null;
  @ApiProperty({ nullable: true, type: Boolean }) inGeofence: boolean | null;
  @ApiProperty({ enum: PUNCH_MODES, nullable: true, type: String }) mode: PunchMode | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) markedById: string | null;
}

export class AttendanceLogDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) staffId: string;
  @ApiProperty({ example: '2026-11-02', description: 'IST date of the shift' }) date: string;
  @ApiProperty({ enum: ATTENDANCE_STATUSES }) status: AttendanceStatus;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) officeId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) assignmentId: string | null;
  @ApiProperty() isLate: boolean;
  @ApiProperty() lateMinutes: number;
  @ApiProperty({ nullable: true, type: Number }) workedMinutes: number | null;
  @ApiProperty({ type: PunchDetailsDto, nullable: true }) checkin: PunchDetailsDto | null;
  @ApiProperty({ nullable: true, type: Number, description: 'Metres outside the geofence' })
  checkinDistanceM: number | null;
  @ApiProperty({ nullable: true, type: Number }) checkinFaceScore: number | null;
  @ApiProperty({ type: PunchDetailsDto, nullable: true }) checkout: PunchDetailsDto | null;
  @ApiProperty({ enum: CHECKOUT_TYPES, nullable: true, type: String })
  checkoutType: CheckoutType | null;
  @ApiProperty({ description: 'Mock location or other warning signs' }) isSuspicious: boolean;
  @ApiProperty() version: number;
}

export class PunchResultDto {
  @ApiProperty({ description: 'True when this clientUuid was already accepted (a retry)' })
  replayed: boolean;
  @ApiProperty({ type: AttendanceLogDto }) attendance: AttendanceLogDto;
}

export class AttendancePageDto {
  @ApiProperty({ type: [AttendanceLogDto] }) items: AttendanceLogDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}
