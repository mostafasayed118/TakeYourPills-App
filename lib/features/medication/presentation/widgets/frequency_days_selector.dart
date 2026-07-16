import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class FrequencyDaysSelector extends StatefulWidget {
  const FrequencyDaysSelector({
    super.key,
    required this.initialDays,
    required this.onChanged,
  });

  final List<int> initialDays;
  final ValueChanged<List<int>> onChanged;

  @override
  State<FrequencyDaysSelector> createState() => _FrequencyDaysSelectorState();
}

class _FrequencyDaysSelectorState extends State<FrequencyDaysSelector> {
  late List<int> _selectedDays;
  static const List<String> _dayNames = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.initialDays);
  }

  void _toggleDay(int dayIndex) {
    setState(() {
      if (_selectedDays.contains(dayIndex + 1)) {
        _selectedDays.remove(dayIndex + 1);
      } else {
        _selectedDays.add(dayIndex + 1);
      }
      _selectedDays.sort();
      widget.onChanged(_selectedDays);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Days',
          style: AppTextStyles.labelLarge.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) {
              final dayValue = index + 1;
              final isSelected = _selectedDays.contains(dayValue);
              return GestureDetector(
                onTap: () => _toggleDay(index),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _dayNames[index],
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(
            'Select specific days of the week',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
