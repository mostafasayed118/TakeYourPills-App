import 'package:flutter/material.dart';
import '../../../../core/entities/medication.dart';
import '../../../../shared/theme/app_colors.dart';
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
    final isPaused = medication.isPaused;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: isPaused
            ? Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5))
            : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: isPaused ? 8 : 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildIcon(isPaused),
              const SizedBox(width: 16),
              Expanded(child: _buildDetails(context, isPaused)),
              _buildPopupMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isPaused) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPaused
            ? AppColors.surfaceContainerLow
            : AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.medication,
        size: 28,
        color: isPaused
            ? AppColors.onSurfaceVariant
            : AppColors.onSecondaryContainer,
      ),
    );

  Widget _buildDetails(BuildContext context, bool isPaused) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          medication.name,
          style: AppTextStyles.titleSmall.copyWith(
            color: isPaused ? AppColors.onSurfaceVariant : AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${medication.dosageAmount} ${medication.dosageUnit}',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          _formatFrequency(medication.frequencyType),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        if (isPaused) _buildPausedBadge(),
        if (medication.pillsRemaining != null) ...[
          const SizedBox(height: 4),
          _buildPillsIndicator(),
        ],
      ],
    );

  Widget _buildPausedBadge() => SizedBox(
      height: 24,
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          'PAUSED',
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

  Widget _buildPillsIndicator() {
    final remaining = medication.pillsRemaining!;
    final threshold = medication.refillThreshold ?? 0;
    final isLow = threshold > 0 && remaining <= threshold;

    return Row(
      children: [
        Icon(
          isLow ? Icons.warning_amber_rounded : Icons.inventory_2_outlined,
          size: 14,
          color: isLow ? AppColors.error : AppColors.primary,
        ),
        const SizedBox(width: 4),
        Text(
          '$remaining pills remaining',
          style: AppTextStyles.bodySmall.copyWith(
            color: isLow ? AppColors.error : AppColors.primary,
            fontWeight: isLow ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu() => PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
      onSelected: _handleMenuSelection,
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(
          value: medication.isPaused ? 'resume' : 'pause',
          child: Text(medication.isPaused ? 'Resume' : 'Pause'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: AppColors.error)),
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
