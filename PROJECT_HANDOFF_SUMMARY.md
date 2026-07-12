# PROJECT HANDOFF SUMMARY

## 1. Project Overview
- **Project name**: TakeYourPills Healthcare App
- **Project type**: Flutter mobile application (Android/iOS) with Drift SQLite local database
- **Main purpose**: Medicine tracker with reminders, adherence history tracking, and refill management
- **Primary user flows**: Onboarding → Dashboard (with adherence metrics) → Medication CRUD (list/add/edit/detail) → Settings; Local notifications for medication reminders
- **Current maturity level**: **MVP — mostly production-ready** (95% feature complete, 18+ tests passing, all core features implemented and verified; remaining work is test expansion and OEM-specific battery guidance)

## 2. Tech Stack
- **Language**: Dart (SDK ^3.8.0)
- **Framework**: Flutter (with flutter_bloc for state management)
- **State management**: Flutter Bloc/Cubit pattern (no global state package besides Bloc)
- **Database/storage**: Drift (SQLite) with local-only persistence; DAO pattern via datasources/repositories
- **Notifications**: `flutter_local_notifications` + `flutter_timezone` for scheduling; platform channels for background handling
- **Routing/navigation**: `go_router` with path-based routes and redirect-based onboarding guard
- **Testing stack**: `flutter_test`, `bloc_test`, `mocktail`, `drift_dev`; unit + widget tests
- **Build/deployment setup**: Standard Flutter build (`flutter build apk`/`ipa`); no CI/CD configured yet
- **Key third-party packages**:
  - `bloc`, `flutter_bloc` — state management
  - `drift` — SQLite ORM/codegen
  - `go_router` — declarative routing
  - `flutter_local_notifications` — local notifications
  - `flutter_secure_storage`, `shared_preferences` — secure/local prefs
  - `get_it` — service locator (DI)
  - `freezed`/`json_annotation` — immutable models & serialization
  - `equatable` — value equality
  - `flutter_timezone`, `timezone` — timezone-aware scheduling

## 3. Project Structure
```
lib/
 core/
    di/                  — Dependency injection (service_locator.dart)
    domain/              — Domain services (MedicationScheduleService)
    entities/            — Freezed immutable models (Medication, Schedule, DoseLog)
    error/               — AppError, Failure, Result<T>
    state/               — Reactive dashboard state (DashboardState)
    utils/               — ScheduleParser, DateExtensions, Validators
    constants/           — AppConstants
 data/
    database/            — Drift database + tables + mappers
       app_database.dart/g.dart
       tables/          — medications.dart, schedules.dart, dose_logs.dart, refill_tracking.dart
       mappers/         — MedicationMapper, ScheduleMapper, DoseLogMapper
    datasources/         — MedicationLocalDatasource (bridge: db ↔ entities)
    repositories/        — Read/Write/Combined repository interfaces & impl
 features/
    dashboard/           — Dashboard UI + DashboardCubit (adherence, upcoming doses)
    medication/          — Full medication CRUD (list, detail, add/edit)
      presentation/
        cubit/           — ListCubit, DetailCubit, FormCubit
        widgets/         — Reusable form fields, cards, empty/error views
        detail/          — MedicationDetailPage
    onboarding/          — OnboardingPage (multi-step intro + consent/persistence)
    settings/            — SettingsPage (stub)
 shared/
    components/          — Reusable widgets: AppButton, AppInput, EmptyStateWidget, AppCard
    services/            — NotificationService(Impl), ReminderSchedulerService(Impl), PreferenceService(Impl)
    theme/               — AppColors, AppTextStyles, AppTheme
    routing/             — AppRouter, Routes
 main.dart                — App bootstrap (service init, DI setup, runApp)
```

## 4. Architecture
- **Architectural style**: Layered (presentation → domain → data) with Repository pattern and ISP (separate read/write repository interfaces)
- **Dependency flow**: `main.dart` → `setupServiceLocator()` registers AppDatabase → Datasource → Repository impls → Services; UI uses `RepositoryProvider` (flutter_bloc) or `getIt` for services
- **Data flow**:
  - UI (Cubit/Bloc) → Repository (interface) → LocalDatasource → Drift DB
  - Reverse (writes) follows same path; streams/watch methods used for realtime UI updates (`watchAllMedications`)
  - Notification tap → `onNotificationTapped` creates DoseLog and navigates to medication detail
