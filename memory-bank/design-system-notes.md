# Design System Notes

## Existing Completed Design Direction

TakeYourPills adopts the **Calm & Clinical Excellence** design language, a "Premium Minimalism" style balancing medical reliability with a reassuring, anxiety-reducing aesthetic.

### Brand Values
- **Sanctuary:** Reduces medication-related stress
- **Clarity:** Rapid visual scanning, clear hierarchy
- **Confidence:** Organized, practical, predictable
- **Premium:** Generous whitespace, subtle textures

### Design Tokens (extracted from DESIGN.md)

**Color Palette (Muted Nature-Inspired):**

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#366460` (Muted Sage/Teal) | Primary buttons, active states, brand |
| `on_primary` | `#FFFFFF` | Text on primary |
| `primary_container` | `#4F7D79` | Secondary containers (dose cards) |
| `on_primary_container` | `#F3FFFD` | Text on primary container |
| `primary_fixed` | `#BBECE7` | Light accents |
| `primary_fixed_dim` | `#A0D0CB` | Subtle highlights |
| `secondary` | `#4C6361` | Supporting elements |
| `secondary_container` | `#CCE5E2` | Info cards, secondary highlights |
| `on_secondary_container` | `#506765` | Text on secondary container |
| `tertiary` | `#565D5D` | Tertiary text, icons |
| `tertiary_container` | `#6F7675` | Neutral containers |
| `background` | `#F9F9FF` | Base background (off-white) |
| `on_background` | `#151C27` | Primary text |
| `surface` | `#F9F9FF` | Card backgrounds |
| `surface_container_lowest` | `#FFFFFF` | Inputs, modals |
| `surface_container_low` | `#F0F3FF` |
| `surface_container` | `#E7EEFE` |
| `surface_container_high` | `#E2E8F8` |
| `surface_container_highest` | `#DCE2F3` |
| `surface_variant` | `#DCE2F3` | Outlines, dividers |
| `on_surface` | `#151C27` |
| `on_surface_variant` | `#404847` | Secondary text |
| `outline` | `#707977` | Border color |
| `outline_variant` | `#C0C8C6` | Subtle borders |
| `error` | `#BA1A1A` |
| `error_container` | `#FFDAD6` |
| `on_error` | `#FFFFFF` |
| `on_error_container` | `#93000A` |
| `inverse_surface` | `#2A313D` |
| `inverse_on_surface` | `#EBF1FF` |

**Typography (Manrope):**

| Style | Font Size | Weight | Line Height | Usage |
|-------|-----------|--------|-------------|-------|
| `display-lg` | 36px | 700 | 44px | Hero headlines (rare) |
| `headline-md` | 24px | 600 | 32px | Screen titles, section headers |
| `title-sm` | 18px | 600 | 24px | Card titles, list item headers |
| `body-base` | 16px | 400 | 24px | Body text, paragraphs |
| `body-sm` | 14px | 400 | 20px | Secondary text, subtitles |
| `label-caps` | 12px | 700 | 16px (tracking 0.05em) | Uppercase labels, chips |

**Spacing & Layout:**

- Base unit: 4px
- Spacing scale: xs(4), sm(8), md(16), lg(24), xl(32)
- Container padding: 20px
- Gutter between columns: 16px
- Max content width: 600px (mobile-first)
- Page margins: 20px (container-padding)

**Shape & Radius:**

- `sm`: 0.25rem (4px)
- `DEFAULT`: 0.5rem (8px)
- `md`: 0.75rem (12px)
- `lg`: 1rem (16px) - **card radius**
- `xl`: 1.5rem (24px)
- `full`: 9999px - pills, avatars

**Elevation (Shadows):**

- Ambient shadow: `0px 4px 20px rgba(0, 0, 0, 0.04)` - soft glow, subtle depth
- No hard borders; separation through surface layers and subtle dividers

**Divider color:** `surface_container_high` or `tertiary_fixed/50`

---

## Screen Inventory

Based on the Stitch design system, here are all screens with their HTML prototypes:

