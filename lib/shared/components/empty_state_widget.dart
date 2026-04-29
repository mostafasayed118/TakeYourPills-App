import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon ?? const Icon(Icons.inbox_outlined, size: 80, color: AppColors.surfaceContainerHigh),
          const SizedBox(height: 24),
          Text(title, style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onSurface)),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(subtitle!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
            ),
          if (onAction != null && actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: AppButton(text: actionLabel!, onPressed: onAction, isPrimary: true),
            ),
        ],
      ),
    );
  }
}
