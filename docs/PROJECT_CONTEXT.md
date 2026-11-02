# FieldOps SMKMC — project context

Handoff from the planning work done in Claude Cowork (27–31 Oct 2026) to Claude Code.
The Word documents in this folder remain the source of truth; this file is the short version.
Update it when a decision, phase status or assumption changes.

## Goal

Final (Round 2) submission of FieldOps SMKMC for the SMKC Civic Innovation Forum 2026, fully
aligned with `SMKC_SCIF26_Technology_Stack.pdf` while keeping every feature of the team's v4
implementation plan. Enterprise-grade, built for 4,000 mobile users. SMKC wants the complete
project and all 19 deliverables, not just a demo.

## Decisions (confirmed 28 Oct, D4 on 31 Oct)

| # | Topic | Decision |
| --- | --- | --- |
| D1 | Web | Move to **Next.js (App Router)**, pure frontend over the API; citizen view server-rendered |
| D2 | Backend | **NestJS** modular monolith on Node.js |
| D3 | Field-staff login | **OTP only** for now; device binding after delivery. Test login without OTP in dev/test only; production refuses to start with it |
| D4 | Face recognition | Highest accuracy within SMKC rules: **AuraFace-v1** (ResNet100, Apache-2.0 weights) on the backend via ONNX Runtime, YuNet detection, MiniFASNet anti-spoofing; **OpenCV SFace** fallback. ML Kit liveness stays on the phone; face crops never stored. **Aadhaar face authentication** (UIDAI FaceRD) kept ready to plug in if SMKC asks (`FACE_PROVIDER=aadhaar`) |
| D5 | v4 extras | **All in scope**: WhatsApp/SMS adapters (off by default), offline OSM tile pack, BLE / rolling-QR co-presence, full-screen spot-check alerts |
| D6 | Ownership | The user and Claude own every track; one combined backlog; docs written alongside each phase |

Fixes to v4 kept from the review: punch must prove the face (challenge + server match, no fail-open);
real UTC timestamps; office check-in accepts ≤100 m accuracy (field staff 25 m); self-picked
assignments start unapproved; one ward per inspector per day; every endpoint role- and scope-checked;
AuraFace 512-D only; 90-day voice-note retention; geofence = point-in-polygon with 25 m edge allowance.
Daily assignments store one row per person placed (`staff_id` + `staff_role`), so `UNIQUE (shift_date, staff_id)`
enforces one ward per worker and per inspector per day on both Postgres and Oracle (v4's nullable
`worker_id` key would collide on Oracle). Shift dates are `DATE` (IST date); shift times IST `HH:MM` text.
Staff CRUD lives in its own `staff-admin` module (it needs AuthService; AuthModule already imports
StaffModule). Standing squads are materialized per day by `POST /assignments/generate` (a scheduled
job calls it in Phase 2). The seed has synthetic ward squares (see working assumptions).
Payroll and QR-checkpoint attendance are removed.
Punch rules (Phase 2): check-in opens 60 min before the shift and closes at its end; on time up to 15:00 after the start, late after, half day past the shift's midpoint or when leaving before half the shift is worked; the third late mark in an IST calendar month raises REPEATED_LATE. Check-in outside the geofence is refused; check-out records it but is allowed. A mock location is accepted, flagged suspicious and alerted (a warning, not security). The liveness challenge is spent even when the face fails. The face crop travels as base64 JSON within the 100 kB body limit (JPEG ≤ ~70 kB) and is never stored. Alerts are raised after the punch commits, so an alert failure never undoes a punch.

