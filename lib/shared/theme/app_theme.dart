import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static const String fontFamily = 'Manrope';

  // Dark clinical palette (teal-tinted, calm)
  static const Color _darkScaffold = Color(0xFF0F1419);
  static const Color _darkSurface = Color(0xFF1A222C);
  static const Color _darkSurfaceHigh = Color(0xFF24303C);
  static const Color _darkOnSurface = Color(0xFFE8EEF4);
  static const Color _darkOnVariant = Color(0xFFA8B3BE);
  static const Color _darkPrimary = Color(0xFF7EB8A8);
  static const Color _darkPrimaryContainer = Color(0xFF2A4A45);
  static const Color _darkOnPrimaryContainer = Color(0xFFD4F0EA);
  static const Color _darkError = Color(0xFFFFB4AB);
  static const Color _darkErrorContainer = Color(0xFF93000A);
  static const Color _darkOnErrorContainer = Color(0xFFFFDAD6);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.surfaceContainerHigh),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: fontFamily).copyWith(
            displayLarge: AppTextStyles.displayLarge,
            headlineMedium: AppTextStyles.headlineMedium,
            titleSmall: AppTextStyles.titleSmall,
            bodyMedium: AppTextStyles.bodyMedium,
            bodySmall: AppTextStyles.bodySmall,
            labelLarge: AppTextStyles.labelLarge,
          ),
    );
  }

  /// Dark palette — clinical calm with reduced luminance.
  static ThemeData get darkTheme {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _darkPrimary,
      onPrimary: Color(0xFF003732),
      primaryContainer: _darkPrimaryContainer,
      onPrimaryContainer: _darkOnPrimaryContainer,
      secondary: Color(0xFFB3CBC9),
      onSecondary: Color(0xFF1E3533),
      secondaryContainer: Color(0xFF2A3F3D),
      onSecondaryContainer: Color(0xFFCFE8E5),
      tertiary: Color(0xFFC1C8C7),
      onTertiary: Color(0xFF2B3232),
      tertiaryContainer: Color(0xFF3F4646),
      onTertiaryContainer: Color(0xFFDDE4E3),
      error: _darkError,
      onError: Color(0xFF690005),
      errorContainer: _darkErrorContainer,
      onErrorContainer: _darkOnErrorContainer,
      surface: _darkSurface,
      onSurface: _darkOnSurface,
      onSurfaceVariant: _darkOnVariant,
      outline: Color(0xFF8A9694),
      outlineVariant: Color(0xFF3F4847),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Color(0xFFE8EEF4),
      onInverseSurface: Color(0xFF1A222C),
      inversePrimary: AppColors.primary,
      surfaceTint: _darkPrimary,
      surfaceContainerLowest: Color(0xFF0B1014),
      surfaceContainerLow: Color(0xFF151C24),
      surfaceContainer: _darkSurfaceHigh,
      surfaceContainerHigh: Color(0xFF2C3845),
      surfaceContainerHighest: Color(0xFF374451),
    );

    final base = ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkScaffold,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkOnSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: const Color(0xFF003732),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          minimumSize: const Size(double.infinity, 56),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimary,
          side: const BorderSide(color: _darkPrimary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: _darkOnVariant,
        ),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: _darkPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkPrimary,
        unselectedItemColor: _darkOnVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _darkPrimary;
          return _darkOnVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkPrimaryContainer;
          }
          return _darkSurfaceHigh;
        }),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: _darkOnVariant,
        textColor: _darkOnSurface,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme
          .apply(
            fontFamily: fontFamily,
            bodyColor: _darkOnSurface,
            displayColor: _darkOnSurface,
          )
          .copyWith(
            displayLarge: AppTextStyles.displayLarge.copyWith(
              color: _darkOnSurface,
            ),
            headlineMedium: AppTextStyles.headlineMedium.copyWith(
              color: _darkOnSurface,
            ),
            titleSmall: AppTextStyles.titleSmall.copyWith(
              color: _darkOnSurface,
            ),
            bodyMedium: AppTextStyles.bodyMedium.copyWith(
              color: _darkOnSurface,
            ),
            bodySmall: AppTextStyles.bodySmall.copyWith(color: _darkOnVariant),
            labelLarge: AppTextStyles.labelLarge.copyWith(
              color: _darkOnSurface,
            ),
          ),
    );
  }
}
