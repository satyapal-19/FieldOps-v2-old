/**
 * Distances for tracking (pings, routes) as pure functions. Great-circle distance on the
 * mean Earth radius: exact enough for a city (well under 0.5 % error) and needs no PostGIS.
 */
import type { GeoPoint } from '../wards/wards.policy';

const EARTH_RADIUS_M = 6_371_008.8;
const rad = (deg: number): number => (deg * Math.PI) / 180;

export function distanceMeters(a: GeoPoint, b: GeoPoint): number {
  const dLat = rad(b.latitude - a.latitude);
  const dLng = rad(b.longitude - a.longitude);
  const h =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(rad(a.latitude)) * Math.cos(rad(b.latitude)) * Math.sin(dLng / 2) ** 2;
  return 2 * EARTH_RADIUS_M * Math.asin(Math.min(1, Math.sqrt(h)));
}

/** A ping this close to the previous one counts as standing still (GPS noise included). */
export const STATIONARY_RADIUS_M = 20;

export function isStationary(previous: GeoPoint | null, current: GeoPoint): boolean {
  return previous !== null && distanceMeters(previous, current) < STATIONARY_RADIUS_M;
}

/**
 * Length of a route through the points in order, in metres. Jumps shorter than the
 * stationary radius are ignored so GPS jitter while standing still does not add distance.
 */
export function routeLengthMeters(points: GeoPoint[]): number {
  let total = 0;
  let anchor: GeoPoint | null = null;
  for (const p of points) {
    if (anchor === null) {
      anchor = p;
      continue;
    }
    const d = distanceMeters(anchor, p);
    if (d >= STATIONARY_RADIUS_M) {
      total += d;
      anchor = p;
    }
  }
  return Math.round(total);
}
