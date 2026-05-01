import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

/// Primary action button following the Calm & Clinical design system.
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      backgroundColor: isPrimary ? AppColors.primary : Colors.transparent,
      foregroundColor: isPrimary ? AppColors.onPrimary : AppColors.primary,
      disabledBackgroundColor: isPrimary
          ? AppColors.primary.withValues(alpha: 0.5)
          : AppColors.surfaceContainerLow,
      disabledForegroundColor: isPrimary
          ? AppColors.onPrimary.withValues(alpha: 0.5)
          : AppColors.onSurfaceVariant,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      minimumSize: const Size(0, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPrimary
            ? BorderSide.none
            : const BorderSide(color: AppColors.primary),
      ),
    );

    return isLoading
        ? ElevatedButton(
            onPressed: null,
            style: style,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: isPrimary ? AppColors.onPrimary : AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
                const SizedBox(width: 12),
                Text('Saving...', style: AppTextStyles.titleSmall),
              ],
            ),
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Text(text, style: AppTextStyles.titleSmall),
              ],
            ),
          );
  }
}
