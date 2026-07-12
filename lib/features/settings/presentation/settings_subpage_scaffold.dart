import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/routing/routes.dart';
import '../../../shared/theme/app_text_styles.dart';
import '../../../shared/theme/theme_context.dart';

/// Shared chrome for settings sub-screens (back → main Settings).
class SettingsSubpageScaffold extends StatelessWidget {
  const SettingsSubpageScaffold({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ),
        body: body,
      );
}

/// Section label matching the main settings list style.
class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
        child: Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: context.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
}

/// Helper card for explanatory / privacy copy.
class SettingsInfoCard extends StatelessWidget {
  const SettingsInfoCard({
    required this.icon,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = context.scheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: context.mutedText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
