# FieldOps web (Next.js)

Next.js (App Router) dashboard and citizen portal. **Frontend only**: every read and write
goes through the NestJS API in `backend/`; no Next.js route or server code touches the database.

## Run locally

```bash
cp .env.example .env.local      # Windows: copy .env.example .env.local
npm install
npm run dev                      # http://localhost:3001
```

Start the backend first (see `backend/README.md`); the home page shows the API health and
database readiness. Staff sign in at `/login` with their employee code and web password
(ADMIN, WARD_INSPECTOR, OFFICE_STAFF). In development, set `SEED_WEB_PASSWORD` in
`backend/.env.development` before `npm run db:seed:dev` to give the sample web users a password.

## Session

The browser never holds a token. `/session/login` signs in through the API and keeps the tokens
in httpOnly cookies; pages call the same-origin `/api/v1/*` pass-through (`app/api/v1/[...path]`),
which adds the bearer token and refreshes it. `API_INTERNAL_URL` tells the Next.js server where the
API is. Behind IIS, set the API's `TRUST_PROXY` to count both IIS and Next.js so rate limits see
the real client address.

## API types

The typed client in `src/api/client.ts` uses types generated from the backend's OpenAPI contract:

```bash
# repo root: export ../../openapi/openapi.json and regenerate the web and Dart clients
npm run api:sync
```

Never edit `src/api/generated/` by hand. CI regenerates it and fails if it is out of date. The
error text for every API code (Marathi / English) is copied from `openapi/error-messages.json`.

## Layout

- `app/` routes and layouts (citizen pages server-rendered; staff dashboards client components)
- `src/api/` the generated client wrapper (`api`, `unwrap`, request ID, typed problem+json errors)
- `src/server/` server-only session layer (cookies, API pass-through, refresh)
- `src/shared/auth/route-table.ts` the one role table read by middleware, layouts and the menu
- `src/features/<feature>/` components and hooks per feature
- `src/shared/` shared UI (error banner, maps)

Every page of the legacy Vite app is ported (payroll and QR checkpoints are out of scope; chat
returns with its backend in Phase 4), so that app has been removed.
