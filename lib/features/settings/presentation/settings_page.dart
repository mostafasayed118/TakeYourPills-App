import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          _buildSection('Notifications'),
          _buildTile(
            'Notification Settings',
            Icons.notifications_outlined,
            () => context.go(AppRoutes.settingsNotifications),
          ),
          _buildDivider(),
          _buildSection('Display'),
          _buildTile(
            'Appearance',
            Icons.palette_outlined,
            () => context.go(AppRoutes.settingsAppearance),
          ),
          _buildDivider(),
          _buildSection('Privacy & Security'),
          _buildTile(
            'Privacy & Sharing',
            Icons.lock_outline,
            () => context.go(AppRoutes.settingsPrivacy),
          ),
          _buildTile(
            'Data Management',
            Icons.storage,
            () => context.go(AppRoutes.settingsData),
          ),
          _buildDivider(),
          _buildSection('About'),
          _buildTile(
            'About TakeYourPills',
            Icons.info_outline,
            () => context.go(AppRoutes.settingsAbout),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );

  Widget _buildSection(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Text(
      title,
      style: AppTextStyles.bodySmall.copyWith(
        color: AppColors.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.left,
    ),
  );
  Widget _buildTile(String title, IconData icon, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
          const Icon(
            Icons.chevron_right,
            size: 24,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    ),
  );
  Widget _buildDivider() => Container(
    margin: const EdgeInsets.only(left: 56),
    height: 1,
    color: AppColors.surfaceContainerHigh,
  );
}
