# Project Overview

## Product Summary

TakeYourPills is a medicine tracker mobile application designed to help users manage their medication regimens with confidence and calm. The app provides reliable reminders, simple logging, adherence tracking, refill management, and optional provider messaging. It adopts a "Premium Minimalism" design philosophy — clinical in its clarity and organization, but warm and anxiety-reducing in its feel.

## Problem Statement

Medication non-adherence is a critical health issue:
- ~50% of patients miss doses or take medications incorrectly
- Missed doses lead to treatment failure, hospitalizations, and worsened outcomes
- Existing medication apps are often cold, clinical, or overly complex
- Users experience "reminder fatigue" and logging friction
- Privacy concerns prevent sharing data with caregivers or providers

TakeYourPills solves this by combining reliability with a calming user experience that makes daily medication management feel manageable and confidence-inspiring.

## User Types

### Primary User: Patient / Self-Manager
- **Demographics:** Adults managing chronic or temporary medications (ages 25-75)
- **Tech comfort:** Moderate to high (smartphone users)
- **Goals:** Establish routine, avoid missed doses, track adherence, manage refills
- **Pain points:** Anxiety about forgetting, confusing schedules, privacy concerns
- **Usage pattern:** Multiple daily check-ins (morning, afternoon, evening)

### Secondary User: Caregiver (Future Phase)
- **Demographics:** Family members managing medications for elderly or dependent patients
- **Goals:** Monitor adherence, receive alerts, assist with scheduling
- **Note:** Out of scope for MVP; considered in privacy architecture design

### Tertiary User: Healthcare Provider (Future Phase)
- **Demographics:** Physicians, pharmacists, nurses
- **Goals:** View patient adherence, send messages, adjust recommendations
- **Note:** Messaging feature in MVP will be local-only; backend integration deferred

## Core Value Proposition

"TakeYourPills gives you quiet confidence in your medication routine — reliable reminders, simple logging, and clear progress, all wrapped in a calm, private experience."

### Key Value Pillars

1. **Reliability First** - Local-first architecture ensures reminders work even without connectivity
2. **Effortless Logging** - One-tap logging from notifications; no tedious data entry
3. **Progress Clarity** - Visual adherence indicators and history that build understanding
4. **Privacy by Design** - You control what data stays on-device vs. what gets shared
5. **Provider Connection** - Secure messaging when you need to ask questions

## App Modules (Feature Map)

| Module | Description | User Goal |
|--------|-------------|-----------|
| Onboarding / Permissions | intro flow + notification permission request | Get set up correctly, understand why permissions matter |
| Home Dashboard | Greeting, adherence score, next dose, today's schedule | See everything at a glance, know what's due now |
| Today's Medications | Expanded view of all doses for current day | Review full day, prepare ahead |
| Next Dose (Hero) | Prominent card for the most imminent dose | Act quickly when a reminder fires |
| Missed Doses Alert | Visual indicator + quick recovery actions | Fix mistakes immediately |
| Medication List | Full catalog of all medications with status | Manage inventory, see all active/paused meds |
| Add/Edit Medication | Multi-step form with scheduling, dosage, inventory | Add new medication with flexible timing |
| Schedule Calendar | Monthly/agenda view of all doses | Plan ahead, visualize monthly patterns |
| Reminder Action Sheet | Bottom sheet when notification triggered | Log dose (taken/snoozed/skipped) in <2 seconds |
| Refill Tracker | Inventory level, low-stock alerts, reorder list | Never run out of medication |
| History & Adherence | Past logs with streaks, daily averages | Understand trends, stay motivated |
| Progress Charts | Graphs over time (7d, 30d, 90d) | Visual progress feedback |
| Settings | App configuration, notifications, privacy | Control how the app works for you |
| Notification Settings | Per-medication toggle, quiet hours,sound selection | Customize alert behavior |
| Privacy & Sharing Settings | Data export, sharing toggles, provider messaging controls | Decide who sees what |
| Provider Messaging | In-app message thread with provider | Ask questions without phone tag |

