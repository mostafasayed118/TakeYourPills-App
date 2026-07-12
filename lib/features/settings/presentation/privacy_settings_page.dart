import 'package:flutter/material.dart';

import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';
import 'settings_subpage_scaffold.dart';

class PrivacySettingsPage extends StatelessWidget {
  const PrivacySettingsPage({super.key});

  @override
  Widget build(BuildContext context) => SettingsSubpageScaffold(
        title: 'Privacy & Sharing',
        body: ListView(
          children: [
            const SettingsInfoCard(
              icon: Icons.lock_outline,
              message:
                  'TakeYourPills is local-first. Your medications, dose logs, '
                  'and schedules stay on this device unless you export them.',
            ),
            const SettingsSectionLabel('Data location'),
            _row(
              context,
              Icons.phone_android,
              'On-device storage',
              'SQLite database protected by the OS app sandbox',
            ),
            _row(
              context,
              Icons.cloud_off_outlined,
              'No cloud sync (MVP)',
              'Medication data is not uploaded to a server',
            ),
            const SettingsSectionLabel('Sharing'),
            _row(
              context,
              Icons.ios_share,
              'JSON export',
              'Available in Data Management — share only with people you trust',
            ),
            _row(
              context,
              Icons.bug_report_outlined,
              'Diagnostic logs',
              'Optional local crash logs; remote Sentry only if the build '
                  'includes a DSN',
            ),
            const SettingsSectionLabel('Your control'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'You can delete medications and dose history at any time from '
                'the app. Clearing app data in system settings removes all '
                'local TakeYourPills data. Provider messaging is not included '
                'in this version.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: context.mutedText,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );

  Widget _row(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) =>
      ListTile(
        leading: Icon(icon, color: context.scheme.primary),
        title: Text(title, style: AppTextStyles.bodyMedium),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.mutedText,
          ),
        ),
      );
}
