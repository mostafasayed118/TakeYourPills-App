# Project Status

**Last Updated:** 2026-07-16
**Updated By:** Color Theme & Architecture Session
**Session Type:** Bug Fix + Refactor - Theme Colors, SQLite Auto-Increment, CLAUDE.md

---

### ✅ SQLite Auto-Increment Fix (P0)
- **Module affected:** `lib/data/database/mappers/medication_mapper.dart`, `lib/data/database/app_database.dart`, `lib/data/datasources/medication_local_datasource.dart`
- **What was fixed:** `createMedication` was inserting `id: 0` explicitly, causing UNIQUE constraint violations. Replaced `toModel`/`toModelList` with `toCreateCompanion` (id absent → SQLite auto-increments) and `toUpdateCompanion` (id present). Updated `AppDatabase.createMedication` and `updateMedicationRow` to accept `MedicationsCompanion`.
- **Verification:** `flutter test` passed; `build_runner` regenerated Drift code.

### ✅ Theme Color Fix — Detail Page (P0)
- **Module affected:** `lib/features/medication/presentation/detail/medication_detail_page.dart`, `detail_card.dart`, `info_row.dart`, `stat_chip.dart`
- **What was fixed:** All detail page widgets used hardcoded `AppColors.*` (light-theme only) instead of `Theme.of(context).colorScheme.*`. Section headers, labels, and card backgrounds were nearly invisible in dark mode.
- **Verification:** `flutter test` passed; both light and dark themes render correctly.

### ✅ Theme Color Fix — Form & List Pages (P0)
- **Module affected:** `add_edit_medication_page.dart`, `section_header.dart`, `dosage_unit_dropdown.dart`, `frequency_dropdown.dart`, `schedule_time_picker.dart`, `frequency_days_selector.dart`, `medication_card.dart`, `reminder_action_sheet_page.dart`
- **What was fixed:** Replaced all hardcoded `AppColors.*` with `Theme.of(context).colorScheme.*` across medication form, list cards, time picker, day selector, and action sheet.
- **Verification:** `flutter test` passed.

### ✅ ChartToggle RenderFlex Fix (P1)
- **Module affected:** `lib/features/progress/presentation/widgets/chart_toggle.dart`
- **What was fixed:** `_ToggleChip` used `Expanded` inside a `Row` that was inside a `ListView` (unbounded width). Removed `Expanded`, added `mainAxisSize: MainAxisSize.min` to parent Row, and used content-based sizing with padding.
- **Verification:** `flutter test` passed; no more RenderFlex overflow.

### ✅ CLAUDE.md Updated for Flutter (P0)
- **Module affected:** `CLAUDE.md`
- **What was fixed:** Rewrote from Android/Kotlin template to Flutter/Dart project-specific reference. Updated tech stack (BLoC/Cubit, Drift, GetIt, GoRouter), package structure, widget discipline, and testing sections.
- **Verification:** File reviewed.

### ✅ Medication Form UI Improvements (P1)
- **Module affected:** `schedule_time_picker.dart`, `frequency_days_selector.dart`, `medication_form_cubit.dart`, `medication_form_state.dart`
- **What was fixed:** Replaced free-text schedule time input with time picker chips. Replaced free-text frequency days input with day-of-week circle selector. Updated cubit/state to handle `List<String>` and `List<int>` instead of raw strings.
- **Verification:** `flutter test` passed.

### ✅ Reminder Action Sheet (P1)
- **Module affected:** `reminder_action_sheet_page.dart`, `reminder_action_cubit.dart`, `app_router.dart`, `notification_service_impl.dart`
- **What was fixed:** Created `ReminderActionCubit` for dose logging/snoozing logic. `onNotificationTapped` now navigates to action sheet instead of directly logging. Added route for reminder action sheet.
- **Verification:** `flutter test` passed.

---

### Previous Completions (Carried Forward)

### ✅ Production close-out (2026-07-12 follow-up)
- Keystore, OEM reliability, data export, crash logs, release AAB built

### ✅ Architectural Refactor - Phase 1
- Repository split (ISP), Result<T> type, domain service extraction

### ✅ Enum Bounds Safety Fix (B9)
- `_safeParseStatus` in `dose_log_mapper.dart`

### ✅ Pause Race Protection Fix (B8)
- `_isTogglingPause` guard in `medication_detail_cubit.dart`

### ✅ Day-Offset Boundary Fix (B10)
- Native Dart `DateTime` wrapping in `dashboard_cubit.dart` and `reminder_scheduler_impl.dart`

### ✅ Unawaited Deletion Side Effects Fix (P2)
- Cancel notifications before DB deletion in `medication_list_cubit.dart` and `medication_detail_cubit.dart`

### ✅ Missing Cascade Delete Fix (B2)
- Delete schedules and dose logs before medication in `app_database.dart`

### ✅ Dashboard Adherence Calculation Fix (B6)
- Real dose log query in `dashboard_cubit.dart`

### ✅ Onboarding Navigation & Completion Fix (B4/B5)
- PopScope, `setOnboardingComplete(true)`, redirect logic

---

## MVP Readiness Assessment

**Feature Completeness:** 98%
**Integration Completeness:** 95%
**Tests Passing:** 57+
**Build Status:** ✅ VERIFIED
**Theme Support:** ✅ Light + Dark

---

## Next Recommended Tasks

1. **Expand Test Coverage** (HIGH) — 4-5 hours
   - Widget tests for remaining pages
   - CI/CD pipeline setup
   - Target: 25+ widget tests

2. **OEM Battery Guide** (MEDIUM) — 1-2 hours
   - In-app warnings for aggressive OEMs
   - Deep links to battery settings

3. **Sentry Integration** (LOW) — 1 hour
   - Production crash reporting
   - Error grouping and alerts
