# Architecture Decisions

## Recommended Flutter Project Structure

```
takeyourpills/
├── lib/
│   ├── app.dart                          # App root widget + MultiBlocProvider
│   ├── main.dart                         # Entry point; init services, run app
│   ├── core/
│   │   ├── error/
│   │   │   ├── app_error.dart            # Base error class
│   │   │   ├── failure.dart              # Domain failure union (freezed)
│   │   │   └── error_handler.dart        # Global error handler, logging
│   │   ├── usecases/
│   │   │   └── (empty or base usecase)   # Optional: clean architecture use cases
│   │   ├── entities/
│   │   │   ├── medication.dart           # Freezed medication entity
│   │   │   ├── schedule.dart             # Freezed schedule entity
│   │   │   └── dose_log.dart             # Freezed dose log entity
│   │   ├── utils/
│   │   │   ├── date_extensions.dart      # DateTime helpers (isSameDay, toLocalString)
│   │   │   ├── validators.dart           # Form validators (dosage, name)
│   │   │   └── constants.dart            # App constants (max medications, snooze durations)
│   │   └── di/
│   │       └── service_locator.dart      # get_it registration
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── presentation/
│   │   │   │   ├── onboarding_page.dart
│   │   │   │   └── widgets/
│   │   │   ├── data/
│   │   │   │   ├── onboarding_repository.dart
│   │   │   │   └── datasources/
│   │   │   └── domain/
│   │   │       └── (could embed in presentation for simple flow)
│   │   ├── medication/
│   │   │   ├── domain/
│   │   │   │   ├── medication.dart       # Freezed entity + copyWith, ==, toString
│   │   │   │   ├── medication_repository.dart (interface)
│   │   │   │   └── entities/ (if not in core)
│   │   │   ├── data/
│   │   │   │   ├── medication_repository_impl.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── medication_local_datasource.dart  (Drift DAO wrapper)
│   │   │   │   │   └── medication_remote_datasource.dart (future: Firebase)
│   │   │   │   ├── mappers/
│   │   │   │   │   ├── medication_mapper.dart
│   │   │   │   │   └── schedule_mapper.dart
│   │   │   │   └── models/
│   │   │   │       ├── medication_model.dart  (Drift table + fromEntity/toEntity)
│   │   │   │       └── schedule_model.dart
│   │   │   └── presentation/
│   │   │       ├── medication_list/
│   │   │       │   ├── medication_list_page.dart
│   │   │       │   ├── medication_list_view.dart
│   │   │       │   ├── widgets/
│   │   │       │   │   ├── medication_card.dart
│   │   │       │   │   ├── medication_list_tile.dart
│   │   │       │   │   └── empty_medication_state.dart
│   │   │       │   └── cubit/
│   │   │       │       ├── medication_list_cubit.dart
│   │   │       │       ├── medication_list_state.dart (freezed)
│   │   │       │       └── medication_list_cubit_test.dart
│   │   │       ├─ medication_detail/
│   │   │       │   ├── medication_detail_page.dart
│   │   │       │   ├── medication_detail_view.dart
│   │   │       │   ├── cubit/
│   │   │       │   │   └── medication_detail_cubit.dart (or stateful)
│   │   │       │   └── widgets/
│   │   │       │       └── pause_resume_fab.dart
│   │   │       └── add_edit_medication/
│   │   │           ├── add_edit_medication_page.dart (multi-step form)
│   │   │           ├── widgets/
│   │   │           │   ├── step1_identity.dart
│   │   │           │   ├── step2_schedule.dart
│   │   │           │   ├── step3_inventory.dart
│   │   │           │   ├── icon_picker.dart
│   │   │           │   └── time_picker_field.dart
│   │   │           └── cubit/
│   │   │               ├── add_medication_cubit.dart
│   │   │               └── add_medication_state.dart (freezed)
│   │   ├── dashboard/
│   │   │   ├── presentation/
│   │   │   │   ├── dashboard_page.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── greeting_header.dart
│   │   │   │   │   ├── adherence_ring.dart
│   │   │   │   │   ├── next_dose_card.dart
│   │   │   │   │   ├── upcoming_list.dart
│   │   │   │   │   └── missed_dose_alert.dart
│   │   │   │   └── cubit/
│   │   │   │       ├── dashboard_cubit.dart
│   │   │   │       └── dashboard_state.dart (freezed)
│   │   │   └── (data/domain minimal; mostly UI)
│   │   ├── reminders/
│   │   │   ├── data/
│   │   │   │   └── datasources/
│   │   │   │       └── notification_local_datasource.dart
│   │   │   ├── domain/
│   │   │   │   ├── dose_log_repository.dart
│   │   │   │   └── entities/ (dose_log from core)
│   │   │   └── presentation/
│   │   │       ├── reminder_action_sheet_page.dart
│   │   │       └── widgets/
│   │   │           ├── action_button_take.dart
│   │   │           ├── action_button_snooze.dart
│   │   │           └── action_button_skip.dart
│   │   ├── history/
│   │   │   ├── presentation/
│   │   │   │   ├── history_page.dart (list)
│   │   │   │   ├── calendar_page.dart
│   │   │   │   ├── progress_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── history_list_tile.dart
│   │   │   │       ├── calendar_day_cell.dart
│   │   │   │       ├── adherence_chart.dart
│   │   │   │       └── streak_counter.dart
│   │   │   └── cubit/
│   │   │       ├── history_cubit.dart
│   │   │       └── progress_cubit.dart
│   │   ├── settings/
│   │   │   ├── presentation/
│   │   │   │   ├── settings_page.dart
│   │   │   │   ├── notification_settings_page.dart
│   │   │   │   ├── privacy_settings_page.dart
│   │   │   │   ├── appearance_settings_page.dart
│   │   │   │   ├── about_page.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── settings_tile.dart
│   │   │   │       ├── settings_switch.dart
│   │   │   │       └── settings_dropdown.dart
│   │   │   └── cubit/
│   │   │       ├── settings_cubit.dart
│   │   │       └── settings_state.dart (freezed)
│   │   └── messaging/
│   │       ├── presentation/
│   │       │   ├── provider_messaging_page.dart (thread list)
│   │       │   ├── conversation_page.dart
│   │       │   ├── composer_page.dart
│   │       │   └── widgets/
│   │       │       ├── message_bubble.dart
│   │       │       └── medication_attachment_chip.dart
│   │       └── cubit/
│   │           ├── messaging_cubit.dart
│   │           └── messaging_state.dart (freezed)
│   ├── shared/
│   │   ├── components/                  # Reusable UI components
│   │   │   ├── app_card.dart
│   │   │   ├── app_button.dart
│   │   │   ├── app_input.dart
│   │   │   ├── app_chip.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── error_widget.dart
│   │   │   └── empty_state_widget.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart           # ThemeData, color scheme, text styles
│   │   │   ├── theme_extensions.dart    # Custom colors if needed
│   │   │   ├── app_colors.dart          # Generated from DESIGN.md
│   │   │   └── app_text_styles.dart     # Manrope styles
│   │   ├── routing/
│   │   │   ├── app_router.dart          # GoRouter configuration
│   │   │   ├── routes.dart              # Route name constants
│   │   │   └── route_guards.dart        # Auth/onboarding guards
│   │   ├── services/
│   │   │   ├── database_service.dart    # Drift DB singleton
│   │   │   ├── notification_service.dart
│   │   │   ├── preference_service.dart  # SharedPreferences wrapper
│   │   │   ├── secure_storage_service.dart
│   │   │   ├── dose_log_service.dart    # Business logic for logging & adherence
│   │   │   ├── reminder_scheduler.dart  # Notification scheduling orchestration
│   │   │   ├── refill_service.dart      # Inventory management logic
│   │   │   ├── adherence_service.dart   # Adherence calculation
│   │   │   └── data_export_service.dart
│   │   ├── extensions/                  # Dart extensions
│   │   │   ├── date_extensions.dart
│   │   │   └── string_extensions.dart
│   │   └── constants/
│   │       ├── app_constants.dart       # Max medications, default snooze durations
│   │       ├── notification_constants.dart
│   │       └── text_constants.dart      # Strings (or use ARB for i18n later)
│   └── generated/                       # build_runner generated files (drift, freezed, json_serializable)
├── test/
│   ├── unit/
│   │   ├── core/
│   │   │   ├── utils/
│   │   │   └── di/
│   │   ├── features/
│   │   │   ├── medication/data/
│   │   │   │   ├── medication_repository_impl_test.dart
│   │   │   │   └── datasources/
│   │   │   ├── medication/domain/ (if usecases)
│   │   │   └── medication/presentation/
│   │   │       ├── cubit/
│   │   │       │   ├── medication_list_cubit_test.dart
│   │   │       │   └── add_medication_cubit_test.dart
│   │   │       └── widgets/
│   │   ├── shared/
│   │   │   ├── services/
│   │   │   │   ├── notification_service_test.dart (mocked)
│   │   │   │   ├── reminder_scheduler_test.dart
│   │   │   │   └── dose_log_service_test.dart
│   │   │   └── utils/
│   │   └── widgets/ (golden tests if used)
│   ├── widget/
│   │   ├── features/
│   │   │   ├── medication/
│   │   │   │   ├── add_edit_medication_page_test.dart
│   │   │   │   ├── medication_list_page_test.dart
│   │   │   │   └── medication_card_test.dart
│   │   │   ├── dashboard/
│   │   │   │   ├── dashboard_page_test.dart
│   │   │   │   ├── adherence_ring_test.dart
│   │   │   │   └── next_dose_card_test.dart
│   │   │   ├── reminders/
│   │   │   │   └── reminder_action_sheet_page_test.dart
│   │   │   └── settings/
│   │   │       └── notification_settings_page_test.dart
│   │   └── shared/
│   │       ├── components/
│   │       │   ├── app_button_test.dart
│   │       │   ├── app_card_test.dart
│   │       │   └── app_input_test.dart
│   │       └── theme/
│   │           └── app_theme_test.dart
│   └── integration/
│       ├── app_start_to_dashboard_test.dart
│       ├── add_medication_and_schedule_test.dart
│       ├── reminder_notification_and_log_test.dart
│       └── settings_change_and_persist_test.dart
├── assets/
│   ├── icons/                           # Custom app icons (medication icons set)
│   ├── images/                          # Illustrations (empty states, onboarding)
│   ├── fonts/                           # Manrope if bundled locally (not GoogleFonts)
│   └── sounds/                          # Notification sounds (optional)
├── android/
├── ios/
├── .github/
│   └── workflows/
│       └── ci.yaml                      # CI pipeline: test, analyze, build
├── .metadata
├── analysis_options.yaml                # Strict lint rules
├── leptok.css?                          # Custom Lint rules (optional)
├── pubspec.yaml
├── README.md
└── memory-bank/                         # Planning files (our output)
```

