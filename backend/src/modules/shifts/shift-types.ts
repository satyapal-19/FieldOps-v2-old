export const SHIFT_TYPES = ['MORNING', 'EVENING', 'NIGHT', 'GENERAL_OFFICE'] as const;
export type ShiftType = (typeof SHIFT_TYPES)[number];
