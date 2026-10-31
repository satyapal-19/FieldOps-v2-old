# FieldOps backend (NestJS)

REST API for FieldOps SMKMC: one NestJS modular monolith, PostgreSQL in development,
Oracle 12c-compatible schema for production. Apps never touch the database; everything
goes through `/api/v1`.

## Prerequisites (Windows or Linux)

- Node.js 20 LTS (18.18+ also works; see risk R1 about the SMKC server)
- Docker Desktop (for the local PostgreSQL), or a local PostgreSQL 16
- Java 17 only if you generate the Dart client

## First run

```bash
# 1. Local database (from the repo root), either:
copy .env.example .env                 # macOS/Linux: cp .env.example .env
docker compose up -d postgres          # a) Docker
#    or b) native PostgreSQL 16+: double-click scripts\setup-local-postgres.bat once

# 2. Backend settings (in backend/)
cd backend
copy env-templates\development.example .env.development   # macOS/Linux: cp
copy env-templates\test.example .env.test
#    use the same DB_USERNAME / DB_PASSWORD as the root .env

# 3. Install, migrate, run
npm install
npm run db:migrate:dev
npm run start:dev
```

- API: http://localhost:3000/api/v1
- Swagger UI: http://localhost:3000/api/docs
- Health: http://localhost:3000/api/v1/health · Ready: http://localhost:3000/api/v1/ready

Commit the generated `package-lock.json` after the first `npm install`.

## Tests

```bash
npm test                 # unit tests (policies, services, config, errors)
npm run db:migrate:test  # once, or after new migrations
npm run test:e2e         # API tests against the fieldops_test database
npm run lint
```

## Gate G0 check: the API starts in dev, test and prod

One command runs every check and writes `g0-check.log` at the repo root: double-click
`scripts\g0-check.bat` (or `powershell -ExecutionPolicy Bypass -File scripts\g0-check.ps1`).
Manual equivalent:

```bash
npm run build
npm run start:dev                 # development: Swagger on, pretty logs
npm run start:test                # test: port 3100
# production: real secrets, CORS origins, AUTH_TEST_LOGIN_ENABLED=false
copy env-templates\production.example .env.production   # fill in values (never commit)
npm run start:prod
curl http://localhost:3000/api/v1/health
```

Production refuses to start with a missing secret, empty `CORS_ORIGINS` or
`AUTH_TEST_LOGIN_ENABLED=true`, and prints every problem at once.

## Structure

```text
src/
  main.ts            bootstrap (loads .env.<NODE_ENV> first)
  app.setup.ts       one pipeline for server, tests and OpenAPI export
  shared/            config, clock, ids, errors, logging, database helpers
  health/            /health and /ready
  modules/<feature>/ controller -> service -> policy (pure) -> repository
  database/          entity and migration registries + migrations
  openapi/           OpenAPI export script
test/                e2e tests
```

`modules/wards` is the **reference module**: copy its layout for every new feature.
Rules go in `*.policy.ts` as pure functions with table-driven tests; only repositories run SQL.

## Database rules (Oracle 12c portability)

- Schema changes only through migrations in `src/database/migrations/` (registered in `index.ts`).
- Use the helpers in `shared/database/column-types.ts`: no JSONB, arrays, PostGIS, triggers,
  stored procedures or `TIMESTAMPTZ`; booleans are 0/1; UUIDs are `VARCHAR(36)` generated in Node.
- Table and column names are 30 characters or fewer (the naming strategy enforces this).
- All times are UTC (the process runs with `TZ=UTC`); IST is applied only for dates and display.
- Check portability: `docker compose --profile oracle up -d oracle`, then run the migrations with
  `DB_TYPE=oracle` settings.

## Errors and logs

- Services throw `AppError(ErrorCode.X, ...)`. Every error leaves the API as
  `application/problem+json` with `code`, `title`, `status` and `requestId`.
- Clients send `X-Request-Id`; the same ID appears in every log line and error body.

## OpenAPI and generated clients

```bash
npm run openapi:export        # writes ../openapi/openapi.json (database must be reachable)
cd .. && npm run api:clients  # regenerates the web (TypeScript) and mobile (Dart) clients
```
