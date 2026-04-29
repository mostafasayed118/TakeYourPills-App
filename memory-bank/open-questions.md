# Open Questions

This file tracks unresolved product, technical, and design questions. Each question includes an assumed solution to maintain momentum during planning. These assumptions must be validated before implementation begins.

---

## Product Questions

| ID | Question | Assumption | Impact | Status |
|-----|----------|------------|--------|--------|
| PQ-001 | Should users be able to set medication **as-needed (PRN)** schedules? | Yes - included in FR3.2; these medications have no automatic reminders, only manual logging. | Low - simple addition to schedule model | Open |
| PQ-002 | Can users attach **notes** to each dose log (e.g., "felt dizzy")? | No - MVP excludes notes to keep logging fast; could be added later as optional field. | Low - would require schema change | Open |
| PQ-003 | If a dose is **logged early** (before scheduled time), should it count as "taken"? | Yes - early is acceptable; timestamp recorded, status = taken. | Low - adherence calc already counts as taken | Open |
| PQ-004 | What is the maximum number of **medications** a user can have? | No hard limit; practical limit ~50; warn at 100. | Low - DB can handle many | Open |
| PQ-005 | Can a medication have **different dosages** at different times (e.g., 10mg morning, 5mg night)? | No - MVP assumes single dosage per medication; complex dosing out of scope. | Medium - requires separate dose-specific data model | Open |
| PQ-006 | Should **refill count decrement** on scheduled doses even if user skips/misses? | Yes - inventory consumed whether taken or not (medication removed from bottle). Alternative: decrement only when taken → risk of overcount if missed. | High - affects refill accuracy | Open |
| PQ-007 | Can users **duplicate** an existing medication (for new prescription with same attributes)? | No - simple workaround: copy values manually from detail screen. | Low - convenience feature | Open |
| PQ-008 | Should **medication name** be free-text or searchable database (Drugs.com API)? | Free-text MVP; future: optional lookup for standardization. | Low - UI only | Open |
| PQ-009 | Should users be able to **reorder** medications in the list? | Yes - drag-and-drop in Phase 1 (low priority). | Low - UX polish | Open |
| PQ-010 | Should there be a **"medication hold"** feature (pause all reminders temporarily)? | No - MVP has per-medication pause; global pause could be added later. | Low - simple cubit state | Open |

---

## Technical Questions

