/**
 * Roles from the v4 authorisation matrix. Rank decides who may act for whom:
 * a marker must out-rank the person they mark (OFFICE_STAFF ranks with WORKER).
 */
export enum Role {
  ADMIN = 'ADMIN',
  WARD_INSPECTOR = 'WARD_INSPECTOR',
  INSPECTOR = 'INSPECTOR',
  WORKER = 'WORKER',
  OFFICE_STAFF = 'OFFICE_STAFF',
  CITIZEN = 'CITIZEN',
}

/** Roles a staff record can hold (citizens are not staff). */
export const STAFF_ROLES = [
  Role.ADMIN,
  Role.WARD_INSPECTOR,
  Role.INSPECTOR,
  Role.WORKER,
  Role.OFFICE_STAFF,
] as const;
export type StaffRole = (typeof STAFF_ROLES)[number];

export const ROLE_RANK: Record<Role, number> = {
  [Role.ADMIN]: 4,
  [Role.WARD_INSPECTOR]: 3,
  [Role.INSPECTOR]: 2,
  [Role.WORKER]: 1,
  [Role.OFFICE_STAFF]: 1,
  [Role.CITIZEN]: 0,
};

export function outranks(actor: Role, target: Role): boolean {
  return ROLE_RANK[actor] > ROLE_RANK[target];
}

/** Roles that sign in to the web dashboard with a password (field roles use OTP on the phone). */
export const PASSWORD_LOGIN_ROLES: readonly Role[] = [Role.ADMIN, Role.WARD_INSPECTOR, Role.OFFICE_STAFF];
