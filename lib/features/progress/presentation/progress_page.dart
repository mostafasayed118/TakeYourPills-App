import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/repositories/medication_repository.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import 'cubit/progress_cubit.dart';
import 'widgets/chart_toggle.dart';
import 'widgets/monthly_line_chart.dart';
import 'widgets/weekly_bar_chart.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => ProgressCubit(
        repository: context.read<MedicationRepository>(),
      )..loadProgress(),
      child: const _ProgressView(),
    );
}

class _ProgressView extends StatelessWidget {
  const _ProgressView();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return BlocBuilder<ProgressCubit, ProgressState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Progress')),
          body: _buildBody(context, state, scheme),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProgressState state,
    ColorScheme scheme,
  ) {
    if (state is ProgressLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ProgressError) {
      return Center(child: Text(state.message));
    }
    if (state is! ProgressLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final cubit = context.read<ProgressCubit>();

    return RefreshIndicator(
      onRefresh: () => cubit.loadProgress(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Summary card ──────────────────────────────────────────
          _SummaryCard(state: state, scheme: scheme),
          const SizedBox(height: 20),

          // ── Chart section ─────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Text(
                  'Adherence trend',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
              ChartToggle(
                selected: state.viewMode,
                onChanged: cubit.setViewMode,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.outlineVariant,
                width: 0.5,
              ),
            ),
            child: state.viewMode == ChartView.week
                ? WeeklyBarChart(bars: state.weeklyBars)
                : MonthlyLineChart(points: state.monthlyPoints),
          ),
          const SizedBox(height: 24),

          // ── Daily breakdown ───────────────────────────────────────
          Text(
            'Daily breakdown',
            style: AppTextStyles.titleSmall.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...state.stats.map((s) {
            final p = s.scheduled == 0 ? 0.0 : s.taken / s.scheduled;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.outlineVariant,
                    width: 0.5,
                  ),
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
                          backgroundColor: scheme.surfaceContainerHigh,
                          color: p >= 1
                              ? scheme.primary
                              : (p >= 0.5 ? scheme.tertiary : scheme.error),
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
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.state, required this.scheme});

  final ProgressLoaded state;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outlineVariant,
          width: 0.5,
        ),
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
            '${state.adherencePercent.toStringAsFixed(0)}%',
            style: AppTextStyles.displayLarge.copyWith(
              color: scheme.primary,
            ),
          ),
          Text(
            '${state.totalTaken} of ${state.totalScheduled} doses taken',
            style: AppTextStyles.bodyMedium.copyWith(
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.totalScheduled == 0
                  ? 0
                  : state.totalTaken / state.totalScheduled,
              minHeight: 10,
              backgroundColor: scheme.surfaceContainerHigh,
              color: scheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
