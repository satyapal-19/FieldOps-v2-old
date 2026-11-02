import { distanceMeters, isStationary, routeLengthMeters } from './geo.policy';

const p = (latitude: number, longitude: number) => ({ latitude, longitude });

describe('geo policy', () => {
  it.each([
    ['same point', p(16.855, 74.585), p(16.855, 74.585), 0, 0.01],
    ['0.001° of latitude', p(16.855, 74.585), p(16.856, 74.585), 111.2, 0.5],
    ['0.001° of longitude at 16.85° N', p(16.855, 74.585), p(16.855, 74.586), 106.4, 0.5],
    ['0.1° of latitude (11.1 km)', p(16.8, 74.6), p(16.9, 74.6), 11_119.5, 0.5],
  ])('%s', (_name, a, b, expected, tolerance) => {
    expect(Math.abs(distanceMeters(a, b) - expected)).toBeLessThanOrEqual(tolerance);
  });

  it.each([
    [null, false],
    [p(16.85509, 74.585), true], // 10 m
    [p(16.85525, 74.585), false], // 28 m
  ])('previous %j -> stationary %s', (previous, expected) => {
    expect(isStationary(previous, p(16.855, 74.585))).toBe(expected);
  });

  it('measures a route and ignores jitter under 20 m', () => {
    expect(routeLengthMeters([])).toBe(0);
    expect(routeLengthMeters([p(16.855, 74.585)])).toBe(0);
    const walk = [p(16.855, 74.585), p(16.85505, 74.585), p(16.856, 74.585), p(16.857, 74.585)];
    expect(routeLengthMeters(walk)).toBe(222);
    const jitter = [p(16.855, 74.585), p(16.85508, 74.585), p(16.855, 74.585), p(16.85508, 74.585)];
    expect(routeLengthMeters(jitter)).toBe(0);
  });
});
