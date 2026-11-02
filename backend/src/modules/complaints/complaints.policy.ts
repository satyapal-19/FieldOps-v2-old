/**
 * Pure citizen-complaint rules: tracking IDs, who sees and manages a complaint, the status
 * machine, and what the public tracking page shows. No database, no clock, no randomness
 * (the service passes random indexes in). Test with plain tables of inputs.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role } from '../../shared/auth/roles';
import type { TaskStatus } from '../tasks/entities/task.entity';
import type { ComplaintStatus } from './entities/citizen-complaint.entity';

export class ComplaintRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

/** No 0/O or 1/I, so a citizen can read the ID out over the phone. */
export const TRACKING_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
export const TRACKING_RANDOM_LENGTH = 6;
const TRACKING_ID = new RegExp(`^SMK-\\d{4}-[${TRACKING_ALPHABET}]{${TRACKING_RANDOM_LENGTH}}$`);

/** "SMK-<year>-<6 characters>" from six alphabet indexes (the service supplies random ones). */
export function formatTrackingId(year: number, indexes: readonly number[]): string {
  if (indexes.length !== TRACKING_RANDOM_LENGTH) throw new Error('Need exactly 6 indexes');
  const suffix = indexes.map((i) => TRACKING_ALPHABET[i % TRACKING_ALPHABET.length]).join('');
  return `SMK-${year}-${suffix}`;
}

/** Accepts lower case and stray spaces from the citizen; returns null if it cannot be an ID. */
export function normalizeTrackingId(input: string): string | null {
  const id = input.trim().toUpperCase();
  return TRACKING_ID.test(id) ? id : null;
}

/** Who may read complaints: ADMIN and office staff (the help desk) all; ward supervisors their ward. */
export type ComplaintScope = { kind: 'ALL' } | { kind: 'WARD'; wardId: string } | { kind: 'NONE' };

export function complaintScope(actor: AuthUser): ComplaintScope {
  if (actor.role === Role.ADMIN || actor.role === Role.OFFICE_STAFF) return { kind: 'ALL' };
  if ((actor.role === Role.WARD_INSPECTOR || actor.role === Role.INSPECTOR) && actor.homeWardId) {
    return { kind: 'WARD', wardId: actor.homeWardId };
  }
  return { kind: 'NONE' };
}

export function canSeeComplaint(actor: AuthUser, wardId: string | null): boolean {
  const scope = complaintScope(actor);
  return scope.kind === 'ALL' || (scope.kind === 'WARD' && wardId === scope.wardId);
}

/**
 * Who acts on a complaint (assign, resolve, reject, close): ADMIN any; the WARD_INSPECTOR of its
 * ward. Complaints with no ward yet are the admin's to route.
 */
export function canManageComplaint(actor: AuthUser, wardId: string | null): boolean {
  if (actor.role === Role.ADMIN) return true;
  return actor.role === Role.WARD_INSPECTOR && wardId !== null && actor.homeWardId === wardId;
}

/** The citizen's phone number is for those who may call them back. */
export function canSeeCitizenPhone(actor: AuthUser): boolean {
  return (
    actor.role === Role.ADMIN ||
    actor.role === Role.WARD_INSPECTOR ||
    actor.role === Role.OFFICE_STAFF
  );
}

export type ComplaintAction = 'ASSIGN' | 'RESOLVE' | 'REJECT' | 'CLOSE';

const DONE_TASK: readonly TaskStatus[] = ['APPROVED', 'CLOSED'];

/**
 *   ASSIGN   RECEIVED | ASSIGNED -> ASSIGNED   (raises a task; more tasks may follow)
 *   RESOLVE  ASSIGNED -> RESOLVED              (needs at least one approved or closed task)
 *   REJECT   RECEIVED -> REJECTED              (not a civic issue / duplicate)
 *   CLOSE    RESOLVED | REJECTED -> CLOSED
 */
export function nextComplaintStatus(
  action: ComplaintAction,
  current: ComplaintStatus,
  taskStatuses: readonly TaskStatus[],
): ComplaintStatus {
  switch (action) {
    case 'ASSIGN':
      if (current === 'RECEIVED' || current === 'ASSIGNED') return 'ASSIGNED';
      break;
    case 'RESOLVE':
      if (current === 'ASSIGNED') {
        if (!taskStatuses.some((s) => DONE_TASK.includes(s))) {
          throw new ComplaintRuleError('status', 'Resolve only after a linked task is approved');
        }
        return 'RESOLVED';
      }
      break;
    case 'REJECT':
      if (current === 'RECEIVED') return 'REJECTED';
      break;
    case 'CLOSE':
      if (current === 'RESOLVED' || current === 'REJECTED') return 'CLOSED';
      break;
  }
  throw new ComplaintRuleError(
    'status',
    `Cannot ${action.toLowerCase()} a complaint that is ${current}`,
  );
}

/**
 * The status shown on the public tracking page: work on a linked task shows as IN_PROGRESS,
 * so the citizen sees movement before the complaint is formally resolved.
 */
export function publicStatus(
  status: ComplaintStatus,
  taskStatuses: readonly TaskStatus[],
): ComplaintStatus {
  if (status !== 'ASSIGNED') return status;
  const working: readonly TaskStatus[] = ['IN_PROGRESS', 'SUBMITTED', 'REJECTED', 'APPROVED'];
  return taskStatuses.some((s) => working.includes(s)) ? 'IN_PROGRESS' : 'ASSIGNED';
}
