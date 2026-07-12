<p align="center">
  <h1 align="center">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</h1>
</p>

<p align="center">
  <h1 align="center">TakeYourPills</h1>
  <p align="center"><strong>Calm & Clinical Excellence</strong></p>
  <p align="center"><em>Premium Minimalism · Sanctuary Experience · Quiet Confidence</em></p>
</p>

<p align="center">
  <h1 align="center">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</h1>
</p>

---

> **Design language for a Flutter medication tracker.**
> Drop this file into any agent context and ask it to *"build me a screen that matches DESIGN.md."*
> Every token below is mirrored **1 : 1** in the Flutter theme at `lib/shared/theme/`.

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 0 &nbsp; PROJECT CONTEXT
## ═══════════════════════════════════════════════════════════════

```
  Name          TakeYourPills
  Package       takeyourpills_healthcare_app
  Version       1.0.0+1
  Tagline       Medicine tracker with reminders, adherence history, and refills.
  Platform      Mobile only  ─  Android 5.0+ (SDK 21)  ·  iOS 13.0+
  Framework     Flutter (Material Design 3)  ·  Dart ^3.8.0
  Typeface      Manrope  (400 · 500 · 600 · 700)
  Architecture  BLoC / Cubit  ·  GoRouter  ·  Drift (SQLite)  ·  get_it DI
  Status        MVP ~95 % feature-complete · dark mode scaffolded but aliased to light
```

| Key dependency | Purpose |
|:-|:-|
| `flutter_bloc` | State management (Cubit / Bloc) |
| `go_router` | Declarative routing with onboarding redirect guard |
| `drift` | Type-safe SQLite (local persistence only) |
| `flutter_local_notifications` | Native notification scheduling |
| `flutter_secure_storage` | Encrypted provider / credential storage |
| `google_fonts` | Manrope loaded at runtime; bundled `.ttf` fallback |

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 1 &nbsp; VISUAL THEME & ATMOSPHERE
## ═══════════════════════════════════════════════════════════════

The system lives at the intersection of **professional medical reliability**
and **modern wellness aesthetics**. It deliberately avoids the cold, sterile
atmosphere of traditional clinical software in favor of a **"Sanctuary"**
experience — one that reduces the anxiety often associated with medication
management.

```
  ┌──────────────────────────────────────────────────────────────┐
  │  STYLE              Premium Minimalism                      │
  │  MOOD               Calm · Trustworthy · Reassuring         │
  │  DENSITY            Low — generous whitespace, single-column│
  │  VISUAL COMPLEXITY  Restrained palette, tonal layers         │
  │  MOTION             Slow fades only, 200-300 ms, easeInOut  │
  │  PHILOSOPHY         Cognitive ease first                     │
  └──────────────────────────────────────────────────────────────┘
```

> **Brand values:** Sanctuary · Clarity · Confidence · Premium

<br>

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 2 &nbsp; COLOR PALETTE & ROLES
## ═══════════════════════════════════════════════════════════════

The palette is **low-stimulation, high-clarity**. A muted Sage/Teal primary
sits over a multi-tier neutral off-white background. Functional tones are
softened so feedback never triggers alarm. Text is deep charcoal — **never
pure black**.

> Source-of-truth: `lib/shared/theme/app_colors.dart`

### ▐ PRIMARY — Muted Sage / Teal

| Swatch | Token | Hex | Role |
|:------:|:------|:----|:-----|
| 🟢 | `primary` | `#366460` | Primary actions, active states, brand, focus ring |
| ⬜ | `onPrimary` | `#FFFFFF` | Text / icons on primary |
| 🟢 | `primaryContainer` | `#4F7D79` | Hero dose card, stat cards, secondary brand surfaces |
| ⬜ | `onPrimaryContainer` | `#F3FFFD` | Text on primaryContainer |
| 🟢 | `primaryFixed` | `#BBECE7` | Light accents, soft sage fills |
| 🟢 | `primaryFixedDim` | `#A0D0CB` | Subtle highlights / inverse primary |
| ⬜ | `onPrimaryFixed` | `#00201E` | Text on primaryFixed |
| ⬜ | `onPrimaryFixedVariant` | `#1F4E4B` | Variant text on primaryFixed |

### ▐ SECONDARY

| Swatch | Token | Hex | Role |
|:------:|:------|:----|:-----|
| 🟢 | `secondary` | `#4C6361` | Supporting elements |
| ⬜ | `onSecondary` | `#FFFFFF` | Text on secondary |
| 🟢 | `secondaryContainer` | `#CCE5E2` | Info chips, secondary icon chips, time chips |
| ⬜ | `onSecondaryContainer` | `#506765` | Text on secondaryContainer |
| 🟢 | `secondaryFixed` | `#CFE8E5` | Fixed light surface |
| 🟢 | `secondaryFixedDim` | `#B3CBC9` | Dim variant |
| ⬜ | `onSecondaryFixed` | `#081F1E` | Text on fixed |
| ⬜ | `onSecondaryFixedVariant` | `#344B49` | Variant text |

### ▐ TERTIARY

