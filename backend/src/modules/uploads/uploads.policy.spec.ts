import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, type StaffRole } from '../../shared/auth/roles';
import { canReadUpload, detectImage, detectMedia, storagePath } from './uploads.policy';

const actor = (role: StaffRole, staffId = 'me', homeWardId: string | null = 'w1'): AuthUser => ({
  staffId,
  role,
  sessionId: 's',
  homeWardId,
  officeId: null,
});

describe('detectImage', () => {
  it.each([
    ['JPEG', [0xff, 0xd8, 0xff, 0xe0, 0x00], 'image/jpeg'],
    ['PNG', [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0x00], 'image/png'],
    ['PDF dressed as an image', [0x25, 0x50, 0x44, 0x46], null],
    ['HTML', [...Buffer.from('<html>')], null],
    ['empty', [], null],
    ['truncated PNG header', [0x89, 0x50, 0x4e], null],
  ])('%s', (_case, bytes, expected) => {
    expect(detectImage(Uint8Array.from(bytes))?.contentType ?? null).toBe(expected);
  });
});

describe('storagePath', () => {
  it('files by UTC year and month', () => {
    expect(storagePath('abc', 'jpg', new Date('2026-01-31T20:00:00Z'))).toBe('2026/01/abc.jpg');
  });
});

describe('canReadUpload', () => {
  const owner = { id: 'wk', homeWardId: 'w1', reportsToId: 'in1' };
  it.each([
    ['the uploader', actor(Role.WORKER, 'wk'), true],
    ['an admin', actor(Role.ADMIN, 'adm', null), true],
    ['the ward inspector of their ward', actor(Role.WARD_INSPECTOR, 'wi'), true],
    ['a ward inspector of another ward', actor(Role.WARD_INSPECTOR, 'wi2', 'w2'), false],
    ['their inspector', actor(Role.INSPECTOR, 'in1'), true],
    ['another inspector', actor(Role.INSPECTOR, 'in2'), false],
    ['a colleague', actor(Role.WORKER, 'wk2'), false],
    ['office staff', actor(Role.OFFICE_STAFF, 'of', null), false],
  ])('%s: %s', (_case, who, expected) => {
    expect(canReadUpload(who, owner)).toBe(expected);
  });
});

describe('detectMedia', () => {
  const bytes = (text: string, prefix: number[] = []) =>
    Uint8Array.from([...prefix, ...Buffer.from(text)]);
  it.each([
    ['M4A voice note', 'VOICE_NOTE', bytes('ftypM4A ', [0, 0, 0, 0x20]), 'audio/mp4'],
    ['3GP voice note', 'VOICE_NOTE', bytes('ftyp3gp4', [0, 0, 0, 0x18]), 'audio/mp4'],
    ['Ogg / Opus voice note', 'VOICE_NOTE', bytes('OggS\0\x02'), 'audio/ogg'],
    ['AMR voice note', 'VOICE_NOTE', bytes('#!AMR\n'), 'audio/amr'],
    ['a photo sent as a voice note', 'VOICE_NOTE', Uint8Array.from([0xff, 0xd8, 0xff, 0xe0]), null],
    ['audio sent as a task photo', 'TASK_PHOTO', bytes('OggS\0\x02'), null],
    ['a task photo', 'TASK_PHOTO', Uint8Array.from([0xff, 0xd8, 0xff, 0xe0]), 'image/jpeg'],
  ] as const)('%s', (_case, kind, data, expected) => {
    expect(detectMedia(kind, data)?.contentType ?? null).toBe(expected);
  });
});
