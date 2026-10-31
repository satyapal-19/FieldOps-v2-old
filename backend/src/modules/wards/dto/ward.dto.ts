import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsBoolean,
  IsIn,
  IsInt,
  IsNumber,
  IsObject,
  IsOptional,
  IsString,
  Length,
  Matches,
  Max,
  Min,
} from 'class-validator';
import { ZONES, type Zone } from '../wards.policy';

const BOUNDARY_EXAMPLE = {
  type: 'Polygon',
  coordinates: [
    [
      [74.58, 16.85],
      [74.59, 16.85],
      [74.59, 16.86],
      [74.58, 16.86],
      [74.58, 16.85],
    ],
  ],
};

export class CreateWardDto {
  @ApiProperty({ example: 'W04', description: 'Unique ward code (A-Z, 0-9, _ or -)' })
  @IsString()
  @Matches(/^[A-Za-z0-9_-]{2,20}$/)
  code: string;

  @ApiProperty({ example: 'Ward 4 - Vishrambag' })
  @IsString()
  @Length(2, 100)
  name: string;

  @ApiProperty({ example: 'प्रभाग ४ - विश्रामबाग' })
  @IsString()
  @Length(1, 100)
  nameMr: string;

  @ApiProperty({ enum: ZONES, example: 'SANGLI' })
  @IsIn(ZONES)
  zone: Zone;

  @ApiProperty({
    type: 'object',
    additionalProperties: true,
    description: 'GeoJSON Polygon or MultiPolygon, coordinates as [longitude, latitude]',
    example: BOUNDARY_EXAMPLE,
  })
  @IsObject()
  boundary: Record<string, unknown>;
}

export class UpdateWardDto {
  @ApiProperty({ example: 1, description: 'The version you last read; stale versions get 409' })
  @IsInt()
  @Min(1)
  expectedVersion: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(2, 100)
  name?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  @Length(1, 100)
  nameMr?: string;

  @ApiPropertyOptional({ enum: ZONES })
  @IsOptional()
  @IsIn(ZONES)
  zone?: Zone;

  @ApiPropertyOptional({ type: 'object', additionalProperties: true, example: BOUNDARY_EXAMPLE })
  @IsOptional()
  @IsObject()
  boundary?: Record<string, unknown>;

  @ApiPropertyOptional()
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;
}

export class ListWardsQueryDto {
  @ApiPropertyOptional({ default: 1, minimum: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @ApiPropertyOptional({ default: 20, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  pageSize = 20;
}

export class WardDto {
  @ApiProperty() id: string;
  @ApiProperty() code: string;
  @ApiProperty() name: string;
  @ApiProperty() nameMr: string;
  @ApiProperty({ enum: ZONES }) zone: Zone;
  @ApiProperty({ type: 'object', additionalProperties: true }) boundary: Record<string, unknown>;
  @ApiProperty() isActive: boolean;
  @ApiProperty() version: number;
  @ApiProperty({ example: '2026-10-28T00:30:00.000Z' }) createdAt: string;
  @ApiProperty({ example: '2026-10-28T00:30:00.000Z' }) updatedAt: string;
}

export class WardPageDto {
  @ApiProperty({ type: [WardDto] }) items: WardDto[];
  @ApiProperty() page: number;
  @ApiProperty() pageSize: number;
  @ApiProperty() total: number;
}

export class LocationCheckDto {
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
}

export class LocationCheckResultDto {
  @ApiProperty() wardId: string;
  @ApiProperty({ description: 'Strictly inside the boundary' }) inside: boolean;
  @ApiProperty({ description: 'Inside, or within the 25 m edge allowance' }) withinTolerance: boolean;
  @ApiProperty({ example: 11.1 }) distanceToEdgeMeters: number;
}
