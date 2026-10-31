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
Payroll and QR-checkpoint attendance are removed.

## Phases and gates

| Phase | Scope | Status |
| --- | --- | --- |
| 0 Foundations | Backend scaffold, shared kit, wards reference module, Next.js scaffold, Docker, CI | **Done — Gate G0 passed 31 Oct 2026** on the dev PC |
| 1 Backend core | Portable schema, auth, RBAC, CRUD, audit, Swagger, seed | **In progress**: auth, offices, staff (no controller yet), audit, face interface + Aadhaar adapter done. Remaining: rosters, assignments, shifts, attendance, pings, tasks, complaints, leave, holidays, alerts, chat, spot checks tables; idempotency + version columns; RBAC scope guards; staff/roster CRUD; seed |
| 2 Attendance engine | Policies, geo service, liveness challenge, face engine (benchmark first), punch, pings, jobs | Not started |
| 3 Client migration | Web pages to Next.js, both apps to the API, Supabase removed | Not started |
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

## Open items

- Final submission date not confirmed — re-date phases when known.
- Move `scripts/ci/github-actions-ci.yml` to `.github/workflows/ci.yml` (enables CI on GitHub).
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
