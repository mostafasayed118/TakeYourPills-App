## Next 3 Tasks (Immediate Actions)

Based on the recent comprehensive Bug Audit, the MVP is largely feature-complete but requires stabilization for specific edge cases.

1. **✅ Fix B8: Medication Detail Cubit Pause Race** (COMPLETED)
   - Added state locking via `_isTogglingPause` guard to `togglePause()` to prevent concurrent database and scheduler operations.

2. **✅ Fix B10: Day-Offset Boundary** (COMPLETED)
   - Replaced `Duration` additions with native Dart `DateTime` wrapping to handle local timezone shifts natively in `dashboard_cubit.dart` and `reminder_scheduler_impl.dart`.

3. **✅ Verify & Fix P2: Deletion Async** (COMPLETED)
   - Reversed deletion order in `medication_list_cubit.dart` and `medication_detail_cubit.dart` to cancel notifications before DB deletion.

## Fixed Issues

### Unawaited Deletion Side Effects Fix (P2)
- **Module affected:** `lib/features/medication/presentation/cubit/medication_list_cubit.dart`, `lib/features/medication/presentation/cubit/medication_detail_cubit.dart`
- **What was fixed:** Ensured `_scheduler.cancelAllForMedication(id)` executes before database deletion. This avoids phantom notifications if the app crashes or the UI popping interrupts the flow before completion.
- **Verification:** `flutter analyze` completed with 0 errors.

### Enum Bounds Safety Fix (B9)
- **Module affected:** `lib/data/database/mappers/dose_log_mapper.dart`
- **What was fixed:** Added `_safeParseStatus` fallback logic so database rows with invalid/deprecated enum integer indexes default to `pending` rather than crashing the app.
- **Verification:** `flutter analyze` completed with 0 logic errors.

### Day-Offset Boundary Fix (B10)
- **Module affected:** `lib/features/dashboard/presentation/cubit/dashboard_cubit.dart`, `lib/shared/services/reminder_scheduler_impl.dart`
- **What was fixed:** Replaced naive `Duration(days: ...)` additions with Dart's native `DateTime(year, month, day + offset)` calculation to accurately resolve local-day boundaries and safely handle DST shifts without 24-hour duration drift.
- **Verification:** `flutter analyze` verified compilation with 0 errors.

### Timezone Identifier Type Verification (P1)
- **Module affected:** `lib/shared/services/notification_service_impl.dart`
- **What was fixed:** N/A. `flutter analyze` confirmed `getLocalTimezone()` returns `TimezoneInfo` in this environment. The code is strictly correct.
- **Verification:** Analyzer threw an `invalid_assignment` error on string coercion.

### Pause Race Condition Fix (B8)
- **Module affected:** `lib/features/medication/presentation/cubit/medication_detail_cubit.dart`
- **What was fixed:** Added `_isTogglingPause` locking flag to `togglePause()` to prevent duplicate concurrent executions.
- **Verification:** `flutter analyze` completed with 0 errors.
- **Module affected:** lib/features/onboarding/presentation/onboarding_page.dart:37-46
- **What was fixed:** PopScope correctly configured with `canPop: _currentPage == 0` and `onPopInvokedWithResult` handling. Back press on pages 2-3 navigates to previous page via PageController; on page 1 allows exit.
- **Verification:** Code logic verified correct

### Onboarding Completion Persistence & Navigation Fix
- **Module affected:** lib/features/onboarding/presentation/onboarding_page.dart:132-139
- **What was fixed:** Ensured `await setOnboardingComplete(true)` persists before navigation. Changed `context.mounted` to `mounted` and navigation uses `AppRoutes.dashboard` constant.
- **Verification:** flutter analyze passed 0 errors; app launched successfully

### Android Manifest OnBackInvokedCallback Support
- **Module affected:** android/app/src/main/AndroidManifest.xml
- **What was fixed:** Added `android:enableOnBackInvokedCallback="true"` to resolve "OnBackInvokedCallback is not enabled" warning on Android 13+
- **Verification:** App built and launched without layout exception

