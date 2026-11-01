export const ATTENDANCE_STATUSES = [
  'PRESENT',
  'ABSENT',
  'LATE',
  'HALF_DAY',
  'HOLIDAY_OFF',
  'ON_LEAVE',
  'REGULARIZED',
] as const;
export type AttendanceStatus = (typeof ATTENDANCE_STATUSES)[number];

/** Who pressed the button: the staff member, or a senior marking on their behalf (v4 hierarchy). */
export const PUNCH_MODES = ['SELF', 'INSPECTOR_PROXY', 'ADMIN_PROXY'] as const;
export type PunchMode = (typeof PUNCH_MODES)[number];

export const CHECKOUT_TYPES = [
  'MANUAL',
  'AUTO_GPS_LAST_SEEN',
  'AUTO_OFFICE_SCHEDULED',
  'SUPERVISOR_OVERRIDE',
] as const;
export type CheckoutType = (typeof CHECKOUT_TYPES)[number];

export const TAMPER_EVENT_TYPES = [
  'GPS_DISABLED',
  'PERMISSION_REVOKED',
  'AIRPLANE_MODE',
  'DATA_DISABLED',
  'DEVICE_OFFLINE',
  'MOCK_LOCATION',
  'SILENT_GAP',
] as const;
export type TamperEventType = (typeof TAMPER_EVENT_TYPES)[number];

/** DEVICE = reported by the phone watchdog; SERVER = found by silent-gap detection. */
export type TamperSource = 'DEVICE' | 'SERVER';
