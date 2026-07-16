import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/domain/dashboard_domain_service.dart';
import '../../../shared/components/reliability_banner.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import 'cubit/dashboard_cubit.dart';
import 'widgets/adherence_ring.dart';
import 'widgets/dose_card.dart';
import 'widgets/streak_badge.dart';

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
                  style: AppTextStyles.bodyMedium.copyWith(color: scheme.error),
                ),
              ),
            );
          }
          if (state is! DashboardLoaded) {
            return const SizedBox.shrink();
          }

          final adherence = (state.adherencePercent / 100).clamp(0.0, 1.0);

          return RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ReliabilityBanner(),
                  const SizedBox(height: 16),

                  // ── Greeting ────────────────────────────────────────
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
                  const SizedBox(height: 20),

                  // ── Streak badge ───────────────────────────────────
                  if (state.currentStreak > 0 || state.bestStreak > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: StreakBadge(
                        currentStreak: state.currentStreak,
                        bestStreak: state.bestStreak,
                        message: state.streakMessage,
                        badge: state.currentStreak >= 100
                            ? StreakBadgeLevel.legendary
                            : state.currentStreak >= 30
                            ? StreakBadgeLevel.gold
                            : state.currentStreak >= 7
                            ? StreakBadgeLevel.silver
                            : state.currentStreak >= 3
                            ? StreakBadgeLevel.bronze
                            : StreakBadgeLevel.none,
                      ),
                    ),

                  // ── Adherence card ──────────────────────────────────
                  _AdherenceCard(
                    taken: state.takenToday,
                    total: state.totalToday,
                    value: adherence,
                  ),
                  const SizedBox(height: 20),

                  // ── Today's doses (with take buttons) ───────────────
                  Text(
                    "Today's doses",
                    style: AppTextStyles.titleSmall.copyWith(
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.doseOccurrences.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: scheme.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          state.medications.isEmpty
                              ? 'Add a medication to get started.'
                              : 'No doses scheduled for today.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: context.mutedText,
                          ),
                        ),
                      ),
                    )
                  else
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: scheme.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          for (
                            var i = 0;
                            i < state.doseOccurrences.length;
                            i++
                          ) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                indent: 84,
                                color: scheme.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            DoseCard(
                              dose: state.doseOccurrences[i],
                              isTaking: state.isTakingDose,
                              onTake: () =>
                                  context.read<DashboardCubit>().takeDose(
                                    medication:
                                        state.doseOccurrences[i].medication,
                                    scheduledTime:
                                        state.doseOccurrences[i].scheduledTime,
                                  ),
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
        border: Border.all(color: scheme.outlineVariant, width: 0.5),
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
