import { Injectable } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { mkdir, readFile, rm, writeFile } from 'node:fs/promises';
import { dirname, isAbsolute, join, resolve } from 'node:path';
import type { AuthUser } from '../../shared/auth/auth-user';
import { Clock } from '../../shared/clock/clock';
import { AppConfig } from '../../shared/config/app-config';
import { isUniqueViolation } from '../../shared/database/db-errors';
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import { IdGenerator } from '../../shared/ids/id-generator';
import { StaffService } from '../staff/staff.service';
import type { UploadDto, UploadFieldsDto } from './dto/upload.dto';
import type { Upload } from './entities/upload.entity';
import {
  canReadUpload,
  detectMedia,
  storagePath,
  VOICE_NOTE_RETENTION_DAYS,
} from './uploads.policy';
import { UploadsRepository } from './uploads.repository';

function toDto(row: Upload, replayed: boolean): UploadDto {
  return {
    id: row.id,
    kind: row.kind,
    contentType: row.contentType,
    sizeBytes: Number(row.sizeBytes),
    createdAt: row.createdAt.toISOString(),
    replayed,
  };
}

/**
 * Photos from the phone (task evidence), kept on this server: bytes on disk under UPLOAD_DIR,
 * metadata in the uploads table. The file type is decided from its first bytes; a retried
 * upload (same clientUuid) answers with the first one. Other modules check ownership through
 * assertOwnedBy before accepting a key.
 */
@Injectable()
export class UploadsService {
  constructor(
    private readonly repo: UploadsRepository,
    private readonly staff: StaffService,
    private readonly config: AppConfig,
    private readonly clock: Clock,
    private readonly ids: IdGenerator,
  ) {}

  async upload(
    actor: AuthUser,
    file: { buffer: Buffer; size: number } | undefined,
    fields: UploadFieldsDto,
  ): Promise<UploadDto> {
    const earlier = await this.repo.findByClientUuid(fields.clientUuid);
    if (earlier) return this.replay(earlier, actor);
    if (!file || file.size === 0) {
      throw new AppError(ErrorCode.VALIDATION_FAILED, 'Attach the photo as the "file" part', {
        field: 'file',
      });
    }
    if (file.size > this.config.uploads.maxBytes) {
      throw new AppError(ErrorCode.PAYLOAD_TOO_LARGE, undefined, {
        maxBytes: this.config.uploads.maxBytes,
      });
    }
    const type = detectMedia(fields.kind, file.buffer);
    if (!type) {
      throw new AppError(
        ErrorCode.VALIDATION_FAILED,
        fields.kind === 'VOICE_NOTE'
          ? 'Voice notes must be M4A / AAC, Ogg or AMR audio'
          : 'Only JPEG or PNG photos are accepted',
        {
          field: 'file',
        },
      );
    }

    const now = this.clock.now();
    const id = this.ids.next();
    const row: Upload = {
      id,
      clientUuid: fields.clientUuid,
      ownerStaffId: actor.staffId,
      kind: fields.kind,
      contentType: type.contentType,
      sizeBytes: file.size,
      sha256: createHash('sha256').update(file.buffer).digest('hex'),
      storagePath: storagePath(id, type.ext, now),
      createdAt: now,
    };
    const path = this.absolute(row.storagePath);
    await mkdir(dirname(path), { recursive: true });
    await writeFile(path, file.buffer, { flag: 'wx' });
    try {
      await this.repo.insert(row);
    } catch (error) {
      await rm(path, { force: true });
      if (!isUniqueViolation(error)) throw error;
      // The same clientUuid arrived twice at once: answer with the one that won.
      return this.replay((await this.repo.findByClientUuid(fields.clientUuid))!, actor);
    }
    return toDto(row, false);
  }

  /** The photo's bytes, for its uploader and the people who review their work; else 404. */
  async open(actor: AuthUser, id: string): Promise<{ row: Upload; bytes: Buffer }> {
    const row = await this.repo.findById(id);
    const owner = row ? await this.staff.findById(row.ownerStaffId) : null;
    if (!row || !owner || !canReadUpload(actor, owner)) {
      throw new AppError(ErrorCode.NOT_FOUND, 'Photo not found', { id });
    }
    return { row, bytes: await readFile(this.absolute(row.storagePath)) };
  }

  /**
   * For other modules that check access themselves (chat checks the conversation): the bytes
   * of an upload of the given kind, or 404.
   */
  async read(id: string, kind: Upload['kind']): Promise<{ row: Upload; bytes: Buffer }> {
    const row = await this.repo.findById(id);
    if (!row || row.kind !== kind)
      throw new AppError(ErrorCode.NOT_FOUND, 'File not found', { id });
    try {
      return { row, bytes: await readFile(this.absolute(row.storagePath)) };
    } catch {
      throw new AppError(ErrorCode.NOT_FOUND, 'File not found', { id });
    }
  }

  /** The retention job: voice notes older than 90 days go, file and row. */
  async purgeVoiceNotes(): Promise<string> {
    const cutoff = new Date(this.clock.now().getTime() - VOICE_NOTE_RETENTION_DAYS * 86_400_000);
    const old = await this.repo.findOlder('VOICE_NOTE', cutoff, 500);
    for (const row of old) {
      await rm(this.absolute(row.storagePath), { force: true });
      await this.repo.delete(row.id);
    }
    return `deleted ${old.length} voice notes older than ${VOICE_NOTE_RETENTION_DAYS} days`;
  }

  /** For other modules: the caller's own upload of this kind (e.g. a voice note for chat), or 400. */
  async ownedOfKind(
    staffId: string,
    id: string,
    kind: Upload['kind'],
    field: string,
  ): Promise<Upload> {
    const row = await this.repo.findById(id);
    if (!row || row.ownerStaffId !== staffId || row.kind !== kind) {
      throw new AppError(
        ErrorCode.VALIDATION_FAILED,
        `${field} is not one of your ${kind} uploads`,
        {
          field,
        },
      );
    }
    return row;
  }

  /** For other modules: refuses a key that does not exist or belongs to someone else. */
  async assertOwnedBy(staffId: string, id: string, field: string): Promise<void> {
    const row = await this.repo.findById(id);
    if (!row || row.ownerStaffId !== staffId) {
      throw new AppError(ErrorCode.VALIDATION_FAILED, `${field} is not one of your uploads`, {
        field,
      });
    }
  }

  private replay(row: Upload, actor: AuthUser): UploadDto {
    if (row.ownerStaffId !== actor.staffId) {
      throw new AppError(ErrorCode.CONFLICT, 'This clientUuid was already used', {
        field: 'clientUuid',
      });
    }
    return toDto(row, true);
  }

  private absolute(relative: string): string {
    const dir = this.config.uploads.dir;
    return join(isAbsolute(dir) ? dir : resolve(process.cwd(), dir), relative);
  }
}
