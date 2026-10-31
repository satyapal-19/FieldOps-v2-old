import type { StaffRole } from './roles';

/** The signed-in caller, taken from a verified access token whose session is still live. */
export interface AuthUser {
  staffId: string;
  role: StaffRole;
  sessionId: string;
  /** Static ward (WARD_INSPECTOR) or default ward (INSPECTOR / WORKER); null otherwise. */
  homeWardId: string | null;
  officeId: string | null;
}

/** Claims inside the access token. Short-lived; the session row is checked on every request. */
export interface AccessTokenClaims {
  sub: string;
  sid: string;
  role: StaffRole;
}
