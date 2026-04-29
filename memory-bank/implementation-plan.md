# Implementation Plan

## Recommended Implementation Phases

### Phase 0: Foundation (Week 1-2)
**Goal:** Project scaffolding, core infrastructure, design system integration, basic routing, and state management foundation.

**Deliverables:**
- Flutter project initialized with all dependencies
- Feature-first folder structure created
- Theme and design system implementation (colors, typography, spacing)
- Core routing with `go_router`
- DI container setup with `get_it`
- Drift database with initial schema (medication, dose, log tables)
- Localization setup (English ready; i18n structure for future)
- Basic error handling and logging infrastructure

---

### Phase 1: Core Medication CRUD (Week 3-4)
**Goal:** Add, edit, delete, and list medications with full schedule configuration.

**Deliverables:**
- Medication entity + DAO with Drift
- Cubit for medication list state (load, add, edit, delete, reorder)
- Add Medication screen (multi-step form)
- Medication List screen with empty state
- Medication detail/edit screen
- Form validation (dosage, name, times)
- Persistence and reactivity
- Unit tests for DAO and Cubit
- Widget tests for form fields

**Definition of Done:**
- Can create a medication with daily 8am schedule
- Medication appears in list immediately
- Edit updates database and UI
- Delete confirms and removes
- Data survives app restart

---

### Phase 2: Reminder Notifications (Week 5-6)
**Goal:** Schedule and fire local notifications at exact times with Action Sheet logging.

**Deliverables:**
- Notification service using `flutter_local_notifications` + `timezone`
- `NotificationScheduler` class to convert medication schedules into notifications
- Permission request flow during onboarding
- Background notification handling (Android: exact alarms, iOS: critical alerts)
- Reminder Action Sheet screen (bottom sheet UI with Take/Snooze/Skip)
- Logging flow from notification and Action Sheet
- Missed dose detection after 3-hour window
- Snooze rescheduling logic
- Notification settings integration (global and per-med toggles, quiet hours)

**Definition of Done:**
- Notification fires precisely at scheduled time
- Tapping notification opens Action Sheet
- "Take" logs dose instantly; "Snooze" reschedules
- Missed doses marked automatically after 3h
- All actions persist to database
- Works on Android & iOS with different permission models

---

### Phase 3: Home Dashboard & Today View (Week 7)
**Goal:** Main dashboard with adherence score, next dose hero, upcoming list, and missed alerts.

