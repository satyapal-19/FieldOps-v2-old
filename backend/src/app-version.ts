import { readFileSync } from 'node:fs';
import { join } from 'node:path';

function readVersion(): string {
  try {
    // src/ and dist/ both sit next to package.json.
    const pkg = JSON.parse(readFileSync(join(__dirname, '..', 'package.json'), 'utf8')) as {
      version?: string;
    };
    return pkg.version ?? '0.0.0';
  } catch {
    return '0.0.0';
  }
}

export const APP_VERSION = readVersion();
