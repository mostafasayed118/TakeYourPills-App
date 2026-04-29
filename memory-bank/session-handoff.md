# Session Handoff

## Current Planning Status

**Date:** 2026-04-29  
**Session Type:** Initial planning phase (pre-implementation)  
**Project:** TakeYourPills (healthcare medication tracker)  
**Phase:** Planning / Pre-initiation  

### What Was Accomplished
- Reviewed existing design system (Stitch) with 14 screen prototypes and HTML code
- Analyzed design tokens: Calm & Clinical Excellence theme (Manrope font, muted teal palette, soft shadows, 16px radius)
- Created complete 10-file memory-bank planning package covering:
  - Project overview and scope
  - Product requirements with acceptance criteria
  - Implementation plan with phases and task breakdown
  - Architecture decisions (Flutter structure, Bloc/Cubit strategy, routing, persistence, testing)
  - Design system notes (UI components, patterns, accessibility)
  - Prioritized task backlog (113 tasks)
  - Open questions (44 items with assumptions)
  - Risk register (20 risks with mitigations)
  - Session handoff (this file)

---

## Confirmed Decisions

These decisions are **locked in** and should not be revisited unless a blocker emerges:

1. **Tech Stack**: Flutter + flutter_bloc (Bloc/Cubit hybrid) + go_router + Drift + get_it + freezed + json_serializable + flutter_local_notifications + timezone + flutter_secure_storage + shared_preferences + bloc_test + mocktail + Firebase Crashlytics ✓

2. **Architecture Style**: Feature-first folder structure (not strict clean architecture 4-layer). Domain layer optional for simple features; present data/presentation separation.

3. **State Management**: Cubit for simple state (settings, forms, list), Bloc for complex event-driven flows (reminder actions, messaging).

4. **Persistence**: Drift SQLite with local-first. No backend in MVP. Mappers isolate domain from database.

5. **Notifications**: flutter_local_notifications + timezone. Schedule 30 days ahead, reschedule on boot/timezone change. exact_alarm_permission plugin for Android 14+.

6. **Routing**: go_router with ShellRoute for bottom nav; redirect guard for onboarding completion.

7. **MVP Scope**: Phases 0-3 + partial settings. Excludes: calendar view, progress charts, provider messaging, data export (these are post-MVP).

8. **Design System**: Calm & Clinical Excellence. Colors from DESIGN.md. Manrope font. Ambient shadows. 600px max width.

9. **Testing Strategy**: Unit tests for Cubits/DAOs/services (≥80% coverage). Widget tests (≥50%). Integration tests for key flows. Accessibility audit required.

10. **Bloc vs Cubit**: Cubit for Medication List, Add Medication, Dashboard (simple state). Bloc for Reminder Action Sheet and Messaging (complex event sequences).

---

## Open Items (Pending Validation)

The following items require confirmation before implementation begins:

### High Priority

| Item | Owner | Rationale |
|------|-------|-----------|
| Confirm **MVP scope boundary** (which features exactly in MVP vs Phase 2) | Product Manager | Determines task order and effort |
| Validate **timezone storage** choice: local vs UTC for `scheduled_time` | Tech Lead | High impact on correctness |
| Confirm exact alarm strategy for **iOS** (critical alerts entitlement?) | iOS Dev | Affects reliability on iOS |
| Decide **snooze behavior**: unlimited vs limited? UX tradeoff | Product/UX | Affects user experience |
| Review **refill count decrement** policy: all logs or only taken? | Product | Affects inventory accuracy |
| Confirm **provider messaging** approach: SMS intent vs clipboard vs disabled | Product | Impacts Phase 6 scope |

### Medium Priority

| Item | Owner | Rationale |
|------|-------|-----------|
| Icon set selection (which Material Icons) | Designer | Ensures visual consistency |
| Empty state illustration assets location | Designer | UI completeness |
| Notification sound choices (default, chime, gentle, none) | UX | Audio preferences |
| Privacy policy text content | Legal/Product | Required for app stores |
| Onboarding flow: skip allowed? | UX | User friction balance |
| Max medications limit (hard or soft?) | Product | Database/UX constraints |

---

## Immediate Next Recommended Action

**Step 1:** Create the Flutter project and folder structure.

```bash
cd E:\projects_mobile_flutter\takeyourpills_healthcare_app
flutter create takeyourpills .
```

**Step 2:** Add all required dependencies to `pubspec.yaml` (see T003 task for full list).

**Step 3:** Commence **Sprint 0 - Sprint 1** tasks:
- T001–T020 in order (Project Setup + Core Infrastructure)
- Focus on getting a blank app running with theme and routing before building any features.

**4-week sprint cadence suggested.**

---

## Required Files to Read Before Implementation

