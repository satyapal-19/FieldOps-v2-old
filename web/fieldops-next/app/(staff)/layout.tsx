import { cookies } from 'next/headers';
import { redirect } from 'next/navigation';
import type { ReactNode } from 'react';
import { StaffShell } from '@/features/shell/staff-shell';
import { isWebRole } from '@/shared/auth/route-table';
import { ROLE_COOKIE } from '@/shared/auth/session-cookies';

/** Every dashboard page: middleware already checked the route; this only picks the menu. */
export default async function StaffLayout({ children }: { children: ReactNode }) {
  const role = (await cookies()).get(ROLE_COOKIE)?.value;
  if (!isWebRole(role)) redirect('/login');
  return <StaffShell role={role}>{children}</StaffShell>;
}
