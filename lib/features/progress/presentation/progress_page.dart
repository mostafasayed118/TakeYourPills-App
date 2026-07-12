import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../core/entities/dose_log.dart';
import '../../../core/entities/medication.dart';
import '../../../core/error/result.dart';
import '../../../core/utils/dose_occurrence_utils.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  static const _days = 7;

  bool _loading = true;
  String? _error;
  List<_DayStat> _stats = const [];
  int _taken = 0;
  int _scheduled = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = GetIt.instance<MedicationRepository>();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final rangeStart = today.subtract(const Duration(days: _days - 1));
      final rangeEnd = today.add(const Duration(days: 1));

      final meds = (await repo.getAllMedications()).getOrNull() ??
          const <Medication>[];
      final logs = (await repo.getDoseLogsForDateRange(rangeStart, rangeEnd))
              .getOrNull() ??
          const <DoseLog>[];

      final occurrences = occurrencesForRange(
        medications: meds,
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      final dayStats = <_DayStat>[];
      var totalTaken = 0;
      var totalScheduled = 0;

      for (var i = 0; i < _days; i++) {
        final day = rangeStart.add(Duration(days: i));
        final dayEnd = day.add(const Duration(days: 1));
        final dayOcc = occurrences
            .where(
              (o) =>
                  !o.scheduledTime.isBefore(day) &&
                  o.scheduledTime.isBefore(dayEnd),
            )
            .toList();
        final scheduled = dayOcc.length;
        var taken = 0;
        for (final occ in dayOcc) {
          final matched = logs.any(
            (l) =>
                logMatchesOccurrence(l, occ) &&
                l.status == DoseLogStatus.taken,
          );
          if (matched) taken++;
        }
        totalTaken += taken;
        totalScheduled += scheduled;
        dayStats.add(
          _DayStat(
            day: day,
            taken: taken,
            scheduled: scheduled,
          ),
        );
      }

      if (!mounted) return;
      setState(() {
        _stats = dayStats;
        _taken = totalTaken;
        _scheduled = totalScheduled;
        _loading = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final percent =
        _scheduled > 0 ? (_taken / _scheduled * 100).clamp(0.0, 100.0) : 0.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Last 7 days',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: context.mutedText,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${percent.toStringAsFixed(0)}%',
                              style: AppTextStyles.displayLarge.copyWith(
                                color: scheme.primary,
                              ),
                            ),
                            Text(
                              '$_taken of $_scheduled doses taken',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _scheduled == 0 ? 0 : _taken / _scheduled,
                                minHeight: 10,
                                backgroundColor: scheme.surfaceContainerHighest,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Daily breakdown',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._stats.map((s) {
                        final p = s.scheduled == 0
                            ? 0.0
                            : s.taken / s.scheduled;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: context.cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        DateFormat.E().add_MMMd().format(s.day),
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ),
                                    Text(
                                      s.scheduled == 0
                                          ? 'No doses'
                                          : '${s.taken}/${s.scheduled}',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: context.mutedText,
                                      ),
                                    ),
                                  ],
                                ),
                                if (s.scheduled > 0) ...[
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: p,
                                      minHeight: 6,
                                      backgroundColor:
                                          scheme.surfaceContainerHighest,
                                      color: p >= 1
                                          ? scheme.primary
                                          : (p >= 0.5
                                              ? scheme.tertiary
                                              : scheme.error),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Text(
                        'Based on scheduled doses for active medications and '
                        'on-device dose logs. Paused and as-needed meds are excluded.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: context.mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _DayStat {
  const _DayStat({
    required this.day,
    required this.taken,
    required this.scheduled,
  });

  final DateTime day;
  final int taken;
  final int scheduled;
}