| Swatch | Token | Hex | Role |
|:------:|:------|:----|:-----|
| ⬛ | `tertiary` | `#565D5D` | Tertiary text / icons |
| ⬜ | `onTertiary` | `#FFFFFF` | Text on tertiary |
| ⬛ | `tertiaryContainer` | `#6F7675` | Neutral containers |
| ⬜ | `onTertiaryContainer` | `#F7FEFD` | Text on tertiaryContainer |
| ⬛ | `tertiaryFixed` | `#DDE4E3` | Fixed light surface |
| ⬛ | `tertiaryFixedDim` | `#C1C8C7` | Dim variant |
| ⬜ | `onTertiaryFixed` | `#161D1D` | Text on fixed |
| ⬜ | `onTertiaryFixedVariant` | `#414848` | Variant text |

### ▐ BACKGROUND & SURFACE — Multi-tier Tonal Layering

> Off-white base with subtle blue-grey undertone.

| Swatch | Token | Hex | Role |
|:------:|:------|:----|:-----|
| ⬜ | `background` | `#F9F9FF` | Scaffold background — off-white |
| ⬛ | `onBackground` | `#151C27` | Primary text on background |
| ⬜ | `surface` | `#F9F9FF` | Card backgrounds (same as bg in light) |
| ⬛ | `surfaceDim` | `#D3DAEA` | Dim surface |
| ⬜ | `surfaceBright` | `#F9F9FF` | Bright surface |
| ⬜ | `surfaceContainerLowest` | `#FFFFFF` | Inputs, modals — pure white lift |
| ⬜ | `surfaceContainerLow` | `#F0F3FF` | Subtle fills, paused states, info cards |
| ⬜ | `surfaceContainer` | `#E7EEFE` | Standard container |
| ⬜ | `surfaceContainerHigh` | `#E2E8F8` | Borders, "UPCOMING" pills, dividers |
| ⬜ | `surfaceContainerHighest` | `#DCE2F3` | Highest container tier |
| ⬜ | `surfaceVariant` | `#DCE2F3` | Alias of `surfaceContainerHighest` |
| ⬛ | `onSurface` | `#151C27` | Primary text — **never `#000`** |
| ⬜ | `onSurfaceVariant` | `#404847` | Secondary text, subtitles, icons |
| ⬛ | `inverseSurface` | `#2A313D` | Inverse bg (snackbars) |
| ⬜ | `inverseOnSurface` | `#EBF1FF` | Inverse text |
| 🟢 | `surfaceTint` | `#386663` | Surface tint |

### ▐ OUTLINE & DIVIDER

| Token | Hex | Role |
|:------|:----|:-----|
| `outline` | `#707977` | Border color |
| `outlineVariant` | `#C0C8C6` | Subtle borders, placeholder text, inactive dots |
| `divider` | `#E0E7E6` | Thin 1px list dividers |

### ▐ ERROR / FUNCTIONAL — Alarmist-Softened

| Token | Hex | Role |
|:------|:----|:-----|
| `error` | `#BA1A1A` | Destructive actions, missed dose alerts |
| `onError` | `#FFFFFF` | Text on error |
| `errorContainer` | `#FFDAD6` | Warning fills, low-refill chips (soft pink) |
| `onErrorContainer` | `#93000A` | Text on errorContainer |

### ▐ SEMANTIC MAP (derived — no extra tokens)

```
  SUCCESS  (Taken)       →  primary  #366460    calm confirmation, never bright green
  WARNING  (Low refill)  →  errorContainer @ 0.5 alpha  soft pink, not amber
  DANGER   (Missed)      →  error  #BA1A1A       restrained red
  INFO     (Upcoming)    →  surfaceContainerHigh  #E2E8F8  neutral chip
```

### ▐ QUICK REFERENCE CARD

```
  ┌─────────────────────────────────────────────────┐
  │  Sage/Teal    #366460     Primary brand         │
  │  Container    #4F7D79     Hero surfaces          │
  │  Background   #F9F9FF     Off-white canvas       │
  │  Pure white   #FFFFFF     Inputs, modals         │
  │  Charcoal     #151C27     Primary text (never 0) │
  │  SubText      #404847     Secondary text         │
  │  Error        #BA1A1A     Soft, restrained red   │
  │  Divider      #E0E7E6     Hairline separators    │
  │  Shadow       0x0A000000  rgba(0,0,0,0.04)       │
  └─────────────────────────────────────────────────┘
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 3 &nbsp; TYPOGRAPHY RULES
## ═══════════════════════════════════════════════════════════════

A single typeface — **Manrope** — for its balanced, modern, and highly
legible characteristics. Type is built for **rapid scanning**, critical
for users checking dosages under stress.

### Font Stack

```
  Manrope  ::  400 · 500 · 600 · 700
  Fallback ::  System sans-serif (Flutter Material default)
```

> Loaded via `google_fonts` package (`GoogleFonts.manropeTextTheme(...)`)
> with bundled `.ttf` files in `assets/fonts/` as offline fallback.

### Type Scale — 6 Styles (exact match to Stitch tokens)

```
  ┌─────────────────────────────────────────────────────────────────────────────────┐
  │  STYLE          SIZE  WEIGHT  HEIGHT  TRACKING   USAGE                         │
  ├─────────────────────────────────────────────────────────────────────────────────┤
  │                                                                                 │
  │  displayLarge   36px  w700    44px    -0.02em   Hero headlines (rare)           │
  │  ██████████████████████████████████████████████████████████████████████████     │
  │                                                                                 │
  │  headlineMed    24px  w600    32px    -0.01em   Screen titles, section headers  │
  │  █████████████████████████████████████████████                                 │
  │                                                                                 │
  │  titleSmall     18px  w600    24px    default    Card titles, button text       │
  │  ██████████████████████████████████                                             │
  │                                                                                 │
  │  bodyMedium     16px  w400    24px    default    Primary body text              │
  │  ████████████████████████████                                                   │
  │                                                                                 │
  │  bodySmall      14px  w400    20px    default    Secondary text, captions       │
  │  ████████████████████████                                                       │
  │                                                                                 │
  │  labelLarge     12px  w700    16px    +0.05em   UPPERCASE labels, badges        │
  │  ████████████████████                     ▲                                     │
  └─────────────────────────────────────────────────────────────────────────────────┘
