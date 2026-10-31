import { parseUtcTimestamp } from './data-source-options';

describe('parseUtcTimestamp', () => {
  it.each([
    ['2026-10-31 13:40:35.848', '2026-10-31T13:40:35.848Z'],
    ['2026-10-31 00:00:00', '2026-10-31T00:00:00.000Z'],
    ['2026-03-01 23:59:59.5', '2026-03-01T23:59:59.500Z'],
  ])('reads %s as UTC', (raw, iso) => {
    expect(parseUtcTimestamp(raw).toISOString()).toBe(iso);
  });

  it('keeps infinity values ordered', () => {
    expect(parseUtcTimestamp('infinity').getTime()).toBeGreaterThan(Date.now());
    expect(parseUtcTimestamp('-infinity').getTime()).toBeLessThan(0);
  });
});
