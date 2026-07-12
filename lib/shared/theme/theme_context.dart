import 'package:flutter/material.dart';

/// Theme helpers so feature screens follow light/dark ColorScheme.
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get scheme => theme.colorScheme;

  TextTheme get texts => theme.textTheme;

  bool get isDark => theme.brightness == Brightness.dark;

  /// Soft card surface that works in both themes.
  Color get cardColor => scheme.surfaceContainerHighest.withValues(
        alpha: isDark ? 0.35 : 1,
      );

  Color get mutedText => scheme.onSurfaceVariant;

  Color get dividerColor => scheme.outlineVariant.withValues(alpha: 0.5);
}
