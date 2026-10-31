# FieldOps SMKMC

### Geo-tagged Photo Attendance & Field Presence System

**SMKC Civic Innovation Forum 2026 — Problem #03 | Sangli Miraj Kupwad Municipal Corporation**

---

## Architecture (revamp in progress)

The project is moving to the SMKC Round 2 technology stack:
**Flutter and Next.js clients → NestJS REST API → repository layer → portable SQL
(PostgreSQL in development, Oracle 12c in production).** The apps never access the database directly.

See `docs/` for the revamp action plan and architecture guidelines, and `docs/PROJECT_CONTEXT.md`
for a one-page summary of decisions and status. AI coding assistants read `CLAUDE.md`.

## Project structure

```
FieldOps/
├── backend/                  # NestJS REST API (new) - see backend/README.md
├── web/fieldops-next/        # Next.js dashboard + citizen portal (new)
├── web/fieldops-web/         # Legacy React + Vite app (Supabase) - replaced in Phase 3
├── mobile/fieldops_mobile/   # Flutter app (field staff) - moves to the API in Phase 3
├── database/                 # Local DB init scripts; exported DDL + ER diagram (Phase 5)
├── openapi/                  # OpenAPI contract exported from the backend
├── data/                     # Legacy Supabase schema/seed (reference only)
├── scripts/                  # Client generation; ci/ holds the GitHub Actions workflow
└── docs/                     # Plans, reviews, SMKC technology stack
```

## Quick start (new stack)

```bash
copy .env.example .env               # local DB credentials (git-ignored)
docker compose up -d postgres        # PostgreSQL 16 with fieldops_dev + fieldops_test

cd backend                           # API on :3000, Swagger at /api/docs
copy env-templates\development.example .env.development
npm install && npm run db:migrate:dev && npm run start:dev

cd ../web/fieldops-next              # Next.js on :3001
copy .env.example .env.local
npm install && npm run dev
```

## Tech stack

| Layer          | Technology                                                    |
| -------------- | ------------------------------------------------------------- |
| Mobile         | Flutter + GetX + flutter_map                                  |
| Web            | Next.js (App Router) + Tailwind + TanStack Query              |
| Backend        | Node.js + NestJS (modular monolith), REST + OpenAPI           |
| Data access    | TypeORM repositories + portable migrations                   |
| Database       | PostgreSQL 16 (dev) · Oracle 12c (production)                 |
| Maps           | OpenStreetMap · flutter_map (mobile) · Leaflet (web)          |
| Auth           | Backend JWT + RBAC + CORS; OTP for field staff                |

## Revamp progress

| Phase | Status | Scope |
| --- | --- | --- |
| 0 — Foundations | Done (Gate G0 passed 31 Oct 2026) | Backend scaffold, shared kit, wards reference module, Next.js scaffold, Docker, CI |
| 1 — Backend core | In progress | Portable schema, auth, RBAC, CRUD, audit, Swagger |
| 2 — Attendance engine | | Geofence, liveness, face match, punch, pings, jobs |
| 3 — Client migration | | Web to Next.js, both apps to the API, Supabase removed |
| 4 — Extended features | | Spot checks, co-presence, chat, voice, WhatsApp, offline tiles |
| 5 — Hardening & handover | | Security, 4,000-user load test, Oracle test, deliverables |
