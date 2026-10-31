/**
 * Pure office rules. The geofence reuses the ward geometry (ray casting + distance to edge)
 * with the office's buffer instead of the 25 m ward allowance.
 */
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import {
  checkLocationInWard,
  GeoPoint,
  LocationCheck,
  parseWardBoundary,
  WardBoundary,
} from '../wards/wards.policy';

export const DEFAULT_OFFICE_BUFFER_METERS = 100;
export const MAX_OFFICE_BUFFER_METERS = 300;

export function normalizeOfficeCode(code: string): string {
  const value = code.trim().toUpperCase();
  if (!/^[A-Z0-9_-]{2,20}$/.test(value)) {
    throw new AppError(ErrorCode.VALIDATION_FAILED, 'Office code: 2-20 letters, digits, _ or -');
  }
  return value;
}

/** Same validation as ward boundaries: closed rings, sane coordinates. */
export function parseOfficePremises(input: unknown): WardBoundary {
  return parseWardBoundary(input);
}

/** Inside the premises, or within the buffer (default 100 m) of its edge. */
export function checkLocationAtOffice(
  premises: WardBoundary,
  point: GeoPoint,
  bufferMeters = DEFAULT_OFFICE_BUFFER_METERS,
): LocationCheck {
  return checkLocationInWard(premises, point, bufferMeters);
}
