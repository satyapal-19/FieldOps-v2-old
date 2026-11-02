'use client';

import { createContext, useContext, type ReactNode } from 'react';
import type { WebRole } from '@/shared/auth/route-table';

const RoleContext = createContext<WebRole | null>(null);

export function RoleProvider({ role, children }: { role: WebRole; children: ReactNode }) {
  return <RoleContext.Provider value={role}>{children}</RoleContext.Provider>;
}

/** The signed-in role, to show or hide actions. Cosmetic: the API decides what is allowed. */
export function useRole(): WebRole {
  const role = useContext(RoleContext);
  if (!role) throw new Error('useRole needs <RoleProvider> (the staff layout)');
  return role;
}
