import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
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
            Icons.phone_android,
            'On-device storage',
            'SQLite database encrypted by the OS sandbox',
          ),
          _row(
            Icons.cloud_off_outlined,
            'No cloud sync (MVP)',
            'Nothing is uploaded to a server in this version',
          ),
          const SettingsSectionLabel('Sharing'),
          _row(
            Icons.share_outlined,
            'Export (coming soon)',
            'You will control any export or share action',
          ),
          _row(
            Icons.medical_services_outlined,
            'Provider messaging',
            'Local drafts only until cloud sync is added',
          ),
          const SettingsSectionLabel('Your control'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'You can delete medications and dose history at any time from '
              'the app. Clearing app data in system settings removes all '
              'local TakeYourPills data.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );

  Widget _row(IconData icon, String title, String subtitle) => ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
}