### Must-Read First (in order):
1. `memory-bank/architecture-decisions.md` - Technical decisions and folder structure
2. `memory-bank/design-system-notes.md` - Design tokens and component patterns
3. `memory-bank/product-requirements.md` - Feature specs and acceptance criteria
4. `memory-bank/implementation-plan.md` - Phase sequence and definition of done
5. `memory-bank/tasks.md` - Detailed task list with dependencies

### Reference As Needed:
6. `memory-bank/project-overview.md` - For product context
7. `memory-bank/open-questions.md` - Check assumptions before starting a feature
8. `memory-bank/risk-register.md` - Watch for pitfalls
9. `stitch_takeyourpills_healthcare_design_system/calm_clinical_excellence/DESIGN.md` - Design token source
10. `stitch_takeyourpills_healthcare_design_system/<screen>/code.html` - UI prototypes for each screen

---

## Reusable Prompt for Future AI Coding Sessions

When a new AI assistant is brought into the project, use this prompt to bootstrap context:

```
You are assisting with the TakeYourPills Flutter medication tracker app. This is a fresh project starting implementation phase. 

Key context:
- Tech stack: Flutter, flutter_bloc (Cubit+Bloc), go_router, Drift, get_it, freezed, json_serializable, flutter_local_notifications, timezone
- Architecture: Feature-first modular structure; data/domain/presentation separation where sensible; local-first offline
- Design: Calm & Clinical Excellence theme (Manrope font, muted teal #366460, soft shadows, 16px radius, 600px max width)
- MVP scope (Phases 0-3): Medication CRUD, local notifications with Action Sheet, Dashboard with adherence, basic settings
- Post-MVP (Phases 4-6): Calendar, progress charts, refill tracker deep dive, provider messaging, export
- Critical: Reminders must be exact and reliable; local-first persistence; privacy-by-design

Read these files in order:
1. memory-bank/session-handoff.md (this snapshot)
2. memory-bank/architecture-decisions.md
3. memory-bank/tasks.md
4. memory-bank/product-requirements.md
5. memory-bank/design-system-notes.md

The most recent tasks are in tasks.md; start with the first TODO items (T001–T020).
Update memory-bank files after every milestone.
```

---

## Known Unknowns to Flag

- **Exact alarm permission on Android 14+** - Need real device testing
- **iOS critical alerts entitlement** - May require Apple approval; could delay or reduce reliability on iOS
- **Timezone edge cases** - Require extensive manual testing across DST boundaries
- **OEM battery optimizations** - Some devices (Xiaomi, Huawei) may still kill notifications despite exact alarm
- **User adoption of provider messaging** (if implemented as SMS intent) - Will users understand?

---

## Dependencies & Blockers

### External Dependencies
- ✅ Design system complete (Stitch screens and tokens available)
- ⚠️ Firebase project setup for Crashlytics (requires Firebase console configuration)
- ⚠️ iOS developer account (needed for notification entitlements)
- ⚠️ Google Play Console account (for testing later)

### Internal Code Dependencies
- **Database schema** must be finalized before any feature work
- **Theme** must be implemented before screens to avoid rework
- **NotificationService** must work before scheduling logic
- **Cubits** must be testable before UI screens to separate concerns

---

## Environment Setup Checklist

Before first line of code:

- [ ] Install Flutter 3.5+ (stable)
- [ ] Configure Android SDK (API 23 min, 34 target)
- [ ] Configure Xcode (iOS 13+ deployment target)
- [ ] Create Firebase project; add Android/iOS apps; download `google-services.json` and `GoogleService-Info.plist`
- [ ] Add Crashlytics dependencies and configure
- [ ] Set up VS Code or Android Studio with Flutter/Dart plugins
- [ ] Install useful CLI tools: `flutter_lints`, `dart_code_metrics` (optional)
- [ ] Run `flutter doctor` to verify setup

---

## Version Control & Branching Strategy

- Main branch: `main` (protected)
- Feature branches: `feature/<name>` (e.g., `feature/medication-crud`)
- Sprint integration branch: `sprint/<n>` (optional)
- PRs require: 2 approvals, all tests passing, lint clean, memory-bank updated

---

## First Week Sprint Goal

**Sprint 0 Deliverable:** Barebones app with:
- App launches without crash
- Theme applied (teal primary, Manrope font)
- Bottom navigation present (placeholder pages)
- Routing between 5 tabs works
- Database file created on first launch
- `pubspec.yaml` locked with all dependencies

**Definition of Done Sprint 0:**
- T001–T020 completed
- No lint warnings
- Compiles on Android emulator and iOS simulator
- README in repo with setup instructions

---

## Stakeholder Communication Plan

- **Weekly demo** every Friday (show working increment)
- **Memory-bank updates** after each session (commit with message)
- **Risk review** bi-weekly
- **Stakeholder sync** every 2 weeks to confirm priorities and scope

---

**Handoff Status:** Ready for implementation  
**Assigned To:** Development Team / Next AI Assistant  
**Start Date:** Next sprint  
**Expected Completion:** 13 weeks (Sprint 0–6) to MVP Beta
