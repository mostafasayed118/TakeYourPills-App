import 'package:flutter/material.dart';

/// Typography using the bundled Manrope family (offline-safe, no network).
class AppTextStyles {
  static const String _fontFamily = 'Manrope';

  // Display Large - rarely used
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.02,
  );

  // Headline Medium - screen titles
  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.01,
  );

  // Title Small - card titles, section headers
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  // Body Medium - primary body text
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // Body Small - secondary text, subtitles
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  // Label Large - uppercase labels, chips
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.05,
  );
}
