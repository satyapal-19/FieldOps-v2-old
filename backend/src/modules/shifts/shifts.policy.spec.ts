import type { ShiftType } from './shift-types';
import { checkShiftTimes, effectiveShift, ShiftRuleError } from './shifts.policy';

describe('shifts.policy', () => {
  it.each<[ShiftType, string, string, boolean]>([
    ['MORNING', '06:00', '14:00', true],
    ['EVENING', '14:00', '22:00', true],
    ['NIGHT', '22:00', '06:00', true],
    ['NIGHT', '20:00', '23:30', true],
    ['MORNING', '22:00', '06:00', false],
    ['GENERAL_OFFICE', '10:00', '10:00', false],
    ['MORNING', '6:00', '14:00', false],
    ['MORNING', '06:00', '24:00', false],
  ])('%s %s-%s valid -> %s', (type, start, end, ok) => {
    const check = () => checkShiftTimes(type, start, end);
    if (ok) expect(check).not.toThrow();
    else expect(check).toThrow(ShiftRuleError);
  });

  describe('effectiveShift', () => {
    const defaults = { shiftStart: '06:00', shiftEnd: '14:00' };

    it('falls back to the staff defaults when there is no override', () => {
      const s = effectiveShift('2026-11-02', defaults, null);
      expect(s).toMatchObject({
        source: 'DEFAULT',
        shiftType: null,
        startTime: '06:00',
        endTime: '14:00',
      });
      expect(s.startsAt.toISOString()).toBe('2026-11-02T00:30:00.000Z');
      expect(s.endsAt.toISOString()).toBe('2026-11-02T08:30:00.000Z');
    });

    it('uses the override, ending a night shift on the next day (and across a month end)', () => {
      const s = effectiveShift('2026-11-30', defaults, {
        shiftType: 'NIGHT',
        startTime: '22:00',
        endTime: '06:00',
      });
      expect(s).toMatchObject({ source: 'OVERRIDE', shiftType: 'NIGHT' });
      expect(s.startsAt.toISOString()).toBe('2026-11-30T16:30:00.000Z');
      expect(s.endsAt.toISOString()).toBe('2026-12-01T00:30:00.000Z');
    });
  });
});
