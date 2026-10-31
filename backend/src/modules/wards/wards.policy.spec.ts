import { AppError } from '../../shared/errors/app-error';
import { ErrorCode } from '../../shared/errors/error-codes';
import {
  checkLocationInWard,
  normalizeWardCode,
  parseWardBoundary,
  type Position,
  type WardBoundary,
} from './wards.policy';

// A ward roughly 1.1 km square near Sangli: lng 74.58-74.59, lat 16.85-16.86.
const square: Position[] = [
  [74.58, 16.85],
  [74.59, 16.85],
  [74.59, 16.86],
  [74.58, 16.86],
  [74.58, 16.85],
];
const hole: Position[] = [
  [74.584, 16.854],
  [74.586, 16.854],
  [74.586, 16.856],
  [74.584, 16.856],
  [74.584, 16.854],
];
const ward: WardBoundary = { type: 'Polygon', coordinates: [square] };

function expectInvalid(input: unknown, reason: RegExp): void {
  try {
    parseWardBoundary(input);
    throw new Error('expected INVALID_BOUNDARY');
  } catch (e) {
    expect(e).toBeInstanceOf(AppError);
    expect((e as AppError).code).toBe(ErrorCode.INVALID_BOUNDARY);
    expect(String((e as AppError).details?.reason)).toMatch(reason);
  }
}

describe('checkLocationInWard', () => {
  it.each([
    // [label, lat, lng, inside, withinTolerance]
    ['centre of the ward', 16.855, 74.585, true, true],
    ['11 m north of the edge', 16.8601, 74.585, false, true],
    ['21 m east of the edge', 16.855, 74.5902, false, true],
    ['111 m north of the edge', 16.861, 74.585, false, false],
    ['far away in Miraj', 16.8285, 74.6442, false, false],
  ])('%s', (_label, lat, lng, inside, withinTolerance) => {
    const result = checkLocationInWard(ward, { latitude: lat, longitude: lng });
    expect(result.inside).toBe(inside);
    expect(result.withinTolerance).toBe(withinTolerance);
  });

  it('reports the distance to the nearest edge in metres', () => {
    const near = checkLocationInWard(ward, { latitude: 16.8601, longitude: 74.585 });
    expect(near.distanceToEdgeMeters).toBeGreaterThan(10);
    expect(near.distanceToEdgeMeters).toBeLessThan(12.5);
  });

  it('treats a hole as outside the ward', () => {
    const withHole: WardBoundary = { type: 'Polygon', coordinates: [square, hole] };
    const result = checkLocationInWard(withHole, { latitude: 16.855, longitude: 74.585 });
    expect(result.inside).toBe(false);
    expect(result.withinTolerance).toBe(false); // ~100 m from the hole's edge
  });

  it('accepts a point inside any polygon of a MultiPolygon', () => {
    const shifted = square.map(([lng, lat]) => [lng + 0.05, lat] as Position);
    const multi: WardBoundary = { type: 'MultiPolygon', coordinates: [[square], [shifted]] };
    expect(checkLocationInWard(multi, { latitude: 16.855, longitude: 74.635 }).inside).toBe(true);
  });

  it('honours a custom tolerance', () => {
    const point = { latitude: 16.8601, longitude: 74.585 }; // ~11 m outside
    expect(checkLocationInWard(ward, point, 5).withinTolerance).toBe(false);
  });
});

describe('parseWardBoundary', () => {
  it('accepts a Polygon geometry, a Feature and a JSON string', () => {
    expect(parseWardBoundary({ type: 'Polygon', coordinates: [square] }).type).toBe('Polygon');
    expect(
      parseWardBoundary({ type: 'Feature', properties: {}, geometry: { type: 'Polygon', coordinates: [square] } })
        .type,
    ).toBe('Polygon');
    expect(parseWardBoundary(JSON.stringify({ type: 'Polygon', coordinates: [square] })).type).toBe('Polygon');
  });

  it('drops altitude values', () => {
    const withAltitude = square.map(([lng, lat]) => [lng, lat, 550]);
    const parsed = parseWardBoundary({ type: 'Polygon', coordinates: [withAltitude] });
    expect(parsed.type === 'Polygon' && parsed.coordinates[0][0]).toEqual([74.58, 16.85]);
  });

  it.each([
    ['not JSON', '{oops', /not valid JSON/],
    ['a point', { type: 'Point', coordinates: [74.58, 16.85] }, /Polygon or MultiPolygon/],
    ['an open ring', { type: 'Polygon', coordinates: [square.slice(0, 4)] }, /closed/],
    ['too few positions', { type: 'Polygon', coordinates: [[square[0], square[1], square[0]]] }, /at least 4/],
    ['latitude out of range', { type: 'Polygon', coordinates: [square.map(([x]) => [x, 95])] }, /out of range/],
    ['text coordinates', { type: 'Polygon', coordinates: [[['a', 'b'], ['a', 'b'], ['a', 'b'], ['a', 'b']]] }, /numbers/],
  ])('rejects %s', (_label, input, reason) => {
    expectInvalid(input, reason);
  });
});

describe('normalizeWardCode', () => {
  it('trims and upper-cases', () => {
    expect(normalizeWardCode('  w04 ')).toBe('W04');
  });
});
