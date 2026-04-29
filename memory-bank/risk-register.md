# Risk Register

## Risk Matrix

| Risk ID | Description | Likelihood | Impact | Priority | Status |
|---------|-------------|------------|--------|----------|--------|
| R-001 | Notification exact timing fails on some Android OEMs (battery optimizations) | Likely | High | Critical | Open |
| R-002 | User misses notification due to device reboot or app force-close | Possible | High | High | Open |
| R-003 | Database corruption on abrupt app termination during write | Unlikely | Critical | High | Open |
| R-004 | Timezone changes cause doses to fire at wrong local time | Possible | High | High | Open |
| R-005 | DST transition causes duplicate or missed dose notifications | Possible | Medium | Medium | Open |
| R-006 | User grants notification permission but denies "exact alarm" (Android 14+) → unreliable reminders | Likely | High | Critical | Open |
| R-007 | Data loss during migration (schema change) | Unlikely | Critical | Critical | Open |
| R-008 | App rejected from Play Store due to exact alarm misuse or privacy concerns | Rare | Critical | High | Open |
| R-009 | User accidentally clears app data → loses all medication history | Possible | High | High | Open |
| R-010 | Performance degradation with 100+ medications and 400+ daily notifications | Unlikely | Medium | Medium | Open |
| R-011 | Crash due to unhandled timezone offset during DST | Possible | High | High | Open |
| R-012 | Provider messaging feature misunderstood as "real messaging" (backed by service) | Likely | Medium | Medium | Open |
| R-013 | Freezed/codegen build failures causing development delays | Possible | Medium | Medium | Open |
| R-014 | Drift migration conflicts when upgrading app version (partial migration) | Possible | High | High | Open |
| R-015 | iOS "critical alerts" entitlement denied by Apple → less precise timing | Possible | High | High | Open |
| R-016 | User changes system clock to manipulate snooze/dose timing | Possible | Low | Low | Open |
| R-017 | Memory leak from uncancelled stream subscriptions in Cubits | Possible | Medium | Medium | Open |
| R-018 | Notification permission permanently denied → user can't receive reminders | Possible | High | High | Open |
| R-019 | SQLite database locked due to concurrent read/write on different isolates | Unlikely | High | Medium | Open |
| R-020 | Crashlytics not capturing all crashes due to misconfiguration | Possible | Medium | Medium | Open |

---

## Detailed Risk Analysis

### R-001: Notification Timing Inaccuracy on Android OEMs

**Description:** Some Android manufacturers (Xiaomi, Huawei, OnePlus) aggressively kill background processes and restrict exact alarms for battery savings, causing notifications to fire late or not at all.

**Likelihood:** Likely - known issue with certain OEMs  
**Impact:** High - Core feature fails; medication missed  
**Priority:** Critical  

**Mitigation Plan:**
1. Request `SCHEDULE_EXACT_ALARM` permission on Android 14+ (bypasses some restrictions)
2. Use `AlarmManager` with `setExactAndAllowWhileIdle` for critical alarms
3. On devices with aggressive OEM, guide user to disable battery optimization for app (in-app deep link to system settings)
4. Fallback: use WorkManager with high priority (not exact, but best effort)
5. Monitor crash logs/logs for delayed notifications; add user feedback mechanism

**Monitoring Signal:** User reports of late reminders; increase in "missed" doses logged after notification

**Owner suggestion:** Mobile tech lead + QA

---

### R-002: Notification Loss After Reboot or Force-Close

**Description:** Device reboot clears pending alarms unless explicitly rescheduled. If app is force-closed, some OS versions may cancel notifications.

**Likelihood:** Possible  
**Impact:** High - All future reminders lost until app reopened  
**Priority:** High  

**Mitigation Plan:**
1. Implement `BOOT_COMPLETED` broadcast receiver on Android to restore all notifications on boot
2. Use `Application` subclass to detect app restart and call `reminderScheduler.rescheduleAll()`
3. Store last-known notification schedule in DB for reconstruction
4. Test on multiple Android versions (8–14) and iOS

