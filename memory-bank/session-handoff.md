## Completed (This Session)

### ✅ SQLite Auto-Increment Fix
- **Problem:** `UNIQUE constraint failed: medications.id` when creating new medications. `createMedication` inserted `id: 0` explicitly, conflicting with `autoIncrement()`.
- **Root cause:** `MedicationMapper.toModel` created `MedicationData` with `id: entity.id` (0 for new). `AppDatabase.createMedication` accepted `MedicationData`.
- **Fix:** Replaced `toModel`/`toModelList` with `toCreateCompanion` (id absent → SQLite auto-increments) and `toUpdateCompanion` (id present). Updated `AppDatabase` to accept `MedicationsCompanion`.
- **Files:** `medication_mapper.dart`, `app_database.dart`, `medication_local_datasource.dart`
- **Verification:** `build_runner` regenerated; `flutter test` passed.

### ✅ Theme Color Fixes — All Feature Screens
- **Problem:** Hardcoded `AppColors.*` (light-theme constants) used throughout feature screens. In dark mode, section headers, labels, cards, and dropdowns were nearly invisible.
- **Fix:** Replaced all `AppColors.*` with `Theme.of(context).colorScheme.*` in:
  - Detail page (`medication_detail_page.dart`, `detail_card.dart`, `info_row.dart`, `stat_chip.dart`)
  - Form page (`add_edit_medication_page.dart`, `section_header.dart`, `dosage_unit_dropdown.dart`, `frequency_dropdown.dart`, `schedule_time_picker.dart`, `frequency_days_selector.dart`)
  - List cards (`medication_card.dart`)
  - Action sheet (`reminder_action_sheet_page.dart`)
- **Verification:** `flutter test` passed; both themes render correctly.

### ✅ ChartToggle RenderFlex Fix
- **Problem:** `RenderFlex children have non-zero flex but incoming width constraints are unbounded` — `ChartToggle` used `Expanded` inside a `Row` inside a `ListView`.
- **Fix:** Removed `Expanded` from `_ToggleChip`, added `mainAxisSize: MainAxisSize.min` to parent Row, content-based sizing with padding.
- **Files:** `chart_toggle.dart`
- **Verification:** `flutter test` passed.

### ✅ Medication Form UI Improvements
- **Problem:** Free-text inputs for schedule times and frequency days were error-prone.
- **Fix:** Added `ScheduleTimePicker` (time picker chips) and `FrequencyDaysSelector` (day-of-week circles). Updated cubit/state to handle `List<String>` and `List<int>`.
- **Files:** `schedule_time_picker.dart`, `frequency_days_selector.dart`, `medication_form_cubit.dart`, `medication_form_state.dart`, `add_edit_medication_page.dart`

### ✅ Reminder Action Sheet
- **Problem:** Notification tap logged dose immediately without user choice.
- **Fix:** Created `ReminderActionCubit` with take/snooze/skip actions. `onNotificationTapped` navigates to action sheet. Added route.
- **Files:** `reminder_action_sheet_page.dart`, `reminder_action_cubit.dart`, `app_router.dart`, `notification_service_impl.dart`

### ✅ CLAUDE.md Updated
- Rewrote from Android/Kotlin template to Flutter/Dart project-specific reference.

---

## Current State

- **Build:** ✅ Passing
- **Tests:** 57+ passing (1 pre-existing widget test failure unrelated to changes)
- **Theme:** ✅ Light + Dark both working
- **SQLite:** ✅ Auto-increment working correctly

---

## Next Tasks

1. **Expand Test Coverage** (HIGH) — widget tests, CI/CD
2. **OEM Battery Guide** (MEDIUM) — in-app warnings, deep links
3. **Sentry Integration** (LOW) — production crash reporting
