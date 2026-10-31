/**
 * Ward rules as pure functions: no database, clock or network.
 * Geofencing is plain geometry on GeoJSON (no PostGIS), so it runs the same on any
 * database and is tested in milliseconds.
 */
import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';

export const ZONES = ['SANGLI', 'MIRAJ', 'KUPWAD'] as const;
export type Zone = (typeof ZONES)[number];

/** A check-in this close to the ward edge still counts (GPS drift allowance). */
export const GEOFENCE_EDGE_TOLERANCE_METERS = 25;

/** GeoJSON position: [longitude, latitude]. */
export type Position = [number, number];

export interface PolygonBoundary {
  type: 'Polygon';
  coordinates: Position[][];
}

export interface MultiPolygonBoundary {
  type: 'MultiPolygon';
  coordinates: Position[][][];
}

export type WardBoundary = PolygonBoundary | MultiPolygonBoundary;

export interface GeoPoint {
  latitude: number;
  longitude: number;
}

export interface LocationCheck {
  inside: boolean;
  withinTolerance: boolean;
  distanceToEdgeMeters: number;
}

const MAX_POSITIONS = 20_000;
const METERS_PER_DEGREE = (6_371_008.8 * Math.PI) / 180;

export function normalizeWardCode(code: string): string {
  return code.trim().toUpperCase();
}

function invalid(reason: string): never {
  throw new AppError(ErrorCode.INVALID_BOUNDARY, undefined, { reason });
}

function parsePosition(value: unknown): Position {
  if (!Array.isArray(value) || value.length < 2) invalid('Each position must be [longitude, latitude]');
  const [lng, lat] = value as unknown[];
  if (typeof lng !== 'number' || typeof lat !== 'number' || !Number.isFinite(lng) || !Number.isFinite(lat)) {
    invalid('Coordinates must be numbers');
  }
  if (lng < -180 || lng > 180 || lat < -90 || lat > 90) invalid('Coordinates are out of range');
  return [lng, lat];
}

function parseRing(value: unknown): Position[] {
  if (!Array.isArray(value) || value.length < 4) invalid('Each ring needs at least 4 positions');
  const ring = (value as unknown[]).map(parsePosition);
  const first = ring[0];
  const last = ring[ring.length - 1];
  if (first[0] !== last[0] || first[1] !== last[1]) invalid('Each ring must be closed (first = last position)');
  return ring;
}

function parsePolygon(value: unknown): Position[][] {
  if (!Array.isArray(value) || value.length === 0) invalid('A polygon needs an outer ring');
  return (value as unknown[]).map(parseRing);
}

/**
 * Accepts a GeoJSON Polygon / MultiPolygon geometry or Feature (object or JSON string)
 * and returns a clean geometry, or throws INVALID_BOUNDARY with the reason.
 */
export function parseWardBoundary(input: unknown): WardBoundary {
  let value: unknown = input;
  if (typeof value === 'string') {
    try {
      value = JSON.parse(value);
    } catch {
      invalid('Boundary is not valid JSON');
    }
  }
  if (typeof value !== 'object' || value === null) invalid('Boundary must be a GeoJSON object');

  let geometry = value as { type?: unknown; coordinates?: unknown; geometry?: unknown };
  if (geometry.type === 'Feature') {
    geometry = (geometry.geometry ?? {}) as typeof geometry;
  }

  let boundary: WardBoundary;
  if (geometry.type === 'Polygon') {
    boundary = { type: 'Polygon', coordinates: parsePolygon(geometry.coordinates) };
  } else if (geometry.type === 'MultiPolygon') {
    if (!Array.isArray(geometry.coordinates) || geometry.coordinates.length === 0) {
      invalid('A MultiPolygon needs at least one polygon');
    }
    boundary = {
      type: 'MultiPolygon',
      coordinates: (geometry.coordinates as unknown[]).map(parsePolygon),
    };
  } else {
    return invalid('Boundary must be a Polygon or MultiPolygon');
  }

  const total = polygonsOf(boundary).reduce(
    (sum, poly) => sum + poly.reduce((s, ring) => s + ring.length, 0),
    0,
  );
  if (total > MAX_POSITIONS) invalid(`Boundary has more than ${MAX_POSITIONS} positions`);
  return boundary;
}

function polygonsOf(boundary: WardBoundary): Position[][][] {
  return boundary.type === 'Polygon' ? [boundary.coordinates] : boundary.coordinates;
}

/** Ray casting; points exactly on an edge are handled by the distance tolerance. */
function pointInRing(lng: number, lat: number, ring: Position[]): boolean {
  let inside = false;
  for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    const [xi, yi] = ring[i];
    const [xj, yj] = ring[j];
    const crosses = yi > lat !== yj > lat && lng < ((xj - xi) * (lat - yi)) / (yj - yi) + xi;
    if (crosses) inside = !inside;
  }
  return inside;
}

/** Distance in metres from a point to a ring, using a local flat projection (accurate at ward scale). */
function distanceToRingMeters(lng: number, lat: number, ring: Position[]): number {
  const cosLat = Math.cos((lat * Math.PI) / 180);
  const project = ([x, y]: Position): [number, number] => [
    (x - lng) * cosLat * METERS_PER_DEGREE,
    (y - lat) * METERS_PER_DEGREE,
  ];
  let best = Number.POSITIVE_INFINITY;
  for (let i = 0; i < ring.length - 1; i++) {
    const [ax, ay] = project(ring[i]);
    const [bx, by] = project(ring[i + 1]);
    const dx = bx - ax;
    const dy = by - ay;
    const lengthSq = dx * dx + dy * dy;
    const t = lengthSq === 0 ? 0 : Math.max(0, Math.min(1, -(ax * dx + ay * dy) / lengthSq));
    const px = ax + t * dx;
    const py = ay + t * dy;
    best = Math.min(best, Math.hypot(px, py));
  }
  return best;
}

/**
 * Is the point inside the ward, or within `toleranceMeters` of its edge?
 * Holes (inner rings) are excluded from the ward.
 */
export function checkLocationInWard(
  boundary: WardBoundary,
  point: GeoPoint,
  toleranceMeters = GEOFENCE_EDGE_TOLERANCE_METERS,
): LocationCheck {
  const { latitude: lat, longitude: lng } = point;
  const polygons = polygonsOf(boundary);

  const inside = polygons.some(
    ([outer, ...holes]) => pointInRing(lng, lat, outer) && !holes.some((h) => pointInRing(lng, lat, h)),
  );

  const distance = Math.min(
    ...polygons.flatMap((poly) => poly.map((ring) => distanceToRingMeters(lng, lat, ring))),
  );

  return {
    inside,
    withinTolerance: inside || distance <= toleranceMeters,
    distanceToEdgeMeters: Math.round(distance * 10) / 10,
  };
}
