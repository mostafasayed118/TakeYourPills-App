import 'package:flutter/material.dart';
import '../../../../core/entities/medication.dart';
import '../../../../shared/theme/app_text_styles.dart';

class MedicationCard extends StatelessWidget {

  const MedicationCard({
    required this.medication,
    required this.onTap,
    required this.onEdit,
    required this.onPauseChanged,
    required this.onDelete,
    super.key,
  });
  final Medication medication;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final void Function(bool) onPauseChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPaused = medication.isPaused;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: isPaused
            ? Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              )
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildIcon(colorScheme, isPaused),
              const SizedBox(width: 16),
              Expanded(child: _buildDetails(colorScheme, isPaused)),
              _buildPopupMenu(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ColorScheme colorScheme, bool isPaused) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPaused
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
            : colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.medication,
        size: 28,
        color: isPaused
            ? colorScheme.onSurfaceVariant
            : colorScheme.onPrimaryContainer,
      ),
    );

  Widget _buildDetails(ColorScheme colorScheme, bool isPaused) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medication.name,
          style: AppTextStyles.titleSmall.copyWith(
            color: isPaused ? colorScheme.onSurfaceVariant : colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${medication.dosageAmount} ${medication.dosageUnit}',
          style: AppTextStyles.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatFrequency(medication.frequencyType),
          style: AppTextStyles.bodySmall.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        if (isPaused) _buildPausedBadge(colorScheme),
        if (medication.pillsRemaining != null) ...[
          const SizedBox(height: 4),
          _buildPillsIndicator(colorScheme),
        ],
      ],
    );

  Widget _buildPausedBadge(ColorScheme colorScheme) => SizedBox(
      height: 24,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'PAUSED',
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

  Widget _buildPillsIndicator(ColorScheme colorScheme) {
    final remaining = medication.pillsRemaining!;
    final threshold = medication.refillThreshold ?? 0;
    final isLow = threshold > 0 && remaining <= threshold;

    return Row(
      children: [
        Icon(
          isLow ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
          size: 14,
          color: isLow ? colorScheme.error : colorScheme.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$remaining pills remaining',
          style: AppTextStyles.bodySmall.copyWith(
            color: isLow ? colorScheme.error : colorScheme.primary,
            fontWeight: isLow ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(ColorScheme colorScheme) => PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: colorScheme.onSurfaceVariant,
      ),
      onSelected: _handleMenuSelection,
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(
          value: medication.isPaused ? 'resume' : 'pause',
          child: Text(medication.isPaused ? 'Resume' : 'Pause'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text(
            'Delete',
            style: TextStyle(color: colorScheme.error),
          ),
        ),
      ],
    );

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'edit':
        onEdit();
        return;
      case 'pause':
        onPauseChanged(true);
        return;
      case 'resume':
        onPauseChanged(false);
        return;
      case 'delete':
        onDelete();
        return;
    }
  }

  String _formatFrequency(String type) {
    const frequencyMap = {
      'daily': 'Every day',
      'weekly': 'Weekly',
      'as_needed': 'As needed',
      'specific_days': 'Specific days',
    };
    return frequencyMap[type] ?? type;
  }
}