```

### Typographic Rules

> **[✓]** Line heights intentionally increased to prevent text-crowding
>
> **[✓]** Negative letter-spacing reserved for display/headline only
>
> **[✓]** Uppercase `label-caps` used **sparingly** — badges, timing, structural eyebrows
>
> **[✓]** Text is **never pure black** — use `onSurface` `#151C27`
>
> **[✓]** No font mixing — Manrope only

### Flutter Mapping

```dart
  Theme.of(context).textTheme.displayLarge     // 36  / w700 / -0.02em / lh 44
  Theme.of(context).textTheme.headlineMedium   // 24  / w600 / -0.01em / lh 32
  Theme.of(context).textTheme.titleSmall       // 18  / w600 / default  / lh 24
  Theme.of(context).textTheme.bodyMedium       // 16  / w400 / default  / lh 24
  Theme.of(context).textTheme.bodySmall        // 14  / w400 / default  / lh 20
  Theme.of(context).textTheme.labelLarge       // 12  / w700 / +0.05em  / lh 16
```

> **Note:** `MaterialApp` wraps `MediaQuery` with `TextScaler.noScaling` —
> runtime font-scale settings are disabled app-wide for layout stability.

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 4 &nbsp; COMPONENT STYLINGS
## ═══════════════════════════════════════════════════════════════

Shared components live in `lib/shared/components/`. Feature-specific
widgets are documented per-screen. All values enforced either in
`AppTheme` (`lib/shared/theme/app_theme.dart`) or inline.

---

### ▐ BUTTON — `AppButton`

```
  ┌─────────────────────────────────────────────────────────────────┐
  │                                                                 │
  │   ┌───────────────────────────────────────────────────────────┐ │
  │   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ │
  │   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓  PRIMARY VARIANT  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ │
  │   │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │ │
  │   └───────────────────────────────────────────────────────────┘ │
  │                                                                 │
  │   ┌───────────────────────────────────────────────────────────┐ │
  │   │  · · · · · · · · · SECONDARY (GHOST) · · · · · · · · · · │ │
  │   └───────────────────────────────────────────────────────────┘ │
  │                                                                 │
  │   12px radius (md)  ·  min height 56  ·  full-width  ·  no shadow│
  └─────────────────────────────────────────────────────────────────┘
```

| Variant | Bg | Text | Border | Radius | Min Size | Padding |
|:--------|:---|:-----|:-------|:-------|:---------|:--------|
| **Primary** | `primary` `#366460` | `onPrimary` `#FFFFFF` | none | 12px | `∞ × 56` | `20 × 16` |
| **Ghost** | transparent | `primary` `#366460` | 1px `primary` | 12px | `∞ × 56` | `20 × 16` |
| **Disabled (primary)** | `primary` @ 0.5 opacity | `onPrimary` | none | 12px | — | `20 × 16` |
| **Disabled (ghost)** | `surfaceContainerLow` `#F0F3FF` | `onSurfaceVariant` | `outlineVariant` | 12px | — | `20 × 16` |
| **Loading** | `primary` | — | none | 12px | — | `CircularProgressIndicator` (20×20) + "Saving..." |

- **Text:** `titleSmall` (18px / w600)
- **Optional icon:** 8px gap before text (`Row`, `gap: 8`)
- **No elevation / no shadow** — depth is reserved for cards
- **Touch target:** 56px height (exceeds 44px accessibility minimum)

---

### ▐ CARD — `AppCard`

```
  ╭──────────────────────────────────────────────╮
  │                                              │
  │   Card surface                                │
  │   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ │
  │                                              │
  │   Background   #F9F9FF  (surface)             │
  │   Radius       16px    (lg)                   │
  │   Padding      16px    (md) default            │
  │   Shadow       0px 4px 20px rgba(0,0,0,0.04) │
  │   Border       none (default)                  │
  │                                              │
  ╰──────────────────────────────────────────────╯
```

| Attribute | Value |
|:----------|:------|
| Background | `surface` `#F9F9FF` (or custom) |
| Radius | **16px** (`lg`) |
| Padding | `EdgeInsets.all(16)` default |
| Shadow | **Ambient Shadow** `0px 4px 20px rgba(0,0,0,0.04)` |
| Border | none by default — 2px `outline` for "paused" |
| `onTap` | wraps in `InkWell` with matched `borderRadius` |

> **Implementation note:** Cards use `Container + BoxDecoration` rather
> than Material `Card` widget — so the ambient `BoxShadow` (not
> elevation-based) can be controlled precisely.

Feature cards (`MedicationCard`, `DetailCard`, `_buildNextDoseCard`,
`_buildAdherenceCard`, `_buildUpcomingList`) reuse the same shadow.
**Paused state** reduces `blurRadius` to 8 (tighter, less "alive").

