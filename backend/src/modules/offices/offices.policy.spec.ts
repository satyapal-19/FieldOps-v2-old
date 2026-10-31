import { checkLocationAtOffice, normalizeOfficeCode, parseOfficePremises } from './offices.policy';

// Roughly a 110 m x 110 m block around SMKMC head office, Sangli.
const premises = parseOfficePremises({
  type: 'Polygon',
  coordinates: [
    [
      [74.5823, 16.8547],
      [74.5833, 16.8547],
      [74.5833, 16.8557],
      [74.5823, 16.8557],
      [74.5823, 16.8547],
    ],
  ],
});

describe('offices.policy', () => {
  it('normalizes codes', () => {
    expect(normalizeOfficeCode(' ho-sangli ')).toBe('HO-SANGLI');
    expect(() => normalizeOfficeCode('x')).toThrow();
  });

  it('accepts a point inside the premises', () => {
    expect(checkLocationAtOffice(premises, { latitude: 16.8552, longitude: 74.5828 })).toMatchObject({
      inside: true,
      withinTolerance: true,
    });
  });

  it('accepts a point about 60 m outside (within the 100 m buffer)', () => {
    const r = checkLocationAtOffice(premises, { latitude: 16.85625, longitude: 74.5828 });
    expect(r.inside).toBe(false);
    expect(r.withinTolerance).toBe(true);
  });

  it('rejects a point about 200 m outside', () => {
    const r = checkLocationAtOffice(premises, { latitude: 16.8575, longitude: 74.5828 });
    expect(r.withinTolerance).toBe(false);
  });

  it('honours a custom buffer', () => {
    const p = { latitude: 16.85625, longitude: 74.5828 };
    expect(checkLocationAtOffice(premises, p, 25).withinTolerance).toBe(false);
  });
});
