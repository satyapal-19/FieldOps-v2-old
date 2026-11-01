/** How a daily assignment came about (v4 §3). Self-picks and self-joins need approval. */
export const ASSIGNMENT_MODES = [
  'STANDING_ROSTER',
  'ADMIN_ASSIGNED',
  'WARD_INSPECTOR_ASSIGNED',
  'INSPECTOR_SELF_PICK',
  'WORKER_SELF_JOIN',
] as const;
export type AssignmentMode = (typeof ASSIGNMENT_MODES)[number];

/** Roles a daily assignment can place in a ward. */
export const ASSIGNABLE_ROLES = ['INSPECTOR', 'WORKER'] as const;
export type AssignableRole = (typeof ASSIGNABLE_ROLES)[number];
