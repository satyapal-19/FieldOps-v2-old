import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform, Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsIn,
  IsInt,
  IsISO8601,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';
import { NOTIFICATION_KINDS, type NotificationKind } from '../entities/notification.entity';

const toBoolean = ({ value }: { value: unknown }) =>
  value === 'true' ? true : value === 'false' ? false : value;

export class InboxQueryDto {
  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @Transform(toBoolean)
  @IsBoolean()
  unreadOnly?: boolean;

  @ApiPropertyOptional({ format: 'date-time', description: 'Older than this (paging back)' })
  @IsOptional()
  @IsISO8601({ strict: true })
  before?: string;

  @ApiPropertyOptional({ type: 'integer', default: 30, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 30;
}

export class NotificationDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ enum: NOTIFICATION_KINDS }) kind: NotificationKind;
  @ApiProperty({ enum: ['HIGH', 'NORMAL'] }) priority: 'HIGH' | 'NORMAL';
  @ApiProperty() title: string;
  @ApiProperty({ nullable: true, type: String }) titleMr: string | null;
  @ApiProperty({ nullable: true, type: String }) body: string | null;
  @ApiProperty({ nullable: true, type: String }) bodyMr: string | null;
  @ApiProperty({ nullable: true, type: String }) refType: string | null;
  @ApiProperty({ nullable: true, type: String }) refId: string | null;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) readAt: string | null;
}

export class InboxDto {
  @ApiProperty({ type: [NotificationDto], description: 'Newest first' }) items: NotificationDto[];
  @ApiProperty() unreadCount: number;
}

export class MarkReadDto {
  @ApiPropertyOptional({ type: [String], description: 'These messages; omit with all=true' })
  @IsOptional()
  @IsArray()
  @ArrayMaxSize(200)
  @IsUUID('all', { each: true })
  ids?: string[];

  @ApiPropertyOptional({ description: 'Mark every unread message read' })
  @IsOptional()
  @IsBoolean()
  all?: boolean;
}

export class MarkedDto {
  @ApiProperty() marked: number;
}

export class PushTokenDto {
  @ApiProperty({ description: 'FCM registration token of this phone' })
  @IsString()
  @Length(20, 255)
  token: string;

  @ApiProperty({ enum: ['ANDROID', 'IOS'] })
  @IsIn(['ANDROID', 'IOS'])
  platform: 'ANDROID' | 'IOS';
}

export class RemovePushTokenDto {
  @ApiProperty()
  @IsString()
  @Length(20, 255)
  token: string;
}
