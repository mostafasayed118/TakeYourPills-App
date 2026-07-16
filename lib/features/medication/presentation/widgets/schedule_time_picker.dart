import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class ScheduleTimePicker extends StatefulWidget {
  const ScheduleTimePicker({
    super.key,
    required this.initialTimes,
    required this.onChanged,
  });

  final List<String> initialTimes;
  final ValueChanged<List<String>> onChanged;

  @override
  State<ScheduleTimePicker> createState() => _ScheduleTimePickerState();
}

class _ScheduleTimePickerState extends State<ScheduleTimePicker> {
  late List<TimeOfDay> _selectedTimes;

  @override
  void initState() {
    super.initState();
    _selectedTimes = widget.initialTimes.map(_parseTimeString).toList()
      ..sort((a, b) {
        final aMinutes = a.hour * 60 + a.minute;
        final bMinutes = b.hour * 60 + b.minute;
        return aMinutes.compareTo(bMinutes);
      });
  }

  TimeOfDay _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      return TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  String _formatTimeOfDay(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _addTime() async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (newTime != null) {
      setState(() {
        if (!_selectedTimes.contains(newTime)) {
          _selectedTimes.add(newTime);
          _selectedTimes.sort((a, b) {
            final aMinutes = a.hour * 60 + a.minute;
            final bMinutes = b.hour * 60 + b.minute;
            return aMinutes.compareTo(bMinutes);
          });
          widget.onChanged(_selectedTimes.map(_formatTimeOfDay).toList());
        }
      });
    }
  }

  void _removeTime(TimeOfDay time) {
    setState(() {
      _selectedTimes.remove(time);
      widget.onChanged(_selectedTimes.map(_formatTimeOfDay).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule Times',
          style: AppTextStyles.labelLarge.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedTimes.map(
              (time) => Chip(
                label: Text(_formatTimeOfDay(time)),
                onDeleted: () => _removeTime(time),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: colorScheme.primaryContainer,
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                deleteIconColor: colorScheme.onPrimaryContainer,
              ),
            ),
            ActionChip(
              avatar: Icon(Icons.add, color: colorScheme.onSurface),
              label: Text(
                'Add Time',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              onPressed: _addTime,
              backgroundColor: colorScheme.surfaceContainerLow,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: Text(
            'Tap to add or remove specific times',
            style: AppTextStyles.bodySmall.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
