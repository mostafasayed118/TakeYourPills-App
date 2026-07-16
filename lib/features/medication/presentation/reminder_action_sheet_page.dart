import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/components/app_button.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_colors.dart';
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
    ),
    child: const _ReminderActionSheetView(),
  );
}

class _ReminderActionSheetView extends StatelessWidget {
  const _ReminderActionSheetView();

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<ReminderActionCubit, ReminderActionState>(
    listener: (context, state) {
      if (state is ReminderActionSuccess) {
        safePop(context, AppRoutes.dashboard); // Close action sheet on success
      } else if (state is ReminderActionError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${state.message}'),
            backgroundColor: AppColors.error,
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
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                    style: AppTextStyles.headlineMedium,
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
                    onPressed: isLoading ? null : () => cubit.snoozeDose(10),
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Snooze 20 min',
                    onPressed: isLoading ? null : () => cubit.snoozeDose(20),
                    isLoading: isLoading,
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    text: 'Snooze 30 min',
                    onPressed: isLoading ? null : () => cubit.snoozeDose(30),
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
                    onPressed: () => safePop(context, AppRoutes.dashboard), // Close without action
                    child: Text(
                      'Close',
                      style: AppTextStyles.displayLarge.copyWith(
                        color: AppColors.onSurfaceVariant,
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
