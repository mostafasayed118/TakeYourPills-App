import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/dose_occurrence_utils.dart';
import '../../../core/utils/schedule_parser.dart';
import '../../../shared/components/reliability_banner.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import 'cubit/dashboard_cubit.dart';
import 'widgets/adherence_ring.dart';
import 'widgets/upcoming_item.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TakeYourPills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go(AppRoutes.settingsNotifications),
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading || state is DashboardInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: scheme.error,
                  ),
                ),
              ),
            );
          }
          if (state is! DashboardLoaded) {
            return const SizedBox.shrink();
          }

          final adherence = (state.adherencePercent / 100).clamp(0.0, 1.0);
          final next = state.nextDose;
          final nextTime = state.nextDoseTime;

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReliabilityBanner(),
                  const SizedBox(height: 16),
                  Text(
                    _greeting(),
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    'Here is your wellness summary for today.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: context.mutedText,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _AdherenceCard(
                    taken: state.takenToday,
                    total: state.totalToday,
                    value: adherence,
                  ),
                  const SizedBox(height: 24),
                  if (next != null && nextTime != null)
                    _NextDoseCard(
                      name: next.name,
                      dosage:
                          '${next.dosageAmount} ${next.dosageUnit}',
                      timeLabel: formatTimeOfDay(nextTime),
                      onLog: () => context.go(AppRoutes.medicationById(next.id)),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            state.medications.isEmpty
                                ? 'Add a medication to see your next dose here.'
                                : 'No more doses scheduled for today.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: context.mutedText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Upcoming today',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (state.upcomingMedications.isEmpty)
                    Text(
                      'Nothing else upcoming.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.mutedText,
                      ),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          for (var i = 0;
                              i < state.upcomingMedications.length;
                              i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                color: context.dividerColor,
                              ),
                            UpcomingItem(
                              name: state.upcomingMedications[i].name,
                              dosage:
                                  '${state.upcomingMedications[i].dosageAmount} ${state.upcomingMedications[i].dosageUnit}',
                              time: _firstUpcomingTimeLabel(
                                state.upcomingMedications[i].scheduleTimes,
                              ),
                              icon: Icons.medication_outlined,
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _firstUpcomingTimeLabel(String scheduleTimes) {
    final now = DateTime.now();
    final times = parseScheduleTimes(scheduleTimes);
    for (final t in times) {
      final dt = DateTime(now.year, now.month, now.day, t.hour, t.minute);
      if (dt.isAfter(now)) {
        return formatTimeOfDay(dt);
      }
    }
    if (times.isEmpty) return '—';
    final t = times.first;
    return formatTimeOfDay(
      DateTime(now.year, now.month, now.day, t.hour, t.minute),
    );
  }
}

class _AdherenceCard extends StatelessWidget {
  const _AdherenceCard({
    required this.taken,
    required this.total,
    required this.value,
  });

  final int taken;
  final int total;
  final double value;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    final missed = (total - taken).clamp(0, total);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              AdherenceRing(value: value),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$taken of $total',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: scheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Taken today',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: context.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (missed > 0) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: scheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$missed missed',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onErrorContainer,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Review calendar',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: scheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NextDoseCard extends StatelessWidget {
  const _NextDoseCard({
    required this.name,
    required this.dosage,
    required this.timeLabel,
    required this.onLog,
  });

  final String name;
  final String dosage;
  final String timeLabel;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              timeLabel.toUpperCase(),
              style: AppTextStyles.labelLarge.copyWith(
                color: scheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: scheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dosage,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medication, color: scheme.onPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onLog,
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.onPrimary,
                foregroundColor: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'View medication',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
