import { cookies } from 'next/headers';
import { Dashboard } from '@/features/dashboard/dashboard';
import { isWebRole } from '@/shared/auth/route-table';
import { ROLE_COOKIE } from '@/shared/auth/session-cookies';

export default async function DashboardPage() {
  const role = (await cookies()).get(ROLE_COOKIE)?.value;
  return isWebRole(role) ? <Dashboard role={role} /> : null;
}
