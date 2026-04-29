# Product Requirements

## Functional Requirements

### FR1: Onboarding & Permissions

| ID | Requirement | Priority |
|----|-------------|----------|
| FR1.1 | Display a brief, skippable intro explaining the app's value and privacy stance | High |
| FR1.2 | Request notification permission with clear rationale ("We send reminders for your medications") | Critical |
| FR1.3 | Explain why exact alarm permission may be needed (Android 14+) | High |
| FR1.4 | Provide quick access to system notification settings if denied | Medium |
| FR1.5 | Show a "Test Notification" button after permission granted | Medium |

**Acceptance Criteria:**
- Onboarding can be completed in <2 minutes
- Permission request is contextual, not up-front cold ask
- Test notification fires within 10 seconds
- User understands what data stays on-device vs. optional sharing

**Edge Cases:**
- User denies notification permission → show in-app banner explaining how to enable
- User skips onboarding → app shows dashboard with subtle reminders to complete setup

---

### FR2: Home Dashboard

| ID | Requirement | Priority |
|----|-------------|----------|
| FR2.1 | Personalized greeting with user's name (configurable) | High |
| FR2.2 | Display adherence score for today (percentage of doses taken) | Critical |
| FR2.3 | Show "Next Dose" hero card with medication name, time, dosage, and action button | Critical |
| FR2.4 | Display "Today's Upcoming" list of remaining doses with times | High |
| FR2.5 | Visually indicate missed doses (red warning card or alert banner) | High |
| FR2.6 | Quick-add button to log "Take Now" from next dose card | Critical |
| FR2.7 | Tapping any medication card navigates to detail or logging flow | High |

**Acceptance Criteria:**
- Dashboard loads in <1 second
- All information visible without scrolling (above the fold)
- Next dose card updates in real-time when time approaches
- Missed doses trigger at first missed scheduled time (not retroactively)

**Edge Cases:**
- No medications added yet → show empty state with CTA to add first medication
- All doses taken today → show "All caught up!" message with celebration animation
- Next dose is overdue → show in red with "Take Now" as primary action

---

### FR3: Medication Management (CRUD)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR3.1 | Add medication with: name, dosage (amount + unit), icon/appearance, frequency, schedule times, inventory count, refill threshold | Critical |
| FR3.2 | Support frequencies: daily, specific weekdays, as-needed (PRN) | Critical |
| FR3.3 | Support multiple schedule times per day (e.g., morning, afternoon, evening) | Critical |
| FR3.4 | Edit any medication field after creation | High |
| FR3.5 | Pause/resume medication (temporarily disable reminders) | High |
| FR3.6 | Delete medication with confirmation dialog | Medium |
| FR3.7 | Reorder medications by drag-and-drop in list view | Low |
| FR3.8 | Duplicate existing medication (for similar prescriptions) | Low |

**Acceptance Criteria:**
- Medication can be added in ≤4 screens/taps
- Schedule builder supports selecting multiple weekdays with clear UI
- As-needed medications do not generate automatic reminders
- Changes to schedule update all future notifications within 1 minute

**Edge Cases:**
- User sets overlapping times for same medication → warn or allow (design decision needed)
- User sets medication name identical to existing → allow duplicates (different prescriptions)
- Timezone change while traveling → schedule adjusts to new local time automatically

---

### FR4: Reminder Notifications

| ID | Requirement | Priority |
|----|-------------|----------|
| FR4.1 | Schedule local notifications at exact times for each dose | Critical |
| FR4.2 | Notifications show: medication name, dosage, time due, quick action buttons | Critical |
| FR4.3 | Tapping notification opens app to Reminder Action Sheet | Critical |
| FR4.4 | Action Sheet offers: "Take Now", "Snooze (10/20/30 min)", "Skip" | Critical |
| FR4.5 | Snooze reschedules notification for selected delay | High |
| FR4.6 | "Take Now" logs dose immediately and marks as taken | Critical |
| FR4.7 | "Skip" logs dose as skipped with optional reason (optional) | Medium |
| FR4.8 | Missed dose indicator: shows up to 3 hours past scheduled time | High |
| FR4.9 | Support for exact alarms (Android 14+) to bypass battery optimizations | High |
| FR4.10 | Respect system quiet hours / Do Not Disturb | High |
| FR4.11 | Allow per-medication notification toggle | High |
| FR4.12 | Support scheduled vs. approximate notifications (flexible window option) | Medium |

**Acceptance Criteria:**
- 99.9% of notifications fire within ±1 minute of scheduled time
- Action Sheet opens within 500ms of notification tap
- Snoozed notifications reappear exactly at delayed time
- Multiple medications due at same time → stacked notification or grouped

**Edge Cases:**
- Device reboot → all notifications reschedule correctly
- Timezone change during day → notifications adjust to new local time
- App killed by OS → notifications still fire (local system service)
- DST transition → 23- or 25-hour day handled correctly
- User changes device time → notification schedule integrity preserved

