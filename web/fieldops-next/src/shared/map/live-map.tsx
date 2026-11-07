'use client';

import 'leaflet/dist/leaflet.css';
import type { LatLngBoundsExpression, LatLngTuple } from 'leaflet';
import { useEffect, useMemo } from 'react';
import { CircleMarker, MapContainer, Polygon, Popup, TileLayer, Tooltip, useMap } from 'react-leaflet';
import { TILE_ATTRIBUTION, TILE_URL } from './tiles';

export interface LiveMarker {
  id: string;
  latitude: number;
  longitude: number;
  label: string;
  detail: string;
  color: string;
  href?: string;
}

export interface WardShape {
  id: string;
  label: string;
  ring: LatLngTuple[];
}

const SANGLI: LatLngTuple = [16.8524, 74.5815];

function FitOnce({ bounds }: { bounds: LatLngBoundsExpression | null }) {
  const map = useMap();
  // Fit when the set of wards changes, not on every 30-second refresh of the markers.
  useEffect(() => {
    if (bounds) map.fitBounds(bounds, { padding: [24, 24], maxZoom: 16 });
  }, [map, bounds]);
  return null;
}

/** Field staff on duty over ward boundaries on OpenStreetMap. Browser only (Leaflet needs window). */
export default function LiveMap({ markers, wards }: { markers: readonly LiveMarker[]; wards: readonly WardShape[] }) {
  const bounds = useMemo(() => {
    const pts: LatLngTuple[] = wards.flatMap((w) => w.ring);
    return pts.length > 0 ? (pts as LatLngBoundsExpression) : null;
  }, [wards]);
  return (
    <MapContainer center={SANGLI} zoom={13} scrollWheelZoom className="h-[520px] w-full rounded-lg border border-slate-200">
      <TileLayer url={TILE_URL} attribution={TILE_ATTRIBUTION} />
      <FitOnce bounds={bounds} />
      {wards.map((w) => (
        <Polygon key={w.id} positions={w.ring} pathOptions={{ color: '#2E5597', weight: 2, fillOpacity: 0.04 }}>
          <Tooltip sticky>{w.label}</Tooltip>
        </Polygon>
      ))}
      {markers.map((m) => (
        <CircleMarker
          key={m.id}
          center={[m.latitude, m.longitude]}
          radius={7}
          pathOptions={{ color: '#ffffff', weight: 2, fillColor: m.color, fillOpacity: 0.95 }}
        >
          <Tooltip>{m.label}</Tooltip>
          <Popup>
            <strong>{m.label}</strong>
            <br />
            {m.detail}
            {m.href ? (
              <>
                <br />
                <a href={m.href}>Route ›</a>
              </>
            ) : null}
          </Popup>
        </CircleMarker>
      ))}
    </MapContainer>
  );
}