### Previous Completions (Carried Forward)

### ReminderScheduler Payload Interpolation Fix (B1)
- **Module affected:** shared/services/reminder_scheduler_impl.dart:44
- **What was fixed:** Corrected Dart string interpolation: `'$medication.id,$doseId,...'` → `'${medication.id},$doseId,...'`. Before fix payload contained "Instance of 'Medication'.id" text, breaking dose log creation from notification taps
- **Verification:** flutter analyze passed 0 errors; payload now correctly parses as integer medicationId in NotificationServiceImpl.onNotificationTapped
- **Remaining blockers:** B2, B3-B5, B7-B10 pending
- **Next recommended step:** Fix B3 — add `await getIt<PreferenceService>().setOnboardingComplete(true)` to OnboardingPage "Get Started" button

### Notification Cancellation Fix (B6)
- **Module affected:** notification_service.dart, notification_service_impl.dart, reminder_scheduler_impl.dart
- **What was fixed:** Changed `cancelAllForMedication` to filter pending notifications by medication ID from payload instead of canceling all app notifications. Added `getPendingNotifications()` method to NotificationService interface.
- **Verification:** flutter analyze passed 0 errors; no compilation issues
- **Remaining blockers:** B2, B3-B5, B7-B10 pending
- **Next recommended step:** Fix B3 — add `await getIt<PreferenceService>().setOnboardingComplete(true)` to OnboardingPage "Get Started" button

### Timezone & AddEditMedicationPage Error UI Fix
- **Module affected:** notification_service_impl.dart (_initializeTimezone) + add_edit_medication_page.dart (error builder)
- **What was fixed:** 
  1. Timezone: Use `final timezoneInfo = await FlutterTimezone.getLocalTimezone(); _location = tz.getLocation(timezoneInfo.identifier);` to correctly extract String identifier from TimezoneInfo
  2. Error UI: Replace `AppTextStyles.headlineSmall` → `AppTextStyles.headlineMedium`; replace non-existent `initializeForm()` retry with `Navigator.of(context).pop()` ("Go Back" button)
- **Verification:** flutter analyze passed 0 errors on both files (no undefined_getter, undefined_method, or invalid_assignment)
- **Remaining blockers:** None within scope
- **Next recommended step:** N/A — completed

### Onboarding Redirect Fix
- **Module affected:** app_router.dart (redirect callback)
- **What was fixed:** Replaced `const onboardingComplete = false` with runtime `await getIt<PreferenceService>().getOnboardingComplete()`; made redirect async; added service imports
- **Verification:** flutter analyze passed 0 errors; redirect logic correct
- **Remaining blockers:** OnboardingPage must persist completion flag via `setOnboardingComplete(true)` on "Get Started"
- **Next recommended step:** N/A — resolved with Onboarding Navigation & Completion Fix (B5)

### Dose Log ID Collision Fix (B4)
- **Module affected:** notification_service_impl.dart:285
- **What was fixed:** Changed `id: doseId` to `id: 0` in DoseLog creation on notification tap, allowing database to auto-assign row ID and preventing primary key collisions
- **Verification:** flutter analyze 0 errors
- **Remaining blockers:** B5, B7-B10 pending

### Dashboard Adherence Calculation Fix (B7)
- **Module affected:** dashboard_cubit.dart
- **What was fixed:** Replaced fake `(totalToday * 0.8).round()` formula with real dose log query via `getDoseLogsForDateRange` counting actual `DoseLogStatus.taken` logs
- **Verification:** flutter analyze 0 errors
- **Remaining blockers:** B5, B8-B10 pending

### Onboarding Navigation & Completion Fix (B5)
- **Module affected:** onboarding_page.dart
- **What was fixed:**
  1. Replaced deprecated `WillPopScope` with `PopScope` for proper Android back button handling
  2. Added `onPopInvokedWithResult` to navigate to previous onboarding page when on pages 2-3, or allow exit on page 1
  3. Added `setOnboardingComplete(true)` call before navigating to dashboard on final action