**Key Structural Principles:**
- **Feature-first**: All code for a feature lives under `features/<feature_name>/`
- **Clean separation**: `domain/` (entities, repos interfaces), `data/` (DAOs, mappers, repo impls), `presentation/` (pages, widgets, cubits)
- **Shared code**: Cross-feature utilities in `shared/` (components, theme, services)
- **Core**: Truly global entities and error types in `core/`
- **Generated**: All code generation output kept in `lib/generated/` to keep source clean

---

## Why Bloc vs Cubit in Specific Parts

### Use Cubit when:
- **Simple state** with few states and no complex transitions
- **Single stream of state** with straightforward mutation methods
- **No need for events**; state changes via method calls directly
- **Low complexity** and minimal business logic

**Recommended for:**
- `SettingsCubit` - simple toggle state (boolean, enum selections)
- `AddMedicationCubit` - form state progression (step navigation + field values)
- `MedicationListCubit` - list loading with simple CRUD triggers
- `DashboardCubit` - data aggregation with straightforward refresh method

**Rationale:** Cubit reduces boilerplate. These states are simple enough that full Bloc event/state separation adds no value.

### Use Bloc when:
- **Complex state transitions** require explicit event handling
- **Multiple streams** of events (user actions, external events, timers)
- **Need to log/hold events** for debugging or replay
- **Multiple independent operations** that can be triggered in various orders
- **Long-lived processes** with substates (loading → success → error → retry)

