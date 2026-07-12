import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'settings_subpage_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => SettingsSubpageScaffold(
      title: 'About',
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.medication, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            AppConstants.appName,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const SettingsInfoCard(
            icon: Icons.favorite_outline,
            message:
                'Quiet confidence for your medication routine — reliable '
                'reminders, simple logging, and clear progress. '
                'This app is a tracking tool, not medical advice.',
          ),
          const SettingsSectionLabel('Details'),
          ListTile(
            title: const Text('Purpose'),
            subtitle: Text(
              'Medicine tracker with reminders, adherence history, and refills',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ListTile(
            title: const Text('Privacy'),
            subtitle: Text(
              'Local-first. Health data stays on your device for MVP.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          ListTile(
            title: const Text('Disclaimer'),
            subtitle: Text(
              'Always follow your clinician’s instructions. Contact a '
              'healthcare professional for medical questions.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
}