---

### ▐ INPUT — `AppInput`

```
   ┌─────────────────────────────────────────┐
   │  MEDICATION NAME            (label-lg)  │  ← 12px w700, onSurfaceVariant
   │  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  │  ← 8px gap
   │  ┌─────────────────────────────────────┐│
   │  │ e.g. Lisinopril                    ││  ← bodyMedium, outlineVariant
   │  └─────────────────────────────────────┘│
   └─────────────────────────────────────────┘
     ▲ filled: #FFFFFF  ·  radius: 16px  ·  border: 1px #E2E8F8
     ▲ focus: 2px #366460 (primary)  ·  error: 2px #BA1A1A
     ▲ label ALWAYS visible (never floating)
```

| Attribute | Value |
|:----------|:------|
| Fill | `surfaceContainerLowest` `#FFFFFF` |
| Radius | **16px** (`lg`) across all states |
| Enabled border | 1px `surfaceContainerHigh` `#E2E8F8` |
| Focused border | **2px** `primary` `#366460` |
| Error border | 2px `error` `#BA1A1A` |
| Label | **Outside / above field** — `labelLarge` 12px w700 in `onSurfaceVariant` |
| Label gap | **8px** (`sm`) |
| Hint text | `bodyMedium` in `outlineVariant` `#C0C8C6` |
| Content padding | `16 × 16` |
| Accessories | `prefixIcon`, `suffixIcon`, `maxLines`, `keyboardType`, `validator`, `onChanged` |

> **Note:** The canonical design doc recommends fill `#F1F3F3`.
> Flutter uses pure white `surfaceContainerLowest` (`#FFFFFF`).
> Treat `#FFFFFF` as authoritative.

---

### ▐ ADHERENCE RING — `AdherenceRing`

```
              ╭───────╮
            ╭─┤ 78%   ├─╮
          ╭─┤  │      │  ├─╮
          │ │  │  ╭─╮  │ │ │
          │ │  │  │%│  │ │ │    80 × 80
          │ │  │  ╰─╯  │ │ │    stroke: 8
          ╰─┤  │      │  ├─╯
            ╰─┤Adhere ├─╯
              ╰───────╯

   Track:    #E2E8F8  (surfaceContainerHigh)
   Progress: #366460  (primary)
   Label:    titleSmall (percentage) + bodySmall ("Adherence")
```

- Widget: determinate `CircularProgressIndicator`
- Size: **80 × 80**, stroke width **8**
- Stroke cap: default (square — Stitch uses round; minor divergence)

---

### ▐ MEDICATION CARD — `MedicationCard`

```
  ╭──────────────────────────────────────────────────────────╮
  │  ┌────┐                                                  │
  │  │ 💊 │  Medication Name              •  30 pills left   │
  │  └────┘  10:00 AM · With Food           [Edit] [Pause]  │
  │          ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔ │
  │  Icon chip: #CCE5E2 bg, 12px radius                      │
  │  Paused badge: "PAUSED" 10px w600 letterSpacing 0.5      │
  │  Margin: 20 × 6  ·  Radius: 16  ·  Shadow: ambient      │
  ╰──────────────────────────────────────────────────────────╯
```

---

### ▐ STAT CHIP — `StatChip`

```
  ╭────────────────────────╮      ╭────────────────────────╮
  │  ┌──────────────────┐  │      │  ┌──────────────────┐  │
  │  │  24px (headline) │  │      │  │  24px (headline) │  │
  │  │  Adherence Score │  │      │  │  Low Refill ⚠    │  │
  │  └──────────────────┘  │      │  └──────────────────┘  │
  │  #F0F3FF (normal)      │      │  #FFDAD6 @ 0.5 (warn)  │
  ╰────────────────────────╯      ╰────────────────────────╯
   Radius: 16px  ·  Padding: 16px
```

---

### ▐ EMPTY STATE — `EmptyStateWidget`

```
           ╭────────────────────────────╮
           │                            │
           │         ┌────────┐         │
           │         │  80px  │         │
           │         │  icon  │         │
           │         └────────┘         │
           │           24px             │
           │                            │
           │    No medications yet      │  ← headlineMedium, #151C27
           │                            │
           │    Tap + to add your       │  ← bodyMedium, #404847
           │    first medication        │
           │           24px             │
           │                            │
           │   ┌────────────────────┐   │
           │   │    Add Medication  │   │  ← Primary AppButton
           │   └────────────────────┘   │
           ╰────────────────────────────╯
```

---

### ▐ BOTTOM NAVIGATION

```
  ╭──────────────────────────────────────────────────────────╮
  │  ┌────────┬────────┬────────┬────────┬────────┐          │
  │  │  HOME  │  MEDS  │  CAL   │  PROG  │  SET   │          │
  │  │  (●)   │  (○)   │  (○)   │  (○)   │  (○)   │          │
  │  └────────┴────────┴────────┴────────┴────────┘          │
  │  Selected: #366460  ·  Unselected: #404847               │
  │  Bg: #F9F9FF (surface)  ·  Type: fixed  ·  Elevation: 8 │
  ╰──────────────────────────────────────────────────────────╯
```

- 5 tabs — fixed type, `primary` selected, `onSurfaceVariant` unselected
- Bottom bar hidden on sub-pages (GoRouter `ShellRoute`)

---

### ▐ APP BAR

