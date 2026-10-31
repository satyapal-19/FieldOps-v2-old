import { DefaultNamingStrategy, NamingStrategyInterface } from 'typeorm';

/** Oracle 12c (before 12.2) limits identifiers to 30 characters. */
export const MAX_IDENTIFIER_LENGTH = 30;

export function toSnakeCase(name: string): string {
  return name
    .replace(/([a-z0-9])([A-Z])/g, '$1_$2')
    .replace(/([A-Z])([A-Z][a-z])/g, '$1_$2')
    .toLowerCase();
}

export function assertIdentifierLength(identifier: string): string {
  if (identifier.length > MAX_IDENTIFIER_LENGTH) {
    throw new Error(
      `Identifier "${identifier}" is ${identifier.length} characters; Oracle 12c allows ${MAX_IDENTIFIER_LENGTH}. Use a shorter name.`,
    );
  }
  return identifier;
}

/**
 * snake_case tables and columns, and a hard failure for any name Oracle 12c would reject.
 * Generated constraint names (PK_/FK_/UQ_/IDX_ + hash) are already 30 characters or fewer.
 */
export class OracleSafeNamingStrategy extends DefaultNamingStrategy implements NamingStrategyInterface {
  override tableName(className: string, customName?: string): string {
    return assertIdentifierLength(customName ?? toSnakeCase(className));
  }

  override columnName(propertyName: string, customName: string | undefined, prefixes: string[]): string {
    const base = customName ?? toSnakeCase(propertyName);
    const prefix = prefixes.length > 0 ? `${toSnakeCase(prefixes.join('_'))}_` : '';
    return assertIdentifierLength(prefix + base);
  }

  override relationName(propertyName: string): string {
    return toSnakeCase(propertyName);
  }

  override joinColumnName(relationName: string, referencedColumnName: string): string {
    return assertIdentifierLength(`${toSnakeCase(relationName)}_${referencedColumnName}`);
  }
}