---

### FR5: Logging & Adherence

| ID | Requirement | Priority |
|----|-------------|----------|
| FR5.1 | Log dose status: Taken, Skipped, or Missed (auto) | Critical |
| FR5.2 | Record timestamp of log (actual time) and scheduled time | Critical |
| FR5.3 | Support logging from Action Sheet, dashboard, or medication detail page | High |
| FR5.4 | Display adherence score as percentage of taken vs. scheduled doses | Critical |
| FR5.5 | Show weekly streak counter (consecutive days with ≥80% adherence) | Medium |
| FR5.6 | Allow editing/deleting past logs within 24 hours | Medium |
| FR5.7 | Calculate adherence daily at midnight snapshot | High |
| FR5.8 | Display missed dose warning after 3 hours past scheduled time | High |
| FR5.9 | Support dose correction: mark skipped as taken, or vice versa | Medium |

**Acceptance Criteria:**
- Logging is instant (<200ms) and atomic
- Adherence score updates immediately across app
- History shows exact timestamps with timezone indicator
- Editing a log recalculates adherence for that day

**Edge Cases:**
- User logs "Taken" before scheduled time → allowed (early) or blocked? (assume: allowed)
- User logs "Taken" 4 hours after scheduled time → marked "late" but still "taken"
- Duplicate log entry prevented (idempotent tap)

---

### FR6: Refill Tracking

| ID | Requirement | Priority |
|----|-------------|----------|
| FR6.1 | Track current pill count for each medication | High |
| FR6.2 | Set refill reminder threshold (e.g., warn when 10 pills left) | High |
| FR6.3 | Auto-decrement count when dose logged as "Taken" | High |
| FR6.4 | Manual adjustment (user corrects count if lost/damaged) | Medium |
| FR6.5 | Low-stock alert when count ≤ threshold | High |
| FR6.6 | Refill tracker screen shows all medications sorted by remaining days | Medium |
| FR6.7 | Estimate days remaining based on schedule | Medium |
| FR6.8 | Option to mark as "Refilled" and reset count | High |

**Acceptance Criteria:**
- Count updates automatically within 1 second of logging a dose
- Low-stock warning visible on dashboard and medication list
- Days remaining calculation accounts for skipped doses (still consumed? → assumption: yes, still consumed from inventory)

**Edge Cases:**
- Medication as-needed → count decrement only when logged as taken (not scheduled)
- User manually sets count higher than previous → log with audit trail
- Medication paused → count does not decrement automatically

---

### FR7: History & Progress

| ID | Requirement | Priority |
|----|-------------|----------|
| FR7.1 | Calendar view showing taken/skipped/missed status per day | High |
| FR7.2 | List view of past dose logs with filter (date range, medication, status) | Medium |
| FR7.3 | Weekly and monthly adherence percentages | High |
| FR7.4 | Streak counter (current and longest) | Medium |
| FR7.5 | Progress charts: line graph of daily adherence over 7/30/90 days | Medium |
| FR7.6 | Export data as CSV or PDF (local file share) | Low |
| FR7.7 | Show total doses taken, total missed, average adherence | Low |

**Acceptance Criteria:**
- Calendar color-codes: green=taken, yellow=skipped, red=missed
- Charts render smoothly with up to 2 years of data
- Export creates file user can share via email/messaging

**Edge Cases:**
- No history yet → show empty state with "Take your first dose" message
- Large date range selected → paginate or summarize to avoid UI overload

---

### FR8: Settings

| ID | Requirement | Priority |
|----|-------------|----------|
| FR8.1 | Global notification toggle (master on/off) | High |
| FR8.2 | Quiet hours configuration (do not disturb window) | High |
| FR8.3 | Default snooze duration selection (10/20/30/60 min) | Medium |
| FR8.4 | Notification sound selection (default, chime, gentle, none) | Medium |
| FR8.5 | Vibration toggle | Low |
| FR8.6 | App theme: light, dark, or system default | Medium |
| FR8.7 | Font size adjustment (small/medium/large) | Low |
| FR8.8 | Default reminder lead time (5 min early warning option) | Low |
| FR8.9 | Data management: export all data, clear all data (with confirmation) | High |
| FR8.10 | App information: version, privacy policy, terms | Medium |

**Acceptance Criteria:**
- Settings changes take effect immediately (no app restart)
- Quiet hours suppress all non-critical notifications
- Clear data requires explicit double-confirmation with warning

**Edge Cases:**
- User disables notifications globally → in-app banner reminding them
- User sets quiet hours overlapping dose times → notifications held and delivered after quiet hours

---

### FR9: Privacy & Sharing

