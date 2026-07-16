import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/core/entities/dose_log.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class ReminderActionSheetPage extends StatelessWidget {
  const ReminderActionSheetPage({
    super.key,
    required this.medicationId,
    required this.doseId,
    required this.scheduledTime,
  });

  final int medicationId;
  final int doseId;
  final DateTime scheduledTime;

  Future<void> _logDose(
    BuildContext context,
    DoseLogStatus status,
  ) async {
    final repository = context.read<MedicationRepository>();
    final scheduler = context.read<ReminderSchedulerService>();

    final doseLog = DoseLog(
      id: 0, // Let database assign ID
      medicationId: medicationId,
      scheduledTime: scheduledTime.toIso8601String(),
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await repository.createDoseLog(doseLog);

    // Cancel the notification after logging
    await scheduler.cancelReminder(doseId);

    if (context.mounted) {
      context.pop(); // Close action sheet
      // Optionally navigate to dashboard or medication detail
      // context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Time for your medication!',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Take Now',
                onPressed: () => _logDose(context, DoseLogStatus.taken),
                isPrimary: true,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Snooze 30 min',
                onPressed: () async {
                  // For MVP, simple snooze by rescheduling
                  final newScheduledTime = scheduledTime.add(
                    const Duration(minutes: 30),
                  );
                  final scheduler = context.read<ReminderSchedulerService>();
                  final medication = await context
                      .read<MedicationRepository>()
                      .getMedicationById(medicationId);

                  if (medication.isSuccess && medication.getOrNull() != null) {
                    await scheduler.scheduleNotification(
                      id: doseId,
                      medicationId: medicationId,
                      doseId: doseId, // Use same doseId for snooze
                      scheduledTime: newScheduledTime,
                      title: 'Time for ${medication.getOrNull()!.name}',
                      body:
                          '${medication.getOrNull()!.dosageAmount} ${medication.getOrNull()!.dosageUnit}',
                      payload: '${medicationId},$doseId,${newScheduledTime.toIso8601String()}',
                    );
                  }

                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Skip Dose',
                onPressed: () => _logDose(context, DoseLogStatus.skipped),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.pop(), // Close without action
                child: Text(
                  'Close',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}
