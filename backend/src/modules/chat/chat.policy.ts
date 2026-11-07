/**
 * Hierarchy-based chat (action plan Phase 4) as pure functions: which channels a person
 * belongs to today, who may post where, and who may message whom directly.
 * No database, clock or network.
 */
import type { AuthUser } from '../../shared/auth/auth-user';
import { Role, ROLE_RANK, type StaffRole } from '../../shared/auth/roles';
import type { ConversationType } from './entities/conversation.entity';

export interface ChannelSpec {
  key: string;
  type: Exclude<ConversationType, 'DIRECT'>;
  wardId: string | null;
  inspectorId: string | null;
  shiftDate: string | null;
}

/** What decides a person's channels today. */
export interface ChatFacts {
  staffId: string;
  role: StaffRole;
  homeWardId: string | null;
  /** Today's placement: the ward, and for a worker the inspector whose team they joined. */
  dayWardId: string | null;
  dayInspectorId: string | null;
}

export const squadKey = (inspectorId: string, date: string) => `S:${inspectorId}:${date}`;
export const wardKey = (wardId: string) => `W:${wardId}`;
export const CITY_KEY = 'C:SMKMC';
export const directKey = (a: string, b: string) => `D:${[a, b].sort().join(':')}`;

/**
 * Channels a person is in today:
 * - an inspector placed today: their squad for today (with the workers placed under them), and
 *   the broadcast of the ward they work in;
 * - a worker placed today: their inspector's squad for today;
 * - a ward inspector: their ward's broadcast and the city broadcast;
 * - an admin: the city broadcast.
 */
export function channelsFor(f: ChatFacts, today: string): ChannelSpec[] {
  const out: ChannelSpec[] = [];
  const squad = (inspectorId: string): ChannelSpec => ({
    key: squadKey(inspectorId, today),
    type: 'SQUAD_TEAM',
    wardId: f.dayWardId,
    inspectorId,
    shiftDate: today,
  });
  const ward = (wardId: string): ChannelSpec => ({
    key: wardKey(wardId),
    type: 'WARD_BROADCAST',
    wardId,
    inspectorId: null,
    shiftDate: null,
  });
  const city: ChannelSpec = {
    key: CITY_KEY,
    type: 'CITY_BROADCAST',
    wardId: null,
    inspectorId: null,
    shiftDate: null,
  };
  switch (f.role) {
    case Role.INSPECTOR:
      if (f.dayWardId) out.push(squad(f.staffId), ward(f.dayWardId));
      else if (f.homeWardId) out.push(ward(f.homeWardId));
      break;
    case Role.WORKER:
      if (f.dayInspectorId) out.push(squad(f.dayInspectorId));
      break;
    case Role.WARD_INSPECTOR:
      if (f.homeWardId) out.push(ward(f.homeWardId));
      out.push(city);
      break;
    case Role.ADMIN:
      out.push(city);
      break;
    default:
      break;
  }
  return out;
}

/** Broadcasts are one-way: the ward inspector (or an admin) posts to the ward, admins to the city. */
export function canPost(type: ConversationType, role: StaffRole): boolean {
  if (type === 'WARD_BROADCAST') return role === Role.WARD_INSPECTOR || role === Role.ADMIN;
  if (type === 'CITY_BROADCAST') return role === Role.ADMIN;
  return true;
}

/** The facts about someone the caller wants to message directly. */
export interface DirectTarget {
  id: string;
  role: StaffRole;
  homeWardId: string | null;
  reportsToId: string | null;
}

/**
 * Direct messages follow the hierarchy: admins reach anyone; anyone reaches their own manager
 * and their direct reports; within a ward, people of different ranks may talk (a worker and a
 * ward inspector), but not peers of the same rank (worker to worker stays in the squad chat).
 */
export function canMessageDirectly(
  actor: Pick<AuthUser, 'staffId' | 'role' | 'homeWardId'> & { reportsToId: string | null },
  target: DirectTarget,
): boolean {
  if (actor.staffId === target.id) return false;
  if (actor.role === Role.ADMIN || target.role === Role.ADMIN) return actor.role !== Role.WORKER;
  if (target.reportsToId === actor.staffId || actor.reportsToId === target.id) return true;
  const sameWard = !!actor.homeWardId && actor.homeWardId === target.homeWardId;
  return sameWard && ROLE_RANK[actor.role] !== ROLE_RANK[target.role];
}
