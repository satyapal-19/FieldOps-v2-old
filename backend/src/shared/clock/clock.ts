/**
 * The only source of "now" in the backend. Inject `Clock`; never call `new Date()`
 * in services or policies. Tests use `FixedClock` to freeze or move time.
 */
export abstract class Clock {
  abstract now(): Date;
}

export class SystemClock extends Clock {
  now(): Date {
    return new Date();
  }
}

export class FixedClock extends Clock {
  private current: number;

  constructor(start: Date | string) {
    super();
    this.current = new Date(start).getTime();
  }

  now(): Date {
    return new Date(this.current);
  }

  set(to: Date | string): void {
    this.current = new Date(to).getTime();
  }

  advanceMinutes(minutes: number): void {
    this.current += minutes * 60_000;
  }
}
