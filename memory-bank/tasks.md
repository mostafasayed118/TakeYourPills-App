# Tasks (Prioritized Backlog)

## Epics & Features

```
EPIC-1: Project Setup & Infrastructure
  F1: Flutter project initialization
  F2: Dependency configuration
  F3: Folder structure creation
  F4: Design system implementation (theme, colors, typography)

EPIC-2: Core Database & State Management
  F5: Drift database schema design and implementation
  F6: Entity models (Freezed) creation
  F7: Repository pattern setup
  F8: get_it service locator
  F9: go_router routing foundation

EPIC-3: Medication CRUD
  F10: Medication domain entities and mappers
  F11: Medication DAOs and Drift tables
  F12: MedicationListCubit (load, list, delete, pause)
  F13: AddMedicationCubit (multi-step form state)
  F14: Medication List UI screen
  F15: Add Medication screen (Forms)
  F16: Medication Detail / Edit screen
  F17: Empty states and error handling

EPIC-4: Reminder Notifications
  F18: NotificationService initialization and permission flow
  F19: Timezone configuration
  F20: Notification scheduling logic (ReminderScheduler)
  F21: Action Sheet UI (Bottom sheet)
  F22: Dose logging flow (Take/Snooze/Skip)
  F23: Missed dose detection
  F24: Quiet hours and notification settings integration

EPIC-5: Home Dashboard
  F25: DashboardCubit and data aggregation
  F26: Adherence score calculation service
  F27: Dashboard UI (greeting, ring, next dose, upcoming)
  F28: Missed dose alert banner
  F29: Real-time integration with medication/log data

EPIC-6: History & Progress
  F30: HistoryCubit and query logic
  F31: History list screen (filterable)
  F32: Calendar view with color-coded days
  F33: Progress charts (line graph, 7d/30d/90d)
  F34: Streak counter
  F35: Refill tracker UI and logic
  F36: Data export service (CSV/JSON)

EPIC-7: Settings & Privacy
  F37: SettingsCubit and preference persistence
  F38: Notification settings screen (toggle, quiet hours, snooze duration, sound)
  F39: Privacy settings screen (export, clear data)
  F40: Appearance settings (theme, font scale)
  F41: Data wipe implementation
  F42: About / legal screens

EPIC-8: Provider Messaging
  F43: Messaging domain entities and tables
  F44: Messaging repository and DAO
  F45: Conversation list UI
  F46: Message thread UI
  F47: Composer with medication attachment
  F48: Draft saving

EPIC-9: Testing & Polish
  F49: Unit tests for Cubits
  F50: Unit tests for DAOs
  F51: Unit tests for services
  F52: Widget tests for screens
  F53: Golden tests for components
  F54: Integration tests for key flows
  F55: Accessibility audit
  F56: Performance profiling & optimization
  F57: Crashlytics integration

EPIC-10: Release & Beta
  F58: CI/CD setup (GitHub Actions)
  F59: Build flavors (dev, beta, prod)
  F60: Internal testing build
  F61: Bug fix iteration
  F62: Release candidate
```

---

## Detailed Task List

