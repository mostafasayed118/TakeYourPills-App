import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/error/result.dart';
import '../../../data/repositories/medication_repository_impl.dart';
import '../../../shared/services/data_export_service.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/services/preference_service.dart';
import '../../../shared/services/reminder_scheduler_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'settings_subpage_scaffold.dart';

class DataManagementPage extends StatefulWidget {
  const DataManagementPage({super.key});

  @override
  State<DataManagementPage> createState() => _DataManagementPageState();
}

class _DataManagementPageState extends State<DataManagementPage> {
  bool _busy = false;

  Future<void> _exportData() async {
    setState(() => _busy = true);
    try {
      final export = GetIt.instance<DataExportService>();
      final result = await export.shareExport();
      if (!mounted) return;
      final msg = switch (result.status) {
        ShareResultStatus.success => 'Export shared',
        ShareResultStatus.dismissed => 'Share sheet closed',
        ShareResultStatus.unavailable => 'Share is unavailable on this device',
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _confirmClearMedications() async {
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
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _busy = true);
    try {
      final repo = GetIt.instance<MedicationRepository>();
      final notifications = GetIt.instance<NotificationService>();
      final scheduler = GetIt.instance.isRegistered<ReminderSchedulerService>()
          ? GetIt.instance<ReminderSchedulerService>()
          : NoOpReminderSchedulerService();
      final listResult = await repo.getAllMedications();
      final meds = listResult.getOrNull() ?? [];
      for (final med in meds) {
        await scheduler.cancelAllForMedication(med.id);
        await repo.deleteMedication(med.id);
      }
      await notifications.cancelAllNotifications();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All medications deleted')),
      );
    } on Object catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to clear data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _confirmResetPreferences() async {
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
    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _busy = true);
    try {
      final prefs = GetIt.instance<PreferenceService>();
      await prefs.clear();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences reset')),
      );
    } on Object catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset preferences: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => SettingsSubpageScaffold(
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
                  onTap: _busy ? null : _exportData,
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
                  onTap: _busy ? null : _confirmClearMedications,
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
                  onTap: _busy ? null : _confirmResetPreferences,
                ),
                const SizedBox(height: 32),
              ],
            ),
            if (_busy)
              const ColoredBox(
                color: Color(0x33000000),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
}