**Deliverables:**
- Dashboard screen Bloc/Cubit
- Adherence calculation service (today's %)
- Next dose card component
- Today's upcoming list (grouped by time)
- Missed dose alert banner
- Quick-log button on next dose card
- Integration with medication list and logs
- Empty states and loading states
- Widget tests for dashboard components

**Definition of Done:**
- Dashboard opens in <500ms
- Shows correct next dose based on current time
- Adherence updates live when dose logged
- Missed dose banner appears at 3h past due
- All UI matches design system

---

### Phase 4: History, Progress & Calendar (Week 8-9)
**Goal:** Past logs view, adherence charts, calendar heatmap, progress insights.

**Deliverables:**
- History screen with list of past logs (filterable)
- Calendar view with color-coded days
- Progress screen with line charts (7d/30d/90d)
- Streak counter logic
- Refill tracker screen with low-stock warnings
- Export data to CSV (local share)
- Integration with existing logs and medication data

**Definition of Done:**
- Calendar shows accurate status for each day
- Charts render smoothly with up to 1 year data
- Streak counter resets correctly on missed days
- Refill warnings appear when count ≤ threshold
- Export file opens in external app

---

### Phase 5: Settings & Privacy (Week 10)
**Goal:** Settings screens, notification preferences, privacy controls, data management.

**Deliverables:**
- Settings screen with navigation to sub-screens
- Notification settings (global toggle, quiet hours, snooze duration, sound)
- Privacy & sharing screen (data posture explanation, export, clear data)
- Data management: export all, delete all (with N-step confirmation)
- Theme switching (light/dark/system)
- About/version/legal screens
- Settings persistence using `shared_preferences` or `flutter_secure_storage`

**Definition of Done:**
- All settings persist across app restarts
- Changes take effect immediately
- Clear all data requires "DELETE" confirmation and irreversibly wipes DB
- Privacy screen clearly explains data philosophy

---

### Phase 6: Provider Messaging (Week 11)
**Goal:** In-app messaging interface (local-only), medication context attachment.

**Deliverables:**
- Provider messaging screen (thread view)
- Composer screen with medication selector to attach context
- Message history stored in DB
- "Send" action copies to clipboard or opens SMS (local-only, no backend)
- Provider contact info configuration
- Message draft auto-save

**Definition of Done:**
- User can compose message referencing specific medication
- Message history retained locally
- No crash when SMS app unavailable
- Clear disclaimer: messages not actually sent unless user uses external app

---

### Phase 7: Polish & Testing (Week 12-13)
**Goal:** Comprehensive testing, bug fixes, accessibility, performance optimization.

**Deliverables:**
- Unit tests: Cubits, services, DAOs (≥80% coverage)
- Widget tests: All screens (≥50% coverage)
- Integration tests: Core flows (add med → schedule → log)
- Accessibility audit (TalkBack/VoiceOver, contrast, font scaling)
- Performance profiling (cold start, memory leaks)
- Error handling validation (DB down, notification failures)
- Crashlytics integration and testing
- Beta test build (internal testing track)

**Definition of Done:**
- All tests passing on CI
- No critical or high-priority bugs open
- Performance metrics within NFR targets
- Accessibility checklist completed
- Build signed and uploaded to internal testing

---

## Milestones

| Milestone | Target Week | Deliverable |
|-----------|-------------|-------------|
| M0: Project Setup | Week 2 | Repo initialized, CI/CD, Flutter app runs on device/simulator |
| M1: Medication CRUD | Week 4 | Add/edit/delete medications working end-to-end |
| M2: Notifications | Week 6 | Reminders fire and log correctly; Action Sheet functional |
| M3: Dashboard | Week 7 | Home screen shows live data; adherence score accurate |
| M4: History & Progress | Week 9 | Calendar, charts, refill tracker operational |
| M5: Settings & Privacy | Week 10 | All preferences saved; data export/delete works |
| M6: Provider Messaging | Week 11 | Messaging UI complete; local-only storage |
| M7: Beta-Ready | Week 13 | Tested, performant, crash-free build ready for external testing |

---

## Dependencies

### External Dependencies
- Flutter SDK 3.5+ (stable)
- Android SDK (minimum API 23, target 34)
- iOS deployment target 13.0+
- Design assets (icons, illustrations) from Stitch design system
- Crashlytics Firebase project setup (requires Firebase console)

### Internal Code Dependencies (Sequential)
1. **Database schema** (needed before Cubits/services)
2. **Entity models** (before Cubits)
3. **Dependency injection** setup (before any service instantiation)
4. **Routing** (before screen navigation)
5. **Theme** (before screens)
6. **Notification service** (needed before scheduling logic)
7. **Cubits** (needed before UI screens)
8. **UI screens** (last, depends on all above)

### Parallelizable Work
- Theme + routing + DI can be built together (Phase 0)
- Medication CRUD and Notification service can be developed in parallel once DB is ready (Phases 1 & 2)
- Settings and History screens can be built in parallel after core medication/log data exists (Phases 4 & 5)
- Provider messaging independent of charts/calendar (can parallel with Phase 4)

---

## Suggested MVP Boundary

**MVP Must-Haves (Phase 0-3 deliverable):**

✓ Onboarding flow with permission request  
✓ Medication CRUD (add/edit/delete/pause)  
✓ Local notification reminders at scheduled times  
✓ Action Sheet logging (Take/Snooze/Skip)  
✓ Home Dashboard with adherence score, next dose, upcoming list  
✓ Basic missed dose alert  
✓ Refill tracking with low-stock warning  
✓ History list (last 30 days)  
✓ Basic settings (notifications toggle, quiet hours)  
✓ Privacy screen with data export & delete  
✓ Crashlytics  

**Post-MVP Additions (Phase 4+):**

- Calendar view
- Progress charts (graphs)
- Streak counter
- Provider messaging
- Export as CSV
- Font size adjustment
- Per-medication notification toggle
- Duplicate medication

**Rationale:** MVP focuses on the core loop: **schedule → remind → log → see adherence**. The calendar, charts, messaging, and advanced export are valuable but not essential for establishing the daily habit.

---

## Detailed Step-by-Step Build Sequence

### Week 1: Scaffold & Architecture (Phase 0)

**Day 1-2:** Project Setup
- [ ] Create Flutter project: `flutter create takeyourpills`
- [ ] Configure `analysis_options.yaml` with strict linting
- [ ] Set up `pubspec.yaml` with all required dependencies
- [ ] Configure `flutter_secure_storage` (Android: key store, iOS: Keychain)
- [ ] Set up Firebase Crashlytics (follow official FlutterFire setup)
- [ ] Create basic folder structure:
  ```
  lib/
   核心/
    features/
      onboarding/
      dashboard/
      medication/
        domain/
        data/
        presentation/
      reminders/
      history/
      settings/
      messaging/
    shared/
      components/
      theme/
      routing/
      services/
    app.dart
    main.dart
  ```
- [ ] Create `main.dart` with `MultiBlocProvider` scaffold (empty for now)

**Day 3-4:** Design System Integration
- [ ] Extract color palette from DESIGN.md → `app_theme.dart` (ThemeData)
- [ ] Configure Manrope font in `pubspec.yaml` (google_fonts or asset)
- [ ] Create `text_theme.dart` with all font styles (display-lg, headline-md, title-sm, body-base, body-sm, label-caps)
- [ ] Create `app_theme.dart` with light/dark themes using Material 3
- [ ] Implement spacing constants (`spacing_unit = 4`, `spacing_sm = 8`, etc.)
- [ ] Create shape constants: `borders_sm`, `borders_md`, `borders_lg`, `radius_full`
- [ ] Create reusable `ElevatedButton`, `OutlinedButton`, `TextButton` styles matching design
- [ ] Create base widgets: `AppCard`, `AppListTile`, `AppInput`, `AppChip`
- [ ] Create `k` constants file for design tokens (colors, radii, spacings)

**Day 5-7:** Core Infrastructure
- [ ] Set up Drift database:
  - [ ] Define `AppDatabase` class extending `@Database`
  - [ ] Create tables: `medications`, `schedules`, `dose_logs`, `refill_tracking`
  - [ ] Generate database code (build_runner)
- [ ] Create `DatabaseService` singleton for DB access
- [ ] Set up `get_it` locator in `service_locator.dart`
- [ ] Register services: `DatabaseService`, `NotificationService`, `PreferenceService`
- [ ] Create base Cubit class with error handling
- [ ] Set up `go_router`:
  - [ ] Define routes: `/`, `/onboarding`, `/dashboard`, `/medications`, `/add-medication`, `/settings`, etc.
  - [ ] Create `AppRouter` class with GoRouter configuration
  - [ ] Add redirect logic for onboarding completion check
  - [ ] Add nested routes for settings sub-screens
- [ ] Create `App` widget with `MaterialApp.router` using router
- [ ] Test routing: app launches with blank screens, navigation works

**Definition of Done Week 1:**
- App compiles and runs on Android emulator
- Navigate between 3 placeholder screens (Dashboard, Meds, Settings)
- Theme colors render correctly
- Database file created on first launch

---

### Week 2: Medication CRUD Foundation (Phase 1)

**Day 1-2:** Domain Layer
- [ ] Create `Medication` entity (freezed + json_serializable)
  - Fields: id, name, dosageAmount, dosageUnit, iconName, colorHex, isPaused, createdAt, updatedAt
- [ ] Create `Schedule` entity (freezed)
  - Fields: id, medicationId, hour, minute, weekdays (bitmask), isAsNeeded
- [ ] Create `DoseLog` entity (freezed)
  - Fields: id, medicationId, scheduledTime, actualTime, status (taken/skipped/missed), notes
- [ ] Create Mappers: `MedicationMapper`, `ScheduleMapper` for DB ↔ domain
- [ ] Write unit tests for entity serialization/deserialization

**Day 3-5:** Data Layer
- [ ] Create Drift tables with converters (weekdays bitfield, icon enum)
- [ ] Implement DAOs:
  - `MedicationDao` (CRUD + queries: getActive, getById, getAllWithNextDose)
  - `ScheduleDao` (CRUD + queries: getByMedication, getSchedulesForDate)
  - `DoseLogDao` (CRUD + queries: getLogsForDate, getLogsForWeek, getAdherence)
- [ ] Write unit tests for DAOs (use `drift_test` with in-memory DB)

**Day 6-7:** Presentation Layer (Cubit + Repository)
- [ ] Create `MedicationRepository` abstract interface
- [ ] Create `MedicationRepositoryImpl` using DAOs
- [ ] Create `MedicationListCubit`:
  - States: `MedicationListInitial`, `MedicationListLoading`, `MedicationListLoaded` (with list), `MedicationListError`
  - Methods: `loadMedications()`, `addMedication(Medication)`, `editMedication(Medication)`, `deleteMedication(id)`, `togglePause(id)`
- [ ] Create `AddMedicationCubit` (multi-step form state machine):
  - States: `AddMedicationInitial`, `AddMedicationStep1(medicationPartial)`, `AddMedicationStep2(schedulePartial)`, `AddMedicationStep3(inventoryPartial)`, `AddMedicationSuccess`, `AddMedicationError`
  - Fields per step, validation methods
- [ ] Write unit tests for Cubits using `bloc_test`

**Definition of Done Week 2:**
- All CRUD operations work on device/emulator
- Medication appears in list after adding
- Can edit and delete
- Data persists across app restarts
- Cubit and DAO tests passing

---

### Week 3-4: Add Medication Screen UI (Phase 1 continued)

**Day 1-3:** Basic Form UI
- [ ] Create `AddMedicationPage` (multi-step with stepper or page view)
- [ ] Step 1: Identity & Dosage form (name, dosage amount, unit dropdown, icon picker)
  - [ ] Icon picker: grid of pre-defined material icons (pill, medication, syringe, etc.)
  - [ ] Color picker: limited palette matching design system
- [ ] Step 2: Frequency selection (radio buttons: daily, specific weekdays, as-needed)
- [ ] Step 3: Schedule times builder (time picker, add/remove times, weekday checkboxes if specific days)
- [ ] Step 4: Inventory tracking (current count, threshold for refill reminder)
- [ ] Form validation: required fields, positive numbers, name length
- [ ] "Save" button creates Medication + Schedule records in DB
- [ ] Success: navigate back to Medication List with new item highlighted
- [ ] Error handling: show error dialog on DB failure

**Day 4-5:** Medication List Screen
- [ ] Create `MedicationListPage` with scaffold and AppBar
- [ ] `BlocBuilder` for `MedicationListCubit` to show loading/error/success states
- [ ] List item widget: medication icon, name, dosage, next dose time, paused overlay
- [ ] Pull-to-refresh gesture
- [ ] Swipe to delete (with undo SnackBar) or delete icon with confirmation dialog
- [ ] Tap → navigate to Medication Detail/Edit page
- [ ] FAB (FloatingActionButton) to add new medication
- [ ] Empty state widget: illustration + "Add medication" CTA

**Day 6-7:** Medication Detail / Edit
- [ ] `MedicationDetailPage` displays all fields read-only
- [ ] Edit button navigates to `AddMedicationPage` pre-filled (reuse same form with edit mode)
- [ ] Pause/Resume toggle switch
- [ ] Delete button with confirmation
- [ ] Show associated schedules (list of times + weekdays)
- [ ] Show inventory count and days remaining estimate

**Definition of Done Week 3-4:**
- Can add 5 medications with varying schedules
- List updates in real-time
- Edit updates correctly
- Delete with undo recovery
- UI matches design system mockups (colors, typography, spacing)
- Widget tests for form, list item, empty state

---

### Week 5-6: Notification Service & Action Sheet (Phase 2)

**Day 1-2:** Notification Service Foundation
- [ ] Create `NotificationService` class (singleton)
- [ ] Initialize `flutter_local_notifications` plugin on app startup
- [ ] Configure Android notification channel (ID: `medication_reminders`, importance: high)
- [ ] Configure iOS notification categories with actions (Take, Snooze, Skip)
- [ ] Request notification permission with rationale dialog
- [ ] Request exact alarm permission on Android 14+ (via `android_alarm_manager_plus` or platform channel)
- [ ] Set timezone data using `timezone` package; load tzdb on first launch
- [ ] Create method: `scheduleDoseNotification(medication, schedule, doseId)`
- [ ] Cancel notification method
- [ ] Reschedule all notifications method (called on boot, timezone change)
- [ ] Unit test: `scheduleDoseNotification` calls plugin correctly

**Day 3-4:** Scheduling Logic
- [ ] Create `ReminderScheduler` service (uses NotificationService)
- [ ] On medication creation: iterate schedules, create notifications for next N days (e.g., 30 days ahead)
- [ ] On medication edit: cancel old notifications, schedule new ones
- [ ] On medication delete: cancel all associated notifications
- [ ] On dose log: if "taken" or "snoozed", reschedule next occurrence if recurring
- [ ] Handle DST transitions: schedule with absolute local time; regenerate after DST change
- [ ] Broadcast receiver (Android) / background fetch (iOS) to reschedule on device reboot
- [ ] Test: notifications appear at correct times on emulator/device

**Day 5-7:** Action Sheet & Logging Flow
- [ ] Create `ReminderActionSheetPage` as bottom sheet (`showModalBottomSheet`)
- [ ] UI: medication icon, name, dosage, time label, large icon
- [ ] Three action buttons:
  - [ ] "Take now" (primary, full-width, prominent)
  - [ ] "Snooze" (secondary, expands to show duration options 10/20/30/60m)
  - [ ] "Skip" (tertiary, ghost button)
- [ ] Tapping "Take" → call `DoseLogService.logDose(doseId, taken: true)`
- [ ] Tapping "Snooze" → show bottom sheet with time options; selection reschedules notification + marks as snoozed
- [ ] Tapping "Skip" → mark as skipped with optional "reason" dialog (optional)
- [ ] After logging, bottom sheet dismisses; update UI elsewhere via Bloc/Cubit events
- [ ] Missed dose detection: background task or timer checks every 15 min for overdue doses; mark as missed after 3h
- [ ] Show missed dose alert on dashboard if any

**Definition of Done Week 5-6:**
- Notifications fire reliably at scheduled times on Android & iOS
- Action Sheet opens from notification tap
- Logging persists dose and updates UI
- Snooze works correctly
- Missed doses auto-mark after 3h
- Permission flows work on fresh install

---

### Week 7: Home Dashboard (Phase 3)

**Day 1-2:** Dashboard Cubit & Data Services
- [ ] Create `DashboardCubit` with state: `DashboardInitial`, `DashboardLoading`, `DashboardLoaded` (with view model)
- [ ] View model fields: greeting (time-based), adherenceScore, nextDose (Medication + schedule), upcomingDoses (list), missedDosesCount
- [ ] Repository methods:
  - `getTodaysDoses()` returns list with status (pending/taken/skipped/missed)
  - `calculateAdherence()` returns percentage of taken vs scheduled (including future as pending)
  - `getNextDose()` returns the closest upcoming (or overdue) dose
  - `getMissedDoses()` returns overdue doses >3h
- [ ] Cubit loads data on init and subscribes to DB change streams for real-time updates
- [ ] Emit new state when logs change (using StreamController from Drift)

**Day 3-5:** Dashboard UI
- [ ] Scaffold with TopAppBar (avatar, brand logo, notifications icon)
- [ ] Greeting section: "Good Morning/Afternoon/Evening" based on time of day
- [ ] Adherence card: circular progress indicator (custom painter) showing % + count (e.g., "4 of 5")
- [ ] Missed dose card (if any): red background, "1 missed" with button to view
- [ ] Next Dose hero card:
  - [ ] Primary container color (teal)
  - [ ] Medication name, dosage, time (scheduled), "WITH FOOD" chip if applicable
  - [ ] Large icon
  - [ ] "Log Taken" button → opens Action Sheet pre-filled for that dose
- [ ] Upcoming list: card with list tiles showing time, medication, dosage; color-coded by status
- [ ] Bottom navigation bar (Home, Meds, Calendar, Progress, Settings) – initial Home active

**Day 6-7:** Integration & Polish
- [ ] Wire up navigation: dashboard loads on app start
- [ ] Ensure real-time updates when dose logged from Action Sheet
- [ ] Add pull-to-refresh (cubit reload)
- [ ] Add empty states: no medications → show onboarding CTA
- [ ] Widget tests for each dashboard component
- [ ] Golden tests for dashboard layout (optional)
- [ ] Performance: ensure <1s load with 50 medications

**Definition of Done Week 7:**
- Dashboard displays accurate real-time information
- Next dose card interactive, opens logging flow
- Adherence score recalculates instantly
- UI matches design spec pixel-perfectly
- All widget tests passing

---

### Week 8-9: History, Progress, and Calendar (Phase 4)

**Week 8: History & Calendar**

**Day 1-2:** Calendar View
- [ ] Create `CalendarPage` with `TableCalendar` or custom implementation
- [ ] Data source: query logs grouped by date (midnight→midnight local)
- [ ] Color markers per day: green (≥80%), yellow (1-79%), red (0% or missed), gray (no doses scheduled)
- [ ] Tap day → slide-up bottom sheet with details: list of medications and their status that day
- [ ] Month navigation arrows
- [ ] Today button (jump to current date)

**Day 3-4:** History List
- [ ] Create `HistoryPage` with filter chips (7d/30d/90d/custom range)
- [ ] List view of dose logs: medication name, scheduled time, actual time, status icon
- [ ] Pull to refresh
- [ ] Infinite scroll pagination (or load all since small dataset)
- [ ] Tap log → detail view (medication info, time, optional notes)
- [ ] Allow editing status within 24h (tap edit → change to taken/skipped/missed)
- [ ] Empty state: "No history yet" for new users

**Day 5-7:** Progress & Charts
- [ ] Create `ProgressPage` with stepper/tabs for 7d/30d/90d
- [ ] Line chart using `fl_chart` or `syncfusion_flutter_charts`:
  - [ ] X-axis: dates
  - [ ] Y-axis: adherence % (0-100)
  - [ ] Smooth line with gradient fill under
  - [ ] Touch tooltip showing date and value
- [ ] Streak counter: "Current streak: X days" and "Best streak: Y days"
- [ ] Stats cards: "Total doses taken", "Average adherence", "Missed doses"
- [ ] Refill tracker widget (list of medications sorted by days remaining)
- [ ] Low-stock warning banner on dashboard (already added in Phase 2? ensure integrated)

**Definition of Done Week 8:**
- Calendar renders correctly with 2 years of data without lag
- History list filters work; editing a log updates adherence
- Charts display smooth curves; no jank on scrolling
- Refill warnings visible on dashboard and progress page

---

### Week 9: Refill Tracker Deep Dive
- [ ] Create dedicated `RefillTrackerPage` (optional: integrate into Progress or Med List)
- [ ] Table/List: Medication icon/name, current count, daily consumption rate, days remaining, threshold indicator
- [ ] Color-coded rows: green (>7 days), yellow (3-7 days), red (<3 days)
- [ ] Tap row → refill action: "Mark as Refilled" modal where user enters new count
- [ ] Adjust count manually: +/- buttons or direct input
- [ ] When dose logged, auto-decrement count; recalc days remaining
- [ ] Low-stock SnackBar or in-app notification when count drops below threshold
- [ ] Widget tests for refill tracker components

---

### Week 10: Settings & Privacy (Phase 5)

**Day 1-3:** Notification & Appearance Settings
- [ ] Create `SettingsPage` with ListView of settings tiles
- [ ] Navigation to subpages: Notifications, Privacy, About
- [ ] `NotificationSettingsPage`:
  - [ ] Global on/off switch (uses `flutter_local_notifications` cancelAll / rescheduleAll)
  - [ ] Quiet hours: time picker for start and end
  - [ ] Default snooze duration: dropdown [10, 20, 30, 60] minutes
  - [ ] Notification sound selection: radio list or dropdown
  - [ ] Per-medication toggle: future feature, placeholder for now
- [ ] `AppearanceSettingsPage`:
  - [ ] Theme mode: light / dark / system (uses `ThemeMode` from `MaterialApp`)
  - [ ] Font scale: small/medium/large (updates `MediaQuery.textScaleFactor`)
  - [ ] Primary color variant selection? (future)
- [ ] Persist all settings using `SharedPreferences` (or `flutter_secure_storage` for sensitive)
- [ ] Immediate effect: changes apply without restart

**Day 4-5:** Privacy & Data Management
- [ ] `PrivacySettingsPage`:
  - [ ] Clear statement: "All data stored locally on your device"
  - [ ] Data export button → generates CSV/JSON file → opens share sheet
  - [ ] Clear all data button → N-step confirmation (e.g., type "DELETE")
  - [ ] Show data size used
  - [ ] Link to privacy policy (local HTML asset)
- [ ] Implement `DataExportService`:
  - [ ] Query all medications, logs, schedules
  - [ ] Format as CSV or JSON with headers
  - [ ] Write to app's documents directory
  - [ ] Launch `share_plus` share sheet for user to send/ save
- [ ] Implement `DataWipeService`:
  - [ ] Drop all tables; recreate schema
  - [ ] Clear preferences
  - [ ] Cancel all scheduled notifications
  - [ ] Restart app to initial state (like first launch)
- [ ] Unit tests for export and wipe (wipe test uses isolated test DB)

**Day 6-7:** Additional Settings
- [ ] `AboutPage`: app name, version (from pubspec), build number, copyright
- [ ] Links: Privacy Policy, Terms of Service (local HTML assets generated from docs)
- [ ] Debug info screen (for testing): DB path, notification count scheduled, last crash report (if any)
- [ ] Feedback / contact email link (`mailto:`)

**Definition of Done Week 10:**
- All settings toggle correctly and persist
- Data export creates valid file shared via native share sheet
- Data wipe is destructive with no recovery path
- Dark mode theme works correctly across all screens
- Settings tested on both light/dark modes

---

### Week 11: Provider Messaging (Phase 6)

**Day 1-2:** Messaging Data Layer
- [ ] Create `MessageThread` entity (id, providerName, providerContact, createdAt)
- [ ] Create `Message` entity (id, threadId, text, direction (inbound/outbound), timestamp, attachmentMedicationId?)
- [ ] Create Drift tables: `message_threads`, `messages`
- [ ] DAO for threads and messages
- [ ] Repository: `MessagingRepository`

**Day 3-5:** Messaging UI
- [ ] `ProviderMessagingPage`: list of conversation threads (provider name + last message preview + unread count)
- [ ] Tap thread → `ConversationPage` with message bubbles (outbound aligned right, inbound left)
- [ ] Composer field at bottom: text input + send button
- [ ] Medication attachment: button to attach medication name to message (inserts `[Medication: Lisinopril]` into text)
- [ ] Draft auto-save: every keystroke saved to DB; restored if app killed
- [ ] "Send" behavior: Mark as outbound; for MVP, simply stores locally and shows "Message ready to send" dialog with "Copy to clipboard" or "Open SMS" button (since no backend)
- [ ] Empty state: "No conversations. Start one with your provider."
- [ ] FAB to start new conversation: enter provider name & phone/email

**Definition of Done Week 11:**
- Can create thread, send messages, view history
- Messages persist across app restarts
- Copy-to-clipboard or SMS-launch works on device
- No crash if SMS app not present
- UI matches design mockups

---

### Week 12-13: Testing, Polish & Beta (Phase 7)

**Week 12: Testing & Bug Fixes**

**Day 1-3:** Unit & Widget Tests
- [ ] Review all Cubits: ensure 100% state transitions covered with `bloc_test`
- [ ] DAO tests: CRUD operations, complex queries (adherence, upcoming)
- [ ] Service tests: `NotificationService` (mock plugin), `ReminderScheduler`, `DoseLogService`
- [ ] Entity serialization tests
- [ ] Widget tests for each screen (at least 50%):
  - [ ] AddMedicationPage (form validation, navigation)
  - [ ] MedicationListPage (list rendering, empty state)
  - [ ] Dashboard (adherence ring, next dose)
  - [ ] ReminderActionSheet (buttons, state changes)
  - [ ] Settings toggles (immediate effect)
- [ ] Golden tests for critical UI components (Card, Button styles)

**Day 4-5:** Integration & Accessibility
- [ ] Write 3-5 integration tests covering main flows:
  - [ ] Onboarding → Add med → Dashboard → Notification → Log
  - [ ] Add medication → Edit → Delete → Undo
  - [ ] Refill tracking: set count → log doses → warning appears
- [ ] Accessibility audit:
  - [ ] All screens reachable via TalkBack/VoiceOver
  - [ ] All interactive elements have contentDescription/semanticLabel
  - [ ] Contrast ratio check with `flutter_contrast_checker` or manual
  - [ ] Font scaling to 200%: no overflow or clipped text
  - [ ] Touch target size 44×44 verified
- [ ] Fix accessibility issues (add labels, reorder semantics)

**Day 6-7:** Performance & Stability
- [ ] Profile app in release mode on mid-range device (Android emulator profile)
- [ ] Measure cold start time (should be <2s)
- [ ] Check memory usage over 1 hour (look for leaks with DevTools)
- [ ] Database size after simulating 1 year of data (should be <5MB)
- [ ] Stress test: add 100 medications, each with 4 daily doses; ensure 400 notifications schedule without crash
- [ ] Verify battery impact: monitor for 24h with active reminders
- [ ] Edge case: Rotate device during action sheet; ensure state preserved
- [ ] Edge case: Incoming call during notification tap; ensure no crash
- [ ] Fix all high-priority bugs

---

**Beta Build preparation (Week 13)**

**Day 1-2:**
- [ ] Configure flavors: `dev` and `prod` (or `beta`)
- [ ] Update `android/app/build.gradle` with versionCode, versionName
- [ ] Update iOS `Info.plist` with permissions (NSRemindersUsageDescription, exact alarm permission if needed)
- [ ] Configure Firebase Crashlytics for both dev and prod (separate projects or apps)
- [ ] Create signing keys (Android keystore, iOS distribution) – keep secure
- [ ] Build release APK/AAB and IPA (TestFlight) with correct config
- [ ] Upload to Google Play Internal Testing or Firebase App Distribution

**Day 3-5:**
- [ ] Internal team testing (3-5 people)
- [ ] Collect crash reports from Crashlytics
- [ ] Fix any critical crashes
- [ ] Update release notes for beta

**Definition of Done Week 12-13:**
- All automated tests passing
- No critical or high-severity bugs
- App meets NFRs (performance, accessibility, reliability)
- Beta build uploaded and installs on test devices
- Crash-free sessions >99.9% in internal testing

---

## What Should Be Built First and Why

### Immediate Order (Critical Path)

1. **Database schema** - All features depend on persistent storage. Must define entities and relationships first.
2. **Theme & design system** - UI consistency from day one; every screen uses it.
3. **Routing + DI** - Foundation for navigation and service access; set up early to avoid refactor.
4. **Notification service initialization** - Platform-specific setup requires manifest changes; do early to catch issues.
5. **Medication CRUD Cubit** - Business logic core; independent of UI, testable.
6. **Add Medication screen** - First feature users need; unlocks all other features.
7. **Notification scheduling logic** - Complex integration with OS; needs iteration.
8. **Dashboard** - Most visible screen; combines multiple data sources.
9. **Action Sheet** - Directly tied to notifications; requires tight integration.

**Rationale:** Data layer first (schema) → application logic (Cubits/services) → presentation (screens). This separation ensures testability and reduces coupling. Infrastructure (routing, theme, DI) is built concurrently before screens depend on them.

---

## Definition of Done (Overall Project)

A feature is considered done when:
1. ✅ Feature implemented in code with no open bugs
2. ✅ Unit tests pass (≥80% coverage for new code)
3. ✅ Widget tests for all new UI components
4. ✅ Integration test for end-to-end flow (if applicable)
5. ✅ Documentation updated (memory-bank files, inline dartdoc)
6. ✅ Code reviewed and merged (if team context)
7. ✅ Works on both Android and iOS
8. ✅ Handles edge cases and error states gracefully
9. ✅ Meets performance budget (load time, memory)
10. ✅ Passes accessibility audit

---

## Suggested MVP Scope

**MVP = Phases 0-3 + Core Settings (partial)**

**Included:**
- Phase 0: Foundation
- Phase 1: Medication CRUD
- Phase 2: Notifications & Action Sheet
- Phase 3: Dashboard
- Subset of Settings: Global notification toggle, quiet hours, snooze duration, theme

**Excluded from MVP (Post-MVP):**
- Phase 4: Calendar view, progress charts, streak, refill tracker deep
- Phase 6: Provider messaging
- Advanced export (CSV)
- Font size adjustment
- Per-medication notification overrides

**MVP Launch Criteria:**
- No known crash bugs
- Notification reliability ≥99% in 1-week beta
- User can complete primary tasks:
  - Add medication
  - Receive reminder
  - Log dose
  - See adherence
  - Adjust quiet hours
- Privacy statement clear

**Post-MVP Phases:**
- Phase 4 → Calendar + Progress + Refill deep dive
- Phase 5 → Privacy & Data Management complete
- Phase 6 → Provider Messaging (local → cloud later)
- Phase 7 → Polish, i18n, widgets, themes, caretaker mode

---

**Last Updated:** 2026-04-29  
**Status:** Proposed  
**Owner:** Project Manager / Tech Lead
