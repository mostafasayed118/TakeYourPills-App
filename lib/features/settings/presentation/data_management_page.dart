import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/medication_repository.dart';
import '../../../shared/services/data_export_service.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/services/preference_service.dart';
import '../../../shared/services/reminder_scheduler_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'cubit/data_management_cubit.dart';
import 'settings_subpage_scaffold.dart';

class DataManagementPage extends StatelessWidget {
  const DataManagementPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => DataManagementCubit(
        exportService: GetIt.instance<DataExportService>(),
        repository: context.read<MedicationRepository>(),
        notificationService: GetIt.instance<NotificationService>(),
        scheduler: GetIt.instance<ReminderSchedulerService>(),
        preferenceService: GetIt.instance<PreferenceService>(),
      ),
      child: const _DataManagementView(),
    );
}

class _DataManagementView extends StatelessWidget {
  const _DataManagementView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DataManagementCubit, DataManagementState>(
      listener: (context, state) {
        if (state is DataManagementSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is DataManagementError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: BlocBuilder<DataManagementCubit, DataManagementState>(
        builder: (context, state) {
          final busy = state is DataManagementBusy;
          return SettingsSubpageScaffold(
            title: 'Data Management',
            body: Stack(
              children: [
                ListView(
                  children: [
                    const SettingsInfoCard(
                      icon: Icons.storage_outlined,
                      message:
                          'All health data stays on this device. Export creates a '
                          'JSON file you can save or share. Treat exports as '
                          'sensitive medical information.',
                    ),
                    const SettingsSectionLabel('Export'),
                    ListTile(
                      leading: const Icon(Icons.ios_share, color: AppColors.primary),
                      title: const Text('Export data'),
                      subtitle: Text(
                        'Share medications and dose history as JSON',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      onTap: busy ? null : () => context.read<DataManagementCubit>().exportData(),
                    ),
                    const SettingsSectionLabel('Actions'),
                    ListTile(
                      leading:
                          const Icon(Icons.delete_outline, color: AppColors.error),
                      title: const Text('Delete all medications'),
                      subtitle: Text(
                        'Removes meds, schedules, logs, and pending reminders',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      onTap: busy ? null : () => _confirmClearMedications(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.restart_alt),
                      title: const Text('Reset app preferences'),
                      subtitle: Text(
                        'Clears settings and onboarding flag',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      onTap: busy ? null : () => _confirmResetPreferences(context),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
                if (busy)
                  const ColoredBox(
                    color: Color(0x33000000),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmClearMedications(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete all medications?'),
        content: const Text(
          'This removes every medication, schedule, and dose log on this '
          'device. Scheduled reminders will be cancelled. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete all'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<DataManagementCubit>().clearAllMedications();
    }
  }

  Future<void> _confirmResetPreferences(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset preferences?'),
        content: const Text(
          'Theme, snooze, quiet hours, and notification toggles return to '
          'defaults. Medications are not deleted. Onboarding will show again '
          'on next launch.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<DataManagementCubit>().resetPreferences();
    }
  }
}