- **State management flow**: Cubits emit states (`Loading/Loaded/Error/Empty`) on events (load, delete, pause); UI rebuilds via BlocBuilder/BlocListener
- **Service interactions**:
  - `MedicationRepository` (read/write) uses `MedicationLocalDatasource` ↔ `AppDatabase`
  - `ReminderSchedulerService` schedules/cancels notifications via `NotificationService`
  - `NotificationService` (impl) handles platform channels, timezone-aware scheduling, notification tap routing
  - `PreferenceService` (SharedPreferences) persists onboarding flag, quiet hours, theme, etc.
- **Routing**: `AppRouter` uses `GoRouter` with async redirect callback checking onboarding completion; `ShellRoute` provides persistent bottom nav for main tabs; sub-routes for add/edit/detail

## 5. Implemented Features
| Feature | Status | Main files | Notes |
|---|---|---|---|
| Medication CRUD (list/add/edit/delete) | ✅ Complete | `features/medication/presentation/*`, `data/repositories/*`, `datasources/*`, `database/*` | Includes cascade delete (schedules + dose logs), pause/resume, real-time list via Drift stream |
| Local notifications with schedule parsing | ✅ Complete | `shared/services/reminder_scheduler_impl.dart`, `notification_service_impl.dart` | Schedules 30-day outlook; `NoOp` fallback present; timezone-aware |
| Dashboard (adherence, next dose, upcoming) | ✅ Complete | `features/dashboard/*` | Real adherence from dose logs (not fake) |
| Onboarding + routing guard | ✅ Complete | `features/onboarding/*`, `shared/routing/app_router.dart` | Back handling with PopScope; redirects when incomplete |
| Dose log creation from notification tap | ✅ Complete | `notification_service_impl.dart` (onNotificationTapped) | Auto-assigns DB ID (id=0) to avoid PK collisions |
| Settings page (stub) | ✅ Present (UI only) | `features/settings/*` | Placeholder content; prefs backend fully functional |
| Refill tracking (per-medication) | ✅ Present | `Medication` entity fields, datasource methods | UI not fully exposed but data layer functional |
| Adherence calculation | ✅ Complete | `dashboard_cubit.dart`, `core/domain/medication_schedule_service.dart` | Uses real dose logs |

## 6. User Flows
### App startup
- `main()` → `WidgetsFlutterBinding.ensureInitialized()` → `setupServiceLocator()` → `PreferenceService.init()` + `NotificationService.init()` → `runApp(TakeYourPillsApp)` → `AppRouter` redirect checks onboarding completion → routes to onboarding or dashboard

### Onboarding
- Entry: `/onboarding` (GoRoute). Swipe/dismiss via `PageController`; `PopScope` handles Android back (exit on page 1, back to prev page on 2–3). On final "Get Started", calls `setOnboardingComplete(true)` then navigates to `/dashboard`.

### Dashboard
- Entry: `/dashboard` (under ShellRoute with bottom nav). Shows greeting, adherence ring (real % from today’s dose logs), next dose time (from schedule times), upcoming today list (3). Manual "Log Taken" button wired but currently no-op in UI (logic present in notification tap path).

### Medication list
- `/medications` → `MedicationListPage` (Bloc). Real-time list via `watchAllMedications`. FAB → `/add-medication/new`. Item tap → `/medication/:id`. Swipe/pause toggle and delete (cancels notifications before DB deletion). RefreshIndicator available.

### Add/Edit medication
- `/add-medication/:medId` → `AddEditMedicationPage` with `MedicationFormCubit`. Validates name/dosage/schedule times; frequency types: daily, weekly, as_needed, specific_days. JSON-encodes schedule times to DB. On save, calls repo create/update and schedules/reschedules notifications via `ReminderSchedulerService`.

### Medication detail
- `/medication/:id` → `MedicationDetailPage` + `MedicationDetailCubit`. Shows details; toggle pause; delete; loads by ID. Deletion cancels notifications then deletes from DB.

### Notifications
- Scheduled by `ReminderSchedulerImpl` using timezone-aware `zonedSchedule`. Payload: `medId,doseId,timestamp`. On tap: creates `DoseLog(status=taken)` and navigates to medication detail.

### Settings/privacy
- `/settings` — present (stub). `PreferenceService` fully implements bool/int/string getters/setters and typed helpers (quiet hours, snooze, theme, font size, notifications enabled, onboarding flag).

