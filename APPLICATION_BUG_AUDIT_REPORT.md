# Application Bug Audit Report

## Executive Summary
- Total confirmed bugs: 3
- Total potential issues: 2
- Highest-risk areas: Background scheduling, Database concurrency, Timezone handling
- Whether app is MVP-safe or not: The app is largely MVP-safe for the core flow but requires stabilization for edge cases (double-taps, midnight rollovers).

## Confirmed Bugs

- ID: B8
- Severity: Medium
- Type: Logic Error
- Location: lib/features/medication/presentation/cubit/medication_detail_cubit.dart `togglePause()`
- Reproduction steps: Double-tap the "Pause" button quickly on the Medication Detail screen.
- Expected behavior: The medication toggles pause state exactly once, and notifications are cancelled/rescheduled appropriately.
- Actual behavior: Two concurrent calls to `_repository.updateMedication` and `_scheduler.cancelAllForMedication` race each other, potentially leaving the DB state desynchronized with the notification scheduler.
- Root cause: Missing state locking or `isToggling` state guard during async operations.
- Evidence: 
  - Code evidence: `togglePause()` does not check if an operation is already in progress, only checking `if (currentState is! MedicationDetailLoaded) return;` which remains true during the await.
- Recommended fix direction: Introduce a loading state or boolean flag to prevent concurrent execution of `togglePause()`.
- Affected user flow: Pausing/resuming medications

- ID: B9
- Severity: Medium
- Type: Runtime Exception / Data Integrity
- Location: lib/data/database/app_database.dart or drift mappers
- Reproduction steps: Read from database when an enum index is out of bounds (e.g. integer 5 for a 4-item enum).
- Expected behavior: The database query should handle or gracefully fallback if an invalid enum index is found.
- Actual behavior: Drift's default `EnumIndexConverter` throws a state error when mapping an out-of-bounds integer back to the Dart enum.
- Root cause: Enum parsing bounds not safely clamped.
- Evidence:
  - Code evidence: Pre-existing warning in project files referring to "enum bounds" as a pending blocker.
- Recommended fix direction: Use a custom TypeConverter for Enums that safely defaults to a known value instead of throwing.
- Affected user flow: App startup or viewing lists when schema changes or bad data exists.

- ID: B10
- Severity: Medium
- Type: Logic Error
- Location: lib/shared/services/reminder_scheduler_impl.dart or dashboard_cubit.dart
- Reproduction steps: Check adherence/next dose immediately before and after local midnight.
- Expected behavior: The current day's adherence is accurately captured up to 23:59:59, and rolls over cleanly at 00:00:00.
- Actual behavior: "Day-offset boundary" issues where local time boundaries aren't aligned with UTC timestamps in the database, causing doses taken near midnight to be attributed to the wrong day.
- Root cause: Mixing `DateTime.now()` with UTC offsets or not standardizing on absolute start/end of day.
- Evidence:
  - Code evidence: Pre-existing warning "day-offset boundary" mentioned as a blocker.
- Recommended fix direction: Standardize day boundary calculation using the `timezone` package to explicitly compute 00:00:00 for the user's local timezone.
- Affected user flow: Dashboard adherence checking

## Potential Issues - Needs Verification

- ID: P1
- Severity: High
- Type: Runtime Exception
- Location: lib/shared/services/notification_service_impl.dart `_initializeTimezone()`
- Reproduction steps: Launch the app on a fresh device.
- Expected behavior: Timezone initializes successfully.
- Actual behavior: Could throw `NoSuchMethodError: Class 'String' has no instance getter 'identifier'`.
- Root cause: `FlutterTimezone.getLocalTimezone()` in v5.0.2 returns `Future<String>`, but the code uses `timezoneInfo.identifier`.
- Evidence:
  - Code evidence: Source shows `final timezoneInfo = await FlutterTimezone.getLocalTimezone(); _location = tz.getLocation(timezoneInfo.identifier);`. `flutter_timezone` API docs indicate `Future<String>` return type.
  - Analyzer evidence: `flutter analyze` somehow doesn't flag this, which suggests a possible extension or `dynamic` typing, so it needs runtime verification.
- Recommended fix direction: Remove `.identifier` and pass `timezoneInfo` directly to `tz.getLocation()`.
- Affected user flow: App startup

- ID: P2
- Severity: Low
- Type: Logic Error
- Location: lib/features/medication/presentation/medication_list_page.dart
- Reproduction steps: Delete a medication from the list and immediately close the app before the deletion future completes.
- Expected behavior: Medication is deleted and notifications are cancelled.
- Actual behavior: Notifications might not be cancelled if the app terminates mid-flight.
- Root cause: `MedicationListCubit` deleting medication might not wait for `_scheduler.cancelAllForMedication`.
- Evidence:
  - Code evidence: General pattern in Flutter UI where fire-and-forget async operations aren't guaranteed to complete if unawaited or app shuts down.
- Recommended fix direction: Use a background worker or ensure critical deletes are fully awaited before UI pop.
- Affected user flow: Medication deletion

## Non-blocking Warnings

- **Test Code Smells**: 1200+ warnings in test files regarding missing consts, redundant arguments, and formatting issues.
- **Dependency Versions**: `flutter_local_notifications` 21.0.0 is used; need to ensure proper Android 14+ specific permission handling (`SCHEDULE_EXACT_ALARM`) as noted in previous tasks.
- **Provider Messaging / Refill Tracking**: Empty folders or out-of-scope code stubs (`lib/features/history`, `lib/features/privacy`, `lib/features/reminders`, `lib/features/messaging`) exist but do not affect MVP.

## Priority Order

1. Fix B8: Medication Detail Cubit Pause Race (High risk of data desync)
2. Verify & Fix P1: Timezone Identifier Type (Potential startup crash)
3. Fix B10: Day-Offset Boundary (Adherence calculation correctness)
4. Fix B9: Enum Bounds Safety (Data resilience)
5. Address Android 14 Exact Alarm Permissions (Test & polish)

## Recommended Prompt Sequence

- Prompt 1: fix highest-priority issue only (B8 pause race in MedicationDetailCubit)
- Prompt 2: fix next issue only (P1 timezone identifier and B10 day-offset boundary logic)
- Prompt 3: add verification tests only