```
  ╭──────────────────────────────────────────────────────────╮
  │  ←   TakeYourPills                          🔔 (badge) │
  ╰──────────────────────────────────────────────────────────╯
  Bg: #F9F9FF (surface)  ·  Elevation: 0  ·  scrolledUnder: 0
  Leading: avatar (home) / back chevron (sub-pages)
  Trailing: notifications (badge) or settings
```

> Flutter uses solid `surface` background — the Stitch HTML uses
> `backdrop-blur(90%)`. Intentional simplification.

---

### ▐ SNACKBAR

```
  ╭──────────────────────────────────────────────────────────╮
  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
  │  ▓  Medication added successfully            Undo  ▓▓▓ │
  │  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ │
  ╰──────────────────────────────────────────────────────────╯
  Bg: #2A313D (inverseSurface)  ·  Text: #151C27 (onSurface)
  Action "Undo": primary #366460  ·  Duration: 4-6 seconds
```

---

### ▐ MODALS & BOTTOM SHEETS

```
  Full-screen dialogs (Add Medication, Settings subpages):
  ────────────────────────────────────────────────────────
  • Sticky top bar: title, back/close, Save action
  • Scrollable body
  • No card shadow — fills viewport

  Bottom sheets (Action Sheet, calendar day detail):
  ────────────────────────────────────────────────────────
  • Top radius: 24px (xl)
  • Drag handle: 1.5px height line
  • Height: auto or 80% screen
  • Dismissible by swipe-down or tap outside
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 5 &nbsp; LAYOUT PRINCIPLES
## ═══════════════════════════════════════════════════════════════

The system follows an **8px spacing rhythm** with a 4px sub-grid.
All Flutter spacing comes from these tokens — treat them as the
only legal spacing values.

### Spacing Scale

```
     ┌─────┐ 4px    ┌─────────┐ 8px    ┌─────────────────┐ 16px
     │     │        │         │        │                 │
     │     │ xs     │         │ sm     │                 │ md
     │     │        │         │        │                 │
     └─────┘        └─────────┘        └─────────────────┘

     ┌─────────────────────────┐ 24px   ┌─────────────────────────────────┐ 32px
     │                         │        │                                 │
     │                         │ lg     │                                 │ xl
     │                         │        │                                 │
     └─────────────────────────┘        └─────────────────────────────────┘

     container-padding: 20px (page margins)
     gutter: 16px (column gutter)
```

| Token | px | Used as |
|:------|:---|:--------|
| `unit` | 4 | Base unit, micro-alignment |
| `xs` | 4 | Tiny gaps (dot pagination margin) |
| `sm` | 8 | Label → field, icon → text |
| `md` | **16** | Card padding, input padding, row gaps |
| `lg` | 24 | Section spacing, button-row padding |
| `xl` | 32 | Onboarding page padding, large breaks |
| `container-padding` | **20** | **Page margins** |
| `gutter` | 16 | Column gutter |

### Grid & Container

```
  ◄─────────────────── 100% ──────────────────►
  ┌──────┬──────────────────────┬──────┐
  │ 20px │    Content 600px     │ 20px │   ← max-width 600px
  │margin│    (single column)   │margin│     mobile-first
  └──────┴──────────────────────┴──────┘
```

- **Mobile-first / single column**, max-width 600px
- **Page margins:** 20px (standard) or 24px (onboarding)
- **Card inner padding:** 16px default, 20-24px hero cards
- **List item min height:** 56px
- **Settings dividers:** 1px `surfaceContainerHigh`, **inset 56px from leading edge**

### Touch Targets

```
  MINIMUM   44 × 44 dp   (accessibility standard)
  BUTTONS   56 tall       (exceeds minimum)
  ICONS     80px          (empty-state hero)
  ONBOARD   120px         (onboarding hero)
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 6 &nbsp; DEPTH & ELEVATION
## ═══════════════════════════════════════════════════════════════

Visual hierarchy is established through **Tonal Layers** and a single
**Ambient Shadow** — never through heavy borders or stacked drop shadows.

### The Ambient Shadow — Signature

```
  ╔══════════════════════════════════════════════════════════════╗
  ║                                                              ║
  ║    BoxShadow(                                                ║
  ║      color:     Color(0x0A000000),   // rgba(0,0,0,0.04)    ║
  ║      blurRadius: 20,                                         ║
  ║      offset:     Offset(0, 4),                               ║
  ║    )                                                         ║
  ║                                                              ║
  ║    Feels like a "soft glow of depth" rather than             ║
  ║    a harsh drop shadow.                                      ║
  ║                                                              ║
  ╚══════════════════════════════════════════════════════════════╝
```

Used identically across:
`AppCard` · `DetailCard` · `MedicationCard` · `_buildAdherenceCard`
`_buildNextDoseCard` · `_buildUpcomingList`

> Paused `MedicationCard` reduces `blurRadius` to 8.

### Elevation Rules

| Element | Elevation | Notes |
|:--------|:----------|:------|
| App Bar | **0** | Zero elevation, zero `scrolledUnder` |
| Cards | Material 0 | Depth via ambient `BoxShadow` only |
| Bottom nav | **8** | Native Material elevation |
| Buttons | **0** | Depth is for cards, not actions |
| Modals | — | Uses `surfaceContainerLowest` |

### Surface Hierarchy (Tiers)

