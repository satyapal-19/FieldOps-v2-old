/**
 * Pure staff rules: identity formats and which links each role must have.
 * No database, no Nest - test with plain tables of inputs.
 */
import { Role, StaffRole } from '../../shared/auth/roles';

export class StaffRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

/**
 * Accepts "9812345678", "+91 98123 45678", "091-9812345678" and returns "9812345678".
 * Indian mobile numbers are 10 digits starting 6-9.
 */
export function normalizePhone(input: string): string {
  let digits = input.replace(/[\s\-()]/g, '');
  if (digits.startsWith('+91')) digits = digits.slice(3);
  else if (digits.length === 12 && digits.startsWith('91')) digits = digits.slice(2);
  else if (digits.length === 11 && digits.startsWith('0')) digits = digits.slice(1);
  if (!/^[6-9]\d{9}$/.test(digits)) {
    throw new StaffRuleError('phone', 'Phone must be a 10-digit Indian mobile number');
  }
  return digits;
}

/** Shows only the last 4 digits, for logs and messages. */
export function maskPhone(phone: string): string {
  return phone.length >= 4 ? `******${phone.slice(-4)}` : '****';
}

export function normalizeEmployeeCode(input: string): string {
  const code = input.trim().toUpperCase();
  if (!/^[A-Z0-9][A-Z0-9-]{1,19}$/.test(code)) {
    throw new StaffRuleError('employeeCode', 'Employee code: 2-20 letters, digits or hyphens');
  }
  return code;
}

const HHMM = /^([01]\d|2[0-3]):[0-5]\d$/;

export function parseShiftTime(field: string, value: string): string {
  if (!HHMM.test(value)) throw new StaffRuleError(field, `${field} must be HH:MM (24-hour IST)`);
  return value;
}

export interface StaffLinks {
  role: StaffRole;
  homeWardId: string | null;
  officeId: string | null;
}

/**
 * v4 links per role:
 * - WARD_INSPECTOR: fixed ward required; no office
 * - INSPECTOR / WORKER: default ward required; no office
 * - OFFICE_STAFF: office required; no ward
 * - ADMIN: global; neither
 */
export function checkStaffLinks(links: StaffLinks): void {
  const { role, homeWardId, officeId } = links;
  const fieldRole = role === Role.WARD_INSPECTOR || role === Role.INSPECTOR || role === Role.WORKER;
  if (fieldRole && !homeWardId) {
    throw new StaffRuleError('homeWardId', `${role} must belong to a ward`);
  }
  if (fieldRole && officeId) {
    throw new StaffRuleError('officeId', `${role} is field staff and cannot belong to an office`);
  }
  if (role === Role.OFFICE_STAFF) {
    if (!officeId) throw new StaffRuleError('officeId', 'OFFICE_STAFF must belong to an office');
    if (homeWardId) throw new StaffRuleError('homeWardId', 'OFFICE_STAFF cannot belong to a ward');
  }
  if (role === Role.ADMIN && (homeWardId || officeId)) {
    throw new StaffRuleError('homeWardId', 'ADMIN is global and has no ward or office');
  }
}
