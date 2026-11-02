import { Suspense } from 'react';
import { RouteView } from '@/features/attendance/route-view';

export default function Page() {
  return (
    <Suspense>
      <RouteView />
    </Suspense>
  );
}