```
  Tier 0   ─── Background / Surface     #F9F9FF     scaffold
              │
  Tier 1   ─── Content cards            #F9F9FF     + ambient shadow
              │
  Tier 2   ─── Lifted surfaces          #FFFFFF     inputs, modals
              │
  Inverse  ─── Snackbars                #2A313D     inverted tone
```

### Dividers

```
  ─────────────────────────────────────────────
  ▲ 1px solid #E0E7E6 (divider)
  ▲ Never pure black
  ▲ Never high contrast
  ▲ Soft separation only
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 7 &nbsp; DO'S AND DON'TS
## ═══════════════════════════════════════════════════════════════

### ✓ DO

```
  ✓  Use primary #366460 for primary CTAs and active states only
  ✓  Pair text with its semantic counterpart (onPrimary, onSurface, etc.)
  ✓  Use ambient shadow 0px 4px 20px rgba(0,0,0,0.04) on every card
  ✓  Keep buttons at 12px radius, cards at 16px — the differentiation matters
  ✓  Pull text styles from Theme.of(context).textTheme.*
  ✓  Reserve label-caps (12px/w700/+0.05em) for badges and timing only
  ✓  Render input labels ABOVE the field — never floating
  ✓  Use single-column primary flow on mobile
  ✓  Use FadeTransition only — calm motion, 200-300 ms, easeInOut
  ✓  Maintain touch targets ≥ 44×44; buttons 56 tall
```

### ✗ DON'T

```
  ✗  Never use pure black (#000000) — use onSurface #151C27
  ✗  Never overload screens with bright red — error #BA1A1A is reserved
  ✗  Never introduce a second typeface — Manrope only
  ✗  Never add Material elevation shadows on cards — ambient BoxShadow
  ✗  Never use hard outlines to separate cards — tone + shadow
  ✗  Never omit the ambient shadow on a content card
  ✗  Never float input labels invisibly — always visible above field
  ✗  Never use bright green for "taken" — primary sage is the calm color
  ✗  Never use active pill animation in bottom nav — Flutter uses native
  ✗  Never set fontSize above displayLarge (36px, hero only)
  ✗  Never disable text-scaling without documenting the tradeoff
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 8 &nbsp; RESPONSIVE BEHAVIOR
## ═══════════════════════════════════════════════════════════════

The app is **mobile-only**. Responsive strategy focuses on
intra-handset adaptation.

### Platform Matrix

| Platform | Status | Min Version |
|:---------|:------:|:------------|
| **Android** | ✅ | SDK 21 (5.0+) |
| **iOS** | ✅ | 13.0+ |
| **Web** | ❌ | SQLite FFI + local notifications incompatible |
| **Windows** | ❌ | Same blockers as Web |
| **macOS** | ❌ | Same blockers |
| **Linux** | ❌ | Same blockers |

### Screen Ranges

```
  < 360px    Compact  ─── single column tight, margins drop to 16px
  360-600px  Default ─── 20px margins, single column, bottom nav
  > 600px    Rare    ─── content caps at 600px and centers
```

### Adaptation Rules

```
  • Buttons stay fixed at 56 tall regardless of width
  • List items: 56px minimum height for easy tapping
  • Text scaling: DISABLED app-wide (TextScaler.noScaling)
  • No landscape accommodations exist
  • RTL: Flutter handles automatically; mirrored icons
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 9 &nbsp; AGENT PROMPT GUIDE
## ═══════════════════════════════════════════════════════════════

Quick prompts for an agent to match this system without re-reading
the full document.

### Master Prompt

```
Build a Flutter screen for the TakeYourPills app following DESIGN.md.
Use Manrope typography, Material 3, and the Calm & Clinical Excellence token set.

Background: #F9F9FF.
Cards: #F9F9FF surface with ambient shadow (0px 4px 20px rgba(0,0,0,0.04)),
       16px radius, 16px padding.
Primary actions: #366460 sage on white text, 12px radius, 56 tall.
Text styles via Theme.of(context).textTheme:
  displayLarge 36/w700, headlineMedium 24/w600, titleSmall 18/w600,
  bodyMedium 16/w400, bodySmall 14/w400, labelLarge 12/w700/+0.05em uppercase.
Use Container + BoxDecoration + BoxShadow for cards (not Material Card).
Single column, mobile-first, page margins 20px, max-width 600px.
Fade transitions only, 200-300ms easeInOut.
Never use pure black — use onSurface #151C27.
```

### Component Prompts

```dart
// ── PRIMARY BUTTON ──────────────────────────────────────────
// ElevatedButton, bg #366460, fg #FFFFFF, 12px radius,
// full-width, min height 56, padding 20×16,
// text via AppTextStyles.titleSmall (18px / w600).
// Optional leading icon, 8px gap to text.

// ── CARD ────────────────────────────────────────────────────
// Container, color #F9F9FF, 16px radius, padding all(16),
// BoxShadow color 0x0A000000 blurRadius 20 offset (0,4).
// No border by default.

// ── INPUT ───────────────────────────────────────────────────
// Filled #FFFFFF (surfaceContainerLowest), 16px radius,
// 1px #E2E8F8 enabled border, 2px #366460 focus border,
// label as Text(labelLarge 12 w700 in onSurfaceVariant)
// ABOVE the field with 8px gap.
// Hint in bodyMedium color outlineVariant #C0C8C6.

// ── EMPTY STATE ─────────────────────────────────────────────
// Centered column, 40px horizontal padding,
// Icon 80px in #E2E8F8,
// 24px gap to headlineMedium title in #151C27,
// 8px gap to optional bodyMedium subtitle in #404847,
// 24px gap to primary AppButton CTA.

// ── LIST DIVIDER ────────────────────────────────────────────
// 1px Container color #E0E7E6 (or #E2E8F8),
// indented 56px from leading edge.
```

### Quick Color Lookup

```
  primary             #366460    primary action, brand, focus
  primaryContainer    #4F7D79    hero surfaces
  onPrimary           #FFFFFF
  background          #F9F9FF    scaffold
  surface             #F9F9FF    cards (alias of bg)
  white               #FFFFFF    inputs, modals
  onSurface           #151C27    primary text — never pure black
  onSurfaceVariant    #404847    secondary text, icons
  surfaceContainerHigh #E2E8F8   borders, dividers, chip bg
  outline             #707977    borders
  outlineVariant      #C0C8C6    placeholder text, inactive dots
  error               #BA1A1A    destructive, missed
  errorContainer      #FFDAD6    warning fills (low refill)
  inverseSurface      #2A313D    snackbars
  divider             #E0E7E6    hairlines
  ambient shadow      0x0A000000 rgba(0,0,0,0.04)
```

### Flutter Implementation Shortcuts

```dart
// ═══ CARD ═══════════════════════════════════════════════════
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 20,
        offset: Offset(0, 4),
      ),
    ],
  ),
  padding: const EdgeInsets.all(16),
  child: ...,
)

