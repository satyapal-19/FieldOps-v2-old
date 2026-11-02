'use client';

import 'leaflet/dist/leaflet.css';
import type { LatLngBoundsExpression, LatLngTuple } from 'leaflet';
import { useEffect } from 'react';
import { CircleMarker, MapContainer, Polygon, Polyline, TileLayer, Tooltip, useMap } from 'react-leaflet';
import { TILE_ATTRIBUTION, TILE_URL } from './tiles';

export interface MapPoint {
  latitude: number;
  longitude: number;
  label: string;
  /** Mocked or out-of-ward fixes are drawn in warning colours. */
  isMocked?: boolean;
  inWard?: boolean | null;
}

const SANGLI: LatLngTuple = [16.8524, 74.5815];

function FitTo({ bounds }: { bounds: LatLngBoundsExpression | null }) {
  const map = useMap();
  useEffect(() => {
    if (bounds) map.fitBounds(bounds, { padding: [24, 24], maxZoom: 17 });
  }, [map, bounds]);
  return null;
}

function color(p: MapPoint): string {
  if (p.isMocked) return '#b91c1c';
  if (p.inWard === false) return '#d97706';
  return '#1F3864';
}

/**
 * A day's route on OpenStreetMap: the ward boundary, the path through trusted points, every
 * point as a dot, and the playback cursor. Loaded only in the browser (Leaflet needs window).
 */
export default function RouteMap({
  points,
  pathPoints,
  boundary,
  cursor,
}: {
  points: readonly MapPoint[];
  /** Points that count for distance (no mocked / inaccurate fixes). */
  pathPoints: readonly MapPoint[];
  boundary: LatLngTuple[] | null;
  cursor: number | null;
}) {
  const all: LatLngTuple[] = [...points.map((p): LatLngTuple => [p.latitude, p.longitude]), ...(boundary ?? [])];
  const bounds = all.length > 0 ? (all as LatLngBoundsExpression) : null;
  const at = cursor !== null ? points[cursor] : undefined;
  return (
    <MapContainer center={SANGLI} zoom={14} scrollWheelZoom className="h-[420px] w-full rounded-lg border border-slate-200">
      <TileLayer url={TILE_URL} attribution={TILE_ATTRIBUTION} />
      <FitTo bounds={bounds} />
      {boundary ? <Polygon positions={boundary} pathOptions={{ color: '#2E5597', weight: 2, fillOpacity: 0.05 }} /> : null}
      <Polyline positions={pathPoints.map((p): LatLngTuple => [p.latitude, p.longitude])} pathOptions={{ color: '#1F3864', weight: 3 }} />
      {points.map((p, i) => (
        <CircleMarker
          key={i}
          center={[p.latitude, p.longitude]}
          radius={4}
          pathOptions={{ color: color(p), fillColor: color(p), fillOpacity: 0.8, weight: 1 }}
        >
          <Tooltip>{p.label}</Tooltip>
        </CircleMarker>
      ))}
      {at ? (
        <CircleMarker
          center={[at.latitude, at.longitude]}
          radius={9}
          pathOptions={{ color: '#16a34a', fillColor: '#22c55e', fillOpacity: 0.9, weight: 2 }}
        >
          <Tooltip permanent direction="top">
            {at.label}
          </Tooltip>
        </CircleMarker>
      ) : null}
    </MapContainer>
  );
}