**Recommended for:**
- `ReminderActionSheetBloc` - handles Take/Snooze/Skip events, each with different side effects and API calls
- `ProviderMessagingBloc` - receives inbound messages (push) and user sends; two event sources
- `HistoryBloc` - handles filter change events, date range selection, pagination

**Rationale:** Explicit `mapEventToState` makes logging/debugging easier for non-linear flows. Events can be replayed in tests.

---

## Routing Approach with go_router

### Configuration
```dart
final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final onboardingComplete = prefService.onboardingComplete;
    final isOnboardingRoute = state.matchedLocation == '/onboarding';
    if (!onboardingComplete && !isOnboardingRoute) return '/onboarding';
    if (onboardingComplete && isOnboardingRoute) return '/dashboard';
    return null;
  },
  routes: [
    GoRoute(path: '/', redirect: '/dashboard'),
    GoRoute(path: '/onboarding', page: ...),
    GoRoute(
      path: '/dashboard',
      page: ...,
      routes: [
        GoRoute(path: 'medications', page: ...),
        GoRoute(path: 'add-medication', page: ...),
        GoRoute(path: 'medication/:id', page: ...),
        GoRoute(path: 'history', page: ...),
        GoRoute(path: 'calendar', page: ...),
        GoRoute(path: 'progress', page: ...),
        GoRoute(path: 'settings', page: ...),
        GoRoute(path: 'messaging', page: ...),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
);
```

