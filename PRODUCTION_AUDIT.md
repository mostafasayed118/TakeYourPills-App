# Production Audit — TakeYourPills

**Date:** 2026-07-12  
**Scope:** Reliability, security, release config, residual bugs  
**Status:** Critical compile/runtime gaps closed; release signing still needs a real keystore

---

## Closed this pass

| Area | Gap | Fix |
|------|-----|-----|
| **Reliability** | `rebuildFromRepository` called but undefined (compile error) | Implemented on `ReminderSchedulerService` + impl + no-op |
| **Reliability** | Cold start did not restore pending dose alarms | `main.dart` rebuilds schedules from active meds after notification init |
| **Reliability** | Notification IDs used epoch math → overflow Android `int32` | `computeNotificationId` → positive 31-bit hash |
| **Reliability** | `matchDateTimeComponents: time` re-fired daily forever | Removed; one-shot schedules only |
| **Reliability** | One schedule failure aborted the whole med | Per-dose try/catch; continue remaining |
| **Reliability** | 30-day × multi-med pending flood | Window reduced to 14 days |
| **Reliability** | TZ init could crash on unknown zone id | Fallback to UTC + `setLocalLocation` |
| **Reliability** | Uncaught errors killed process silently | `runZonedGuarded` + Flutter/platform error hooks (debug logs) |
| **Security** | Lock-screen showed med names (`public`) | `NotificationVisibility.private` |
| **Security** | Android auto-backup of health DB/prefs | `allowBackup=false` + data extraction rules |
| **Security** | Cleartext HTTP possible by default | `network_security_config` (no cleartext) |
| **Release** | Always signed with **debug** keys | Optional `android/key.properties` + example template |
| **Release** | No minify/shrink on release | R8 minify + shrink + proguard rules |
| **Release** | Unused deps (`dio`, `google_fonts`, `flutter_secure_storage`) | Removed; offline Manrope fonts already bundled |
| **UX / a11y** | Forced no text scaling | Clamped system scale 0.85–1.4 |
| **UX** | Bottom nav hard-coded light colors | Uses `Theme.of(context).colorScheme` |
| **iOS** | Display name unpolished | `TakeYourPills` |

**Verification:** `flutter analyze lib test` — clean · `flutter test` — **51 passed**, 4 skipped

---

## Closed in follow-up pass

| Area | Gap | Fix |
|------|-----|-----|
| **Release** | No upload keystore | Generated local `android/upload-keystore.jks` + `key.properties` (gitignored); `scripts/build_release.ps1` |
| **Reliability** | OEM battery / exact alarms | `DeviceReliabilityService`, dashboard `ReliabilityBanner`, Notification Settings deep links (`app_settings`) |
| **Data** | Export stubbed | `DataExportService` → JSON + system share sheet |
| **Diagnostics** | No crash sink | `LocalCrashReportingService` wired in `main` + About → Share diagnostics |

## Closed in product pass (2026-07-13)

| Area | Change |
|------|--------|
| **Dark theme** | Full dark `ColorScheme` + components; live `ThemeController`; dashboard/settings/calendar/progress use `ThemeContextX` |
| **Calendar** | Real week strip + day doses from schedules/logs |
| **Progress** | 7-day adherence from schedules + dose logs |
| **Messaging / History** | Messaging routes → Settings; History → Progress |
| **Sentry** | Optional remote sink: `flutter build … --dart-define=SENTRY_DSN=…` (local logs always on) |

### Enable Sentry (when you have a project)

```powershell
flutter run --dart-define=SENTRY_DSN=https://KEY@oORG.ingest.sentry.io/PROJECT
# or release:
flutter build appbundle --release --dart-define=SENTRY_DSN=https://...
```

---

## Release checklist

```powershell
# Keystore already generated locally (gitignored). Rotate password if machine is shared.
# Template: android/key.properties.example

flutter test
.\scripts\build_release.ps1
# or: flutter build appbundle --release
# iOS (macOS): flutter build ipa --release
```

Never commit `android/key.properties`, `*.jks`, or `*.keystore` (gitignored).