**Monitoring Signal:** Sudden drop in scheduled notification count after device restart logs

**Owner suggestion:** Mobile engineer (Android focus)

---

### R-003: Database Corruption During Abrupt Termination

**Description:** If app crashes or power loss occurs during a DB write (e.g., logging a dose), the SQLite file could become corrupted, losing all data.

**Likelihood:** Unlikely (Drift uses transactions)  
**Impact:** Critical - Total data loss  
**Priority:** High  

**Mitigation Plan:**
1. Use Drift's built-in transactions for all writes
2. Enable write-ahead logging (WAL) mode for better concurrency and crash safety
3. Implement automatic backup before schema migrations
4. On app startup, verify DB integrity; if corrupted, restore from last backup or prompt user for cloud restore (Phase 2)
5. Consider periodic backups to external storage (advanced)

**Monitoring Signal:** Database exception stack traces; user reports of data loss

**Owner suggestion:** Backend architect (DB expert)

---

### R-004: Timezone Change Breaks Schedule Calculations

**Description:** User travels across timezones; doses scheduled at 8:00 local time should still be 8:00 in new timezone, but if stored incorrectly as UTC, could fire at wrong hour.

**Likelihood:** Possible  
**Impact:** High - Wrong timing could lead to missed or untimely doses  
**Priority:** High  

**Mitigation Plan:**
1. Store schedules as local hour/minute (no timezone) → always interpreted in device’s current timezone
2. When logging, record `scheduled_time` as local time string (no conversion)
3. On timezone change broadcast (Android) or app focus (iOS), recalculate next dose times
4. Write comprehensive timezone simulation tests
5. Consider storing IANA timezone ID per user (future)

**Monitoring Signal:** User reports of doses firing at unexpected times after travel

**Owner suggestion:** QA + mobile engineer

---

### R-005: DST Transition Glitches

**Description:** Daylight saving time shift creates 23- or 25-hour days. Recurring daily alarms scheduled at 8:00 might fire at 7:00 or 9:00 on DST day.

**Likelihood:** Possible  
**Impact:** Medium - Most users notice one-off timing error; may cause missed dose  
**Priority:** Medium  

**Mitigation Plan:**
1. Use `flutter_local_notifications` with timezone-aware scheduling (tz package)
2. Enable `android:usesCleartextTraffic="false"`? Not relevant; instead rely on tz db updates
3. Schedule notifications explicitly using `tz.TZDateTime` with location-based timezone
4. Test DST transitions in spring/fall on emulator with timezone set to regions that observe DST
5. Notify user of DST adjustment in dashboard? Optional

**Monitoring Signal:** Spike in missed doses twice a year (DST weekends)

**Owner suggestion:** QA engineer

---

### R-006: Exact Alarm Permission Denied (Android 14+)

**Description:** Android 14 requires user to grant `SCHEDULE_EXACT_ALARM` permission manually in system settings; many users will deny or not understand. Reminders become inexact (10-minute window) which harms reliability.

**Likelihood:** Likely  
**Impact:** High - Core feature degraded  
**Priority:** Critical  

**Mitigation Plan:**
1. Provide clear, friendly rationale during onboarding: "Exact alarms ensure your reminders ring precisely when you need them"
2. Deep-link directly to exact alarm settings screen (`ACTION_REQUEST_SCHEDULE_EXACT_ALARM`)
3. If denied, show persistent educational banner explaining impact
4. Consider fallback: use high-priority notification channel with `IMPORTANCE_HIGH` (but still inexact)
5. Track denied rate via analytics (Crashlytics custom keys)

**Monitoring Signal:** Percentage of Android 14+ users who grant exact alarm permission

**Owner suggestion:** Product manager + mobile engineer

---

### R-007: Data Loss During Schema Migration

**Description:** When database schema changes (e.g., add column), migration runs. If migration fails or is untested, user data could be lost.

