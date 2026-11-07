import {
  Body,
  Controller,
  Get,
  Header,
  Param,
  ParseUUIDPipe,
  Post,
  StreamableFile,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiBody,
  ApiConsumes,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiPayloadTooLargeResponse,
  ApiProduces,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import type { AuthUser } from '../../shared/auth/auth-user';
import { CurrentUser, Roles } from '../../shared/auth/decorators';
import { STAFF_ROLES } from '../../shared/auth/roles';
import { ProblemDetailsDto } from '../../shared/errors/problem-details.dto';
import { UploadDto, UploadFieldsDto } from './dto/upload.dto';
import { UPLOAD_KINDS } from './entities/upload.entity';
import { UploadsService } from './uploads.service';

/** Hard ceiling for multer (UPLOAD_MAX_BYTES, checked in the service, is at most this). */
const MULTER_MAX_BYTES = 10_000_000;

/** HTTP only. Type sniffing, storage and access: uploads.service / uploads.policy. */
@ApiTags('uploads')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ProblemDetailsDto })
@Controller('uploads')
export class UploadsController {
  constructor(private readonly uploads: UploadsService) {}

  @Post()
  @Roles(...STAFF_ROLES)
  @UseInterceptors(FileInterceptor('file', { limits: { fileSize: MULTER_MAX_BYTES, files: 1 } }))
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file', 'clientUuid', 'kind'],
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'TASK_PHOTO: JPEG or PNG; VOICE_NOTE: M4A / AAC, Ogg or AMR',
        },
        clientUuid: { type: 'string', format: 'uuid' },
        kind: { type: 'string', enum: [...UPLOAD_KINDS] },
      },
    },
  })
  @ApiOperation({
    summary: 'Upload a photo (task evidence); returns the key to send as photoKey',
    description: 'Retry-safe with clientUuid. Stored on the FieldOps server only.',
  })
  @ApiCreatedResponse({ type: UploadDto })
  @ApiBadRequestResponse({ type: ProblemDetailsDto, description: 'Not a JPEG / PNG, or no file' })
  @ApiPayloadTooLargeResponse({ type: ProblemDetailsDto })
  upload(
    @CurrentUser() user: AuthUser,
    @UploadedFile() file: Express.Multer.File | undefined,
    @Body() fields: UploadFieldsDto,
  ): Promise<UploadDto> {
    return this.uploads.upload(user, file, fields);
  }

  @Get(':id')
  @Roles(...STAFF_ROLES)
  @Header('Cache-Control', 'private, max-age=86400')
  @ApiProduces('image/jpeg', 'image/png')
  @ApiOperation({ summary: 'A photo, for its uploader and the people who review their work' })
  @ApiOkResponse({ schema: { type: 'string', format: 'binary' } })
  @ApiNotFoundResponse({ type: ProblemDetailsDto })
  async get(
    @CurrentUser() user: AuthUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<StreamableFile> {
    const { row, bytes } = await this.uploads.open(user, id);
    return new StreamableFile(bytes, { type: row.contentType, length: bytes.length });
  }
}
