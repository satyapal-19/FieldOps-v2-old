/**
 * Map tiles: OpenStreetMap only (SMKC rule). Point NEXT_PUBLIC_TILE_URL at the offline SMKMC
 * tile pack served by our backend once it exists (Phase 4); until then the public OSM server.
 */
export const TILE_URL = process.env.NEXT_PUBLIC_TILE_URL ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

export const TILE_ATTRIBUTION =
  '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';

/** A GeoJSON Polygon's outer ring as Leaflet [lat, lng] pairs; null for anything else. */
export function polygonRing(geo: unknown): [number, number][] | null {
  const g = geo as { type?: string; coordinates?: number[][][] } | null;
  if (!g || g.type !== 'Polygon' || !Array.isArray(g.coordinates?.[0])) return null;
  return g.coordinates[0].map(([lng, lat]) => [lat, lng]);
}
