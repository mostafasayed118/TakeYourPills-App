import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/entities/dose_log.dart';
import '../../../core/entities/medication.dart';
import '../../../core/error/result.dart';
import '../../../core/utils/dose_occurrence_utils.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _weekStart;
  DateTime _selectedDay = DateTime.now();
  bool _loading = true;
  String? _error;
  List<Medication> _meds = const [];
  List<DoseLog> _logs = const [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _weekStart = _selectedDay.subtract(Duration(days: _selectedDay.weekday - 1));
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = GetIt.instance<MedicationRepository>();
      final medsResult = await repo.getAllMedications();
      final rangeStart = _weekStart;
      final rangeEnd = _weekStart.add(const Duration(days: 7));
      final logsResult = await repo.getDoseLogsForDateRange(rangeStart, rangeEnd);

      final meds = medsResult.getOrNull() ?? const <Medication>[];
      final logs = logsResult.getOrNull() ?? const <DoseLog>[];

      if (!mounted) return;
      setState(() {
        _meds = meds;
        _logs = logs;
        _loading = false;
        if (medsResult.isFailure) {
          _error = 'Could not load medications';
        }
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _shiftWeek(int delta) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * delta));
      _selectedDay = _weekStart;
    });
    _load();
  }

  List<DoseOccurrence> get _dayOccurrences {
    final start = _selectedDay;
    final end = start.add(const Duration(days: 1));
    return occurrencesForRange(
      medications: _meds,
      rangeStart: start,
      rangeEnd: end,
    );
  }

  DoseLogStatus? _statusFor(DoseOccurrence occ) {
    for (final log in _logs) {
      if (logMatchesOccurrence(log, occ)) return log.status;
    }
    final now = DateTime.now();
    if (occ.scheduledTime.isBefore(now)) return DoseLogStatus.missed;
    return DoseLogStatus.pending;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final weekLabel =
        '${DateFormat.MMMd().format(_weekStart)} – ${DateFormat.MMMd().format(_weekStart.add(const Duration(days: 6)))}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _shiftWeek(-1),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _shiftWeek(1),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        weekLabel,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _WeekStrip(
                        weekStart: _weekStart,
                        selected: _selectedDay,
                        onSelect: (d) => setState(() => _selectedDay = d),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        DateFormat.yMMMMEEEEd().format(_selectedDay),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.mutedText,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_dayOccurrences.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'No doses scheduled this day.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.mutedText,
                            ),
                          ),
                        )
                      else
                        ..._dayOccurrences.map((occ) {
                          final status = _statusFor(occ);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              child: ListTile(
                                onTap: () => context.go(
                                  '/medication/${occ.medication.id}',
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: scheme.primaryContainer,
                                  child: Icon(
                                    Icons.medication_outlined,
                                    color: scheme.onPrimaryContainer,
                                  ),
                                ),
                                title: Text(occ.medication.name),
                                subtitle: Text(
                                  '${formatTimeOfDay(occ.scheduledTime)} · '
                                  '${occ.medication.dosageAmount} ${occ.medication.dosageUnit}',
                                ),
                                trailing: _StatusChip(status: status),
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.weekStart,
    required this.selected,
    required this.onSelect,
  });

  final DateTime weekStart;
  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final today = DateTime.now();
    final todayKey = DateTime(today.year, today.month, today.day);

    return Row(
      children: List.generate(7, (i) {
        final day = weekStart.add(Duration(days: i));
        final isSelected = day.year == selected.year &&
            day.month == selected.month &&
            day.day == selected.day;
        final isToday = day == todayKey;

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onSelect(day),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? scheme.primary
                      : (isToday
                          ? scheme.primaryContainer.withValues(alpha: 0.5)
                          : scheme.surfaceContainerLow),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat.E().format(day).substring(0, 1),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${day.day}',
                      style: AppTextStyles.titleSmall.copyWith(
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final DoseLogStatus? status;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final (label, bg, fg) = switch (status) {
      DoseLogStatus.taken => (
          'Taken',
          scheme.primaryContainer,
          scheme.onPrimaryContainer,
        ),
      DoseLogStatus.skipped => (
          'Skipped',
          scheme.surfaceContainerHighest,
          scheme.onSurfaceVariant,
        ),
      DoseLogStatus.missed => (
          'Missed',
          scheme.errorContainer,
          scheme.onErrorContainer,
        ),
      DoseLogStatus.snoozed => (
          'Snoozed',
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        ),
      _ => (
          'Pending',
          scheme.surfaceContainerHigh,
          scheme.onSurfaceVariant,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelLarge.copyWith(color: fg, fontSize: 11),
      ),
    );
  }
}
