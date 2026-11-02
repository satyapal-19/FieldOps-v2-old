import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';
import { STAFF_ROLES, StaffRole } from '../../../shared/auth/roles';
import { StaffProfileDto } from '../../staff/dto/staff-profile.dto';

export class CreateStaffDto {
  @ApiProperty({
    example: 'SMK-W-0042',
    description: '2-20 letters, digits or hyphens; stored upper-case',
  })
  @IsString()
  @Length(2, 20)
  employeeCode: string;

  @ApiProperty({ example: 'Sunil Patil' })
  @IsString()
  @Length(2, 100)
  fullName: string;

  @ApiPropertyOptional({ example: 'सुनील पाटील' })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  fullNameMr?: string;

  @ApiProperty({ example: '9812345678', description: 'Indian mobile; +91 / 0 prefixes accepted' })
  @IsString()
  @Length(10, 16)
  phone: string;

  @ApiProperty({ enum: STAFF_ROLES })
  @IsIn(STAFF_ROLES)
  role: StaffRole;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'Required for WARD_INSPECTOR, INSPECTOR, WORKER',
  })
  @IsOptional()
  @IsUUID()
  homeWardId?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'Required for OFFICE_STAFF' })
  @IsOptional()
  @IsUUID()
  officeId?: string;

  @ApiPropertyOptional({ format: 'uuid', description: 'Line manager: exactly the next rank up' })
  @IsOptional()
  @IsUUID()
  reportsToId?: string;

  @ApiPropertyOptional({ example: 'Sanitation' })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  department?: string;

  @ApiPropertyOptional({ example: '06:00', default: '06:00', description: 'IST, 24-hour HH:MM' })
  @IsOptional()
  @IsString()
  shiftStart?: string;

  @ApiPropertyOptional({ example: '14:00', default: '14:00' })
  @IsOptional()
  @IsString()
  shiftEnd?: string;

  @ApiPropertyOptional({
    description: 'Only for ADMIN, WARD_INSPECTOR and OFFICE_STAFF (web sign-in). 10-72 characters.',
    writeOnly: true,
  })
  @IsOptional()
  @IsString()
  @Length(10, 72)
  initialPassword?: string;
}

export class UpdateStaffDto {
  @ApiProperty({ example: 1, description: 'The version you last read; stale versions get 409' })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 100)
  fullName?: string;

  @ApiPropertyOptional({ nullable: true, type: String })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  fullNameMr?: string | null;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(10, 16)
  phone?: string;

  @ApiPropertyOptional({ enum: STAFF_ROLES })
  @IsOptional()
  @IsIn(STAFF_ROLES)
  role?: StaffRole;

  @ApiPropertyOptional({
    format: 'uuid',
    nullable: true,
    type: String,
    description: 'null clears it',
  })
  @IsOptional()
  @IsUUID()
  homeWardId?: string | null;

  @ApiPropertyOptional({ format: 'uuid', nullable: true, type: String })
  @IsOptional()
  @IsUUID()
  officeId?: string | null;

  @ApiPropertyOptional({ format: 'uuid', nullable: true, type: String })
  @IsOptional()
  @IsUUID()
  reportsToId?: string | null;

  @ApiPropertyOptional({ nullable: true, type: String })
  @IsOptional()
  @IsString()
  @Length(1, 100)
  department?: string | null;

  @ApiPropertyOptional({ example: '06:00' })
  @IsOptional()
  @IsString()
  shiftStart?: string;

  @ApiPropertyOptional({ example: '14:00' })
  @IsOptional()
  @IsString()
  shiftEnd?: string;

  @ApiPropertyOptional({ description: 'false deactivates and signs the person out everywhere' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' ? true : value === 'false' ? false : value;

export class ListStaffQueryDto {
  @ApiPropertyOptional({ enum: STAFF_ROLES })
  @IsOptional()
  @IsIn(STAFF_ROLES)
  role?: StaffRole;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  wardId?: string;

  @ApiPropertyOptional({ format: 'uuid' })
  @IsOptional()
  @IsUUID()
  officeId?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({ description: 'Part of an employee code or name' })
  @IsOptional()
  @IsString()
  @Length(1, 50)
  q?: string;

  @ApiPropertyOptional({
    type: String,
    description: 'Comma-separated staff ids (up to 100), e.g. the names behind a page of records',
  })
  @IsOptional()
  @Transform(({ value }: { value: unknown }) =>
    typeof value === 'string' ? value.split(',').map((v) => v.trim()).filter(Boolean) : value,
  )
  @IsArray()
  @ArrayMinSize(1)
  @ArrayMaxSize(100)
  @IsUUID('all', { each: true })
  ids?: string[];

  @ApiPropertyOptional({ type: 'integer', default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ type: 'integer', default: 20, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize = 20;
}

export class StaffPageDto {
  @ApiProperty({ type: [StaffProfileDto] }) items: StaffProfileDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}
