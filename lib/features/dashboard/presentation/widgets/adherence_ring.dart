import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class AdherenceRing extends StatelessWidget {
  final double value;

  const AdherenceRing({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            backgroundColor: AppColors.surfaceContainerHigh,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${(value * 100).round()}%', style: AppTextStyles.titleSmall),
            Text(
              'Adherence',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
