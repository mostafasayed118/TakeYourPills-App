---
name: Calm & Clinical Excellence
colors:
  surface: '#f9f9ff'
  surface-dim: '#d3daea'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eefe'
  surface-container-high: '#e2e8f8'
  surface-container-highest: '#dce2f3'
  on-surface: '#151c27'
  on-surface-variant: '#404847'
  inverse-surface: '#2a313d'
  inverse-on-surface: '#ebf1ff'
  outline: '#707977'
  outline-variant: '#c0c8c6'
  surface-tint: '#386663'
  primary: '#366460'
  on-primary: '#ffffff'
  primary-container: '#4f7d79'
  on-primary-container: '#f3fffd'
  inverse-primary: '#a0d0cb'
  secondary: '#4c6361'
  on-secondary: '#ffffff'
  secondary-container: '#cce5e2'
  on-secondary-container: '#506765'
  tertiary: '#565d5d'
  on-tertiary: '#ffffff'
  tertiary-container: '#6f7675'
  on-tertiary-container: '#f7fefd'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#bbece7'
  primary-fixed-dim: '#a0d0cb'
  on-primary-fixed: '#00201e'
  on-primary-fixed-variant: '#1f4e4b'
  secondary-fixed: '#cfe8e5'
  secondary-fixed-dim: '#b3cbc9'
  on-secondary-fixed: '#081f1e'
  on-secondary-fixed-variant: '#344b49'
  tertiary-fixed: '#dde4e3'
  tertiary-fixed-dim: '#c1c8c7'
  on-tertiary-fixed: '#161d1d'
  on-tertiary-fixed-variant: '#414848'
  background: '#f9f9ff'
  on-background: '#151c27'
  surface-variant: '#dce2f3'
typography:
  display-lg:
    fontFamily: Manrope
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Manrope
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  title-sm:
    fontFamily: Manrope
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-base:
    fontFamily: Manrope
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Manrope
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: Manrope
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-padding: 20px
  gutter: 16px
---

## Brand & Style

The design system is rooted in the intersection of professional medical reliability and modern wellness aesthetics. It avoids the cold, sterile atmosphere of traditional clinical software in favor of a "Sanctuary" experience—one that reduces the anxiety often associated with medication management.

The style is defined as **Premium Minimalism**. It prioritizes cognitive ease through generous whitespace, a restricted color palette, and a clear visual hierarchy. By utilizing soft textures and tonal layering, the system feels approachable and human, yet remains strictly organized and practical for daily health routines. The emotional response should be one of quiet confidence and reassurance.

## Colors

The palette is designed to be low-stimulation and high-clarity. 

- **Primary (Muted Sage/Teal):** Used for primary actions, active states, and brand presence. It is purposefully desaturated to remain calm.
- **Background (Off-white/Soft Gray):** A multi-tiered neutral system using `#F9FAFA` for the base and slightly darker grays for grouped content areas to reduce glare.
- **Functional Colors:** Success, Warning, and Destructive tones have been adjusted to "soft" variants. They provide necessary feedback without triggering "alarmist" responses from the user.
- **Text:** Avoid pure black. Use a deep charcoal-gray to maintain high legibility while softening the contrast against the off-white background.

## Typography

This design system utilizes **Manrope** for its balanced, modern, and highly legible characteristics. The typographic scale is designed for rapid scanning, essential for users who may be checking dosages under stress or in low-light conditions.

- **Hierarchy:** Large, bold titles establish clear entry points for each screen. 
- **Readability:** Line heights are slightly increased to prevent "text-crowding."
- **Labels:** Uppercase labels with increased letter spacing are used sparingly for secondary categorization to provide a structured, architectural feel.

## Layout & Spacing

The system follows an **8px spacing rhythm** (with a 4px sub-grid for minor alignment). 

- **Grid Model:** A fluid grid with a maximum container width of 600px for mobile-first views. 
- **Margins:** Standard page margins are set to 20px or 24px to provide a premium "wide" feel that avoids content appearing cramped.
- **Touch Targets:** All interactive elements must maintain a minimum 44x44px hit area, regardless of their visual size, to ensure accessibility for all age groups and physical conditions.

## Elevation & Depth

Visual hierarchy is established through **Tonal Layers** and **Ambient Shadows** rather than heavy borders.

- **Surface Tiers:** Backgrounds are the lowest layer. Content sits on rounded cards (Surface 1). Secondary information or modals sit on Surface 2.
- **Shadow Profile:** Use a single, highly-diffused shadow style: `0px 4px 20px rgba(0, 0, 0, 0.04)`. The shadow should feel like a soft glow of depth rather than a harsh drop shadow.
- **Dividers:** Use 1px solid lines in the Tertiary color (`#E0E7E6`) to separate list items. Dividers should never be pure black or high contrast.

## Shapes

The shape language is consistently **Rounded**. 

- **Cards:** Use a 16px (1rem) radius to convey friendliness and safety.
- **Buttons:** Use a 12px (0.75rem) radius to differentiate them slightly from content cards while maintaining a soft aesthetic.
- **Active States:** Small indicators or pill-shaped chips use a fully rounded (pill) radius to signify high interactivity.

## Components

- **Buttons:** Primary buttons use the Muted Sage background with white text. Secondary buttons use a subtle ghost style with a thin sage border or a tonal sage background at 10% opacity.
- **Cards:** The foundational element of the UI. Cards should have a white background and the "Ambient Shadow" defined in Elevation. Use internal padding of 16px or 20px.
- **Inputs:** Text fields use a light gray fill (`#F1F3F3`) and a subtle 1px border that shifts to Sage on focus. Labels sit outside the field for permanent visibility.
- **Progress Trackers:** For medication adherence, use soft, rounded pill bars. Avoid thin lines; use a 8px-12px height for progress bars to make them feel tangible.
- **Chips:** Small, rounded-pill elements used for dosage timing (e.g., "Morning," "With Food"). Use tonal Sage backgrounds for active states.
- **Lists:** Clean, edge-to-edge lists within cards, separated by thin dividers. Each item should have a minimum height of 56px to ensure easy tapping.