import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Display Large - rarely used
  static TextStyle get displayLarge => GoogleFonts.manrope(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 44 / 36,
    letterSpacing: -0.02,
  );

  // Headline Medium - screen titles
  static TextStyle get headlineMedium => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.01,
  );

  // Title Small - card titles, section headers
  static TextStyle get titleSmall => GoogleFonts.manrope(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );

  // Body Medium - primary body text
  static TextStyle get bodyMedium => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );

  // Body Small - secondary text, subtitles
  static TextStyle get bodySmall => GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );

  // Label Large - uppercase labels, chips (tracking 0.05em = 1.6px)
  static TextStyle get labelLarge => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 16 / 12,
    letterSpacing: 0.05,
  );
}
