/**
 * The one route table: which staff roles may open each dashboard page. Middleware, layouts
 * and the menu all read it. Hiding a page is cosmetic; the API enforces every access rule.
 * Web sign-in is by password, so only ADMIN, WARD_INSPECTOR and OFFICE_STAFF reach these pages.
 */
export const WEB_ROLES = ['ADMIN', 'WARD_INSPECTOR', 'OFFICE_STAFF'] as const;
export type WebRole = (typeof WEB_ROLES)[number];

export interface StaffRoute {
  path: string;
  roles: readonly WebRole[];
  label: { en: string; mr: string };
  /** Shown in the side menu (false for detail pages reached from another page). */
  menu: boolean;
}

export const STAFF_ROUTES: readonly StaffRoute[] = [
  {
    path: '/dashboard',
    roles: ['ADMIN', 'WARD_INSPECTOR', 'OFFICE_STAFF'],
    label: { en: 'Dashboard', mr: 'डॅशबोर्ड' },
    menu: true,
  },
  {
    path: '/attendance',
    roles: ['ADMIN', 'WARD_INSPECTOR'],
    label: { en: 'Attendance', mr: 'हजेरी' },
    menu: true,
  },
  {
    path: '/alerts',
    roles: ['ADMIN', 'WARD_INSPECTOR'],
    label: { en: 'Alerts', mr: 'सूचना' },
    menu: true,
  },
  {
    path: '/approvals',
    roles: ['ADMIN', 'WARD_INSPECTOR'],
    label: { en: 'Leave & corrections', mr: 'रजा व दुरुस्ती' },
    menu: true,
  },
  {
    path: '/tasks',
    roles: ['ADMIN', 'WARD_INSPECTOR'],
    label: { en: 'Tasks', mr: 'कामे' },
    menu: true,
  },
  {
    path: '/staff',
    roles: ['ADMIN', 'WARD_INSPECTOR'],
    label: { en: 'Staff', mr: 'कर्मचारी' },
    menu: true,
  },
];

/** Pages anyone may open without signing in. */
export function isPublicPath(pathname: string): boolean {
  return pathname === '/' || pathname === '/login' || pathname === '/citizen' || pathname.startsWith('/citizen/');
}

function matches(route: StaffRoute, pathname: string): boolean {
  return pathname === route.path || pathname.startsWith(`${route.path}/`);
}

export function isWebRole(role: string | undefined | null): role is WebRole {
  return !!role && (WEB_ROLES as readonly string[]).includes(role);
}

/** Whether `role` may open `pathname`. Unknown dashboard paths are refused. */
export function canOpen(role: WebRole, pathname: string): boolean {
  const route = STAFF_ROUTES.find((r) => matches(r, pathname));
  return !!route && route.roles.includes(role);
}

/** Where a role lands after sign-in or when it opens a page it may not see. */
export function homeFor(role: WebRole): string {
  return STAFF_ROUTES.find((r) => r.menu && r.roles.includes(role))?.path ?? '/dashboard';
}

export function menuFor(role: WebRole): StaffRoute[] {
  return STAFF_ROUTES.filter((r) => r.menu && r.roles.includes(role));
}

/** A `next` redirect target is honoured only for a same-site dashboard path the role may open. */
export function safeNext(role: WebRole, next: string | null | undefined): string {
  if (next && next.startsWith('/') && !next.startsWith('//') && canOpen(role, next.split('?')[0])) {
    return next;
  }
  return homeFor(role);
}