Job rules (Phase 2): every PM2 instance runs the scheduler; a guarded update on `job_locks` (free lock and a new slot key) lets exactly one run each slot, and every job is safe to repeat. `JOBS_ENABLED` turns them off (default off in tests, which call the jobs directly with a frozen clock). An unclosed shift is closed 60 min after its end: office staff at the scheduled end, field staff when their phone was last seen during the shift (never later than the end; at check-in, flagged suspicious, if no ping at all), audited as `ATTENDANCE_AUTO_CHECKOUT` by `SYSTEM`. A checked-in field phone with no ping for 30 min gets a SERVER `SILENT_GAP` tamper event and a TAMPER_DETECTED alert; it closes at the next ping (late offline uploads count) or the check-out. The nightly roll-up recomputes the two previous IST days (pings count towards their shift's date) and stores aggregates only, never coordinates, so the purge really ends the location history. Route distance ignores mocked fixes and fixes worse than 50 m.

Web session rules (Phase 3): the browser never holds a token. `/session/login` calls `POST /auth/login` and stores the access token, refresh token and role in httpOnly, SameSite=Lax cookies (Secure in production); every page calls the same-origin `/api/v1/*` pass-through, which adds the bearer token, refreshes it 60 s before expiry or on a 401, and shares one refresh between requests that arrive together (refresh tokens rotate and reuse revokes the session). Writes need the `X-Requested-With: fieldops-web` header and a same-host Origin (X-Forwarded-Host behind IIS). Middleware only steers navigation from the role cookie; the API checks every request. The pass-through forwards X-Forwarded-For, so `TRUST_PROXY` must count both IIS and Next.js in production.

## Phases and gates

| Phase | Scope | Status |
| --- | --- | --- |
| 0 Foundations | Backend scaffold, shared kit, wards reference module, Next.js scaffold, Docker, CI | **Done — Gate G0 passed 31 Oct 2026** on the dev PC |
| 1 Backend core | Portable schema, auth, RBAC, CRUD, audit, Swagger, seed | **In progress**: auth, offices, staff (no controller yet), audit, face interface + Aadhaar adapter done; **full portable schema done (1 Nov)**: rosters, assignments, shifts, attendance, pings, tamper events, spot checks, tasks + task updates, complaints, leave, regularization, holidays, alerts, chat — each with client UUIDs and version columns where needed. **Endpoints done (2 Nov)**: `/staff`, `/rosters/standing`, `/assignments` (+ `self`, `approve`, `generate`), `/shifts` (+ `effective`), `/holidays`, `/leave`, `/regularizations`, `/tasks` (+ `updates`, `review`, `reassign`, `history`), `/complaints` + public `/public/complaints`, `/alerts`; sample seed. Swagger lists 68 operations; every non-public one requires a bearer token. Remaining: per-device rate limits (with device binding, D3). Chat endpoints are Phase 4 |
| 2 Attendance engine | Policies, geo service, liveness challenge, face engine (benchmark first), punch, pings, jobs | **In progress (2 Nov)**: pure attendance + geo policies; `POST /attendance/challenges` (one-time, 2 min); `POST /attendance/punches` (check-in/out, self and proxy, server time, approved assignment, leave, accuracy, geofence, night-shift IST rollover, late / half-day marks, challenge + server face match, idempotent, audited); `GET /attendance`; `POST /attendance/pings` (batch ≤ 200, offline buffer, OUT_OF_ZONE) and `POST /attendance/tamper-events`; **scheduled jobs (2 Nov)** through `@nestjs/schedule` with a run-once `job_locks` row: auto-checkout (30 min), silent-gap detection (15 min), nightly roll-up into `route_summaries` + `ward_daily_summaries` (01:30 IST), retention purge (02:30 IST); `GET /staff/:id/route?date=`. **Gate G2 passes in e2e** with a fake face provider. Remaining: local face engine (needs pilot photos and the ONNX models) |
| 3 Client migration | Web pages to Next.js, both apps to the API, Supabase removed | **In progress (2 Nov)**: `openapi/openapi.json` committed with both generated clients (web types, Dart `fieldops_api` package); one Marathi / English error-message table `openapi/error-messages.json` for every API code (copied into both apps); web sign-in through a Next.js session layer (httpOnly cookies, `/api/v1/*` pass-through with token refresh), middleware + layouts + menu from one route table, staff shell, dashboard on live API data. Remaining: port the other web pages, live map, reports, citizen pages, the whole mobile migration |
| 4 Extended features | Spot checks, co-presence, chat, voice, notifications, offline tiles, muster roll | Not started |
| 5 Hardening & handover | Security checklist, Oracle XE run, k6 4,000-user test, Windows Server deploy rehearsal, 19 deliverables | Not started |

Gates: G1 Swagger lists core endpoints and role tests pass · G2 full check-in/out incl. proxy punch via API ·
G3 zero Supabase imports in web/ and mobile/ · G4 extras pass demo script · G5 deliverables done, load test passes, release tagged.
If time runs short, drop extras in this order: BLE co-presence, WhatsApp, offline tiles (risk R5).

## Scale targets (4,000 users)

Pings ≈ 7 req/s steady, ~190k rows/day (batch endpoint, p95 < 300 ms) · 06:00 check-in burst:
sustain 50 punches/s, p95 < 500 ms, zero duplicates · ~17M ping rows at 90 days → nightly roll-up
+ purge (no Oracle Partitioning) · face matching in memory, 1-to-N only within one ward team.

## Working assumptions (no contact with SMKC before submission)

| Unknown | Assumption |
| --- | --- |
| Server OS / Node | Windows Server 2012/R2; code runs on Node 18.18+ |
| Web server | IIS reverse proxy with HTTPS; API + Next.js as Windows services (PM2/NSSM) |
| Oracle | 12c Release 1 limits (30-char names, no BOOLEAN/JSON, no PL/SQL); tested on Oracle XE 21 |
| Capacity | 4 vCPU, 8–16 GB RAM |
| Internet from server | May be restricted; nothing core needs it; FCM best-effort + in-app polling |
| SMS / WhatsApp | None approved; adapters ship off, enabled by config |
| Map tiles | Own offline OSM tile pack served by our backend |
| Backups | Scripts + schedule in the administrator manual |
| TLS | Certificate supplied by SMKC; tested with self-signed |
| Citizen accounts | None: citizens file and track complaints on the public portal with a tracking ID (no sign-in, stricter per-IP rate limit, no personal data in responses) |
| Ping retention | Raw pings kept 90 days (`PING_RETENTION_DAYS`, 7–365), then purged nightly; daily route summaries (no coordinates) are kept. Used/expired liveness challenges kept 7 days |
| Forgotten check-out | Closed automatically 60 min after the shift end at the last-seen time (field) or the scheduled end (office); supervisors correct it through regularization |
| Silent phone | 30 min without a ping during a field shift (phones ping about every 10 min) counts as a silent gap |
| Who sees routes | ADMIN all; ward inspector their ward that day; inspector their team; workers and office staff only their own route for today's shift (yesterday's for a night shift) |
| Web sign-in | The dashboard is for ADMIN, WARD_INSPECTOR and OFFICE_STAFF with a password (the API's password roles); inspectors and workers use the mobile app with OTP. No demo or test login on the web. In development the seed sets `SEED_WEB_PASSWORD` for these roles |
| Web language | Marathi by default, English one click away (remembered in a cookie); API errors shown from the shared code table with the request ID |
| Ward boundaries | SMKMC supplies official prabhag boundaries (GeoJSON or shapefile) before the pilot; until then the seed uses synthetic squares, loaded through `PATCH /wards/:id` when they arrive |

## Open items

- Final submission date not confirmed — re-date phases when known.
- CI is live in `.github/workflows/ci.yml` (1 Nov): backend lint, unit, build, migrations, e2e on every
  push and pull request. `openapi/openapi.json` and both generated clients are committed (2 Nov), so the
  web and Dart-client jobs can run: turn them on with the repo variable `CI_CLIENTS=true`.
- Face benchmark needs pilot (Ward 4) photos at the start of Phase 2.
- The legacy mobile app still has demo OTP, fail-open face match and Supabase calls (Phase 3).

## Documents in docs/

| File | What |
| --- | --- |
| `SMKC_SCIF26_Technology_Stack.pdf` | SMKC's mandatory stack, security rules and 19 deliverables |
| `FieldOps_Revamp_Action_Plan_SMKC_TechStack_Alignment_v1_2026-10-27.docx` | **Master plan**: gaps, phases, checklists, decisions, risks |
| `FieldOps_Architecture_Guidelines_Modular_Monolith_Robustness_and_Simplicity_v1_2026-10-27.docx` | **Current** architecture guidelines (Next.js, AuraFace) |
| `FieldOps_Architecture_Guidelines_Modular_Monolith_Robustness_and_Simplicity_v2_4000_Users_Scale_2026-10-27.docx` | Older copy (still says React + Vite, 128-D embeddings); superseded by the v1 file above |
| `FieldOps_Face_Recognition_Model_Selection_D4_AuraFace_Licensing_and_Benchmark_Plan_2026-10-31.docx` | Face model comparison, licences, benchmark plan |
| `FieldOps_Implementation_Plan_v4_Architecture_Technical_Review_2026-10-27.docx` | Review of the team's v4 plan |
| `FieldOps_Current_Codebase_vs_SMKC_TechStack_Compliance_Review_2026-10-27.docx` | Gap review of the pre-revamp code |
