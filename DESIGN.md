# DESIGN.md — TakeYourPills

> **Calm & Clinical Excellence** — a "Premium Minimalism" design language for a Flutter mobile medication tracker.
> Drop this file into any agent context, and ask it to "build me a screen that matches DESIGN.md."

This document is the canonical design system for the TakeYourPills healthcare app. It is written in the [Stitch DESIGN.md](https://stitch.withgoogle.com/docs/design-md/overview/) format and extended with the Agent Prompt Guide section popularized by the [Awesome DESIGN.md](https://github.com/VoltAgent/awesome-design-md) collection. Every token below is mirrored 1:1 in the Flutter theme implementation (`lib/shared/theme/`), so agents generating Dart/Flutter code can rely on these values verbatim.

---

## 0. Project Context

| Property | Value |
|---|---|
| **App name** | TakeYourPills |
| **Package** | `takeyourpills_healthcare_app` |
| **One-liner** | Medicine tracker with reminders, adherence history, and refills. |
| **Platforms** | **Mobile only** — Android 5.0+ (min SDK 21), iOS 13.0+. No web / desktop / macOS / Linux (SQLite FFI + local notifications + secure storage block them). |
| **Framework** | Flutter (Material Design 3), Dart `^3.8.0` |
| **Typeface** | Manrope (loaded via `google_fonts` with bundled `.ttf` fallback at 400 / 500 / 600 / 700) |
| **Target user** | People managing daily medication routines who want calm, low-anxiety, hospital-grade reliability. |
| **Status** | MVP — ~95% feature complete. Dark mode scaffolded but currently aliased to light. |

---

## 1. Visual Theme & Atmosphere

The system is rooted in the intersection of **professional medical reliability** and **modern wellness aesthetics**. It deliberately avoids the cold, sterile atmosphere of traditional clinical software in favor of a **"Sanctuary" experience** — one that reduces the anxiety often associated with medication management.

**Style:** Premium Minimalism.

**Emotional goal:** *Quiet confidence and reassurance.* Users checking dosages under stress or in low light should feel organized, never alarmed.

| Attribute | Directive |
|---|---|
| **Mood** | Calm, trustworthy, reassuring, organized |
| **Density** | Low — generous whitespace, breathable cards, single-column primary flow |
| **Visual complexity** | Restrained palette, tonal layering over borders, rounded soft surfaces |
| **Motion** | Slow, gentle fades (`FadeTransition` only — no slides), 200–300 ms, `Curves.easeInOut` |
| **Philosophy** | Cognitive ease first. Hierarchy through tone and shape, never through heavy borders or harsh shadows. |

**Brand values:** Sanctuary · Clarity · Confidence · Premium.

---

## 2. Color Palette & Roles

The palette is **low-stimulation, high-clarity**. A muted Nature-Inspired Sage/Teal primary sits over a multi-tier neutral off-white background. Functional tones are softened so feedback never triggers an "alarmist" response. Text is a deep charcoal — **never pure black**.

All hex values are the source-of-truth tokens mirrored in `lib/shared/theme/app_colors.dart`.

### Primary — Muted Sage / Teal
| Token | Hex | Role |
|---|---|---|
| `primary` | `#366460` | Primary actions, active states, brand, focus ring |
| `onPrimary` | `#FFFFFF` | Text / icons on primary |
| `primaryContainer` | `#4F7D79` | Hero dose card, stat cards, secondary brand surfaces |
| `onPrimaryContainer` | `#F3FFFD` | Text on primaryContainer |
| `primaryFixed` | `#BBECE7` | Light accents, soft sage fills |
| `primaryFixedDim` | `#A0D0CB` | Subtle highlights / inverse primary |
| `onPrimaryFixed` | `#00201E` | Text on primaryFixed |
| `onPrimaryFixedVariant` | `#1F4E4B` | Variant text on primaryFixed |

### Secondary
| Token | Hex | Role |
|---|---|---|
| `secondary` | `#4C6361` | Supporting elements |
| `onSecondary` | `#FFFFFF` | Text on secondary |
| `secondaryContainer` | `#CCE5E2` | Info chips, secondary icon chips, time chips |
| `onSecondaryContainer` | `#506765` | Text on secondaryContainer |
| `secondaryFixed` | `#CFE8E5` | Fixed light surface |
| `secondaryFixedDim` | `#B3CBC9` | Dim variant |
| `onSecondaryFixed` | `#081F1E` | Text on fixed |
| `onSecondaryFixedVariant` | `#344B49` | Variant text |

### Tertiary
| Token | Hex | Role |
|---|---|---|
| `tertiary` | `#565D5D` | Tertiary text / icons |
| `onTertiary` | `#FFFFFF` | Text on tertiary |
| `tertiaryContainer` | `#6F7675` | Neutral containers |
| `onTertiaryContainer` | `#F7FEFD` | Text on tertiaryContainer |
| `tertiaryFixed` | `#DDE4E3` | Fixed light surface |
| `tertiaryFixedDim` | `#C1C8C7` | Dim variant |
| `onTertiaryFixed` | `#161D1D` | Text on fixed |
| `onTertiaryFixedVariant` | `#414848` | Variant text |

### Background & Surface — multi-tier tonal layering (off-white with subtle blue tint)
| Token | Hex | Role |
|---|---|---|
| `background` | `#F9F9FF` | Scaffold background (off-white, blue undertone) |
| `onBackground` | `#151C27` | Primary text on background |
| `surface` | `#F9F9FF` | Card backgrounds (same as background in light theme) |
| `surfaceDim` | `#D3DAEA` | Dim surface |
| `surfaceBright` | `#F9F9FF` | Bright surface |
| `surfaceContainerLowest` | `#FFFFFF` | Inputs, modals — pure white lift |
| `surfaceContainerLow` | `#F0F3FF` | Subtle fills, paused states, info cards |
| `surfaceContainer` | `#E7EEFE` | Standard container |
| `surfaceContainerHigh` | `#E2E8F8` | Borders, "UPCOMING" pills, dividers |
| `surfaceContainerHighest` | `#DCE2F3` | Highest container tier |
| `surfaceVariant` | `#DCE2F3` | Alias of `surfaceContainerHighest` |
| `onSurface` | `#151C27` | Primary text (deep charcoal, never `#000`) |
| `onSurfaceVariant` | `#404847` | Secondary text, subtitles, icons |
| `inverseSurface` | `#2A313D` | Inverse background (snackbars) |
| `inverseOnSurface` | `#EBF1FF` | Inverse text |
| `surfaceTint` | `#386663` | Surface tint |

### Outline & Divider
| Token | Hex | Role |
|---|---|---|
| `outline` | `#707977` | Border color |
| `outlineVariant` | `#C0C8C6` | Subtle borders, placeholder text, inactive dot pagination |
| `divider` | `#E0E7E6` | Thin 1px list dividers (Flutter may use `surfaceContainerHigh` instead) |

### Error / Functional (alarmist-softened)
| Token | Hex | Role |
|---|---|---|
| `error` | `#BA1A1A` | Soft red — destructive actions, missed dose alerts |
| `onError` | `#FFFFFF` | Text on error |
| `errorContainer` | `#FFDAD6` | Warning fills, low-refill warning chips (light pink) |
| `onErrorContainer` | `#93000A` | Text on errorContainer |

### Functional semantics (no extra tokens — derived from above)
| Semantic | Source token |
|---|---|
| Success / Taken | `primary` (`#366460`) — calm confirmation, never bright green |
| Warning / Low refill | `errorContainer` at 0.5 alpha — soft pink, not amber |
| Danger / Missed | `error` (`#BA1A1A`) — restrained red |
| Info / Upcoming | `surfaceContainerHigh` (`#E2E8F8`) — neutral chip |

### Quick Reference — Light
```
Sage/Teal   #366460     Primary brand
Container   #4F7D79     Hero surfaces
Background  #F9F9FF     Off-white canvas
Pure white  #FFFFFF     Inputs, modals
Charcoal    #151C27     Primary text (never #000)
SubText     #404847     Secondary text
Error       #BA1A1A     Soft, restrained red
Divider     #E0E7E6     Hairline separators
```

---

## 3. Typography Rules

A single typeface — **Manrope** — for its balanced, modern, and highly legible characteristics. Type is built for **rapid scanning**, critical for users checking dosages under stress.

### Font Stack
```
Manrope  ::  400 / 500 / 600 / 700
Fallback ::  System sans-serif (Flutter Material default)
```
In Flutter, Manrope is loaded via the `google_fonts` package (`GoogleFonts.manropeTextTheme(...)`) with bundled `.ttf` files in `assets/fonts/` as offline fallback.

### Type Scale (6 styles — matches the Stitch design tokens verbatim)
| Flutter Style | Design name | Size | Weight | Line height | Letter spacing | Usage |
|---|---|---|---|---|---|---|
| `displayLarge` | `display-lg` | 36px | 700 | 44px (1.22) | -0.02em | Hero headlines — onboarding titles only |
| `headlineMedium` | `headline-md` | 24px | 600 | 32px (1.33) | -0.01em | Screen titles, section headers, large medication names |
| `titleSmall` | `title-sm` | 18px | 600 | 24px (1.33) | 0 | Card titles, list item headers, button text |
| `bodyMedium` | `body-base` | 16px | 400 | 24px (1.5) | 0 | Primary body text, paragraphs |
| `bodySmall` | `body-sm` | 14px | 400 | 20px (1.43) | 0 | Secondary text, subtitles, captions |
| `labelLarge` | `label-caps` | 12px | 700 | 16px (1.33) | +0.05em | **UPPERCASE** labels, chips, badges (e.g., `"10:00 AM • WITH FOOD"`, `"UPCOMING"`, `"PAUSED"`) |

### Typographic Rules
- **Line heights** are intentionally increased to prevent text-crowding and to ease scanning.
- **Negative letter-spacing** is reserved for display and headline sizes only; body and small use default tracking.
- **Uppercase labels** (`label-caps`) with `+0.05em` tracking are used **sparingly** — only for badging, timing, and structural eyebrows — to create an architectural feel without over-capitalizing.
- **Text is never pure black.** Use `onSurface` (`#151C27`) for the deepest text.
- **No font mixing.** Manrope is the only display/face. Do not introduce second families.

### Flutter mapping hint
```dart
Theme.of(context).textTheme.displayLarge   // 36 / w700 / -0.02em / lh 44
Theme.of(context).textTheme.headlineMedium // 24 / w600 / -0.01em / lh 32
Theme.of(context).textTheme.titleSmall     // 18 / w600 / lh 24
Theme.of(context).textTheme.bodyMedium     // 16 / w400 / lh 24
Theme.of(context).textTheme.bodySmall      // 14 / w400 / lh 20
Theme.of(context).textTheme.labelLarge     // 12 / w700 / +0.05em / lh 16
```

> **Note:** The Flutter `MaterialApp` currently wraps `MediaQuery` with `TextScaler.noScaling`, so runtime font-scale settings are disabled app-wide for layout stability. Treat the px values above as fixed.

---

## 4. Component Stylings

This section codifies the shared component library (`lib/shared/components/`) plus feature widgets. All values are enforced either in `AppTheme` (`lib/shared/theme/app_theme.dart`) or directly inside the component widgets.

### Button — `AppButton` (variants via `isPrimary`)

| Variant | Background | Text color | Border | Radius | Min size | Padding |
|---|---|---|---|---|---|---|
| **Primary** | `primary` `#366460` | `onPrimary` `#FFFFFF` | none | 12px (`md`) | `∞ × 56` | `20 × 16` |
| **Secondary (ghost)** | transparent | `primary` | 1px `primary` | 12px (`md`) | `∞ × 56` | `20 × 16` |
| **Disabled (primary)** | `primary` @ **opacity 0.5** | `onPrimary` | none | 12px | — | `20 × 16` |
| **Disabled (secondary)** | `surfaceContainerLow` `#F0F3FF` | `onSurfaceVariant` | `outlineVariant` | 12px | — | `20 × 16` |
| **Loading** | `primary` | — | none | 12px | — | inline `CircularProgressIndicator` (20×20, stroke 2) + `"Saving..."` in `titleSmall` |

- **Text style:** `titleSmall` (18px / w600) for both variants.
- **Optional icon** is placed 8px before the text (`Row`, `gap: 8`).
- **No elevation / no shadow** on buttons — depth is reserved for cards.
- **Touch target:** 56px height (exceeds the 44px accessibility minimum).
- Note: `AppButton` styles via `ElevatedButton.styleFrom(...)` — it intentionally overrides the theme-level button style. Ghost variant is rendered with `OutlinedButton`.

### Card — `AppCard`

| Attribute | Value |
|---|---|
| Background | `surface` `#F9F9FF` (or custom color) |
| Radius | **16px** (`lg`) — default |
| Padding | `EdgeInsets.all(16)` default (overridable per card) |
| Margin | optional |
| Shadow | **Ambient Shadow** (see §6) — `0px 4px 20px rgba(0,0,0,0.04)` equivalent |
| Border | none by default — a 2px `outline` border may indicate "paused" |
| `onTap` | wraps content in `InkWell` with matched `borderRadius`; ripple uses theme splash |

Feature cards (`MedicationCard`, `DetailCard`, `_buildNextDoseCard`, `_buildAdherenceCard`, `_buildUpcomingList`) reuse the same ambient shadow signature. **Paused state** reduces `blurRadius` to 8 (slightly tighter depth).

> **Implementation note:** Cards use `Container + BoxDecoration` rather than the Material `Card` widget, so the ambient `BoxShadow` (not elevation-based) can be controlled precisely. The `cardTheme` exists in `AppTheme` but is largely bypassed.

### Input — `AppInput`

| Attribute | Value |
|---|---|
| Fill | `surfaceContainerLowest` `#FFFFFF` |
| Radius | **16px** (`lg`) across all states |
| Enabled border | 1px `surfaceContainerHigh` `#E2E8F8` |
| Focused border | **2px** `primary` `#366460` |
| Error border | 2px `error` `#BA1A1A` |
| Label | **Outside / above the field** — always visible, never floating, rendered as a separate `Text` in `labelLarge` (12px / w700) painted in `onSurfaceVariant` |
| Label gap | **8px** (`sm`) |
| Hint text | `bodyMedium` in `outlineVariant` `#C0C8C6` |
| Content padding | `16 × 16` |
| Accessories | `prefixIcon`, `suffixIcon`, `maxLines`, `keyboardType`, `textCapitalization`, `validator`, `onChanged`, `onSubmitted` |

> Contrasts with the canonical design note which recommends fill `#F1F3F3` —Flutter uses pure white `surfaceContainerLowest`. Treat `#FFFFFF` as authoritative.

### Adherence Ring — `AdherenceRing`
| Attribute | Value |
|---|---|
| Widget | `CircularProgressIndicator` (deterministic) |
| Size | 80 × 80 |
| StrokeWidth | 8 |
| Track | `surfaceContainerHigh` `#E2E8F8` |
| Value color | `primary` `#366460` |
| Center label | `titleSmall` (percentage) + `bodySmall` ("Adherence") |
| Stroke cap | default (round in Stitch; Flutter uses square) |

### Medication Card — `MedicationCard`
- **Margin:** `20 × 6` (horizontal × vertical)
- **Radius / padding:** 16 inner, 16 radius
- **Icon chip:** `secondaryContainer` `#CCE5E2` background, 12px radius
- **Trailing:** popup menu (`Edit / Pause / Resume / Delete`)
- **Paused badge:** uppercase "PAUSED", 10px / w600 / `letterSpacing 0.5`, `error` background
- **Low-refill warning icon** appears next to pills-remaining count

### Stat Chip — `StatChip`
- Radius 16, padding 16
- **Warning state:** `errorContainer` at 0.5 alpha (soft pink)
- **Normal state:** `surfaceContainerLow` `#F0F3FF`
- **Value text:** `headlineMedium` (24px / w600)

### Empty State — `EmptyStateWidget`
- Centered column, 40px horizontal padding
- Icon: default `Icons.inbox_outlined` at **80px** in `surfaceContainerHigh` (custom icon override accepted)
- 24px gap → title (`headlineMedium` in `onSurface`, centered)
- 8px gap → subtitle (`bodyMedium` in `onSurfaceVariant`, centered, optional)
- 24px gap → optional `AppButton` CTA

### Bottom Navigation
- 5 tabs, fixed type, elevation 8
- Background: `surface`; selected icon/text: `primary`; unselected: `onSurfaceVariant`
- Active icons: `Icons.home`, `medication`, `calendar_today`, `insights`, `settings` (filled variants when active)
- Tabs: Home · Meds · Calendar · Progress · Settings

### App Bar
- Background: `surface` (solid — Flutter drops the Stitch HTML `backdrop-blur(90%)` effect)
- Foreground: `onSurface`
- **Elevation 0, `scrolledUnderElevation: 0`** — no shadow ever
- Leading: avatar (home) or back chevron (sub-pages)
- Trailing: notifications icon (badge) or settings

### Snackbars
- Background: `inverseSurface` `#2A313D`
- Text: `onSurface`
- Action (e.g., "Undo"): `primary`
- Duration: 4–6 seconds

### Modals & Bottom Sheets
- Full-screen dialogs (Add Medication, Settings subpages): sticky top bar with title, back/close, Save action; scrollable body
- Bottom sheets: top radius **24px** (`xl`), drag handle (1.5px line), auto or 80% screen height, swipe-down dismissible

---

## 5. Layout Principles

The system follows an **8px spacing rhythm** with a 4px sub-grid. All Flutter spacing comes from the tokens below — treat them as the only legal spacing values.

### Spacing Scale
| Token | px | Used as |
|---|---|---|
| `unit` | 4 | Base unit, micro-alignment |
| `xs` | 4 | Tiny gaps (dot pagination margin) |
| `sm` | 8 | Small gaps — label→field, icon→text, row micro |
| `md` | **16** | Card internal padding, input vertical/horizontal padding, row gaps |
| `lg` | 24 | Section spacing, button-row padding |
| `xl` | 32 | Onboarding page padding, large breaks |
| `container-padding` | **20** | **Page margins** (standard) |
| `gutter` | 16 | Column gutter |

### Grid & Container
- **Mobile-first / single column** — fluid grid, **max content width 600px** (enforced in Stitch HTML; not strictly enforced in Flutter but app is mobile-only)
- **Page margins:** 20px (~container-padding) or 24px on screens with more breathing room (onboarding)
- **Card inner padding:** 16px default, 20–24px on hero cards
- **List item minimum height:** 56px
- **Settings dividers:** 1px in `surfaceContainerHigh`, **inset 56px from the leading edge** (so the divider starts after the icon + 16px gap)

### Touch Targets
- **Minimum:** 44 × 44 (accessibility)
- **Buttons:** 56 tall (exceeds minimum)
- **Empty-state hero icon:** 80
- **Onboarding hero icon:** 120

### Whitespace Philosophy
Whitespace is a feature, not a gap to fill. Prefer one fewer element over one too many. Cards and surfaces — not borders — establish structure.

---

## 6. Depth & Elevation

Visual hierarchy is established through **Tonal Layers** and a single **Ambient Shadow** — never through heavy borders or stacked drop shadows.

### The Ambient Shadow (signature)
```dart
BoxShadow(
  color: Color(0x0A000000), // rgba(0,0,0,0.04)
  blurRadius: 20,
  offset: Offset(0, 4),
)
```
- Distributed across `AppCard`, `DetailCard`, `MedicationCard`, `_buildAdherenceCard`, `_buildNextDoseCard`, `_buildUpcomingList`
- Paused `MedicationCard` reduces `blurRadius` to 8 (tighter, less "alive")
- Feels like **a soft glow of depth rather than a harsh drop shadow**

### Elevation Rules
| Element | Elevation |
|---|---|
| App Bar | **0** (zero elevation, zero `scrolledUnder`) |
| Cards | no Material elevation — ambient `BoxShadow` only |
| Bottom nav | 8 (native Material elevation) |
| Buttons | **0** — depth is for cards, not actions |
| Modals | handled by framework (uses `surfaceContainerLowest`) |

### Surface Hierarchy (Tiers)
| Tier | Token | Purpose |
|---|---|---|
| 0 — Base | `background` / `surface` | Scaffold |
| 1 — Content | `surface` (with ambient shadow) | Cards |
| 2 — Lift | `surfaceContainerLowest` (`#FFFFFF`) | Inputs, modals, the most "raised" content |
| Inverse | `inverseSurface` | Snackbars (inverted tone) |

### Dividers
- **1px solid** `divider` `#E0E7E6` (Flutter may substitute `surfaceContainerHigh` `#E2E8F8` — treat both as legal for thin separators)
- **Never pure black**
- **Never high contrast** — dividers separate softly

---

## 7. Do's and Don'ts

### Do
- ✅ Use **`primary` (`#366460`)** for primary CTAs and active states only.
- ✅ Pair text with its semantic counterpart (`onPrimary`, `onSurface`, `onSurfaceVariant`) — never guess.
- ✅ Use the **ambient shadow** `0px 4px 20px rgba(0,0,0,0.04)` for every card.
- ✅ Keep buttons at **12px** radius and cards at **16px** — the small differentiation matters.
- ✅ Pull text styles from `Theme.of(context).textTheme.*` — never hard-code `fontSize`.
- ✅ Reserve **`label-caps` (12px / w700 / +0.05em uppercase)** for badges and timing only.
- ✅ Render input **labels above the field** — never floating.
- ✅ Use a **single-column** primary flow on mobile.
- ✅ Use `FadeTransition` only — calm motion, 200–300 ms, `Curves.easeInOut`.
- ✅ Touch targets **≥ 44×44**; buttons **56 tall**.

### Don't
- ❌ Never use **pure black** (`#000000`) for text or borders — use `onSurface` `#151C27` or `outline` `#707977`.
- ❌ Never overload a screen with bright "alarm" reds — `error` `#BA1A1A` is reserved for destructive and missed-dose states.
- ❌ Never add a second typeface — Manrope only.
- ❌ Never introduce Material elevation shadows on cards — ambient `BoxShadow` is the signature.
- ❌ Never use hard 1px outlines around cards to separate them — depth comes from tone + ambient shadow.
- ❌ Never omit the ambient shadow on a content card.
- ❌ Never float an input label invisibly — labels are always visible above the field.
- ❌ Never use bright green for "success/taken" — `primary` sage `#366460` is the calm-success color.
- ❌ Never render the bottom nav with a colored pill animation — Flutter uses native Material `BottomNavigationBar`; the Stitch "active pill" is documented but not implemented.
- ❌ Never set `fontSize` higher than `displayLarge` 36 (hero onboarding only).
- ❌ Never disable text-scaling accessibly without documenting the tradeoff — `TextScaler.noScaling` is current app behavior and should be flagged in PRs.

---

## 8. Responsive Behavior

The app is **mobile-only**. Responsive strategy focuses on intra-handset adaptation, not multi-device.

### Platforms
| Platform | Status | Notes |
|---|---|---|
| Android | ✅ Supported | min SDK 21 (5.0+), target per Flutter default |
| iOS | ✅ Supported | iOS 13.0+ |
| Web | ❌ Not supported | SQLite FFI + local notifications + secure storage incompatible |
| Windows / macOS / Linux | ❌ Not supported | Same blockers as Web |

### Screen breakpoints (mobile-first)
| Range | Behavior |
|---|---|
| < 360px | Compact — single column tight, container-padding drops to 16 if needed |
| 360–600px | **Default canvas** — 20px page margins, single column, bottom nav |
| > 600px | Rare phone widths — content may cap at 600px max-width and center |

### Touch & Density adaptations
- Buttons stay fixed at 56 tall regardless of width (full-width primary)
- List items use a generous **56 minimum height** to ensure easy tapping for older users
- Text scaling is **disabled app-wide** via `TextScaler.noScaling` (current implementation — intentional for layout stability, flagged as an accessibility tradeoff)
- Respect `MediaQuery.textScaleFactor` only if `noScaling` is removed in future

### Orientation
- Portrait is the default and assumed. No special landscape accommodations exist.

### RTL
- Flutter handles directionality automatically via `MaterialApp` — use mirrored icons (`Icons.arrow_back`) and avoid hard-coded leading/trailing assumptions. No strings are currently localized beyond English.

---

## 9. Agent Prompt Guide

Quick prompts an agent can paste into a generation request to match this system without re-reading the full document.

### Master prompt
```
Build a Flutter screen for the TakeYourPills app following DESIGN.md.
Use Manrope typography, Material 3, and the Calm & Clinical Excellence token set.
Background: #F9F9FF. Cards: #F9F9FF surface with ambient shadow
(0px 4px 20px rgba(0,0,0,0.04)), 16px radius, 16px padding. Primary actions:
#366460 sage on white text, 12px radius, 56 tall. Text styles via
Theme.of(context).textTheme (displayLarge 36 / w700, headlineMedium 24 / w600,
titleSmall 18 / w600, bodyMedium 16 / w400, bodySmall 14 / w400,
labelLarge 12 / w700 / +0.05em uppercase). Use Container + BoxDecoration +
BoxShadow for cards (not Material Card). Single column, mobile-first, page
margins 20px, max-width 600px. Fade transitions only, 200–300ms easeInOut.
Never use pure black for text — use onSurface #151C27.
```

### Component prompts
```
A primary button: ElevatedButton, bg #366460, fg #FFFFFF, 12px radius,
full-width, min height 56, padding 20×16, text via AppTextStyles.titleSmall
(18px / w600). Optional leading icon, 8px gap to text.

A card: Container with color #F9F9FF, 16px radius, padding EdgeInsets.all(16),
BoxShadow color 0x0A000000 blurRadius 20 offset (0,4). No border by default.

An input field: filled with #FFFFFF (surfaceContainerLowest), 16px radius,
1px #E2E8F8 enabled border, 2px #366460 focus border, label rendered as a
Text(labelLarge 12 w700 in onSurfaceVariant) ABOVE the field with 8px gap,
hint text in bodyMedium color outlineVariant #C0C8C6.

An empty state: centered column, 40px horizontal padding, Icon 80px in
#E2E8F8, 24px gap to headlineMedium title in #151C27, 8px gap to optional
bodyMedium subtitle in #404847, 24px gap to primary AppButton CTA.

A list divider: 1px Container color #E0E7E6 (or #E2E8F8 surfaceContainerHigh),
indented 56px from the leading edge when it follows an icon row.
```

### Quick color lookup (paste anywhere)
```
primary       #366460   primary action, brand, focus
primaryContainer #4F7D79 hero surfaces
onPrimary     #FFFFFF
background    #F9F9FF   scaffold
surface       #F9F9FF   cards (alias of background in light)
white         #FFFFFF   inputs, modals (surfaceContainerLowest)
onSurface     #151C27   primary text — never pure black
onSurfaceVariant #404847 secondary text, icons
surfaceContainerHigh #E2E8F8  borders, dividers, chip bg
outline       #707977   borders
outlineVariant #C0C8C6  placeholder text, inactive dots
error         #BA1A1A   destructive, missed
errorContainer #FFDAD6  warning fills (low refill)
inverseSurface #2A313D  snackbars
divider       #E0E7E6   hairlines
ambient shadow 0px 4px 20px rgba(0,0,0,0.04)  (Color(0x0A000000))
```

### Flutter implementation shortcuts
```dart
// Card
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface, // #F9F9FF
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 4)),
    ],
  ),
  padding: const EdgeInsets.all(16),
  child: ...,
)

// Primary button
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF366460),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  ),
  onPressed: ...,
  child: Text('Save', style: Theme.of(context).textTheme.titleSmall),
)

// Input label (always above)
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Medication name',
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      )),
    const SizedBox(height: 8),
    TextField(
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: 'e.g. Lisinopril',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFFC0C8C6)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F8))),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF366460), width: 2)),
      ),
    ),
  ],
)
```

---

## 10. Screen Inventory & Navigation (reference)

For browsing context only — see the Stitch HTML prototypes at `stitch_takeyourpills_healthcare_design_system/<screen>/code.html` for pixel reference.

| Route | Screen | Stitch prototype |
|---|---|---|
| `/onboarding` | OnboardingPage (3-step PageView: Take Your Meds → Track Progress → Stay Organized) | `onboarding_privacy/`, `onboarding_reminders/` |
| `/dashboard` | Dashboard (greeting, adherence ring, next-dose card, upcoming list, missed alert) | `dashboard/` |
| `/medications` | MedicationListPage (medication cards, empty/error state, FAB) | `medication_list/` |
| `/medication/:id` | MedicationDetailPage (info rows, stat chips, history) | `medication_history/` (visual ref) |
| `/add-medication/:medId` | AddEditMedicationPage (multi-step form) | `add_medication/` |
| `/calendar` | Coming Soon stub → planned schedule calendar | `schedule_calendar/` |
| `/history` | Coming Soon stub → planned filtered history list | `medication_history/` |
| `/progress` | Coming Soon stub → planned adherence chart + streaks | `adherence_progress/` |
| `/settings` | SettingsPage (master settings list) | `settings/` |
| `/settings/notifications` | NotificationSettingsPage | `settings/` |
| `/settings/appearance` | AppearanceSettingsPage (stub) | `settings/` |
| `/settings/privacy` | PrivacySettingsPage (stub) → planned privacy + export + clear data | `privacy_sharing/` |
| `/settings/about` | AboutPage (stub) | `settings/` |
| `/settings/data` | DataManagementPage (stub) | `settings/` |
| `/messaging` | Provider Messaging — Coming Soon | `provider_messaging/` |
| `/reminder-action-sheet` | Hidden route → planned full-screen reminder action | `reminder_action_sheet/` |
| `/refill-tracker` | Hidden route → planned refill dashboard | `refill_tracker/` |

**Bottom nav:** Home · Meds · Calendar · Progress · Settings — fixed type, elevation 8, `primary` selected, bottom bar hidden on sub-pages.

---

## 11. State Patterns (checklists)

Every interactive surface must handle these states. Reuse the `EmptyStateWidget` template as the backbone.

### Empty State
- [ ] Icon 80px in `surfaceContainerHigh` (or custom), tonal, centered
- [ ] `headlineMedium` title in `onSurface`, centered ("No medications yet")
- [ ] `bodyMedium` subtitle in `onSurfaceVariant`, centered, with action hint ("Tap + to add your first medication")
- [ ] Primary `AppButton` CTA visible & prominent
- [ ] Optional "Learn more" link

### Loading State
- [ ] Skeleton shimmer lists for repeating content
- [ ] Centered `CircularProgressIndicator` (20×20, stroke 2) for page-level loads
- [ ] Disable interactive elements during async; "Saving..." inline for buttons

### Error State
- [ ] Clear `error`-toned icon (soft red, not alarmist)
- [ ] Human-readable `headlineMedium` title ("Unable to load medications")
- [ ] `bodyMedium` explanation in `onSurfaceVariant`
- [ ] Retry as primary `AppButton`
- [ ] Optional secondary fallback ("Open in browser" if applicable)

### Success State
- [ ] `primary` sage confirmation (not bright green)
- [ ] Brief `bodyMedium` message ("Medication added successfully")
- [ ] Auto-dismiss after 2–3 seconds
- [ ] "Undo" action via SnackBar with `primary` text for destructive operations

### Disabled State
- [ ] Opacity 0.5 on primary; `surfaceContainerLow` background on secondary
- [ ] No tap handler active
- [ ] Optional tooltip explaining why disabled

### Reminder Interaction (action sheet)
- **Take now:** primary, full width, 64px min touch target
- **Snooze:** secondary split-button → expands to 10 / 20 / 30 / 60 min chips
- **Skip:** tertiary ghost button
- After any action: dose logged, notification dismissed, sheet closes, dashboard updates in background. Confirmation SnackBar: "Reminder set for 10:30 AM".

### Missed Dose Handling
- Dose enters "missed" 3 hours after scheduled time
- Dashboard renders red alert card ("1 missed") → tap to see list of missed doses with Take/Skip actions

---

## 12. Accessibility Notes

| Concern | Rule |
|---|---|
| **Contrast (WCAG AA)** | `onPrimary (#FFFFFF)` on `primary (#366460)` ✓ · `onSurface (#151C27)` on `background (#F9F9FF)` ✓ (>15:1) · `onSurfaceVariant` on `surface` ✓ |
| **Touch targets** | ≥ 44×44 dp; 8px minimum spacing between adjacent targets; small icons still live in 44×44 containers |
| **Screen reader** | All icons/images carry `semanticLabel`; custom widgets expose `MergeSemantics` for grouped controls (e.g., Take/Snooze/Skip); list tiles read title + subtitle as one sentence |
| **Font scaling** | Currently **disabled** app-wide via `TextScaler.noScaling` — known accessibility tradeoff. If removed, ensure fixed-height containers accommodate up to 200% scale via `IntrinsicHeight` / `Flexible` / `Expanded` |
| **Motion** | Respect `ReduceMotion` — disable non-essential animations. Standard durations 200–300 ms; transitions 500 ms |
| **Focus outline** | 2px `primary` outline for keyboard focus (future desktop/web prerequisite) |
| **RTL** | Use `Icons.arrow_back` and other auto-mirroring icons; never hard-code leading/trailing where Flutter provides directionality |

---

## 13. Implementation Notes & Known Divergences

These are intentional simplifications or unrealized futures between the Stitch HTML prototypes and the Flutter implementation. Treat the **Flutter values in this document as authoritative** for new screens.

1. **Dark theme is scaffolded but not implemented** — `AppTheme.darkTheme` returns `lightTheme`. A `theme_mode` SharedPreferences key exists but is unused. Do not generate dark-only screens without first defining the dark ColorScheme.
2. **Font files are 0-byte placeholders** — Manrope is fully fetched at runtime via `google_fonts`. Listed `assets/fonts/*.ttf` files exist in `pubspec.yaml` but are empty on disk; offline rendering would fail.
3. **Cards use `Container + BoxDecoration`** instead of the Material `Card` widget — required to apply the ambient `BoxShadow` signature (the framework Card is elevation-based).
4. **App Bar** in Flutter uses solid `surface` background — the Stitch HTML uses `backdrop-blur(90%)`. Intentional simplification.
5. **Bottom nav** in Flutter uses native Material `BottomNavigationBar`. The Stitch design's elaborate active pill (`scale 0.95`, filled pill background) is **not** implemented. Don't expect it on new screens without custom work.
6. **Adherence ring** uses a determinate `CircularProgressIndicator` (80×80, stroke 8, square caps). The Stitch HTML uses a custom-painted two-circle SVG ring with round caps — visually similar but not identical.
7. **`SectionHeader` in code uses `primary` color** (`titleSmall` + primary tint), while `memory-bank/design-system-notes.md` describes section labels as `bodySmall` w600 in `onSurfaceVariant`. Code is currently authoritative but the divergence is intentional.
8. **Input field fill** in Flutter is `#FFFFFF` (`surfaceContainerLowest`); the design doc recommends `#F1F3F3`. Pure white is the implemented baseline.
9. **Input labels do not float** — `AppInput` renders the label as a `Text` above the field. The `floatingLabelStyle` defined in `AppTheme` is unused.
10. **Page transitions** are fade-only (`FadeTransition`), no slide transitions. Consistent with the "calm" aesthetic.
11. **Text scaling is disabled** app-wide (`TextScaler.noScaling`) — flagged as an accessibility tradeoff rather than a permanent design decision.
12. **Three tab routes are stubs** (`/calendar`, `/history`, `/progress`) showing "Coming Soon". The Stitch designs for these screens exist but are not implemented in Flutter.

---

## 14. Source Files (where to verify)

| Purpose | Path |
|---|---|
| This document | `DESIGN.md` (project root) |
| Canonical Stitch design tokens | `stitch_takeyourpills_healthcare_design_system/calm_clinical_excellence/DESIGN.md` |
| Flutter color tokens | `lib/shared/theme/app_colors.dart` |
| Flutter text styles | `lib/shared/theme/app_text_styles.dart` |
| Flutter theme assembly | `lib/shared/theme/app_theme.dart` |
| Shared components | `lib/shared/components/` (`app_button.dart`, `app_card.dart`, `app_input.dart`, `empty_state_widget.dart`) |
| Routes | `lib/shared/routing/routes.dart`, `lib/shared/routing/app_router.dart` |
| Behavioral constants | `lib/core/constants/app_constants.dart` |
| Flutter implementation notes (extended) | `memory-bank/design-system-notes.md` |
| Screen HTML prototypes | `stitch_takeyourpills_healthcare_design_system/<screen>/code.html` + `<screen>/screen.png` |

---

**Status:** Complete and stable. Mirrors the source-of-truth design tokens verbatim.
**Last synced with:** Flutter theme at `lib/shared/theme/` and Stitch `calm_clinical_excellence/DESIGN.md`.