| ID | Epic | Feature | Task Description | Status | Dependencies | Est. Order |
|----|------|---------|------------------|--------|--------------|------------|
| T001 | EPIC-1 | F1 | Create Flutter project; configure `pubspec.yaml` with all dependencies | todo | none | 1 |
| T002 | EPIC-1 | F1 | Set up `analysis_options.yaml` with strict lint rules | todo | T001 | 2 |
| T003 | EPIC-1 | F2 | Add all required dependencies to `pubspec.yaml` | todo | T001 | 3 |
| T004 | EPIC-1 | F3 | Create feature-first folder structure (`lib/features/`, `lib/shared/`) | todo | T001 | 4 |
| T005 | EPIC-1 | F4 | Extract design tokens from DESIGN.md → `app_theme.dart` and `app_colors.dart` | todo | T001 | 5 |
| T006 | EPIC-1 | F4 | Configure Manrope font (GoogleFonts or asset) | todo | T005 | 6 |
| T007 | EPIC-1 | F4 | Create `TextTheme` with TextStyle for all typography styles | todo | T006 | 7 |
| T008 | EPIC-1 | F4 | Implement theme (light + dark) with Material 3 theming | todo | T007 | 8 |
| T009 | EPIC-1 | F4 | Create shared component base classes: `AppCard`, `AppButton`, `AppInput` | todo | T008 | 9 |
| T010 | EPIC-2 | F8 | Set up `get_it` service locator and register core services | todo | T004 | 10 |
| T011 | EPIC-2 | F9 | Configure `go_router` with placeholder routes and ShellRoute for bottom nav | todo | T004 | 11 |
| T012 | EPIC-2 | F9 | Create onboarding guard and redirect logic | todo | T011 | 12 |
| T013 | EPIC-2 | F5 | Design Drift database schema; create `AppDatabase` class | todo | T004 | 13 |
| T014 | EPIC-2 | F5 | Create Drift tables: `medications`, `schedules`, `dose_logs`, `refill_tracking` | todo | T013 | 14 |
| T015 | EPIC-2 | F5 | Generate database code with `build_runner` | todo | T014 | 15 |
| T016 | EPIC-2 | F6 | Create Freezed entities: `Medication`, `Schedule`, `DoseLog` | todo | T004 | 16 |
| T017 | EPIC-2 | F6 | Create mappers: `MedicationMapper`, `ScheduleMapper` (Model ↔ Entity) | todo | T015, T016 | 17 |
| T018 | EPIC-2 | F7 | Create `MedicationRepository` interface and `MedicationRepositoryImpl` | todo | T016, T017 | 18 |
| T019 | EPIC-2 | F7 | Create `DatabaseService` wrapper around Drift DB | todo | T015 | 19 |
| T020 | EPIC-2 | F7 | Create other services: `PreferenceService`, `SecureStorageService` | todo | T010 | 20 |

| T021 | EPIC-3 | F10 | Create `MedicationListCubit` with states and methods | todo | T018 | 21 |
| T022 | EPIC-3 | F12 | Create `AddMedicationCubit` with multi-step form state machine | todo | T016 | 22 |
| T023 | EPIC-3 | F14 | Build `MedicationListPage`: scaffold, list, FAB, pull-to-refresh | todo | T021, T009 | 23 |
| T024 | EPIC-3 | F14 | Build `MedicationCard` and `MedicationListTile` widgets | todo | T009 | 24 |
| T025 | EPIC-3 | F14 | Implement empty state for no medications | todo | T023 | 25 |
| T026 | EPIC-3 | F15 | Build `AddMedicationPage` step 1: identity & dosage form | todo | T022 | 26 |
| T027 | EPIC-3 | F15 | Build `AddMedicationPage` step 2: frequency & schedule builder | todo | T026 | 27 |
| T028 | EPIC-3 | F15 | Build `AddMedicationPage` step 3: inventory tracking | todo | T027 | 28 |
| T029 | EPIC-3 | F15 | Build icon picker widget | todo | T026 | 29 |
| T030 | EPIC-3 | F15 | Build time picker field with multiple time support | todo | T027 | 30 |
| T031 | EPIC-3 | F16 | Build `MedicationDetailPage` (read-only view) | todo | T021 | 31 |
| T032 | EPIC-3 | F16 | Implement edit flow (navigate to AddMedicationPage in edit mode) | todo | T031 | 32 |
| T033 | EPIC-3 | F16 | Implement pause/resume toggle and delete with confirmation | todo | T031 | 33 |
| T034 | EPIC-3 | F17 | Add error handling dialogs for DB failures | todo | T023 | 34 |
| T035 | EPIC-3 | F17 | Write unit tests for MedicationListCubit (bloc_test) | todo | T021 | 35 |
| T036 | EPIC-3 | F17 | Write unit tests for AddMedicationCubit | todo | T022 | 36 |
| T037 | EPIC-3 | F17 | Write DAO tests for medications, schedules tables (drift_test) | todo | T015 | 37 |
| T038 | EPIC-3 | F17 | Write widget tests for MedicationListPage and MedicationCard | todo | T023 | 38 |