| ID | Requirement | Priority |
|----|-------------|----------|
| FR9.1 | Privacy dashboard showing current data posture (all data local) | High |
| FR9.2 | Optional: Share data with provider (local messaging only, no sync) | Medium |
| FR9.3 | Per-medication visibility: hide sensitive medications from history export | Low |
| FR9.4 | Local data export as JSON/CSV | Low |
| FR9.5 | Clear all local data function (with N-step confirmation) | High |
| FR9.6 | Privacy policy accessible from settings | Required |
| FR9.7 | No third-party analytics (except Crashlytics) | Critical |

**Acceptance Criteria:**
- Privacy screen clearly states "Your data never leaves this device unless you explicitly share"
- Export creates file in Downloads/ Documents folder
- Clear all data requires typing "DELETE" to confirm

**Edge Cases:**
- User requests data deletion → full local wipe with no recovery
- Provider messaging contains text → stored locally encrypted? (assumption: plain local storage acceptable for MVP)

---

### FR10: Provider Messaging

| ID | Requirement | Priority |
|----|-------------|----------|
| FR10.1 | In-app message composer to send text to provider phone number | Medium |
| FR10.2 | Conversation history view (threaded by provider) | Medium |
| FR10.3 | Pre-populated medication context (attach medication name to message) | Low |
| FR10.4 | Message draft saved locally if app closed mid-composition | Low |
| FR10.5 | No real-time sync; messages stored locally only | Low |
| FR10.6 | Provider contact info configurable in settings | Low |

**Acceptance Criteria:**
- Messages can be composed and "sent" (opens SMS/email app actually, or shows confirmation) → clarification needed
- Message history persists across app launches
- No delivery receipts or read confirmations (local only)

**Edge Cases:**
- No SMS app on device → show error with contact info copy
- Message contains medication name → format clearly
- Provider number not set → prompt user to enter before sending

---

## Non-Functional Requirements

