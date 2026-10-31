import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsIn, IsInt, IsObject, IsOptional, IsString, Length, Max, Min } from 'class-validator';
import { ZONES, type Zone } from '../../wards/wards.policy';
import { DEFAULT_OFFICE_BUFFER_METERS, MAX_OFFICE_BUFFER_METERS } from '../offices.policy';

const PREMISES_EXAMPLE = {
  type: 'Polygon',
  coordinates: [
    [
      [74.5823, 16.8547],
      [74.5833, 16.8547],
      [74.5833, 16.8557],
      [74.5823, 16.8557],
      [74.5823, 16.8547],
    ],
  ],
};

export class CreateOfficeDto {
  @ApiProperty({ example: 'HO-SANGLI' })
  @IsString()
  @Length(2, 20)
  code: string;

  @ApiProperty({ example: 'SMKMC Head Office, Sangli' })
  @IsString()
  @Length(2, 100)
  name: string;

  @ApiProperty({ example: 'मुख्यालय - सांगली' })
  @IsString()
  @Length(1, 100)
  nameMr: string;

  @ApiProperty({ enum: ZONES })
  @IsIn(ZONES)
  zone: Zone;

  @ApiProperty({ type: 'object', additionalProperties: true, example: PREMISES_EXAMPLE })
  @IsObject()
  premises: Record<string, unknown>;

  @ApiPropertyOptional({ default: DEFAULT_OFFICE_BUFFER_METERS, minimum: 0, maximum: MAX_OFFICE_BUFFER_METERS })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(MAX_OFFICE_BUFFER_METERS)
  bufferMeters?: number;
}

export class UpdateOfficeDto {
  @ApiProperty({ example: 1 })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiPropertyOptional() @IsOptional() @IsString() @Length(2, 100) name?: string;
  @ApiPropertyOptional() @IsOptional() @IsString() @Length(1, 100) nameMr?: string;
  @ApiPropertyOptional({ enum: ZONES }) @IsOptional() @IsIn(ZONES) zone?: Zone;

  @ApiPropertyOptional({ type: 'object', additionalProperties: true })
  @IsOptional()
  @IsObject()
  premises?: Record<string, unknown>;

  @ApiPropertyOptional({ minimum: 0, maximum: MAX_OFFICE_BUFFER_METERS })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(MAX_OFFICE_BUFFER_METERS)
  bufferMeters?: number;

  @ApiPropertyOptional() @IsOptional() @IsBoolean() isActive?: boolean;
}

export class OfficeDto {
  @ApiProperty() id: string;
  @ApiProperty() code: string;
  @ApiProperty() name: string;
  @ApiProperty() nameMr: string;
  @ApiProperty({ enum: ZONES }) zone: Zone;
  @ApiProperty({ type: 'object', additionalProperties: true }) premises: Record<string, unknown>;
  @ApiProperty() bufferMeters: number;
  @ApiProperty() isActive: boolean;
  @ApiProperty() version: number;
  @ApiProperty() createdAt: string;
  @ApiProperty() updatedAt: string;
}

export class OfficeLocationCheckResultDto {
  @ApiProperty() officeId: string;
  @ApiProperty() inside: boolean;
  @ApiProperty({ description: 'Inside, or within the office buffer' }) withinTolerance: boolean;
  @ApiProperty() distanceToEdgeMeters: number;
  @ApiProperty() bufferMeters: number;
}