| Screen | File Path | Components | State Notes |
|--------|-----------|------------|-------------|
| Dashboard | `dashboard/` | Greeting, adherence ring, next dose card, upcoming list, missed alert | Real-time updates; loading → success/error |
| Add Medication | `add_medication/` | Multi-step form: identity, schedule, inventory; icon picker | Stepper state; validation per step |
| Medication List | `medication_list/` | List of medication cards; empty state; FAB | Loading → loaded; pull-to-refresh |
| Reminder Action Sheet | `reminder_action_sheet/` | Bottom sheet with Take/Snooze/Skip; dose context | Taken/Snoozed/Skipped actions |
| Schedule Calendar | `schedule_calendar/` | Monthly calendar with color-coded days; detail on tap | Date selection; day detail bottom sheet |
| Refill Tracker | `refill_tracker/` | List with remaining days, low-stock warning | Static updates when inventory changes |
| Medication History | `medication_history/` | Scrollable list with filters; status indicators | Filter state; empty history |
| Adherence Progress | `adherence_progress/` | Line chart, streak counter, stats cards | Date range selection (7d/30d/90d) |
| Onboarding - Permissions | `onboarding_privacy/` | Intro pages; permission request; test notification | Single flow; skip allowed |
| Onboarding - Reminders | `onboarding_reminders/` | Explanation of reminder importance | Educational; optional skip |
| Privacy & Sharing | `privacy_sharing/` | Privacy dashboard; data export; clear data | Destructive action confirmation |
| Settings | `settings/` | Master settings list with navigation tiles | Sub-pages for each category |
| Provider Messaging | `provider_messaging/` | Conversation list; composer; message bubbles | Thread selection; draft saving |

---

## Shared UI Components

### Buttons

**Primary Button (`AppPrimaryButton`)**
- Background: `primary`
- Text: `on_primary` (white)
- Full-width or fixed width
- Height: 56px (min touch target)
- Radius: `md` (12px)
- Shadow: ambient (optional)
- States: enabled, disabled (opacity 0.5, cursor not-allowed)

**Secondary Button (`AppSecondaryButton`)**
- Border: 1px solid `primary`
- Background: transparent
- Text: `primary`
- Radius: `md`
- States: hover background `primary_container` at 10% opacity

**Tertiary/Text Button (`AppTextButton`)**
- No border, no background
- Text: `primary`
- Padding: horizontal 16px

**Icon Button (`AppIconButton`)**
- Circular container, 40–56px
- Icon: `primary` or `on_surface_variant`
- Hover/focus: light background

---

### Inputs

**Text Field (`AppTextInput`)**
- Background: `surface_container_lowest` (white)
- Border: 1px solid `surface_container_high`; focus → `primary` (2px)
- Radius: `lg` (16px)
- Height: 56px (including padding)
- Label: `body-sm`, `on_surface_variant`; floats or stays above
- Placeholder: `outline_variant`
- Error: red border + error text below

**Number Input**
- Same as text but numeric keyboard
- Stepper buttons optional (add/subtract icons)

**Dropdown/Select (`AppDropdown`)**
- Same styling as TextField but with trailing chevron icon
- Menu: rounded corners, surface background

**Time Picker**
- Use `showTimePicker` with custom theme
- 12-hour format with AM/PM
- Default to current medication time if editing

---

### Cards

**Base Card (`AppCard`)**
- Background: `surface` or `surface_container_lowest` (white)
- Radius: `lg` (16px)
- Padding: `md` (16px) or `lg` (24px)
- Shadow: `ambient-shadow` (0 4px 20px rgba(0,0,0,0.04))
- Child: any widget

**Variants:**
- `PrimaryContainerCard`: background `primary_container`, text `on_primary_container`
- `SecondaryContainerCard`: background `secondary_container`, text `on_secondary_container`
- `ErrorContainerCard`: background `error_container`, text `on_error_container`

---

### Chips & Selections

**Choice Chip (`AppChoiceChip`)**
- Pill-shaped (`full` radius)
- Background: selected → `primary_container`; unselected → `surface_container_low`
- Text: selected → `on_primary_container`; unselected → `on_surface_variant`
- Border: selected → 2px solid `primary`; unselected → transparent
- Size: height 36px, horizontal padding `md`

**Icon Picker Chip**
- Circle 56×56
- Selected: `primary_container` background + 2px `primary` border
- Unselected: `surface_container_low` background, transparent border
- Material icon centered

---

### Lists

**AppListTile**
- Height: 72px (minimum)
- Leading: icon/avatar 40×40 or 56×56
- Title: `title-sm`, `on_surface`
- Subtitle: `body-sm`, `on_surface_variant`
- Trailing: optional icon or chevron
- Divider: bottom 1px `tertiary_fixed/50` (unless last child)
- Padding: horizontal `container-padding` (20px), vertical 12px

