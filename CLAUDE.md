# FieldOps SMKMC — guide for Claude Code

Geo-tagged photo attendance and field presence system for **Sangli Miraj Kupwad Municipal
Corporation (SMKMC)**, SMKC Civic Innovation Forum 2026, Problem #03, **Round 2 final submission**.
Target: enterprise-grade, **4,000 field staff** on the mobile app, a few hundred supervisors on web.

Read `docs/PROJECT_CONTEXT.md` for decisions, status, assumptions and risks before planning work.
The SMKC rules are in `docs/SMKC_SCIF26_Technology_Stack.pdf`; the master plan is
`docs/FieldOps_Revamp_Action_Plan_SMKC_TechStack_Alignment_v1_2026-10-27.docx`.

## Architecture (mandatory, from SMKC)

```
Flutter app / Next.js web  →  REST API (JSON, /api/v1)  →  NestJS services + pure policies
                           →  repositories (TypeORM)    →  SQL database
```

- **Clients never touch the database.** No Supabase, no direct SQL, no Next.js server code reading the DB.
- **The backend is the only authority**: server time, geofence, hierarchy, face match, liveness.
- **The database only stores**: tables, keys, constraints, indexes, transactions. No triggers,
  stored procedures, RLS, PostGIS, pgvector, pg_cron, JSONB, arrays, `TIMESTAMPTZ`.
- **Portable to Oracle 12c (12.1)**: identifiers ≤ 30 chars, no BOOLEAN/JSON types, UUIDs as
  `VARCHAR(36)` generated in Node, all times stored in UTC (IST only for shift dates and display).
- **Self-hosted, free**: nothing personal (selfies, embeddings, GPS) goes to a public cloud/AI. Maps = OpenStreetMap.
- **Not building**: microservices, Redis/Kafka, GraphQL, Kubernetes, a separate Python service.

## Repo map

| Path | What | State |
| --- | --- | --- |
| `backend/` | NestJS 10 modular monolith (TypeScript) — see `backend/CLAUDE.md` | Active |
| `web/fieldops-next/` | Next.js 15 App Router dashboard + citizen portal — see its `CLAUDE.md` | Scaffold only |
| `web/fieldops-web/` | **Legacy** React + Vite + Supabase app | Reference only; deleted when Phase 3 ends |
| `mobile/fieldops_mobile/` | Flutter + GetX field-staff app, still on Supabase — see its `CLAUDE.md` | Migrates in Phase 3 |
| `database/` | Postgres init scripts; exported DDL + ER diagram later (Phase 5) | |
| `data/` | **Legacy** Supabase `schema.sql` / `seed.sql` — never run against the new backend | Reference only |
| `scripts/` | G0 check, local Postgres setup, API client generation, `ci/` workflow | |
| `docs/` | Plans, reviews, SMKC stack PDF (Word files are the source of truth for plans) | |

## Commands (Windows dev machine, PowerShell or cmd)

```bash
docker compose up -d postgres            # or scripts\setup-local-postgres.bat for native Postgres 16
cd backend
npm install
npm run lint
npm test                                 # unit tests (jest, src/**/*.spec.ts)
npm run db:migrate:test && npm run test:e2e
npm run db:migrate:dev && npm run start:dev   # http://localhost:3000/api/v1, Swagger /api/docs
scripts\g0-check.bat                     # full gate: install, lint, tests, migrations, start dev/test/prod
npm run api:sync                         # (repo root) export openapi.json and regenerate web + Dart clients
```

Before saying backend work is done: `npm run lint`, `npm test` and (if schema or endpoints changed)
`npm run test:e2e` must pass.

## Conventions that apply everywhere

- Every backend feature module: **controller → service (one transaction) → pure policy → repository**.
  `backend/src/modules/wards` is the reference module; copy its layout.
- Policies are pure functions (no DB, clock, network) with table-driven tests.
- Errors: throw `AppError(ErrorCode.X)`; they leave as `application/problem+json` with `requestId`.
- Every offline-capable write carries a client UUID with a unique constraint (retry-safe).
- Roles: `ADMIN → WARD_INSPECTOR → INSPECTOR → WORKER`, plus `OFFICE_STAFF` (reports to ADMIN) and `CITIZEN`.
- API clients are **generated** from `openapi/openapi.json`; never hand-edit `src/api/generated/`.
- Config only from environment files / `--dart-define`; **no keys or passwords in source.**
- Never commit `.env*` files except `*.example` / `env-templates/*.example`.
- Test login (no OTP) exists only in development/test; production refuses to start with it.

## Working with this team

- Owner: the user and Claude own every track together (decision D6). The team **cannot contact SMKC**
  before submission: resolve unknowns with a documented assumption (add it to the working
  assumptions in `docs/PROJECT_CONTEXT.md` and the action plan), never by waiting.
- Project documents (plans, reviews, guides) live in `docs/` as Word files with long descriptive names.
  **Update the existing document in place under the same file name** — do not create `_v2` copies.
  Only produce a new Word file when the user asks for one.
- Keep the action plan's phase checkboxes in sync when a task completes.
- Line endings: the team works on Windows; keep `.bat`/`.ps1` as CRLF (see `.gitattributes`).
- Git remote: `origin` = https://github.com/smkc-fieldops/FieldOps-v2 (branch `main`).
  Use conventional commits (`feat(auth): …`, `fix(face): …`, `docs: …`).