### Navigation Patterns
- **BottomNavigationBar** uses `context.go('/dashboard')` etc. with `GoRouter` of `ShellRoute` for persistent layout
- **Detail → Edit**: `context.push('/medication/$id/edit')`
- **Return with result**: `context.pop(result)` for "Save" actions returning to previous screen
- **Deep linking**: Not needed for MVP; future: `takeyourpills://medication/123/log`

### Route Guards
- Onboarding guard: ensure user has seen intro before accessing main app
- Notification permission guard: optional warning banner if permissions denied

---

## Local Persistence Strategy with Drift

### Database Schema

**Tables:**
```sql
-- Medications
CREATE TABLE medications (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  dosage_amount REAL NOT NULL,
  dosage_unit TEXT NOT NULL, -- 'mg', 'mcg', 'g', 'ml'
  icon_name TEXT NOT NULL, -- Material icon name
  color_hex TEXT, -- Optional custom color
  is_paused INTEGER DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- Schedules (one medication can have multiple)
CREATE TABLE schedules (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  medication_id INTEGER NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
  hour INTEGER NOT NULL, -- 0-23
  minute INTEGER NOT NULL, -- 0-59
  weekdays_bitfield INTEGER DEFAULT 127, -- bit 0=Mon, 1=Tue, ... 6=Sun; 127 = all days
  is_as_needed INTEGER DEFAULT 0,
  CONSTRAINT unique_schedule UNIQUE (medication_id, hour, minute, weekdays_bitfield)
);

-- Dose logs
CREATE TABLE dose_logs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  medication_id INTEGER NOT NULL REFERENCES medications(id),
  schedule_id INTEGER REFERENCES schedules(id),
  scheduled_time TEXT NOT NULL, -- stored as ISO string in UTC? or local?
  actual_time TEXT, -- when logged (null if not yet logged)
  status TEXT NOT NULL DEFAULT 'pending', -- 'pending', 'taken', 'snoozed', 'skipped', 'missed'
  snooze_count INTEGER DEFAULT 0,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- Refill tracking (can be embedded in medications, but separate for history)
CREATE TABLE refill_tracking (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  medication_id INTEGER UNIQUE NOT NULL REFERENCES medications(id) ON DELETE CASCADE,
  current_quantity INTEGER NOT NULL DEFAULT 0,
  refill_threshold INTEGER NOT NULL DEFAULT 10,
  last_refill_date TEXT,
  notes TEXT
);

-- Message threads (Phase 6)
CREATE TABLE message_threads (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  provider_name TEXT NOT NULL,
  provider_contact TEXT,
  created_at TEXT NOT NULL
);
CREATE TABLE messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  thread_id INTEGER NOT NULL REFERENCES message_threads(id) ON DELETE CASCADE,
  is_outbound INTEGER NOT NULL DEFAULT 0,
  text TEXT NOT NULL,
  attachment_medication_id INTEGER REFERENCES medications(id),
  created_at TEXT NOT NULL
);
```

