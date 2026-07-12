import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 8),
            _buildSection(context, 'Notifications'),
            _buildTile(
              context,
              'Notification Settings',
              Icons.notifications_outlined,
              () => context.go(AppRoutes.settingsNotifications),
            ),
            _buildDivider(context),
            _buildSection(context, 'Display'),
            _buildTile(
              context,
              'Appearance',
              Icons.palette_outlined,
              () => context.go(AppRoutes.settingsAppearance),
            ),
            _buildDivider(context),
            _buildSection(context, 'Privacy & Security'),
            _buildTile(
              context,
              'Privacy & Sharing',
              Icons.lock_outline,
              () => context.go(AppRoutes.settingsPrivacy),
            ),
            _buildTile(
              context,
              'Data Management',
              Icons.storage,
              () => context.go(AppRoutes.settingsData),
            ),
            _buildDivider(context),
            _buildSection(context, 'About'),
            _buildTile(
              context,
              'About TakeYourPills',
              Icons.info_outline,
              () => context.go(AppRoutes.settingsAbout),
            ),
            const SizedBox(height: 32),
          ],
        ),
      );

  Widget _buildSection(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.mutedText,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
      );

  Widget _buildTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) =>
      InkWell(
        onTap: onTap,
        child: Container(
          color: context.scheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 24, color: context.mutedText),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
              Icon(
                Icons.chevron_right,
                size: 24,
                color: context.mutedText,
              ),
            ],
          ),
        ),
      );

  Widget _buildDivider(BuildContext context) => Container(
        margin: const EdgeInsets.only(left: 56),
        height: 1,
        color: context.dividerColor,
      );
}
