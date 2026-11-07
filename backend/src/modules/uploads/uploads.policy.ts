/**
 * Rules for uploaded photos as pure functions: what a file really is (by its first bytes, not
 * the name or the declared type), where it is stored, and who may look at it.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import type { UploadKind } from './entities/upload.entity';

export type ImageType =
  { contentType: 'image/jpeg'; ext: 'jpg' } | { contentType: 'image/png'; ext: 'png' };

/** JPEG starts FF D8 FF; PNG starts 89 50 4E 47 0D 0A 1A 0A. Anything else is refused. */
export function detectImage(bytes: Uint8Array): ImageType | null {
  if (bytes.length >= 3 && bytes[0] === 0xff && bytes[1] === 0xd8 && bytes[2] === 0xff) {
    return { contentType: 'image/jpeg', ext: 'jpg' };
  }
  const png = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a];
  if (bytes.length >= png.length && png.every((b, i) => bytes[i] === b)) {
    return { contentType: 'image/png', ext: 'png' };
  }
  return null;
}

export type MediaType =
  ImageType | { contentType: 'audio/mp4' | 'audio/ogg' | 'audio/amr'; ext: string };

const ascii = (bytes: Uint8Array, from: number, text: string) =>
  bytes.length >= from + text.length &&
  [...text].every((c, i) => bytes[from + i] === c.charCodeAt(0));

/**
 * A voice note as Android records it: MPEG-4 audio (AAC in .m4a / .3gp: an "ftyp" box at byte
 * 4), Ogg (Opus) or AMR. Anything else is refused.
 */
export function detectAudio(bytes: Uint8Array): MediaType | null {
  if (ascii(bytes, 4, 'ftyp')) return { contentType: 'audio/mp4', ext: 'm4a' };
  if (ascii(bytes, 0, 'OggS')) return { contentType: 'audio/ogg', ext: 'ogg' };
  if (ascii(bytes, 0, '#!AMR')) return { contentType: 'audio/amr', ext: 'amr' };
  return null;
}

/** What a file of this kind must be: photos for tasks, audio for voice notes. */
export function detectMedia(kind: UploadKind, bytes: Uint8Array): MediaType | null {
  return kind === 'VOICE_NOTE' ? detectAudio(bytes) : detectImage(bytes);
}

/** Voice notes are kept 90 days (decision in the v4 review), then deleted with their file. */
export const VOICE_NOTE_RETENTION_DAYS = 90;

/** Storage path under UPLOAD_DIR: year/month folders keep any one folder small. */
export function storagePath(id: string, ext: string, at: Date): string {
  const yyyy = String(at.getUTCFullYear());
  const mm = String(at.getUTCMonth() + 1).padStart(2, '0');
  return `${yyyy}/${mm}/${id}.${ext}`;
}

/**
 * Who may open a photo: its uploader, an admin, the ward inspector of the uploader's home
 * ward, or the inspector they report to (the people who review their work).
 */
export function canReadUpload(
  actor: Pick<AuthUser, 'staffId' | 'role' | 'homeWardId'>,
  owner: { id: string; homeWardId: string | null; reportsToId: string | null },
): boolean {
  if (actor.staffId === owner.id || actor.role === Role.ADMIN) return true;
  if (actor.role === Role.WARD_INSPECTOR) {
    return !!actor.homeWardId && actor.homeWardId === owner.homeWardId;
  }
  if (actor.role === Role.INSPECTOR) return owner.reportsToId === actor.staffId;
  return false;
}