### Timezone Handling
- All times stored as **local time** (hour, minute) in schedules table
- `scheduled_time` in `dose_logs` stored as **local ISO string** (no timezone conversion) for historical accuracy
- Date calculations use `tz` package to get current local time; notifications use local timezone
- **Do not** store naive UTC; preserve user's local time for display

### Migrations
- Use Drift's `Migration` class with versioned schema changes
- Before migration, create backup of database file
- Test migrations on devices with real data

---

## Notifications Scheduling Strategy

### Architecture
```
NotificationService (low-level wrapper around flutter_local_notifications)
    ↑
ReminderScheduler (orchestrator)
    ↑
MedicationRepository (listens to medication/schedule changes)
    ↑
DoseLogRepository (logs dose → triggers reschedule)
```

### Scheduling Flow
1. **Medication created** → `ReminderScheduler.scheduleForMedication(med)`
   - Get all schedules for med
   - For each schedule, generate occurrences for next 30 days (or 90)
   - Call `NotificationService.schedule()` for each occurrence

2. **Medication updated** → `ReminderScheduler.rescheduleForMedication(med)`
   - Cancel all pending notifications for that med (by matching medicationId in payload)
   - Re-schedule new occurrences

3. **Medication deleted** → `ReminderScheduler.cancelForMedication(medId)`
   - Cancel all notifications for that med

4. **Dose logged (Taken/Snoozed)** → `ReminderScheduler.handleDoseLog(log)`
   - If recurring daily: schedule next day's dose at same time
   - If specific weekdays: find next matching weekday
   - If snoozed: schedule for `scheduledTime + snoozeDuration`

5. **App startup** → `ReminderScheduler.rescheduleAll()`
   - Reads all medications + schedules
   - Rebuilds all pending notifications (in case app was uninstalled/reinstalled or device rebooted)
   - Called from `main()` after DI container ready

### Exact Alarms (Android 14+)
- Add `<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>` to AndroidManifest.xml
- Request permission via `ExactAlarmPermissionAndroidX` plugin or platform channel
- Explain in UI: "Allow exact alarms so your reminders fire at the right time"
- If denied, fall back to inexact alarms; show persistent banner encouraging grant

### Notification Channels
- **Android:**
  - `medication_reminders` (importance: high, sound enabled, exact alarm)
  - `refill_alerts` (importance: default, sound optional)
- **iOS:**
  - Use `UNNotificationCategory` with `UNNotificationAction` for Take/Snooze/Skip
  - Request `UNAuthorizationOptions.critical` if possible for exact timing; otherwise `UNAuthorizationOptions.alert | sound`

### Payload Design
```json
{
  "doseId": 12345,
  "medicationId": 678,
  "scheduledTime": "2026-04-29T08:00:00", // local
  "type": "reminder"
}
```
- Keep payload minimal; fetch details from DB when action sheet opens
- Avoid embedding medication name in payload to keep notification compact; fetch from DB for Action Sheet display

---

## Settings Persistence Strategy

### Preference Keys (SharedPreferences)
```dart
class PrefKeys {
  static const onboardingComplete = 'onboarding_complete';
  static const notificationsEnabled = 'notifications_enabled';
  static const quietHoursStart = 'quiet_hours_start'; // int minutes from midnight
  static const quietHoursEnd = 'quiet_hours_end';
  static const defaultSnoozeMinutes = 'default_snooze_minutes';
  static const notificationSound = 'notification_sound';
  static const themeMode = 'theme_mode'; // 'light', 'dark', 'system'
  static const fontSizeMultiplier = 'font_size_multiplier';
  static const providerName = 'provider_name';
  static const providerContact = 'provider_contact';
}
```

### Sensitive Data (flutter_secure_storage)
- `provider_contact` (phone/email) - encrypted storage
- Any future authentication tokens (Phase 2)

### Migration Path
- Start with `SharedPreferences` for all
- If encryption needed later, migrate keys to `flutter_secure_storage` transparently on first read

---

## Error Handling Strategy

