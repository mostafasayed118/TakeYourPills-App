import 'package:flutter/material.dart';

import '../../../../shared/theme/app_text_styles.dart';
import '../../../../shared/theme/theme_context.dart';

class AdherenceRing extends StatelessWidget {
  const AdherenceRing({required this.value, super.key});
  final double value;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: value.clamp(0.0, 1.0),
            strokeWidth: 8,
            backgroundColor: scheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(value * 100).round()}%',
              style: AppTextStyles.titleSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
            Text(
              'Adherence',
              style: AppTextStyles.bodySmall.copyWith(
                color: context.mutedText,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