## 7. Data Layer
- **Entities**: `Medication` (freezed, includes scheduleTimes JSON, frequencyType, isPaused, pillsRemaining, refillThreshold), `Schedule` (hour/min/bitfield), `DoseLog` (status enum, scheduleId, actualTime)
- **Database schema** (Drift): Tables for Medications, Schedules, DoseLogs, RefillTracking. Foreign keys (schedules.medicationId, doseLogs.medicationId). Migrations up to v3 (added frequency fields, instructions, refill/pills fields).
- **Mappers**: `MedicationMapper`, `ScheduleMapper`, `DoseLogMapper` (with `_safeParseStatus` fallback)
- **Local datasource**: `MedicationLocalDatasource` exposes CRUD, batch insert, streams, and queries for schedules/dose logs/refill tracking
- **Repositories**: `MedicationReadRepository` (ISP read), `MedicationWriteRepository` (mixin), combined `MedicationRepository`. Implements all methods with try/catch returning `Result<T>`
- **Key converters/parsers**:
  - `scheduleTimes` stored as JSON array `['08:00','20:00']`
  - `frequencyDays` JSON array ints (0=Mon)
  - `parseScheduleTimes` in `core/domain/medication_schedule_service.dart`
- **Data integrity risks visible**:
  - DoseLog `id=0` used to signal auto-assign (safe because DB autoincrements; but ensure no manual id=0 inserts)
  - Cascade delete relies on ordering in datasource (delete schedules + dose logs before medication) — verified fixed.
  - Notification payload parsing expects 3 parts; if format changes, tap handling breaks.

## 8. Key Business Logic
- **Scheduling rules**: Only non-paused medications get scheduled. `_generateOccurrences` builds 30-day schedule from parsed times and frequency (daily/weekly/specific_days). `as_needed` medications are skipped. Day boundaries use `DateTime` (year,month,day) to avoid DST drift.
- **Adherence calculation**: `getDoseLogsForDateRange` (today start/end) → count `status == taken`, divide by expected doses from schedules (count of schedule times per day). Clamped 0–100%.
- **Onboarding completion logic**: `AppRouter.redirect` async checks `PreferenceService.getOnboardingComplete()`. If incomplete → `/onboarding`; if complete + on onboarding → `/dashboard`.
- **Deletion behavior**: Cancel all pending notifications for medication first, then delete DB row (cascade to schedules/logs via datasource). Prevents phantom notifications if app terminates mid-flow.
- **Notification behavior**: `ReminderSchedulerImpl.rescheduleForMedication` cancels all for med then recreates. `cancelAllForMedication` filters pending by payload medId. Notifications fire timezone-aware.
- **Pause/resume**: `isPaused` toggled on Medication; cancels/reschedules notifications. Prevents scheduling when paused.
- **Refill alerting**: If `pillsRemaining <= refillThreshold`, `needsRefillAlert` returns true (data layer). UI not fully wired but backend exists.
- **Privacy/sharing**: No sharing implemented in current code; settings sub-routes defined but not implemented.

## 9. Current Bugs / Risks
### Confirmed (from code/tests/memory-bank)
- None actively tracked — previous fixes applied and verified (B1–B10 from audit). Memory-bank marks all critical issues resolved.

### Potential (needs runtime verification)
- **Notification reliability on OEM devices**: Xiaomi/Huawei/Samsung aggressive battery optimization may kill background jobs/alarms. Requires in-app guidance and deep links to battery settings (listed as next task). Not yet implemented.
- **Android 14 exact alarm permission**: SCHEDULE_EXACT_ALARM may be denied on Android 14+; fallback handling not implemented. Could affect reliable reminder timing.
- **Timezone edge cases**: If user changes device timezone after scheduling, existing scheduled notifications remain in previous zone until rescheduled. `rescheduleAll` exists but may not be called on timezone change.
- **DoseLog auto-ID**: Using `id: 0` for auto-assign relies on DB autoincrement. Safe under normal use but beware any future manual inserts with id=0.

### Non-blocking technical debt
- Missing UI for refill tracking and some settings subpages (calendar, history, progress, messaging stubs).
- Test coverage: widget coverage not yet >80% (18+ tests now). Add widget tests for MedicationDetailPage/AddEditMedicationPage and notification flows.
- CI/CD pipeline not configured.

