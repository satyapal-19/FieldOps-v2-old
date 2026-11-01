# backend/ — NestJS API (read with the root CLAUDE.md)

NestJS 10 + TypeORM 0.3, Node 18.18+ (SMKC server may be Windows Server 2012; risk R1).
PostgreSQL 16 in dev/test, Oracle 12c in production (`oracledb` driver already installed).
Full setup: `backend/README.md`.

## Layout

```
src/main.ts           bootstrap; loads .env.<NODE_ENV> first
src/app.setup.ts      one pipeline shared by server, e2e tests and OpenAPI export
src/shared/           config (Joi-validated, fails fast), clock (UTC + IST helpers), ids,
                      errors (AppError, ErrorCode, problem+json), logging (pino + request id),
                      database (column helpers, Oracle-safe naming, unit of work), audit, auth
src/health/           /health and /ready
src/modules/<name>/   controller → service → policy (pure) → repository, plus dto/ and entities/
src/database/         entities.ts and migrations/index.ts registries + migrations
test/                 e2e tests (supertest) against the fieldops_test database
```

## Modules built so far

| Module | Endpoints (`/api/v1/...`) | Notes |
| --- | --- | --- |
| wards | `GET/POST/PATCH wards`, `POST wards/:id/location-check` | **Reference module** — copy it |
| offices | `GET/POST/PATCH offices`, `POST offices/:id/location-check` | 100 m office geofence |
| staff | (service + repository, no controller yet) | profile mapper, policy |
| auth | `otp/request`, `otp/verify`, `login`, `test-login`, `refresh`, `logout`, `me`, `change-password`, `staff/:id/revoke-sessions` | OTP for field roles, bcrypt passwords for ADMIN / WARD_INSPECTOR / OFFICE_STAFF, rotating refresh sessions, rate limits |
| face | `GET face/capture-options` | `FaceVerifier` with `local` (AuraFace via ONNX — engine is a placeholder until Phase 2) and `aadhaar` (UIDAI FaceRD, plug-in ready) providers; see `modules/face/README.md` |
| shared/audit | — | `audit_log` written in the same transaction |
| rosters, shifts | (entities only; CRUD next) | `standing_rosters`, `daily_assignments` (one row per person per IST date), `shifts` (per-day override of staff shift times) |

Migrations: wards → offices + staff → auth + audit → rosters + shifts. Gate G0 passed on 31 Oct 2026
(16 unit suites / 154 tests, 2 e2e suites / 27 tests); now 3 e2e suites / 43 tests.

## Rules for new code

- New table = new migration in `src/database/migrations/` registered in `index.ts`, plus the entity
  in `src/database/entities.ts`. Never edit a migration that has already run; add a new one.
- Use `shared/database/column-types.ts` helpers. Names ≤ 30 chars (the naming strategy throws).
  Booleans are 0/1, UUIDs `VARCHAR(36)` from `shared/ids`, timestamps UTC.
- Time comes from the injected `Clock`, never `new Date()` in services or policies.
- Services own the transaction (`unit-of-work.ts`); only repositories run queries (query builder or
  repository API, never string-built SQL).
- Controllers declare roles (`shared/auth/decorators.ts`), DTOs with class-validator, and Swagger
  decorators. Scope checks (own ward / own team / self) belong in the policy, tested.
- Add every new error to `shared/errors/error-codes.ts`; clients map codes to Marathi/English text.
- New env var → `shared/config/env.validation.ts` (+ spec) and all three `env-templates/*.example`.
- Tests: policy specs are table-driven; e2e for every endpoint's happy path and 401/403 cases.

## Commands

```bash
npm run lint && npm test
npm run db:migrate:test && npm run test:e2e
npm run start:dev                 # Swagger at http://localhost:3000/api/docs
npm run openapi:export            # writes ../openapi/openapi.json
```

Never read or print `.env.development`, `.env.test` or `.env.production`; use the templates in
`env-templates/` to learn variable names.