### Error Types
- **AppError** base class with `message` and `stackTrace`
- **DatabaseError** for SQLite failures
- **NotificationError** for scheduling failures
- **PermissionError** for missing OS permissions
- **ValidationError** for form validation

### Handling Patterns
- **UI exceptions:** Catch at UI layer (BlocListener or Cubit) → show SnackBar/ErrorDialog
- **Repository errors:** Catch in Cubit → emit Error state → UI displays error widget with retry
- **Global errors:** `runZonedGuarded` in `main()` catches unhandled → log to Crashlytics → show generic error screen
- **Network errors:** Not applicable until Phase 2; still design `NetworkException`

### Example: Repository level
```dart
class MedicationRepositoryImpl {
  Future<void> addMedication(Medication med) async {
    try {
      await db.medicationDao.insert(med.toModel());
    } on DatabaseException catch (e) {
      throw DatabaseError('Failed to insert: ${e.message}');
    }
  }
}
```

### Example: Cubit level
```dart
if (state is AddMedicationStep2 && form.valid) {
  emit(AddMedicationLoading());
  try {
    await repository.addMedication(medication);
    emit(AddMedicationSuccess());
  } on AppError catch (e) {
    emit(AddMedicationError(e.message));
  }
}
```

---

## Dependency Injection Strategy

### Using get_it
```dart
final getIt = GetIt.instance;

void init() {
  // Services (singletons)
  getIt.registerLazySingleton<DatabaseService>(() => DatabaseService());
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<PreferenceService>(() => PreferenceService());
  getIt.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  getIt.registerLazySingleton<DoseLogService>(() => DoseLogService(
    db: getIt<DatabaseService>(),
    notification: getIt<NotificationService>(),
  ));
  getIt.registerLazySingleton<ReminderScheduler>(() => ReminderScheduler(
    notificationService: getIt<NotificationService>(),
    doseLogService: getIt<DoseLogService>(),
  ));
  getIt.registerLazySingleton<AdherenceService>(() => AdherenceService(
    db: getIt<DatabaseService>(),
  ));
  
  // Repositories
  getIt.registerFactory<MedicationRepository>(() => MedicationRepositoryImpl(
    medicationDao: getIt<DatabaseService>().medicationDao,
  ));
  
  // Cubits
  getIt.registerFactory<MedicationListCubit>(() => MedicationListCubit(
    repository: getIt<MedicationRepository>(),
  )..loadMedications());
}
```

### Testing: overrides for mocks
```dart
getIt.registerFactory<MedicationRepository>(
  () => MockMedicationRepository(),
);
```

---

## Model / Entity Mapping Strategy

### Layering
- **Domain layer:** Freezed entities (`Medication`, `Schedule`, `DoseLog`) in `core/entities/`
- **Data layer:** Drift models (`MedicationModel`, `ScheduleModel`, `DoseLogModel`) as `@Table()` classes
- **Mappers:** Static methods or separate mapper classes to convert between Model ↔ Entity

### Example
```dart
// medication_model.dart
@DataClassName('medication')
class Medications extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // ...
  Medication fromModel(MedicationData data) => Medication(
    id: data.id,
    name: data.name,
    // ...
  );
  MedicationData toModel(Medication med) => MedicationData(
    id: med.id,
    name: med.name,
    // ...
  );
}
```

**Why this approach?** Keeps domain layer pure (no Drift dependency). Mappers isolated in `data/mappers/` for easy testing and future remote data source additions.

---

## Testing Strategy

### Unit Tests (fast, isolated)
- **Cubits/Blocs:** Use `bloc_test` for state verification; mock repositories
- **Services:** Mock dependencies (e.g., `NotificationService` using mockito); test pure logic
- **DAOs:** Use `drift_test` with in-memory database; test SQL queries
- **Entities:** Test `freezed` equality, `copyWith`, `toJson/fromJson`

**Target:** 80% code coverage on all `lib/` except UI render code

### Widget Tests (UI components)
- **Pages:** Render full screen; verify widgets appear; interact with tap/enter text; verify state changes
- **Components:** Golden tests for pixel-perfect rendering of shared components
- **Accessibility:** Verify semantic labels present

**Target:** 50% coverage of widget files; 100% for critical shared components (buttons, inputs)

