/**
 * Pure shift rules: valid times, overnight shifts, and the effective shift for a day
 * (the day's override, else the staff defaults - v4 fix: spot checks never lack a shift).
 * No database, no clock. Test with plain tables of inputs.
 */
import { istWallClockToUtc } from '../../shared/clock/ist';
import type { ShiftType } from './shift-types';

export class ShiftRuleError extends Error {
  constructor(
    readonly field: string,
    message: string,
  ) {
    super(message);
  }
}

const HHMM = /^([01]\d|2[0-3]):[0-5]\d$/;

/**
 * Start and end as IST "HH:MM". Only a NIGHT shift may end before it starts (it ends the next
 * day); a zero-length shift is never valid.
 */
export function checkShiftTimes(shiftType: ShiftType, startTime: string, endTime: string): void {
  if (!HHMM.test(startTime))
    throw new ShiftRuleError('startTime', 'startTime must be HH:MM (24-hour IST)');
  if (!HHMM.test(endTime))
    throw new ShiftRuleError('endTime', 'endTime must be HH:MM (24-hour IST)');
  if (startTime === endTime)
    throw new ShiftRuleError('endTime', 'A shift cannot start and end at the same time');
  if (endTime < startTime && shiftType !== 'NIGHT') {
    throw new ShiftRuleError('endTime', 'Only a NIGHT shift may end the next day');
  }
}

export interface EffectiveShift {
  date: string;
  shiftType: ShiftType | null;
  startTime: string;
  endTime: string;
  /** UTC instants of the shift window; `endsAt` is on the next day for overnight shifts. */
  startsAt: Date;
  endsAt: Date;
  /** OVERRIDE = a shifts row for that day; DEFAULT = the staff record's shift_start / shift_end. */
  source: 'OVERRIDE' | 'DEFAULT';
}

function nextDay(date: string): string {
  const d = new Date(`${date}T00:00:00Z`);
  d.setUTCDate(d.getUTCDate() + 1);
  return d.toISOString().slice(0, 10);
}

/** The shift that applies to a person on an IST date. */
export function effectiveShift(
  date: string,
  defaults: { shiftStart: string; shiftEnd: string },
  override: { shiftType: ShiftType; startTime: string; endTime: string } | null,
): EffectiveShift {
  const startTime = override?.startTime ?? defaults.shiftStart;
  const endTime = override?.endTime ?? defaults.shiftEnd;
  const overnight = endTime <= startTime;
  return {
    date,
    shiftType: override?.shiftType ?? null,
    startTime,
    endTime,
    startsAt: istWallClockToUtc(date, startTime),
    endsAt: istWallClockToUtc(overnight ? nextDay(date) : date, endTime),
    source: override ? 'OVERRIDE' : 'DEFAULT',
  };
}