**Likelihood:** Unlikely  
**Impact:** Critical - All medication history erased → trust broken  
**Priority:** High  

**Mitigation Plan:**
1. Write migrations with Drift's `Migration` class; test on real production-like DB snapshots
2. Before migration, create `.backup` copy of DB file in same directory
3. Use `ALTER TABLE` statements that preserve data (never DROP TABLE without backup)
4. Version database; only migrate from adjacent versions
5. On migration failure, show error with option to restore backup (but may lose recent data)
6. For major changes, consider new table + copy + drop old (with backup)

**Monitoring Signal:** Migration exception logs; number of users hitting "Database error" screen

**Owner suggestion:** Backend architect

---

### R-008: App Store Rejection Due to Alarm Permissions

**Description:** Google Play and Apple App Store have strict policies around exact alarms and background execution. If used improperly, app could be rejected or removed.

**Likelihood:** Rare  
**Impact:** Critical - Can't distribute app  
**Priority:** High  

**Mitigation Plan:**
1. Follow exact guidelines:
   - Google: Permissions Policy - exact alarms only for core functionality (medication reminders qualify)
   - Apple: Critical alerts require entitlement; justify with medical necessity documentation (hard to get)
2. On iOS, request `time-sensitive` category and explain in App Store notes
3. Avoid using exact alarms for non-medical purposes
4. Test with pre-launch report on Google Play Console
5. Consider starting with inexact alarms on iOS (acceptable if user knows to open app)

**Monitoring Signal:** App store review status; rejection reason

**Owner suggestion:** DevOps / Release manager

---

### R-009: Accidental Data Wipe via "Clear All Data"

**Description:** User taps "Clear all data" in privacy settings, then confirms without reading dialog. All medication history lost; user may churn.

**Likelihood:** Possible  
**Impact:** High - Data loss; unhappy user  
**Priority:** High  

**Mitigation Plan:**
1. N-step confirmation: must type "DELETE" in text field to enable button
2. Show warning: "This will permanently delete all medications, logs, and messages. This cannot be undone."
3. Optionally require biometric authentication (`local_auth`) before proceeding
4. After clearing, app shows onboarding as fresh install
5. Consider adding "Export backup before delete" prompt

**Monitoring Signal:** Support tickets about data loss; frequency of clear data action

**Owner suggestion:** Product manager + UX

---

### R-010: Performance with Large Dataset

**Description:** User with 100+ medications each with 4 daily doses creates 400+ daily notifications and thousands of logs per year; queries may slow.

**Likelihood:** Unlikely (80% of users have <10 meds)  
**Impact:** Medium - Janky UI, slow dashboard  
**Priority:** Medium  

**Mitigation Plan:**
1. Use SQLite indexes on foreign keys and date columns
2. Paginate history queries (LIMIT 50, OFFSET)
3. Pre-aggregate adherence stats into nightly summary table (optional)
4. Profile with large synthetic dataset in development
5. Optimize calendar rendering: paint only visible month cells
6. Consider virtualized list packages (e.g., `reorderables` for long lists)

**Monitoring Signal:** Slow query logs (>100ms); user feedback about lag

**Owner suggestion:** Performance engineer (or mobile dev)

---

### R-011: DST Crash or Duplicate Notifications

**Description:** DST transition (spring forward 2AM→3AM) causes hour 2:00-3:00 to be skipped; notifications scheduled at 2:30 might never fire or fire twice on fall-back.

**Likelihood:** Possible  
**Impact:** High - Missed or duplicated dose  
**Priority:** High  

**Mitigation Plan:**
1. Use `tz` package with accurate timezone database
2. When scheduling, specify exact local time with timezone; plugin handles DST
3. Test thoroughly: schedule notification at 2:30 on DST transition date; observe behavior on emulator
4. Log every scheduled notification and fired notification to compare
5. If duplicate detected, deduplicate in action sheet (ignore second log)

**Monitoring Signal:** Spike in duplicate/missed doses on DST weekends

