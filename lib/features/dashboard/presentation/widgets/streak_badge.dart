import 'package:flutter/material.dart';

import '../../../../core/domain/dashboard_domain_service.dart';
import '../../../../shared/theme/app_text_styles.dart';

/// Streak badge showing current streak and motivational message.
class StreakBadge extends StatelessWidget {
  const StreakBadge({
    required this.currentStreak,
    required this.bestStreak,
    required this.message,
    required this.badge,
    super.key,
  });

  final int currentStreak;
  final int bestStreak;
  final String message;
  final StreakBadgeLevel badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (currentStreak == 0 && bestStreak == 0) {
      return const SizedBox.shrink();
    }

    final (icon, color) = switch (badge) {
      StreakBadgeLevel.legendary => (Icons.emoji_events, Color(0xFFF59E0B)),
      StreakBadgeLevel.gold => (Icons.emoji_events, Color(0xFFF59E0B)),
      StreakBadgeLevel.silver => (Icons.emoji_events, Color(0xFF94A3B8)),
      StreakBadgeLevel.bronze => (Icons.emoji_events, Color(0xFFD97706)),
      StreakBadgeLevel.none => (Icons.local_fire_department, scheme.primary),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: badge != StreakBadgeLevel.none
              ? color.withValues(alpha: 0.3)
              : scheme.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$currentStreak',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      currentStreak == 1 ? 'day streak' : 'day streak',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (bestStreak > currentStreak)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Best: $bestStreak',
                style: AppTextStyles.labelSmall.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
