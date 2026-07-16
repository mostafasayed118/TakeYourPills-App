import 'package:flutter/material.dart';

/// Design tokens for the TakeYourPills design system.
///
/// Palette: Calm Clinical — vibrant teal primary with warm accents.
/// Optimized for WCAG AA contrast (4.5:1+ for body text).
class AppColors {
  // ── Primary (vibrant teal) ──────────────────────────────────────────
  static const Color primary = Color(0xFF0D9488);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFCCFBF1);
  static const Color onPrimaryContainer = Color(0xFF064E3B);

  // ── Secondary (muted sage) ──────────────────────────────────────────
  static const Color secondary = Color(0xFF5B7A6E);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD1E8DD);
  static const Color onSecondaryContainer = Color(0xFF1B3A2D);

  // ── Tertiary (warm amber accent) ────────────────────────────────────
  static const Color tertiary = Color(0xFFD97706);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFFEF3C7);
  static const Color onTertiaryContainer = Color(0xFF78350F);

  // ── Error ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFDC2626);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF7F1D1D);

  // ── Success ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successContainer = Color(0xFFDCFCE7);

  // ── Surfaces ────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFB);
  static const Color onBackground = Color(0xFF0F172A);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF64748B);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);
  static const Color surfaceContainer = Color(0xFFE2E8F0);
  static const Color surfaceContainerHigh = Color(0xFFCBD5E1);
  static const Color surfaceContainerHighest = Color(0xFF94A3B8);

  // ── Outline ─────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF94A3B8);
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // ── Divider ─────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE2E8F0);

  // ── Shadow ──────────────────────────────────────────────────────────
  static const Color shadow = Color(0x1A000000);

  // ── Legacy aliases (remove after migration) ─────────────────────────
  static const Color surfaceDim = surfaceContainer;
  static const Color surfaceBright = surface;
  static const Color inverseSurface = Color(0xFF1E293B);
  static const Color inverseOnSurface = Color(0xFFF1F5F9);
  static const Color surfaceTint = primary;
  static const Color surfaceVariant = surfaceContainerLow;
}