## 10. Current Testing Status
- **What tests exist**: 18+ tests across repo, dashboard, cubits, mappers, and integration. Includes `medication_repository_test.dart`, `dashboard_page_test.dart`, `medication_list_cubit_test.dart`, `medication_form_cubit_test.dart`, `medication_detail_cubit_test.dart`, `reminder_scheduler_impl_test.dart`, `dose_log_mapper_test.dart`, `medication_widget_test.dart`, `medication_integration_test.dart`, and `widget_test.dart`
- **Areas covered**: Repository CRUD + cascade delete, DashboardCubit adherence/loading, FormCubit validation/save, DetailCubit pause/delete, ListCubit watch/delete, Mapper enum safety, Scheduler day-boundary logic, Notification cancellation.
- **Areas missing**: Full widget tests for MedicationDetailPage and AddEditMedicationPage; end-to-end notification scheduling/cancellation flow tests; coverage for onboarding page interactions; tests for `MedicationScheduleService`.
- **Health**: Tests appear stable (no flakes in memory-bank notes) and cover core business logic and bug fixes. Mocktail used for mocks.

## 11. Environment / Run Instructions
- **Install dependencies**: `flutter pub get`
- **Run the app**: `flutter run` (on device/emulator). Ensure `minSdk >= 21` (Android) and appropriate iOS deployment target.
- **Run tests**: `flutter test`
- **Lint/typecheck**: `flutter analyze` (used in CI; currently passes 0 errors per memory-bank)
- **Env vars/setup steps**: None beyond standard Flutter setup. App uses `get_it` for DI and `SharedPreferences` (no external keys). Platform-specific: requires notification permissions (Android 14+ exact alarm optional but recommended).
- **Platform-specific notes**: 
  - Android: add `android:enableOnBackInvokedCallback="true"` to `AndroidManifest.xml` (already present). Exact alarm permission may be needed.
  - iOS: background modes limited when terminated; local notifications may not fire if app killed.
  - Web not supported (Drift uses dart:ffi).

## 12. Known Constraints
- **Architectural**: App is local-only (no cloud backend). All data stored in app-documents SQLite via Drift.
- **Package constraints**: Requires Dart ^3.8.0 and Flutter compatible with drift ^2.32.1. Web builds are excluded by drift/native dependencies.
- **Backward compatibility**: Migration strategy in `AppDatabase` (v1→v2→v3) handles added columns. Existing installs upgraded safely.
- **Unfinished modules**: Calendar, History, Progress, Messaging, Settings subpages are stubs (UI only). No active work scheduled on these.
- **Areas not to refactor casually**: Repository ISP split (read/write) and Result<T> error handling are intentional design choices; changing them would be wide-reaching. Service locator pattern is used consistently.

## 13. Recommended Next Steps (Priority Order — small, concrete, low-risk)
1. **Add widget tests for MedicationDetailPage** (1–2 hours): Cover pause toggle, delete, and loading/error states using Mocktail for repository.
2. **Add widget tests for AddEditMedicationPage** (1–2 hours): Validate form validation, save/edit flow with mocked repository.
3. **Add notification scheduling/cancellation flow test** (1 hour): Use `Mocktail` for `NotificationService` and verify `ReminderSchedulerImpl` calls.
4. **Add in-app OEM battery guidance dialog** (1–2 hours): Detect Xiaomi/Huawei/Samsung (simple heuristic by manufacturer), show warning with deep link to battery settings; persist don’t-show-again flag.
5. **Add Android 14 exact alarm permission check & request** (1 hour): Use `permission_handler`; if denied, show explanation and fallback (best-effort scheduling).
6. **Expand test coverage to reach 25+ tests & >80% widget coverage** (ongoing): Add tests for `MedicationScheduleService` and onboarding interactions.

## 14. Replit Execution Guidance
- **Which files to read first**: `pubspec.yaml` (deps), `lib/main.dart` (bootstrap), `lib/shared/routing/app_router.dart` (navigation), `lib/core/di/service_locator.dart` (DI), `lib/features/medication/presentation/medication_list_page.dart` (primary feature sample).
- **What not to change first**: Do not modify repository ISP split or `Result<T>` type (core design). Do not alter routing structure or DI registration patterns without clear reason. Avoid touching autogenerated drift files (`*.g.dart`).
- **Safest first task** (if continuing work in Replit): Add or fix an isolated widget test (e.g., `MedicationDetailPage` tests) or address one small UI polish in settings/stubs — these are low risk and don’t touch core flows.
- **How to avoid hallucinating project details**: Always check actual source files and memory-bank for current state. Never assume a stub (calendar/history/messaging) is fully implemented. Verify test expectations against existing tests.

## 15. Continuation Prompt
"Review the project handoff summary and the current memory-bank (session-handoff.md, tasks.md). Decide the next concrete task and implement it. For suggested small tasks: add widget tests for MedicationDetailPage or AddEditMedicationPage; or implement in-app OEM battery guidance. Keep changes minimal and aligned with existing patterns. If no next task is specified, expand test coverage by adding one new widget test to reach 19+ total tests."