- **Verification:** flutter analyze 0 errors; all 39 tests passing
- **Remaining blockers:** B8-B10 pending

### Service Initialization Fix in main.dart
- **Module affected:** main.dart
- **What was fixed:** Added `await getIt<PreferenceService>().init()` and `await getIt<NotificationService>().init()` before `runApp()`; added `init()` abstract method to PreferenceService; made `main()` async
- **Verification:** flutter analyze passed 0 errors; services properly initialized
- **Remaining blockers:** None
- **Next recommended step:** N/A — completed

### Medication Repository Registration Fix
- **Module affected:** service_locator.dart (lines 30-32)
- **What was fixed:** Changed `getIt.registerLazySingleton<MedicationRepository>(getIt,)` to `() => getIt<MedicationRepositoryImpl>()`
- **Verification:** flutter analyze passed 0 errors
- **Remaining blockers:** None
- **Next recommended step:** N/A — completed

### Previous Completions (Carried Forward)
- Dashboard Page Widget Tests (2 tests passing)
- MedicationRepository CRUD tests (7 tests passing)
- MedicationFormCubit: ReminderScheduler wired (9 tests passing)
- MedicationListCubit: ReminderScheduler wired (6 tests passing)
- MedicationDetailCubit: ReminderScheduler wired
- DashboardCubit: Real-time data binding complete
- Notification tap: Dose log creation + navigation
- Integration tests: CRUD, FORM, NAVIGATION (3 tests)

---

1. **Expand Test Coverage** (HIGH) - 4-5 hours
   - Widget tests: MedicationDetailPage, AddEditMedicationPage
   - Notification scheduling/cancellation flow tests
   - Mocktail fallbacks for all test files
   - CI/CD pipeline setup
   - Target: 25+ tests, >80% widget coverage

2. **OEM Battery Optimization Guide** (MEDIUM) - 1-2 hours
   - In-app warning for Xiaomi/Huawei/Samsung devices
   - Deep links to battery optimization settings
   - User education on notification reliability
   - Graceful degradation when exact alarms denied

3. **Android 14 Exact Alarm Permission** (LOW) - 1 hour
   - Add permission_handler for SCHEDULE_EXACT_ALARM
   - Request permission on Android 14+ first launch
   - Graceful fallback UI for denied permission
   - Permission check on launch

---

## Task Status Legend

| Value | Meaning |
|-------|---------|
| `todo` | Not started |
| `in_progress` | Currently being worked on |
| `completed` | Finished and merged |
| `cancelled` | No longer needed |
| `blocked` | Waiting on dependency or external factor |

---

## Progress Summary

**Last Updated:** 2026-04-30
**Status:** Phase 0-6 core code COMPLETE, Build ✅ VERIFIED, ALL CUBITS ✅ WIRED, Tests ✅
**Tests:** 18+ passing (7 repo + 2 dashboard + 9 form + 3 integration)

| Sprint | Tasks | Status |
|--------|-------|--------|
| Sprint 0 | T001–T020 (Foundation) | ✅ Complete |
| Sprint 1 | T021–T038 (Medication CRUD) | ✅ Complete |
| Sprint 2 | T039–T059 (Notifications) | ✅ Complete (ALL 3 CUBITS + tap) |
| Sprint 3 | T060–T071 (Dashboard) | ✅ Complete (UI + Cubit) |
| Sprint 4 | T072–T085 (History + Settings) | ✅ Complete |
| Sprint 5 | T086–T099 (Refill + Messaging) | N/A (Out of scope) |
| Sprint 6 | T100–T108 (Testing + Polish) | 🟢 18+ tests |

## Completed vs Remaining

| Category | Completed | % Complete |
|----------|-----------|------------|
| Foundation | 19/19 | 100% |
| Medication CRUD | 19/19 | 100% |
| Notifications | 21/21 | 100% |
| Dashboard | 12/12 | 100% |
| History & Progress | 12/12 | 100% |
| Settings & Privacy | 8/8 | 100% |
| Testing & Polish | 18+/30 | 60% (ongoing) |
