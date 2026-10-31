# web/fieldops-next/ — Next.js web (read with the root CLAUDE.md)

Next.js 15 (App Router) + React 19 + Tailwind 3 + TanStack Query 5, typed client via
`openapi-fetch` over types generated from `../../openapi/openapi.json`. Runs on port 3001.

**State:** scaffold only (home page shows API health). Every page of the legacy app in
`../fieldops-web/src/pages/` is ported here in Phase 3, one page at a time, then the Vite app is deleted.
Payroll and QR-checkpoint pages are **not** ported (removed from scope).

## Rules

- Frontend only: no route handler, server action or server component touches a database.
  All data comes from the NestJS API through `src/api/client.ts`.
- Never edit `src/api/generated/`; run `npm run api:types` after the backend exports OpenAPI.
- Server data in client components goes through TanStack Query; no `useEffect` fetching.
  Socket.IO events (later) only invalidate queries.
- One route table with allowed roles, read by middleware, layouts and the menu. Tokens in httpOnly
  cookies. Hiding a menu item is cosmetic — the API enforces access.
- Citizen pages are server-rendered over read-only public endpoints; staff dashboards are client components.
- Maps: OpenStreetMap + Leaflet only.
- Show the error `code` mapped to Marathi/English text and the `requestId` on error screens.

## Folders

`app/` routes and layouts · `src/api/` client wrapper · `src/features/<feature>/` components and
hooks · `src/shared/` shared UI (error banner, map).

## Commands

```bash
npm install
npm run dev          # http://localhost:3001 (start the backend first)
npm run lint && npm run typecheck && npm run build
```
