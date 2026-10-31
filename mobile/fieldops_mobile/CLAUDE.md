# mobile/fieldops_mobile/ — Flutter field-staff app (read with the root CLAUDE.md)

Flutter (Dart ≥ 3.0) + GetX, flutter_map (OSM), camera, geolocator, ML Kit face detection,
Drift (offline), workmanager (background GPS). Android first; package `com.smkmc.fieldops_mobile`.

**State:** still the pre-revamp app. It talks to **Supabase directly** (`supabase_flutter`), which
SMKC forbids. Phase 3 rewrites its data layer; until then treat Supabase code as legacy to replace,
not to extend. Freeze new features on Supabase.

## Phase 3 target (from the action plan)

- Repositories over a **generated Dart client** (`npm run api:clients` at the repo root); tokens in
  `flutter_secure_storage`. Remove `supabase_flutter` completely (Gate G3: zero Supabase imports).
- One Drift **outbox** for every offline write (punch, ping, task update, tamper event), each with a
  client UUID (idempotency) and backoff.
- Face: ML Kit active liveness (blink/smile) on the phone, then upload the face crop with the
  server's one-time challenge ID; matching happens on the server (AuraFace). Follow
  `GET /api/v1/face/capture-options` so the Aadhaar FaceRD provider can be switched on without a release.
- GPS settling and check-in lock, tamper watchdog, 25 m accuracy for field staff (100 m for office staff).
- Config only via `--dart-define` (e.g. `--dart-define=API_BASE_URL=...`); no URLs or keys in source.
- Delete: demo OTP, `simulatePosition()`, fail-open face match, payroll and QR-checkpoint screens.
- Minimum-version check and remote logout; device binding comes after delivery (decision D3).
- All user-facing text in `core/localization/app_translations.dart` (Marathi + English).

## Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...   # legacy, until Phase 3
```
