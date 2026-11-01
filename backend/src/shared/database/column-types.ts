import type { ColumnOptions, ColumnType, ValueTransformer } from 'typeorm';

/**
 * Portable column types. Entities and migrations use these helpers so the same code
 * creates matching columns on PostgreSQL (development) and Oracle 12c (production).
 *
 * The database type is read from DB_TYPE, which load-env sets before entities load.
 */
export function isOracle(dbType: string | undefined = process.env.DB_TYPE): boolean {
  return (dbType ?? 'postgres') === 'oracle';
}

/** Short ASCII text: codes, statuses, UUIDs. */
export function varcharType(dbType?: string): ColumnType {
  return isOracle(dbType) ? 'varchar2' : 'varchar';
}

/** Short text that may contain Marathi (Devanagari). */
export function unicodeVarcharType(dbType?: string): ColumnType {
  return isOracle(dbType) ? 'nvarchar2' : 'varchar';
}

/** Long text such as GeoJSON boundaries. */
export function longTextType(dbType?: string): ColumnType {
  return isOracle(dbType) ? 'clob' : 'text';
}

/** UTC timestamps (the process runs with TZ=UTC; see load-env). */
export function timestampType(): ColumnType {
  return 'timestamp';
}

/**
 * Calendar date without time (shift dates, as the IST date). Hydrated as 'YYYY-MM-DD'
 * on both databases; Oracle DATE carries a time part, which is always midnight here.
 */
export function dateType(): ColumnType {
  return 'date';
}

/** Integer column options (Oracle has no INTEGER type in TypeORM; NUMBER(10) is used). */
export function intColumn(dbType?: string): Pick<ColumnOptions, 'type' | 'precision'> {
  return isOracle(dbType) ? { type: 'number', precision: 10 } : { type: 'integer' };
}

/** Column type strings for migrations (TypeORM Table API), per database. */
export interface MigrationColumnTypes {
  varchar: string;
  unicodeVarchar: string;
  longText: string;
  timestamp: string;
  date: string;
  int: { type: string; precision?: number };
  bool: { type: string; precision?: number };
}

export function migrationColumnTypes(dbType: string): MigrationColumnTypes {
  const oracle = isOracle(dbType);
  return {
    varchar: oracle ? 'varchar2' : 'varchar',
    unicodeVarchar: oracle ? 'nvarchar2' : 'varchar',
    longText: oracle ? 'clob' : 'text',
    timestamp: 'timestamp',
    date: 'date',
    int: oracle ? { type: 'number', precision: 10 } : { type: 'integer' },
    bool: oracle ? { type: 'number', precision: 1 } : { type: 'smallint' },
  };
}

const booleanTransformer: ValueTransformer = {
  to: (value: boolean | null | undefined) =>
    value === null || value === undefined ? value : value ? 1 : 0,
  from: (value: number | string | null) => (value === null ? null : Number(value) === 1),
};

/**
 * Booleans stored as 0/1, because Oracle 12c has no BOOLEAN column type.
 * The transformer keeps entities typed as `boolean`.
 */
export function booleanColumn(
  dbType?: string,
): Pick<ColumnOptions, 'type' | 'precision' | 'transformer'> {
  return isOracle(dbType)
    ? { type: 'number', precision: 1, transformer: booleanTransformer }
    : { type: 'smallint', transformer: booleanTransformer };
}