| T039 | EPIC-4 | F18 | Create `NotificationService` wrapper; configure channels | todo | T001, T010 | 39 |
| T040 | EPIC-4 | F18 | Set up timezone database and local timezone data | todo | T039 | 40 |
| T041 | EPIC-4 | F18 | Implement permission request flow (onboarding + fallback) | todo | T039 | 41 |
| T042 | EPIC-4 | F18 | Request exact alarm permission (Android 14+) | todo | T039 | 42 |
| T043 | EPIC-4 | F19 | Create `ReminderScheduler` service (schedule/cancel/reschedule) | todo | T039, T018 | 43 |
| T044 | EPIC-4 | F19 | Implement schedule generation for a medication (next 30 days) | todo | T043 | 44 |
| T045 | EPIC-4 | F19 | Handle reschedule on medication create/edit/delete | todo | T043, T021 | 45 |
| T046 | EPIC-4 | F19 | Implement boot/reboot receiver to restore notifications (Android) | todo | T039 | 46 |
| T047 | EPIC-4 | F20 | Create `ReminderActionSheetPage` UI with three action buttons | todo | T009 | 47 |
| T048 | EPIC-4 | F20 | Implement "Take Now" → calls `DoseLogService.logDose(taken: true)` | todo | T043 | 48 |
| T049 | EPIC-4 | F20 | Implement "Snooze" with duration options; reschedule notification | todo | T043, T047 | 49 |
| T050 | EPIC-4 | F20 | Implement "Skip" logging with optional reason dialog | todo | T047 | 50 |
| T051 | EPIC-4 | F20 | Create `DoseLogService` (repository method to log dose) | todo | T018 | 51 |
| T052 | EPIC-4 | F22 | Implement missed dose detection (background timer or check on open) | todo | T043 | 52 |
| T053 | EPIC-4 | F22 | Show missed dose banner on dashboard when applicable | todo | T052 | 53 |
| T054 | EPIC-4 | F23 | Integrate notification settings: global toggle, quiet hours, per-med toggle | todo | T039, T037 | 54 |
| T055 | EPIC-4 | F23 | Implement quiet hours suppression logic | todo | T054 | 55 |
| T056 | EPIC-4 | F23 | Test notification scheduling on Android & iOS emulators | todo | T045 | 56 |
| T057 | EPIC-4 | F17 | Write unit tests for NotificationService (mocked) | todo | T039 | 57 |
| T058 | EPIC-4 | F17 | Write unit tests for ReminderScheduler | todo | T043 | 58 |
| T059 | EPIC-4 | F17 | Write widget tests for ReminderActionSheetPage | todo | T047 | 59 |