---

### Badges & Indicators

**Status Badge**
- Small capsule, `label-caps` text
- Colors: taken (greenish), missed (reddish), snoozed (bluish)
- Padding: xs sm

**Adherence Ring**
- Custom painter: two circles (track, progress)
- Track: `surface_variant`
- Progress: `primary`
- Text centered: percentage in `title-sm`

---

## Reusable Patterns

### Empty States
- Illustration or icon (100–120px)
- Title: `headline-md`, `on_surface`
- Subtitle: `body-sm`, `on_surface_variant`
- Primary CTA button below
- Padding: `xl` vertical

Examples:
- No medications yet → "Add your first medication" + FAB or button
- No history → "Take your first dose to see history"
- No upcoming → "All caught up!"

---

### Loading States
- Skeleton loaders: animated shimmer on card-shaped rectangles
- `CircularProgressIndicator` using `primary` color
- Full-screen overlay with centered spinner for async operations

---

### Error States
- Error icon (warning or alert)
- Title: "Something went wrong"
- Message: error description
- "Retry" button primary
- Optionally "Contact support" secondary

Placement:
- Full-page error: entire screen blocked
- Inline error: widget replacement within list or card
- SnackBar: transient errors (network failure, DB write failed)

---

### Success States
- Checkmark animation (Lottie or AnimatedIcon)
- Confirmation toast or SnackBar with brief message
- "Undo" action in SnackBar for destructive operations (delete)

---

### Form Patterns

**Multi-Step Form**
- Horizontal stepper or vertical page view
- Next/Back buttons at bottom
- Progress indicator (dots or step numbers)
- Validation per step; "Next" disabled until valid
- Save on final step → show loading → success dialog → pop

**Field Validation**
- Real-time validation on change (or on blur)
- Error message below field in `body-sm`, `error` color
- Required field indicator (*) or label says "Required"

---

## Navigation Patterns

### Bottom Navigation Bar (Global)

Fixed at bottom, 5 tabs:
1. **Home** (`/dashboard`) - active state: `primary` background pill, scale 0.95 animation
2. **Meds** (`/medications`) - list of medications
3. **Calendar** (`/calendar`) - schedule view
4. **Progress** (`/progress`) - charts and streak
5. **Settings** (`/settings`) - gear icon

Active icon: `primary` fill, larger
Inactive icon: `on_surface_variant` outline, smaller

**Implementation:** Use `Scaffold` with `BottomNavigationBar` inside `ShellRoute` with `GoRouter` to preserve navigation stack per tab.

---

### Top App Bar
- Sticky, backdrop blur (90% opacity background)
- Leading: avatar (user) or back chevron
- Title: app name (Home) or screen title
- Trailing: notifications icon (badge count if pending) or settings

---

### Modals & Bottom Sheets

**Full-screen dialogs** (Add Medication, Settings subpages)
- Sticky top bar with title, back/close button, action button (Save)
- Body scrollable

**Bottom sheets** (Action Sheet, day detail on calendar)
- Rounded top corners `xl` (24px)
- Drag handle at top (1.5px height line)
- Height: auto or 80% screen
- Dismissible by swipe down or tap outside

---

### In-app Notifications (SnackBars)
- Background: `inverse_surface` or `surface_container_highest`
- Text: `on_surface`
- Action button: `primary`
- Duration: 4–6 seconds
- Undo action: "Undo" in primary color

---

## Reminder Interaction Patterns

**Notification Tap → Action Sheet**
1. User receives notification at scheduled time
2. Taps notification → app opens directly to ReminderActionSheet (full-screen modal)
3. Sheet shows medication details (icon, name, dosage, time)
4. Three clear actions:

   - **Take now** (primary, full width, `primary` bg, white text, large touch target 64px min)
   - **Snooze** (secondary, split-button or expanded on tap → 10/20/30/60 min options)
   - **Skip** (tertiary, ghost button)

5. After any action:
   - Dose logged immediately
   - Notification dismissed
   - Sheet closes
   - Dashboard updates in background

**Missed Dose Handling**
- Dose enters "missed" state 3 hours after scheduled time
- Dashboard shows red alert card with "1 missed" and button to view
- Tapping alert shows list of missed doses with logging options (Take/Skip)