## In Scope (MVP Boundaries)

### Phase 1: Core Local-First Tracking (MVP)
- Single-user medication management (no caregiver sharing)
- Local database persistence (Drift/SQLite)
- Local notification reminders with flexible scheduling
- Complete medication CRUD (add/edit/delete/pause)
- Daily logging (taken/snoozed/skipped) from notifications and app
- Adherence calculation (daily score, history)
- Refill tracking with low-quantity alerts
- Basic settings (notifications toggle, quiet hours, medication appearance)
- Privacy controls (data on-device only, local export)
- Provider messaging (local-only message list; no backend sync)
- Offline operation with no network requirement
- Crashlytics for stability monitoring

### Phase 2: Sync & Sharing (Post-MVP)
- Firebase backend for optional cloud sync
- Caregiver view & alerts
- Provider portal / message sync
- Multi-device sync
- Automatic refill reminders via provider integration

## Out of Scope (Explicitly Excluded)

- Electronic prescribing (e-prescribing)
- Pharmacy integration / automatic refill ordering
- Insurance claims or benefit checking
- Medication interaction checking (FDA database integration)
- Gamification, rewards, or social sharing
- Apple Health / Google Fit integration (may add later)
- Voice input or Siri/Google Assistant shortcuts
- Multi-language support (English only for MVP)
- Wearable app (Apple Watch / Wear OS)

## Assumptions

### User Assumptions
- Users can grant notification permissions during onboarding
- Users understand basic medication terms (dosage, frequency, unit)
- Primary user is the medication taker (not a proxy)
- Users have smartphones with Android 8+ or iOS 13+
- Users check the app at least once daily (morning routine)
- Users may have 1-10 active medications (not hundreds)

### Technical Assumptions
- Local-only storage is acceptable for MVP; cloud sync is Phase 2
- Notifications require exact scheduling (not approximate)
- Timezone changes must be handled correctly for reminders
- Daylight saving time transitions must not break schedules
- Device storage constraints are minimal (<50MB app + data)
- Users may have multiple daily reminders (up to 20/day)
- Provider messaging does not need real-time delivery in MVP

### Regulatory Assumptions
- HIPAA compliance is not required for local-only storage (no PHI transmitted)
- Once cloud sync is added, data will be encrypted at rest and in transit
- App store guidelines for health apps are followed (clear privacy policy)
- No medical advice is given; app is a tracking tool only

## Constraints

- **Platform:** Must support both Android and iOS from single Flutter codebase
- **Offline-first:** Core functionality must work without network
- **Privacy:** Sensitive health data must stay on device unless explicitly shared
- **Reliability:** Reminders must fire at exact scheduled times
- **Performance:** App must launch in <2 seconds; logging must be instant
- **Battery:** Background operations must not drain battery excessively
- **Notifications:** Must respect OS-level quiet hours and Do Not Disturb
- **Testing:** Codebase must be highly testable (≥80% unit test coverage targeted)

## Success Criteria

### MVP Success Metrics
- **Reminder Reliability:** ≥99.5% of scheduled reminders fire within 1 minute of target time
- **Logging Speed:** ≥90% of logged doses occur within 10 seconds of notification
- **Adherence Impact:** Users average ≥80% weekly adherence score after 2 weeks
- **Retention:** ≥60% of users still opening app daily after 14 days
- **Crash-free:** ≥99.9% crash-free sessions (Firebase Crashlytics)
- **Privacy Confidence:** ≥85% of users feel "in control" of their data (survey)

### Qualitative Success Indicators
- Users describe the app as "calm" and "reassuring"
- Users report reduced anxiety about medication management
- Care provider messaging used for legitimate clinical questions
- Refill alerts prevent actual medication runs-outs (user reports)

---

**Last Updated:** 2026-04-29  
**Status:** Planning  
**Phase:** Pre-initiation
