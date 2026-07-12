import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Reusable empty state widget with icon, title, subtitle, and CTA.
class EmptyStateWidget extends StatelessWidget {

  const EmptyStateWidget({
    required this.title, super.key,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionLabel,
  });
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                const Icon(
                  Icons.inbox_outlined,
                  size: 80,
                  color: AppColors.surfaceContainerHigh,
                ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  subtitle!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (onAction != null && actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: AppButton(
                  text: actionLabel!,
                  onPressed: onAction,
                ),
              ),
          ],
        ),
      ),
    );
}