**Owner suggestion:** QA + mobile engineer

---

### R-012: Provider Messaging Misunderstood as Real-Time

**Description:** User believes messages are actually sent to provider and expects reply; in MVP, "send" only copies to clipboard or opens SMS, leading to confusion and disappointment.

**Likelihood:** Likely  
**Impact:** Medium - User frustration, bad reviews  
**Priority:** Medium  

**Mitigation Plan:**
1. Clear UI labeling: "Compose message (will open your SMS app)" or "Copy to clipboard"
2. Disable send button and show message "This feature will be available in a future update"
3. Or: actually launch SMS intent (`sms:`) with prefilled number and text — more functional but still not in-app backend
4. Add disclaimer in settings: "Messaging is local only; to actually contact your provider, copy and paste message into your phone's messaging app"
5. Hide messaging behind "Coming Soon" for MVP

**Monitoring Signal:** Support questions: "Why didn't my provider get my message?"

**Owner suggestion:** Product manager + UX

---

### R-013: Code Generation Failures (Freezed/Drift/JSON)

**Description:** `build_runner` fails due to version conflicts or syntax errors, blocking development.

**Likelihood:** Possible  
**Impact:** Medium - Can't compile until fixed  
**Priority:** Medium  

**Mitigation Plan:**
1. Pin versions of `freezed`, `json_serializable`, `drift_dev` to compatible releases
2. Run `flutter pub upgrade --major-versions` carefully, test after each
3. Include `build_runner` in dev dependencies; document common errors in README
4. CI runs `flutter pub run build_runner build --delete-conflicting-outputs` on PRs to catch early
5. All developers run same Flutter version (enforced via `.fvm` if using FVM)

**Monitoring Signal:** Build failures in CI; developers unable to generate code locally

**Owner suggestion:** DevOps / Build engineer

---

### R-014: Migration Conflicts During App Upgrade

**Description:** User skips multiple versions (e.g., v1.0 → v1.3) and migration path missing intermediate step; schema version mismatch → migration fails.

**Likelihood:** Possible  
**Impact:** High - App crashes on startup, data inaccessible  
**Priority:** High  

**Mitigation Plan:**
1. All migrations must be **linear and cumulative**; never skip a version number
2. Write migration for every schema change, no matter how minor
3. Test upgrading from old version to new via side-load APK
4. On startup, check DB version; if lower, run all migrations sequentially
5. Backup before each migration step (Drift does not auto-backup)

**Monitoring Signal:** Crash reports on first launch after update; "DatabaseException: migration failed"

**Owner suggestion:** Backend/mobile architect

---

### R-015: iOS Critical Alerts Entitlement Denied

**Description:** For exact timing on iOS, app needs "Critical Alerts" entitlement from Apple (medical justification). Without it, notifications may be silenced or delayed by system.

**Likelihood:** Possible  
**Impact:** High - Reminders less reliable on iOS  
**Priority:** High  

**Mitigation Plan:**
1. Apply for Critical Alerts entitlement with Apple (requires medical app justification)
2. Prepare for denial: implement best-effort with standard alerts + prominent in-app indicator when dose due
3. Include "Enable notifications" troubleshooting guide in app
4. Rely on `UNCalendarNotificationTrigger` with precise date without repeating; schedule each individually (more reliable than repeating)
5. If still insufficient, emphasize user must open app at scheduled time (not ideal)

**Monitoring Signal:** iOS user feedback about late or missing notifications

**Owner suggestion:** Product + iOS dev

---

### R-016: System Clock Manipulation for Snooze Bypass

**Description:** User sets device clock forward to bypass snooze or make dose "already due".

**Likelihood:** Possible  
**Impact:** Low - Hack, not real harm; could undermine adherence tracking integrity  
**Priority:** Low  

**Mitigation Plan:**
1. Accept that determined users can cheat; medication tracking is self-reported
2. Optionally detect large clock jumps and warn or reset notifications
3. Consider using network time as sanity check (but can be spoofed; adds network requirement)