| T060 | EPIC-5 | F25 | Create `DashboardCubit` with load method and real-time subscription | todo | T021, T051 | 60 |
| T061 | EPIC-5 | F26 | Implement `AdherenceService` (calculate today's percentage) | todo | T051 | 61 |
| T062 | EPIC-5 | F26 | Implement method `getNextDose()` from schedules + logs | todo | T018 | 62 |
| T063 | EPIC-5 | F26 | Implement method `getUpcomingDoses()` for today | todo | T062 | 63 |
| T064 | EPIC-5 | F28 | Build dashboard widgets: Greeting, AdherenceRing, NextDoseCard | todo | T009 | 64 |
| T065 | EPIC-5 | F28 | Build `UpcomingList` widget with list tiles | todo | T009 | 65 |
| T066 | EPIC-5 | F28 | Build `MissedDoseAlert` banner widget | todo | T009 | 66 |
| T067 | EPIC-5 | F29 | Assemble `DashboardPage` with all widgets; wire cubit | todo | T060, T064, T065, T066 | 67 |
| T068 | EPIC-5 | F29 | Implement quick-log: tap "Log Taken" on NextDoseCard opens Action Sheet | todo | T067, T047 | 68 |
| T069 | EPIC-5 | F29 | Real-time updates: dashboard refreshes when dose logged | todo | T060 | 69 |
| T070 | EPIC-5 | F17 | Write widget tests for DashboardPage components | todo | T067 | 70 |
| T071 | EPIC-5 | F17 | Write unit tests for DashboardCubit | todo | T060 | 71 |

| T072 | EPIC-6 | F30 | Create `HistoryCubit` with filter state (date range, medication filter) | todo | T051 | 72 |
| T073 | EPIC-6 | F31 | Build `HistoryPage` with list of dose logs; use `HistoryCubit` | todo | T072 | 73 |
| T074 | EPIC-6 | F31 | Implement list item with status icon and timestamp | todo | T073 | 74 |
| T073 | EPIC-6 | F32 | Build `CalendarPage` using `TableCalendar` or custom grid | todo | T072 | 75 |
| T074 | EPIC-6 | F32 | Implement marker colors based on daily adherence | todo | T073 | 76 |
| T075 | EPIC-6 | F32 | Tap day → bottom sheet with detailed status per medication | todo | T074 | 77 |
| T076 | EPIC-6 | F33 | Build `ProgressPage` with stepper/tabs (7d/30d/90d) | todo | T072 | 78 |
| T077 | EPIC-6 | F33 | Implement line chart (fl_chart) showing daily adherence % | todo | T076 | 79 |
| T078 | EPIC-6 | F34 | Add streak counter logic (current and best) | todo | T061 | 80 |
| T079 | EPIC-6 | F35 | Build `RefillTrackerPage` list with low-stock warnings | todo | T018 | 81 |
| T080 | EPIC-6 | F36 | Implement `DataExportService` (CSV/JSON) | todo | T018 | 82 |
| T081 | EPIC-6 | F36 | Add "Export data" button to Privacy settings; share via share_plus | todo | T080 | 83 |
| T082 | EPIC-6 | F17 | Write widget tests for CalendarPage and ProgressPage | todo | T075 | 84 |
| T083 | EPIC-6 | F17 | Write unit tests for AdherenceService and RefillService | todo | T061 | 85 |

| T084 | EPIC-7 | F37 | Create `SettingsCubit` with load/save methods | todo | T010 | 86 |
| T085 | EPIC-7 | F38 | Build `SettingsPage` master list with navigation tiles | todo | T084 | 87 |
| T086 | EPIC-7 | F38 | Build `NotificationSettingsPage` with toggles and pickers | todo | T039 | 88 |
| T087 | EPIC-7 | F38 | Build `AppearanceSettingsPage` (theme mode, font scale) | todo | T084 | 89 |
| T088 | EPIC-7 | F39 | Build `PrivacySettingsPage` with export and clear data | todo | T084 | 90 |
| T089 | EPIC-7 | F40 | Implement clear all data (N-step confirmation with text entry) | todo | T088 | 91 |
| T090 | EPIC-7 | F41 | Build `AboutPage` with version, legal links | todo | T084 | 92 |
| T091 | EPIC-7 | F17 | Write widget tests for settings pages | todo | T085 | 93 |

| T092 | EPIC-8 | F43 | Create messaging entities: `MessageThread`, `Message` | todo | T016 | 94 |
| T093 | EPIC-8 | F43 | Create Drift tables `message_threads`, `messages` | todo | T013 | 95 |
| T094 | EPIC-8 | F44 | Create `MessagingRepository` and DAO | todo | T092, T093 | 96 |
| T095 | EPIC-8 | F45 | Build `ProviderMessagingPage` (list of threads) | todo | T094 | 97 |
| T096 | EPIC-8 | F46 | Build `ConversationPage` with message bubbles | todo | T094 | 98 |
| T097 | EPIC-8 | F47 | Build composer UI with medication attachment | todo | T096 | 99 |
| T098 | EPIC-8 | F48 | Implement draft autosave and "send" (copy to clipboard or SMS intent) | todo | T097 | 100 |
| T099 | EPIC-8 | F17 | Write widget tests for messaging screens | todo | T095 | 101 |

| T100 | EPIC-9 | F52 | Write widget tests for all remaining screens | todo | T067 | 102 |
| T101 | EPIC-9 | F49 | Write unit tests for all Cubits (≥80% coverage) | todo | T021 | 103 |
| T102 | EPIC-9 | F50 | Write unit tests for all DAOs (≥80% coverage) | todo | T015 | 104 |
| T103 | EPIC-9 | F51 | Write unit tests for services (Notification, Scheduler, DoseLog, etc.) | todo | T039 | 105 |
| T104 | EPIC-9 | F53 | Write golden tests for shared components (buttons, cards, inputs) | todo | T009 | 106 |
| T105 | EPIC-9 | F54 | Write integration tests: 3-5 key user journeys | todo | T067 | 107 |
| T106 | EPIC-9 | F55 | Conduct accessibility audit (TalkBack, contrast, font scaling) | todo | T067 | 108 |
| T107 | EPIC-9 | F56 | Profile app performance; fix memory leaks; optimize start time | todo | T067 | 109 |
| T108 | EPIC-9 | F57 | Integrate Firebase Crashlytics; test crash reporting | todo | T001 | 110 |

| T109 | EPIC-10 | F58 | Set up GitHub Actions CI workflow (test, analyze, build) | todo | T001 | 111 |
| T110 | EPIC-10 | F59 | Configure build flavors (dev, beta) and versioning | todo | T001 | 112 |
| T111 | EPIC-10 | F60 | Build and upload internal testing build (Firebase App Distribution) | todo | T107 | 113 |
| T112 | EPIC-10 | F61 | Collect internal test feedback; fix critical bugs | todo | T111 | 114 |
| T113 | EPIC-10 | F62 | Prepare release candidate build | todo | T112 | 115 |

---

## Next 3 Tasks (Immediate Actions)

Based on current planning stage (pre-initiation), the first tasks to execute are:

1. **T001: Create Flutter project** - Initialize the codebase with `flutter create takeyourpills`, configure folder structure, and commit initial empty project.
2. **T002: Set up analysis_options.yaml** - Configure strict linting to enforce code quality from day one.
3. **T003: Add dependencies to pubspec.yaml** - Include all required packages from the tech stack (flutter_bloc, freezed, drift, dio, get_it, etc.)

**Rationale:** Without a running Flutter project, no further development can occur. These three tasks create the foundational project environment.

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

## Estimation Notes

- Tasks are estimated in ideal days (6h focused work)
- Buffer of 20% included across all tasks for integration overhead
- Parallel tasks can reduce total timeline (e.g., F28/F29, F38/F39/F40)
- Testing tasks (F49–F54) include writing test code and debugging failures

---

**Last Updated:** 2026-04-29  
**Status:** All tasks `todo` (planning phase)  
**Sprint 0:** T001–T020 (Foundation)  
**Sprint 1:** T021–T038 (Medication CRUD)  
**Sprint 2:** T039–T059 (Notifications)  
**Sprint 3:** T060–T071 (Dashboard)  
**Sprint 4:** T072–T085 (History + Settings)  
**Sprint 5:** T086–T099 (Refill + Messaging)  
**Sprint 6:** T100–T108 (Testing + Polish)  
**Sprint 7:** T109–T113 (Release)