// ═══ PRIMARY BUTTON ════════════════════════════════════════
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF366460),
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
  ),
  onPressed: ...,
  child: Text('Save', style: Theme.of(context).textTheme.titleSmall),
)

// ═══ INPUT WITH LABEL ABOVE ════════════════════════════════
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
          color: const Color(0xFFC0C8C6),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF366460), width: 2),
        ),
      ),
    ),
  ],
)
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 10 &nbsp; SCREEN INVENTORY & NAVIGATION
## ═══════════════════════════════════════════════════════════════

For reference. Stitch HTML prototypes at
`stitch_takeyourpills_healthcare_design_system/<screen>/code.html`.

```
  ┌────────────────────────────────────────────────────────────────────────┐
  │  ROUTE               SCREEN                    STITCH PROTOTYPE       │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /onboarding         OnboardingPage            onboarding_privacy/    │
  │                       3-step PageView           onboarding_reminders/  │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /dashboard          DashboardPage (tab 1)     dashboard/             │
  │                       adherence ring,           add_medication/        │
  │                       next dose, upcoming       medication_list/       │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /medications        MedicationListPage        medication_list/       │
  │                       (tab 2)                   medication_history/    │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /medication/:id     MedicationDetailPage      medication_history/    │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /add-medication/    AddEditMedicationPage     add_medication/        │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /calendar           Coming Soon (tab 3)       schedule_calendar/     │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /history            Coming Soon               medication_history/    │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /progress           Coming Soon (tab 4)       adherence_progress/    │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /settings           SettingsPage (tab 5)      settings/              │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /settings/*         Sub-settings pages        settings/              │
  │                       notifications, appearance                       │
  │                       privacy, about, data                            │
  ├────────────────────────────────────────────────────────────────────────┤
  │  /messaging          Coming Soon               provider_messaging/    │
  ├────────────────────────────────────────────────────────────────────────┤
  │  (hidden)            Reminder Action Sheet     reminder_action_sheet/ │
  ├────────────────────────────────────────────────────────────────────────┤
  │  (hidden)            Refill Tracker            refill_tracker/        │
  └────────────────────────────────────────────────────────────────────────┘
```

### Bottom Navigation

```
  Home · Meds · Calendar · Progress · Settings
  Fixed type, elevation 8, primary selected, hidden on sub-pages
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 11 &nbsp; STATE PATTERNS
## ═══════════════════════════════════════════════════════════════

Every interactive surface must handle these states. Reuse
`EmptyStateWidget` as the backbone.

### Empty State

```
  ✓  Icon 80px in surfaceContainerHigh (or custom), tonal, centered
  ✓  headlineMedium title in onSurface ("No medications yet")
  ✓  bodyMedium subtitle in onSurfaceVariant (action hint)
  ✓  Primary AppButton CTA visible & prominent
  ✓  Optional "Learn more" link
```

### Loading State

```
  ✓  Skeleton shimmer lists for repeating content
  ✓  Centered CircularProgressIndicator (20×20, stroke 2)
  ✓  Disable interactive elements during async
  ✓  "Saving..." inline for buttons (CircularProgressIndicator + titleSmall)
```

### Error State

```
  ✓  Clear error-toned icon (soft red, not alarmist)
  ✓  Human-readable headlineMedium title ("Unable to load medications")
  ✓  bodyMedium explanation in onSurfaceVariant
  ✓  Retry as primary AppButton
  ✓  Optional secondary fallback
```

### Success State

```
  ✓  Primary sage confirmation (not bright green)
  ✓  Brief bodyMedium message ("Medication added successfully")
  ✓  Auto-dismiss after 2-3 seconds
  ✓  "Undo" action via SnackBar with primary text
```

### Disabled State

```
  ✓  Opacity 0.5 on primary; surfaceContainerLow bg on secondary
  ✓  No tap handler active
  ✓  Optional tooltip explaining why disabled
