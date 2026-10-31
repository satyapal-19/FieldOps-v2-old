import { OracleSafeNamingStrategy, assertIdentifierLength, toSnakeCase } from './oracle-safe-naming.strategy';

describe('OracleSafeNamingStrategy', () => {
  const strategy = new OracleSafeNamingStrategy();

  it.each([
    ['Ward', 'ward'],
    ['DailyShiftAssignment', 'daily_shift_assignment'],
    ['nameMr', 'name_mr'],
    ['HTTPRequestLog', 'http_request_log'],
  ])('snake-cases %s as %s', (input, expected) => {
    expect(toSnakeCase(input)).toBe(expected);
  });

  it('prefers explicit names', () => {
    expect(strategy.tableName('Ward', 'wards')).toBe('wards');
    expect(strategy.columnName('nameMr', 'name_mr', [])).toBe('name_mr');
  });

  it('rejects identifiers longer than 30 characters', () => {
    expect(() => assertIdentifierLength('a'.repeat(30))).not.toThrow();
    expect(() => strategy.columnName('thisColumnNameIsWayTooLongForOracle', undefined, [])).toThrow(
      /Oracle 12c allows 30/,
    );
  });
});
