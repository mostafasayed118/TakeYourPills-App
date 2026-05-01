import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isWarning;

  const StatChip({
    super.key,
    required this.label,
    required this.value,
    required this.unit,
    required this.isWarning,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.errorContainer.withValues(alpha: 0.5)
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: isWarning ? AppColors.error : AppColors.onSurface,
            ),
          ),
          Text(
            unit,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
