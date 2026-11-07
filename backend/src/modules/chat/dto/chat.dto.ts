import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  IsIn,
  IsInt,
  IsISO8601,
  IsLatitude,
  IsLongitude,
  IsOptional,
  IsString,
  IsUUID,
  Length,
  Max,
  Min,
} from 'class-validator';
import type { ConversationType } from '../entities/conversation.entity';
import type { MessageType } from '../entities/message.entity';

const CONV_TYPES: ConversationType[] = ['DIRECT', 'SQUAD_TEAM', 'WARD_BROADCAST', 'CITY_BROADCAST'];
const MSG_TYPES: MessageType[] = ['TEXT', 'VOICE', 'IMAGE', 'LOCATION'];

export class ConversationDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ enum: CONV_TYPES }) type: ConversationType;
  @ApiProperty({ nullable: true, type: String }) title: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) wardId: string | null;
  @ApiProperty({ format: 'uuid', nullable: true, type: String }) inspectorId: string | null;
  @ApiProperty({ nullable: true, type: String, example: '2026-11-02' }) date: string | null;
  @ApiProperty({ description: 'Read-only (a past squad chat)' }) archived: boolean;
  @ApiProperty({ description: 'Whether you may post here (broadcasts are one-way)' })
  canPost: boolean;
  @ApiProperty({ type: [String], description: 'Active members (staff ids)' }) memberIds: string[];
  @ApiProperty({ format: 'date-time', nullable: true, type: String }) lastMessageAt: string | null;
  @ApiProperty() unread: number;
}

export class MessageDto {
  @ApiProperty({ format: 'uuid' }) id: string;
  @ApiProperty({ format: 'uuid' }) conversationId: string;
  @ApiProperty({ format: 'uuid' }) senderId: string;
  @ApiProperty({ enum: MSG_TYPES }) type: MessageType;
  @ApiProperty({ nullable: true, type: String }) text: string | null;
  @ApiProperty({ description: 'Voice note or photo attached (GET /chat/messages/{id}/media)' })
  hasMedia: boolean;
  @ApiProperty({ nullable: true, type: Number }) durationSec: number | null;
  @ApiProperty({ nullable: true, type: Number }) latitude: number | null;
  @ApiProperty({ nullable: true, type: Number }) longitude: number | null;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
}

export class MessagesQueryDto {
  @ApiPropertyOptional({ format: 'date-time', description: 'Older than this (paging back)' })
  @IsOptional()
  @IsISO8601({ strict: true })
  before?: string;

  @ApiPropertyOptional({ type: 'integer', default: 50, minimum: 1, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 50;
}

export class SendMessageDto {
  @ApiProperty({ format: 'uuid', description: 'Made on the phone: a retry sends once' })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ enum: MSG_TYPES })
  @IsIn(MSG_TYPES)
  type: MessageType;

  @ApiPropertyOptional({ description: 'TEXT' })
  @IsOptional()
  @IsString()
  @Length(1, 2000)
  text?: string;

  @ApiPropertyOptional({
    format: 'uuid',
    description: 'VOICE / IMAGE: your upload (POST /uploads)',
  })
  @IsOptional()
  @IsUUID()
  uploadId?: string;

  @ApiPropertyOptional({ description: 'VOICE: length in seconds' })
  @IsOptional()
  @IsInt()
  @Min(0)
  @Max(600)
  durationSec?: number;

  @ApiPropertyOptional() @IsOptional() @IsLatitude() latitude?: number;
  @ApiPropertyOptional() @IsOptional() @IsLongitude() longitude?: number;
}

export class DirectDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID()
  staffId: string;
}
