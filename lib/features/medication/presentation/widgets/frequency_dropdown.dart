import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class FrequencyDropdown extends StatelessWidget {

  const FrequencyDropdown({
    required this.value, required this.onChanged, super.key,
  });
  final String value;
  final void Function(String) onChanged;

  static const _frequencies = {
    'daily': 'Every day',
    'weekly': 'Weekly',
    'specific_days': 'Specific days',
    'as_needed': 'As needed',
  };

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _frequencies.containsKey(value)
                  ? value
                  : _frequencies.keys.first,
              isExpanded: true,
              items: _frequencies.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              style: AppTextStyles.bodyMedium,
              dropdownColor: AppColors.surface,
            ),
          ),
        ),
      ],
    );
}
