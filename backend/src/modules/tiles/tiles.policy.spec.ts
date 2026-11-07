import { tilePath, validTile } from './tiles.policy';

describe('validTile', () => {
  it.each([
    ['the world tile', 0, 0, 0, true],
    ['Sangli at zoom 16', 16, 46_335, 30_244, true],
    ['x beyond the row', 2, 4, 0, false],
    ['negative y', 3, 0, -1, false],
    ['zoom 20', 20, 0, 0, false],
    ['fractional', 1.5, 0, 0, false],
  ])('%s', (_case, z, x, y, expected) => {
    expect(validTile(z, x, y)).toBe(expected);
  });

  it('maps to z/x/y.png', () => {
    expect(tilePath(16, 46335, 30244)).toBe('16/46335/30244.png');
  });
});
