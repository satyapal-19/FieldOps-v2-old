/** Which tile requests are valid (pure): standard XYZ (slippy map) addressing. */

export const TILE_MAX_ZOOM = 19;

/** A tile address is valid when 0 <= x, y < 2^z and z is within the usual range. */
export function validTile(z: number, x: number, y: number): boolean {
  if (![z, x, y].every(Number.isInteger) || z < 0 || z > TILE_MAX_ZOOM) return false;
  const n = 2 ** z;
  return x >= 0 && y >= 0 && x < n && y < n;
}

/** Relative path of a tile inside the pack folder. */
export function tilePath(z: number, x: number, y: number): string {
  return `${z}/${x}/${y}.png`;
}
