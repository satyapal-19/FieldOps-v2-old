#!/usr/bin/env node
/**
 * Generates the typed API clients from openapi/openapi.json:
 *   - web:    web/fieldops-next/src/api/generated/schema.d.ts   (openapi-typescript)
 *   - mobile: mobile/fieldops_mobile/packages/fieldops_api        (OpenAPI Generator, dart-dio)
 *
 * Cross-platform (Windows / Linux). The Dart generator needs Java 11+ on PATH.
 * Usage: npm run api:clients            (both)
 *        npm run api:clients -- --web   (web only)
 *        npm run api:clients -- --dart  (mobile only)
 */
import { execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = join(dirname(fileURLToPath(import.meta.url)), '..');
const spec = join(root, 'openapi', 'openapi.json');
const args = new Set(process.argv.slice(2));
const doWeb = args.size === 0 || args.has('--web');
const doDart = args.size === 0 || args.has('--dart');

function run(command, cwd) {
  console.log(`\n> ${command}`);
  execSync(command, { cwd, stdio: 'inherit', shell: true });
}

if (!existsSync(spec)) {
  console.error(`Missing ${spec}. Run "npm run api:export" first (needs the backend database running).`);
  process.exit(1);
}

if (doWeb) {
  run('npm run api:types', join(root, 'web', 'fieldops-next'));
}

if (doDart) {
  const out = join('mobile', 'fieldops_mobile', 'packages', 'fieldops_api');
  run(
    [
      'npx openapi-generator-cli generate',
      `-i "${join('openapi', 'openapi.json')}"`,
      '-g dart-dio',
      `-o "${out}"`,
      '--additional-properties=pubName=fieldops_api,pubDescription="FieldOps SMKMC API client (generated)"',
      '--global-property=skipFormModel=true',
    ].join(' '),
    root,
  );
  console.log('\nDart client generated. In the package folder run:');
  console.log('  dart pub get && dart run build_runner build --delete-conflicting-outputs');
}

console.log('\nAPI clients are up to date.');