### NFR1: Performance
- **App launch:** Cold start <2 seconds on mid-range device (Android 10+, iOS 14+)
- **Dashboard render:** <500ms after first frame
- **Notification trigger:** Fire within 1 minute of scheduled time; ideally exact
- **Database queries:** <100ms for all common queries (fetch today's doses, adherence calc)
- **Logging:** <200ms from tap to persisted and UI updated
- **Memory:** <100MB RSS on idle; no memory leaks over 1-hour usage

### NFR2: Reliability / Data Integrity
- **Data loss:** Zero tolerance; all logs and medication data must be durably stored
- **Atomic writes:** Medication edits and log entries are all-or-nothing
- **Backup:** Local SQLite file; no cloud backup unless user opts in (Phase 2)
- **Crash resilience:** App state recoverable after crash; pending logs not lost

### NFR3: Offline / Local-First
- **Core functionality 100% offline:** logging, reminders, history, settings, add/edit meds
- **No network required** for any primary user task
- **Network optional** only for optional sharing/export features
- **Data size:** <5MB typical after 1 year of use (text-only data)

### NFR4: Security & Privacy
- **Data encryption:** Optional; plain SQLite acceptable for MVP (no PHI transmitted)
- **Secure storage:** Use `flutter_secure_storage` for sensitive config (provider number, export path)
- **No analytics:** Except Crashlytics (only crash data, no PII)
- **No tracking:** No third-party SDKs that track user behavior
- **Permissions:** Request only what is strictly needed (notifications, exact alarms)

### NFR5: Maintainability
- **Code coverage:** Unit tests ≥80%; widget tests ≥50% of screens
- **Architecture:** Feature-first folder structure; clear separation of data/domain/presentation
- **Documentation:** Public APIs documented with dartdoc comments
- **Static analysis:** Zero lint warnings; strict analyzer rules

### NFR6: Accessibility
- **TalkBack / VoiceOver:** All screens fully navigable with screen reader
- **Dynamic text:** Support system font scaling up to 200%
- **Contrast ratio:** ≥4.5:1 for normal text, ≥3:1 for large text
- **Touch targets:** Minimum 44×44 dp with adequate spacing
- **Color-only cues:** Never rely solely on color (add icons/text)

### NFR7: Internationalization (Future)
- **i18n support:** Strings externalized in `arb` files (phase 2)
- **Date/time formatting:** Locale-aware
- **RTL support:** Layout mirroring for RTL languages (future)

---

## Notification Requirements (Detailed)

| Requirement | Detail |
|-------------|--------|
| Types | Daily reminders, refill alerts, missed dose alerts, quiet-hour suppression |
| Channels (Android) | "medication_reminders" (high priority, exact alarm), "refill_alerts" (lower), "general" (info) |
| Categories (iOS) | `time-sensitive` critical alerts for medications (requires entitlement), fallback to standard |
| Actions | Notification actions: "Take", "Snooze 30m", "Skip" (no text input) |
| Payload | Medication ID, dose ID, scheduled time; NOT full medication object |
| Scheduling | Pre-scheduled at dose-creation time using tz-aware DateTime; reschedule on timezone change |
| Recurring | Use local notification's built-in recurrence (daily/weekly) OR reschedule after each fire |
| Exact timing | On Android 14+, request `SCHEDULE_EXACT_ALARM` permission; on iOS, use `UNCalendarNotificationTrigger` with precise date |
| Delivery | Fire at scheduled local time, respecting system DND unless critical alert approved |
| Background | Works when app terminated or in background; no network required |

---

## Privacy Requirements (Detailed)

| Data Category | Storage | Sharing | Retention |
|---------------|---------|---------|-----------|
| Medication list | Encrypted SQLite (optional) | None | Until user deletes |
| Dose logs | Encrypted SQLite (optional) | None | Until user deletes |
| Schedule times | Encrypted SQLite (optional) | None | Until user deletes |
| Notification preferences | `flutter_secure_storage` | None | Until user clears app data |
| Provider messaging | Plain text SQLite | None (local only) | Until user deletes conversation |
| Refill counts | Encrypted SQLite (optional) | None | Until user deletes |
| Export files | Device file system (Downloads) | User-directed share intent | Until user deletes file |

**Encryption Note:** For MVP, plain SQLite is acceptable as data never leaves device. For Phase 2 cloud sync, implement AES-256 encryption at rest and TLS 1.3 in transit. All encryption keys stored in `flutter_secure_storage` or derived from user passphrase.

---

## Reliability Expectations

| Scenario | Expected Behavior |
|----------|-------------------|
| App crash during logging | Log entry persisted before UI update; no duplicate entry after restart |
| Device reboot | All scheduled notifications restored within 1 minute of boot |
| Timezone change during travel | All future doses shift to new local time; past doses maintain original logged timezone |
| DST transition (spring forward) | 2:00→3:00 shift: dose at 2:30 becomes 3:30 (or as configured) |
| DST transition (fall back) | 2:00→1:00 repeat: both 1:30 doses logged separately |
| Battery saver mode | Notifications still fire (use exact alarm permission) |
| Do Not Disturb enabled | Notifications suppressed unless user granted critical alert entitlement |
| User changes system time | Doses maintain original scheduled time; notifications adjust accordingly |
| Storage full | Prevent new medication creation; warn user; current data intact |
| Database migration (schema change) | Automatic migration with no data loss; backup created before migration |

---

## Acceptance Criteria Format: Per Major Module

**Example: Medication List Module**

**Given** the user has at least one medication configured  
**When** the user navigates to the Medications screen from the bottom nav  
**Then** the app displays a scrollable list of all active medications with name, dosage, next dose time, and icon  

**Given** the user has no medications  
**When** the Medications screen loads  
**Then** the app displays an empty state illustration with "Add your first medication" CTA button  

**Given** the user is viewing the Medications screen  
**When** the user taps a medication card  
**Then** the app navigates to the medication detail/edit screen with current values pre-filled  

---

## Edge Cases & Error States

### Edge Cases to Handle

1. **Zero medications** → onboarding prompts to add first med; dashboard shows CTA
2. **All medications paused** → dashboard shows "No active medications" with unpause option
3. **All doses taken today** → dashboard shows "Everything logged!" with celebration
4. **Multiple medications at same time** → group notifications or stack in Action Sheet
5. **Timezones while traveling** → all times display in device local time; history preserves original timezone
6. **As-needed medications** → no reminders scheduled; still track inventory and allow manual logging
7. **Daylight saving transition** → 23- or 25-hour day handled; adherence calculation uses calendar dates
8. **Device time changed by user** → notification schedule persists based on original clock time (not relative)
9. **Notification permission denied** → in-app daily reminder banner; deep link to system settings
10. **Storage nearly full** → warn user; disable new medication creation; still allow logging
11. **Exact alarm permission denied (Android 14+)** → fall back to inexact; prompt user to grant in settings
12. **App killed/swiped away** → notifications still fire (system-level); logging works
13. **Concurrent edits** (if multi-user future) → last-write-wins with merge conflict warning
14. **Large medication list (50+)** → search/filter; alphabetically grouped; performance remains smooth
15. **History with 1000+ entries** → paginated; charts aggregated by week/month

### Error States

- **Database unavailable** → show modal "Data temporarily unavailable"; app in read-only mode
- **Notification scheduling failed** → toast "Could not schedule reminder; please restart app"
- **Export failed** → "Not enough storage; free space and try again"
- **Invalid medication configuration** → inline validation; Save button disabled until valid
- **Logging failed** → retry button; local queue for later
- **Clock mismatch detected** → warning "System time changed; reminders may be off" with reset option

---

**Last Updated:** 2026-04-29  
**Status:** Draft  
**Next Review:** After MVP scope confirmation
