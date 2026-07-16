import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/medication_repository.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/services/reminder_scheduler_service.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'cubit/reminder_action_cubit.dart';

class ReminderActionSheetPage extends StatelessWidget {
  const ReminderActionSheetPage({
    required this.medicationId,
    required this.doseId,
    required this.scheduledTime,
    super.key,
  });

  final int medicationId;
  final int doseId;
  final DateTime scheduledTime;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => ReminderActionCubit(
      medicationId: medicationId,
      doseId: doseId,
      scheduledTime: scheduledTime,
      repository: GetIt.instance<MedicationRepository>(),
      scheduler: GetIt.instance<ReminderSchedulerService>(),
      notificationService: GetIt.instance<NotificationService>(),
    ),
    child: const _ReminderActionSheetView(),
  );
}

class _ReminderActionSheetView extends StatelessWidget {
  const _ReminderActionSheetView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<ReminderActionCubit, ReminderActionState>(
      listener: (context, state) {
        if (state is ReminderActionSuccess) {
          safePop(context, AppRoutes.dashboard);
        } else if (state is ReminderActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: BlocBuilder<ReminderActionCubit, ReminderActionState>(
              builder: (context, state) {
                final cubit = context.read<ReminderActionCubit>();
                final isLoading = state is ReminderActionLoading;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Time for your medication!',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Take Now',
                      onPressed: isLoading ? null : cubit.takeDose,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Snooze 10 min',
                      onPressed:
                          isLoading ? null : () => cubit.snoozeDose(10),
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Snooze 20 min',
                      onPressed:
                          isLoading ? null : () => cubit.snoozeDose(20),
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Snooze 30 min',
                      onPressed:
                          isLoading ? null : () => cubit.snoozeDose(30),
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      text: 'Skip Dose',
                      onPressed: isLoading ? null : cubit.skipDose,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () =>
                          safePop(context, AppRoutes.dashboard),
                      child: Text(
                        'Close',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
