/**
 * The monthly muster roll (action plan Phase 4) as pure functions: one row per person, one
 * column per day, a one-letter code per cell, and totals. No database, clock or network.
 */
import { addDays } from '../../shared/clock/ist';
import type { AttendanceStatus } from './attendance-types';

/** Codes printed in the grid (legend on every export). */
export const MUSTER_CODES = {
  PRESENT: 'P',
  LATE: 'L',
  HALF_DAY: 'H',
  ABSENT: 'A',
  ON_LEAVE: 'LV',
  HOLIDAY_OFF: 'HO',
  REGULARIZED: 'R',
} as const satisfies Record<AttendanceStatus, string>;

export const MUSTER_LEGEND: { code: string; en: string; mr: string }[] = [
  { code: 'P', en: 'Present', mr: 'उपस्थित' },
  { code: 'L', en: 'Late', mr: 'उशिरा' },
  { code: 'H', en: 'Half day', mr: 'अर्धा दिवस' },
  { code: 'A', en: 'Absent', mr: 'अनुपस्थित' },
  { code: 'LV', en: 'On leave', mr: 'रजा' },
  { code: 'HO', en: 'Holiday / weekly off', mr: 'सुट्टी' },
  { code: 'R', en: 'Corrected (regularized)', mr: 'दुरुस्त' },
  { code: '-', en: 'Not rostered', mr: 'नेमणूक नाही' },
];

/** Every IST date of a month (YYYY-MM), or null for a malformed month. */
export function monthDays(month: string): string[] | null {
  const m = /^(\d{4})-(0[1-9]|1[0-2])$/.exec(month);
  if (!m) return null;
  const first = `${month}-01`;
  const days: string[] = [];
  for (let d = first; d.startsWith(month); d = addDays(d, 1)) days.push(d);
  return days;
}

export interface MusterPerson {
  staffId: string;
  employeeCode: string;
  name: string;
  role: string;
}

export interface MusterLog {
  staffId: string;
  date: string;
  status: AttendanceStatus;
}

export interface MusterRow extends MusterPerson {
  cells: string[];
  /** Days worked: P + L + R count 1, H counts a half. */
  presentDays: number;
  absentDays: number;
  leaveDays: number;
  lateDays: number;
}

/** The grid: people sorted by employee code, a code per day ('-' without a row that day). */
export function buildMuster(
  days: readonly string[],
  people: readonly MusterPerson[],
  logs: readonly MusterLog[],
): MusterRow[] {
  const byKey = new Map(logs.map((l) => [`${l.staffId}|${l.date}`, l.status]));
  return [...people]
    .sort((a, b) => a.employeeCode.localeCompare(b.employeeCode))
    .map((p) => {
      const statuses = days.map((d) => byKey.get(`${p.staffId}|${d}`));
      const count = (...wanted: AttendanceStatus[]) =>
        statuses.filter((s) => s && wanted.includes(s)).length;
      return {
        ...p,
        cells: statuses.map((s) => (s ? MUSTER_CODES[s] : '-')),
        presentDays: count('PRESENT', 'LATE', 'REGULARIZED') + count('HALF_DAY') / 2,
        absentDays: count('ABSENT'),
        leaveDays: count('ON_LEAVE'),
        lateDays: count('LATE'),
      };
    });
}

/** CSV text: header, one line per person, then the legend. Cells quoted only when needed. */
export function musterCsv(
  title: string,
  days: readonly string[],
  rows: readonly MusterRow[],
): string {
  const cell = (v: string | number) => {
    const s = String(v);
    return /[",\n\r]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  const header = [
    'Code',
    'Name',
    'Role',
    ...days.map((d) => d.slice(8)),
    'Present',
    'Absent',
    'Leave',
    'Late',
  ];
  const lines = [
    [title],
    header,
    ...rows.map((r) => [
      r.employeeCode,
      r.name,
      r.role,
      ...r.cells,
      r.presentDays,
      r.absentDays,
      r.leaveDays,
      r.lateDays,
    ]),
    [],
    ['Legend', ...MUSTER_LEGEND.map((l) => `${l.code} = ${l.en}`)],
  ];
  return lines.map((l) => l.map(cell).join(',')).join('\r\n');
}
