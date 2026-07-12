import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class DosageUnitDropdown extends StatelessWidget {

  const DosageUnitDropdown({
    required this.value, required this.onChanged, super.key,
  });
  final String value;
  final void Function(String) onChanged;

  static const _units = [
    'mg',
    'ml',
    'g',
    'mcg',
    'IU',
    'tablet',
    'capsule',
    'drop',
    'patch',
  ];

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
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
              value: _units.contains(value) ? value : _units.first,
              isExpanded: true,
              items: _units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
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
