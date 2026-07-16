import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/entities/dose_log.dart';
import '../../../core/utils/dose_occurrence_utils.dart';
import '../../../data/repositories/medication_repository.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import 'cubit/calendar_cubit.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => CalendarCubit(
        repository: context.read<MedicationRepository>(),
      )..loadWeek(),
      child: const _CalendarView(),
    );
}

class _CalendarView extends StatelessWidget {
  const _CalendarView();

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;

    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        final weekStart = state is CalendarLoading
            ? state.weekStart
            : state is CalendarLoaded
                ? state.weekStart
                : state is CalendarError
                    ? state.weekStart
                    : DateTime.now();
        final selectedDay = state is CalendarLoading
            ? state.selectedDay
            : state is CalendarLoaded
                ? state.selectedDay
                : state is CalendarError
                    ? state.selectedDay
                    : DateTime.now();

        final weekLabel =
            '${DateFormat.MMMd().format(weekStart)} – ${DateFormat.MMMd().format(weekStart.add(const Duration(days: 6)))}';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Calendar'),
            actions: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () =>
                    context.read<CalendarCubit>().shiftWeek(-1),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () =>
                    context.read<CalendarCubit>().shiftWeek(1),
              ),
            ],
          ),
          body: _buildBody(context, state, weekStart, selectedDay, weekLabel, scheme),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    CalendarState state,
    DateTime weekStart,
    DateTime selectedDay,
    String weekLabel,
    ColorScheme scheme,
  ) {
    if (state is CalendarLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is CalendarError) {
      return Center(child: Text(state.message));
    }
    if (state is! CalendarLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final cubit = context.read<CalendarCubit>();
    final dayOccurrences = cubit.occurrencesForDay(selectedDay);

    return RefreshIndicator(
      onRefresh: () => cubit.loadWeek(),
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
            weekStart: weekStart,
            selected: selectedDay,
            onSelect: (d) => cubit.selectDay(d),
          ),
          const SizedBox(height: 20),
          Text(
            DateFormat.yMMMMEEEEd().format(selectedDay),
            style: AppTextStyles.bodySmall.copyWith(
              color: context.mutedText,
            ),
          ),
          const SizedBox(height: 12),
          if (dayOccurrences.isEmpty)
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
            ...dayOccurrences.map((occ) {
              final status = cubit.statusFor(occ);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    onTap: () => context.go(
                      AppRoutes.medicationById(occ.medication.id),
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
