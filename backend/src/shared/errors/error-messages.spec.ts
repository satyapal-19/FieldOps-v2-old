import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { ErrorCode } from './error-codes';

/** The clients' message table (openapi/error-messages.json) must cover every code in both languages. */
describe('error message table', () => {
  const file = join(__dirname, '..', '..', '..', '..', 'openapi', 'error-messages.json');
  const table = JSON.parse(readFileSync(file, 'utf-8')) as {
    messages: Record<string, { en?: string; mr?: string }>;
  };

  it.each(Object.values(ErrorCode))('%s has English and Marathi text', (code) => {
    expect(table.messages[code]?.en?.trim()).toBeTruthy();
    expect(table.messages[code]?.mr?.trim()).toBeTruthy();
  });

  it('has no codes the API does not return', () => {
    const known = new Set<string>(Object.values(ErrorCode));
    expect(Object.keys(table.messages).filter((c) => !known.has(c))).toEqual([]);
  });
});