**Snooze UX**
- User taps "Snooze" → expands to show duration chips (10, 20, 30, 60 min)
- Tapping duration reschedules notification; shows confirmation SnackBar "Reminder set for 10:30 AM"
- Snooze count tracked (max 3 snoozes? may limit)

---

## Empty / Loading / Error / Success / Disabled States

### Empty State Checklist
- [ ] Illustration or large icon (tonal)
- [ ] Descriptive title ("No medications yet")
- [ ] Subtitle with action hint ("Tap + to add your first medication")
- [ ] Primary CTA button (visible, prominent)
- [ ] Secondary "Learn more" link optional

### Loading State Checklist
- [ ] Skeleton screens for lists (shimmer effect)
- [ ] Centered CircularProgressIndicator for full-page loads
- [ ] Disable interactive elements during async operations
- [ ] Show progress indicator for long operations (>1s) with cancel if possible

### Error State Checklist
- [ ] Clear error icon
- [ ] Human-readable title ("Unable to load medications")
- [ ] Brief explanation (could include error code)
- [ ] Retry primary button
- [ ] Secondary fallback (e.g., "Open in browser" if applicable)
- [ ] Log error to Crashlytics

### Success State
- [ ] Checkmark animation or green confirmation icon
- [ ] Brief message ("Medication added successfully")
- [ ] Auto-dismiss after 2-3 seconds
- [ ] "Undo" action for destructive operations

### Disabled State
- [ ] Visual dimming (opacity 0.5)
- [ ] Cursor: not-allowed visual (crosshair or gray)
- [ ] No tap handler active
- [ ] Tooltip explaining why disabled (optional)

---

## Accessibility & UX Notes for Flutter Implementation

### Screen Reader (TalkBack/VoiceOver)

**All images/icons must have `semanticLabel`:**
```dart
Icon(Icons.medication, semanticLabel: 'Medication')
Image.asset('empty.png', semanticLabel: 'Empty medication list illustration')
```

**Custom widgets must set `excludeSemantics` or provide `label`**:
- `AppCard` should have `semanticLabel` summarizing its content
- List tiles: title + subtitle read as one sentence with pause

**Navigation order:** Logical; use `MergeSemantics` to group related controls (e.g., Take/Snooze/Skip buttons)

---

### Font Scaling

- Text widgets use `Theme.of(context).textTheme` (automatically scales)
- Fixed-height containers must accommodate up to 200% text scale
- Test with `MediaQuery(textScaleFactor: 2.0)` in widget tests
- Avoid hard-coded heights; use `IntrinsicHeight` or `Flexible`/`Expanded`

---

### Color Contrast

- Verify all text combinations meet WCAG AA:
  - `on_primary` (white) on `primary` (teal) → ✅
  - `on_surface` (dark) on `background` (light) → ✅ (contrast > 15:1)
  - `on_surface_variant` on `surface` → ✅
- Use `flutter_contrast_checker` package to automate testing

---

### Touch Target Size

- All tappable elements ≥44×44 dp
- Maintain 8px minimum spacing between adjacent touch targets
- Large hit area independent of visual size (e.g., small icon button still has 44×44 container)

---

### Motion & Animation

- Subtle animations: fade-in, slide-up, scale on tap
- Duration: 200–300ms standard; 500ms for transitions
- Easing: `Curves.easeInOut` or `Curves.easeOut`
- Accessibility: respect `ReduceMotion` setting → disable non-essential animations

---

### RTL (Right-to-Left) Support

- Use `Directionality` widget automatically provided by MaterialApp
- Use `textDirection` property where needed
- LTR icons may need mirroring (use `Icons.arrow_back` which auto-mirrors)
- Test RTL with `Directionality(textDirection: TextDirection.rtl, ...)`

---

### Focus & Keyboard Navigation (Desktop)

- For future desktop/web support, ensure all interactive widgets have focusable ancestors
- Use `Shortcuts` and `Actions` for keyboard shortcuts if needed
- Ensure focus outline visible (2px `primary` outline)

---

**Design System Reference Files:**
- Original design: `stitch_takeyourpills_healthcare_design_system/calm_clinical_excellence/DESIGN.md`
- Screen prototypes: `stitch_takeyourpills_healthcare_design_system/<screen>/code.html`

---

**Last Updated:** 2026-04-29  
**Status:** Complete (design direction stable)  
**Next:** Translate design tokens into Flutter `ThemeData` and custom widgets