**Monitoring Signal:** Unusual dose logging timestamps (future or past)

**Owner suggestion:** Security review (low priority)

---

### R-017: Memory Leaks from Stream Subscriptions

**Description:** Cubits or services that open `StreamSubscription` and don't cancel on `close()` leak memory, causing gradual slowdown.

**Likelihood:** Possible  
**Impact:** Medium - Performance degradation over long sessions  
**Priority:** Medium  

**Mitigation Plan:**
1. Enforce pattern: all Cubits extend `CloseableCubit` that cancels subscriptions in `close()`
2. Code review checklist: verify `@override void close()` includes subscription cancellation
3. Run Flutter DevTools memory profiler in testing
4. Add automated test that creates/c destroys Cubit 100x and checks for orphaned isolates

**Monitoring Signal:** Gradual increase in RSS memory in session; DevTools heap snapshot shows orphaned objects

**Owner suggestion:** QA / Performance tester

---

### R-018: Notification Permission Permanent Denial Without Recovery

**Description:** User denies notification permission and checks "Don't ask again" (Android) or iOS similar. No in-app way to re-prompt; user must manually go to system settings.

**Likelihood:** Possible  
**Impact:** High - App becomes useless without reminders  
**Priority:** High  

**Mitigation Plan:**
1. Detect permission denied permanently via plugin APIs
2. Show persistent banner: "Notifications disabled. Tap here to enable." with deep link to app settings
3. Provide step-by-step guide with screenshots to enable
4. Allow "Test without notifications" mode (in-app daily reminder banner) but with reduced reliability
5. Track permission grant rate

**Monitoring Signal:** Percentage of users who grant notification permission on first launch

**Owner suggestion:** UX + mobile engineer

---

### R-019: SQLite Database Locked (Concurrent Access)

**Description:** If multiple isolates/threads attempt simultaneous writes, SQLite can throw `database is locked` errors.

**Likelihood:** Unlikely (Drift handles serialization)  
**Impact:** High - Write failures, lost logs  
**Priority:** Medium  

**Mitigation Plan:**
1. Drift uses single connection by default; ensure all DB access goes through same instance
2. Avoid opening multiple DB connections anywhere
3. Use transactions for batch writes
4. Implement retry logic with exponential backoff on database lock exception
5. Log all DB errors to Crashlytics with severity

**Monitoring Signal:** Frequency of `DatabaseException` with "locked" message

**Owner suggestion:** Backend/mobile architect

---

### R-020: Crashlytics Misconfiguration (Missing Crashes)

**Description:** Crashlytics not initialized early enough or disabled in debug, so crashes in release go unreported.

**Likelihood:** Possible  
**Impact:** Medium - Can't monitor stability in wild  
**Priority:** Medium  

**Mitigation Plan:**
1. Initialize Crashlytics in `main()` before `runApp()`
2. Enable Crashlytics in both dev and prod flavors (separate projects to avoid noise)
3. Test crash reporting by forcing test crash (`FirebaseCrashlytics.instance.crash()`)
4. Verify on Firebase console that crashes appear within minutes
5. Add custom keys (userId, medicationCount) to crash reports for context

**Monitoring Signal:** Crash-free users metric on Firebase dashboard

**Owner suggestion:** DevOps / mobile engineer

---

## Risk Status Definitions

| Status | Meaning |
|--------|---------|
| Open | Identified, not yet mitigated |
| Mitigated | Controls in place; monitoring active |
| Closed | No longer relevant or resolved |
| Active | Currently being addressed |

---

## Risk Review Cadence

- **Sprint Planning:** Review high-priority risks
- **Sprint Retrospective:** Update status of addressed risks
- **Monthly:** Reassess likelihood/impact
- **Before Release:** Final risk review and sign-off

---

**Last Updated:** 2026-04-29  
**Next Review:** After MVP scope confirmation  
**Owner:** Project Manager / Tech Lead
