'use client';

import dynamic from 'next/dynamic';
import type { WardShape } from '@/shared/map/live-map';

const LiveMap = dynamic(() => import('@/shared/map/live-map'), {
  ssr: false,
  loading: () => <div className="h-[520px] animate-pulse rounded-lg bg-slate-200" />,
});

/** A ward's boundary on OpenStreetMap (citizen pages are server-rendered; the map is not). */
export function WardMap({ wards }: { wards: WardShape[] }) {
  return <LiveMap markers={[]} wards={wards} />;
}
