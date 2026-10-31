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
database readiness.

## API types

The typed client in `src/api/client.ts` uses types generated from the backend's OpenAPI contract:

```bash
# after the backend exports ../../openapi/openapi.json
npm run api:types
```

Never edit `src/api/generated/` by hand. CI regenerates it and fails if it is out of date.

## Layout

- `app/` routes and layouts (citizen pages server-rendered; staff dashboards client components)
- `src/api/` the generated client wrapper (request ID, typed problem+json errors)
- `src/features/<feature>/` components and hooks per feature
- `src/shared/` shared UI (error banner, maps)

The current Vite app in `../fieldops-web` stays until every page is ported (Phase 3).