| ID | Question | Assumption | Impact | Status |
|-----|----------|------------|--------|--------|
| TQ-001 | How to handle **exact alarms on Android 14+** without the permission? | Request `SCHEDULE_EXACT_ALARM` via `exact_alarm_permission` plugin; if denied, fall back to inexact and show banner. | High - reliability critical | Open |
| TQ-002 | What is the **notification payload size** limit? | Minimal: doseId, medicationId, scheduledTime (as ISO string). | Low - standard payload | Open |
| TQ-003 | Should **dose_logs.scheduled_time** be stored in UTC or local? | Local (preserve user's timezone for historical display); convert to display in user's current timezone. | High - timezone correctness | Open |
| TQ-004 | How to handle **timezone changes** (travel)? | On timezone change (detected via system broadcast), reschedule all notifications using new local time; scheduled_time in logs remains original local time. | High - complex edge case | Open |
| TQ-005 | Should we **batch schedule** notifications (e.g., 30 days ahead) or schedule one at a time? | Batch schedule next 30 days to reduce DB/plugin calls; regenerate on boot/timezone change. | Medium - optimization | Open |
| TQ-006 | What is the **DB migration strategy** when schema changes in Phase 2? | Drift migrations with backup; test thoroughly before release. | High - data integrity | Open |
| TQ-007 | How to ensure **atomic log writes** (no duplicate entries on rapid taps)? | Use DB transaction + unique constraint on (medication_id, scheduled_time) or optimistic locking. | High - data consistency | Open |
| TQ-008 | Should **dose logs** be soft-deleted or hard-deleted? | Hard-delete allowed within 24h; after 24h, editing allowed but not delete. | Low - policy decision | Open |
| TQ-009 | What **encryption** for local data in MVP? | None (plain SQLite); add AES encryption in Phase 2 when cloud sync is introduced. | Medium - privacy vs. complexity trade-off | Open |
| TQ-010 | How to handle **large data sets** (thousands of logs) in history/charts? | Paginate history queries; aggregate charts by week/month for >90 days; limit calendar to 1 year back. | Medium - performance | Open |
| TQ-011 | Should we use `bloc_test` or `test` with `pump`? | Prefer `bloc_test` for Cubit/Bloc; use `test` for pure unit functions. | Low - testing strategy | Open |
| TQ-012 | How to test **notifications** reliably in CI? | Use mocks for `flutter_local_notifications`; avoid actual notification tests in CI; manual verification on device. | Medium - test coverage gap | Open |
| TQ-013 | Should **exact alarm** permission be requested during onboarding or when first dose scheduled? | During onboarding (if Android 14+); include rationale. | Medium - UX timing | Open |
| TQ-014 | What **error reporting** service besides Crashlytics? | None - only crash reporting; no analytics. | Low - compliance | Open |
| TQ-015 | How to handle **battery optimizations** that kill background services? | Exact alarm permission bypasses Doze on most devices; fallback notifications may be delayed. | High - reliability | Open |

---

## Reminder Scheduling Questions

| ID | Question | Assumption | Impact | Status |
|-----|----------|------------|--------|--------|
| RQ-001 | When a dose is **snoozed**, should the snoozed dose create a new pending dose entry or just reschedule notification? | Just reschedule notification; the original dose_log entry marked snoozed; no new dose entry created. | Medium - data model clarity | Open |
| RQ-002 | How many times can a dose be snoozed? | Unlimited snoozes until taken or skipped (but warn after 3 snoozes?). | Low - UX preference | Open |
| RQ-003 | If user **snoozes past the next scheduled dose** (e.g., has 8am and 10am, snoozes 8am to 10:30am), what happens? | 8am dose remains pending until taken; 10am dose remains scheduled; both show as overdue. | Medium - complexity | Open |
| RQ-004 | Should **missed dose window** be configurable (currently 3h)? | No - fixed at 3 hours for MVP; configurable later. | Low - preference | Open |
| RQ-005 | When a medication is **paused**, should pending notifications be cancelled? | Yes - cancel all future notifications for that med; resume recreates from current time. | High - correctness | Open |
| RQ-006 | If user changes **device time** manually, should notifications shift? | No - schedule based on original clock time (absolute); e.g., medication at 8am always 8am device time. | Medium - UX consistency | Open |
| RQ-007 | For **specific weekdays** (e.g., Mon/Wed/Fri), how to calculate next occurrence? | Find next calendar date matching weekday bitmask after current time. | Low - algorithm | Open |
| RQ-008 | Should **recurring notifications** be scheduled individually (each occurrence as separate notification) or use recurrence API? | Individual notifications (more control, easier reschedule). | Medium - implementation complexity | Open |
| RQ-009 | How far in advance to **schedule notifications**? | Next 30 days (adjustable later); regenerate after 7 days remain to avoid old stale notifications. | Medium - OS limits | Open |
| RQ-010 | What happens to **scheduled notifications** if app is **uninstalled and reinstalled**? | All lost; on fresh start, reschedule all active medications from DB. | Low - acceptable loss | Open |

---

## Privacy / Sharing Questions

| ID | Question | Assumption | Impact | Status |
|-----|----------|------------|--------|--------|
| PQ-011 | Should **provider messaging** be local-only or require backend in MVP? | Local-only; messages stored on device; "send" copies to clipboard or opens SMS app. | High - scope | Open |
| PQ-012 | Can users **export** individual medication history or only all data? | MVP: export all data only; individual export later. | Low - completeness | Open |
| PQ-013 | Should **sensitive medications** be hideable from exports? | No - MVP export includes all; later: per-medication privacy flag. | Low - privacy detail | Open |
| PQ-014 | What **data is included** in privacy export (CSV/JSON)? | medications table, schedules, dose_logs, refill_tracking, messages. | Medium - completeness | Open |
| PQ-015 | Should app request **屏Lock** before showing private data? | No - assume device already secured; no in-app PIN/biometric. | Low - security depth | Open |
| PQ-016 | Is **two-factor authentication** needed for cloud sync (Phase 2)? | Yes, but out of scope for now. | Low - future only | Open |

---

## Provider Messaging Questions

| ID | Question | Assumption | Impact | Status |
|-----|----------|------------|--------|--------|
| PM-001 | How does the user specify **provider contact info**? | Settings screen: enter provider name and phone number/email. | Low - simple config | Open |
| PM-002 | What **messaging protocol** to use? No backend. | Two options: 1) Open SMS app with prefilled text (SMS); 2) Copy message to clipboard with instruction to paste. | Medium - UX | Open |
| PM-003 | Can messages contain **attachments** (screenshots, PDFs)? | No - MVP text-only. | Low - future enhancement | Open |
| PM-004 | Are messages **encrypted** locally? | No - plain text in SQLite; acceptable for MVP (local-only). | Medium - privacy | Open |
| PM-005 | Can users **delete** or **edit** sent messages? | Delete allowed (local only); edit not supported. | Low - basic CRUD | Open |
| PM-006 | Should there be **notifications** for new provider messages? | No - messaging is polling user-initiated only (Phase 2: push notifications). | Low - out of scope | Open |
| PM-007 | How to **attach medication context** to a message? | Composer has "Attach medication" button that inserts text `[Medication: Aspirin 10mg]`. | Low - convenience | Open |
| PM-008 | Can users have **multiple providers**? | MVP: single provider; Phase 2: multiple threads. | Medium - scope | Open |