```

### Reminder Interaction

```
  Take now:   primary, full width, 64px min touch target
  Snooze:     secondary split-button → 10/20/30/60 min chips
  Skip:       tertiary ghost button

  After any action:
    dose logged → notification dismissed → sheet closes → dashboard updates
    Confirmation SnackBar: "Reminder set for 10:30 AM"
```

### Missed Dose

```
  Dose enters "missed" 3 hours after scheduled time
  Dashboard: red alert card ("1 missed") → tap to see list with Take/Skip
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 12 &nbsp; ACCESSIBILITY NOTES
## ═══════════════════════════════════════════════════════════════

```
  ┌──────────────────────────────────────────────────────────────────┐
  │  CONCERN           RULE                                         │
  ├──────────────────────────────────────────────────────────────────┤
  │  Contrast (AA)     onPrimary/onSurface → ✓  (>15:1)             │
  │                     onSurfaceVariant/surface → ✓                 │
  │                                                                  │
  │  Touch targets     ≥ 44×44 dp · 8px spacing between targets     │
  │                     Buttons 56 tall · small icons 44×44 container│
  │                                                                  │
  │  Screen reader     All icons: semanticLabel                      │
  │                     Custom widgets: MergeSemantics for groups     │
  │                     List tiles: title + subtitle as one sentence  │
  │                                                                  │
  │  Font scaling      Currently DISABLED (TextScaler.noScaling)     │
  │                     If removed: use Flexible/Expanded everywhere │
  │                                                                  │
  │  Motion            Respect ReduceMotion → disable non-essential  │
  │                     Standard: 200-300ms · Transitions: 500ms     │
  │                                                                  │
  │  Focus outline     2px primary outline for keyboard focus        │
  │                                                                  │
  │  RTL               Flutter handles automatically · mirrored icons│
  └──────────────────────────────────────────────────────────────────┘
```

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 13 &nbsp; IMPLEMENTATION NOTES & KNOWN DIVERGENCES
## ═══════════════════════════════════════════════════════════════

Intentional simplifications or unrealized futures between Stitch HTML
prototypes and Flutter implementation.

> **Flutter values in this document are authoritative for new screens.**

| # | Divergence | Details |
|:--|:-----------|:--------|
| 1 | Dark theme scaffolded but not implemented | `AppTheme.darkTheme` returns `lightTheme`. `theme_mode` pref exists but unused. |
| 2 | Font files are 0-byte placeholders | Manrope fetched at runtime via `google_fonts`. Offline rendering would fail. |
| 3 | Cards use `Container + BoxDecoration` | Required for ambient `BoxShadow` (framework Card is elevation-based). |
| 4 | App Bar uses solid `surface` bg | Stitch HTML uses `backdrop-blur(90%)`. Intentional simplification. |
| 5 | Bottom nav uses native Material | Stitch's active pill animation (`scale 0.95`, filled bg) not implemented. |
| 6 | Adherence ring uses `CircularProgressIndicator` | Stitch uses custom-painted SVG with round caps — minor visual difference. |
| 7 | `SectionHeader` uses `primary` color | `design-system-notes.md` describes `bodySmall` w600 `onSurfaceVariant`. Code diverges. |
| 8 | Input fill is `#FFFFFF` | Design doc recommends `#F1F3F3`. Pure white is implemented baseline. |
| 9 | Input labels don't float | `AppInput` renders label above field as `Text`. `floatingLabelStyle` unused. |
| 10 | Page transitions are fade-only | No slide/curve variety — consistent with "calm" aesthetic. |
| 11 | Text scaling disabled app-wide | `TextScaler.noScaling` — known accessibility tradeoff. |
| 12 | Three tab routes are stubs | `/calendar`, `/history`, `/progress` show "Coming Soon" placeholders. |

---

<br>

## ═══════════════════════════════════════════════════════════════
## § 14 &nbsp; SOURCE FILES
## ═══════════════════════════════════════════════════════════════

```
  ┌────────────────────────────────────────────────────────────────────────────┐
  │  PURPOSE                          PATH                                     │
  ├────────────────────────────────────────────────────────────────────────────┤
  │  This document                    DESIGN.md (project root)                 │
  │  Canonical Stitch tokens          stitch_.../calm_clinical_excellence/     │
  │  Flutter color tokens             lib/shared/theme/app_colors.dart         │
  │  Flutter text styles              lib/shared/theme/app_text_styles.dart    │
  │  Flutter theme assembly           lib/shared/theme/app_theme.dart          │
  │  Shared components                lib/shared/components/                   │
  │  Routes                           lib/shared/routing/                      │
  │  Behavioral constants             lib/core/constants/app_constants.dart    │
  │  Flutter implementation notes     memory-bank/design-system-notes.md       │
  │  Screen HTML prototypes           stitch_.../<screen>/code.html            │
  │  Screen screenshots               stitch_.../<screen>/screen.png           │
  └────────────────────────────────────────────────────────────────────────────┘
```

---

<br>

<p align="center">
  <h1 align="center">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</h1>
  <p align="center"><strong>Status:</strong> Complete &amp; stable</p>
  <p align="center"><em>Last synced with: Flutter theme at <code>lib/shared/theme/</code> &amp; Stitch <code>calm_clinical_excellence/DESIGN.md</code></em></p>
  <h1 align="center">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</h1>
</p>