### Integration Tests (end-to-end)
- **Flows:** Use `integration_test` package; run on emulator/device
  - [ ] Onboarding → Add 2 meds → Dashboard shows both
  - [ ] Notification truncation → Action Sheet → Log taken
  - [ ] Set quiet hours → notification delayed correctly
  - [ ] Export data → file appears
  - [ ] Delete all data → fresh start

**Target:** 5-10 critical user journeys fully automated

---

## Scalability Notes for Future Backend Sync

### Local-First Foundation Benefits
- All data operations currently go through repository interfaces
- Already separated into `MedicationRepository` with `MedicationLocalDataSource` and future `MedicationRemoteDataSource`
- Sync will be additive, not replacement

### Sync Architecture (Phase 2)
- Introduce `RemoteMedicationDataSource` (Firebase Remote Config or Firestore)
- Add `SyncManager` service that queues local changes and pulls remote updates
- Use `device_id` or `user_id` to scope data
- Conflict resolution: Last-write-wins with timestamp; manual merge UI if needed
- Encryption: encrypt data before upload (AES-256); key derived from user passphrase or stored in secure storage

### Modularity for Multiple Users (Caregiver Mode)
- Table `users` (id, name, role)
- `medications` add `owner_user_id`
- `caregiver_sharing` table: caregiver_user_id ↔ patient_user_id, permissions (view-only, edit)
- Local-only in MVP; sync will replicate caregiver relationships from cloud

---

## Decision Log

| Decision | Status | Rationale | Alternatives Considered |
|----------|--------|-----------|------------------------|
| **Use Drift over sqflite** | Confirmed | Type-safe, reactive streams, migrations easy; less boilerplate | sqflite (raw SQL), Hive (NoSQL), Floor (similar to Drift but less mature) |
| **Bloc/Cubit over Provider/Riverpod** | Confirmed | Predictable state; testable; explicit; team familiarity | Provider (simpler but less structure), Riverpod (more powerful but steeper learning curve) |
| **go_router over auto_route** | Confirmed | Officially recommended by Flutter team; declarative; deep linking easy | auto_route (codegen verbose), Beamer (less maintained) |
| **get_it over Riverpod's DI** | Confirmed | Simple service locator; decoupled from UI layer; easy to override in tests | Riverpod (tightly coupled), GetIt (chosen) |
| **Freezed over manual codegen** | Confirmed | Immutability + copyWith + equality + union types for state/result | BuiltValue (more complex), manual (error-prone) |
| **Local-first (no cloud)** | Confirmed MVP | Privacy, simplicity, no backend cost, works offline | Firebase from start (adds complexity, auth requirement) |
| **Use flutter_secure_storage for all prefs** | Rejected | Overkill for simple settings; use SharedPreferences for non-sensitive | flutter_secure_storage (slower, more complex) |
| **Exact alarms vs. inexact** | Confirmed | Medication timing is critical; Android 14 requires explicit permission | Inexact (battery-friendly but less reliable) |
| **Single database table for logs** | Confirmed | Simpler queries; denormalization fine for small dataset | Fully normalized (med, schedule, log separate) → too complex |
| **Notification payload contains doseId only** | Confirmed | Minimal payload size; fetch details from DB when needed | Embed medication name (convenient but bloats payload) |
| **Material Icons over custom icons** | Confirmed | Already available; design system uses Material Icons variants | Custom SVG icons (more work, larger asset bundle) |
| **Onboarding cannot be skipped** | Rejected | Allow skipping; show contextual hints later | Mandatory intro (annoying) |
| **Provider messaging local-only in MVP** | Confirmed | Avoid needing backend; user can copy message to SMS | Full backend chat (out of scope) |
| **Strict clean architecture layers** | Deferred | Too heavy for MVP; use feature-first with clear separation but not 4-layer | Full clean architecture (data/domain/presentation + use cases) |
| **Bloc for all features** | Partially | Use Bloc where event complexity warrants, otherwise Cubit | All Cubit (simpler) or all Bloc (more consistent) |

---

**Last Updated:** 2026-04-29  
**Status:** Draft  
**Open Decisions:** None pending; all proposed decisions documented