---

## Design Ambiguity Questions

| ID | Question | Suggested Resolution | Impact |
|-----|----------|---------------------|--------|
| DQ-001 | **Icon picker**: Which icons available? | Use Material Icons subset: pill, medication, vaccines, water_drop, syringe, science, health_and_safety, etc. ~12 icons. | Low |
| DQ-002 | **Empty state illustrations**: custom or generic? | Use simple vector illustrations from design system (already in Stitch assets). | Low |
| DQ-003 | **Color for primary action button**: Should hover state change shade? | Yes: hover → `surface_tint` (darker) or `primary_fixed` (lighter)? Use `surface_tint` for depth. | Low |
| DQ-004 | **Progress ring animation**: should it animate on load? | Yes: animate stroke-dashoffset from 0 to target over 800ms. | Low |
| DQ-005 | **Snooze duration picker**: inline or separate screen? | Inline expansion: tap Snooze → reveals 4 duration chips in place. | Low |
| DQ-006 | **Deleted medication behavior**: what happens to associated logs? | Keep logs (historical record); medication gone from list; logs still show in history. | Medium |
| DQ-007 | **Missed dose notification**: should it be separate or just dashboard alert? | Dashboard banner only; no additional notification (avoid alarm fatigue). | Low |
| DQ-008 | **Adherence calculation**: treat "snoozed" as missed or pending? | Snoozed → eventually taken counts as taken; if snoozed indefinitely, eventually becomes missed. | Medium |
| DQ-009 | **Calendar view**: month grid or week list? | Month grid with color-coded days; tap for detail. | Low |
| DQ-010 | **Action Sheet**: Should "Snooze" be a button or a dropdown? | Button with expandable chips; primary action "Take" always visible. | Low |

---

## Assumptions Summary

All open questions above have an associated **assumption** that allows planning to proceed. These assumptions should be confirmed with stakeholders (product owner, designer, tech lead) before implementation begins.

**Critical path assumptions** (high-impact if changed):
- TQ-003: Local time storage for scheduled_time
- TQ-004: Timezone change handling via reschedule
- TQ-007: Atomic log writes via transaction
- RQ-005: Paused meds cancel notifications
- PQ-006: Refill count decrements on all logs (taken/skipped/missed)
- PM-002: Messaging via SMS intent (simplest)
- TQ-009: 30-day notification schedule window

---

**Last Updated:** 2026-04-29  
**Status:** 0 resolved, 34 open  
**Next:** Review with stakeholders and update assumptions
