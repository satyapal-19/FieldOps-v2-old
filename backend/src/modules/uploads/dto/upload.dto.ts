import { ApiProperty } from '@nestjs/swagger';
import { IsIn, IsUUID } from 'class-validator';
import { UPLOAD_KINDS, type UploadKind } from '../entities/upload.entity';

/** The text fields of the multipart upload (the file itself is the `file` part). */
export class UploadFieldsDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Made on the phone; a retry with the same one lands once',
  })
  @IsUUID()
  clientUuid: string;

  @ApiProperty({ enum: UPLOAD_KINDS })
  @IsIn(UPLOAD_KINDS)
  kind: UploadKind;
}

export class UploadDto {
  @ApiProperty({
    format: 'uuid',
    description: 'Pass as photoKey on a task update, or as a voice message key',
  })
  id: string;
  @ApiProperty({ enum: UPLOAD_KINDS }) kind: UploadKind;
  @ApiProperty({ example: 'image/jpeg' }) contentType: string;
  @ApiProperty() sizeBytes: number;
  @ApiProperty({ format: 'date-time' }) createdAt: string;
  @ApiProperty({ description: 'True when this clientUuid was already uploaded (a retry)' })
  replayed: boolean;
}
