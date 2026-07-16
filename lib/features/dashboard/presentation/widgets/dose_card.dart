import 'package:flutter/material.dart';

import '../../../../core/domain/dashboard_domain_service.dart';
import '../../../../core/utils/dose_occurrence_utils.dart';
import '../../../../shared/theme/app_text_styles.dart';

/// A dose occurrence card with a "Take" button for quick logging.
class DoseCard extends StatelessWidget {
  const DoseCard({
    required this.dose,
    required this.onTake,
    super.key,
    this.isTaking = false,
  });

  final ScheduledDose dose;
  final VoidCallback onTake;
  final bool isTaking;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final med = dose.medication;
    final isTaken = dose.isTaken;
    final time = formatTimeOfDay(dose.scheduledTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Time
          SizedBox(
            width: 56,
            child: Text(
              time,
              style: AppTextStyles.bodySmall.copyWith(
                color: isTaken
                    ? scheme.onSurfaceVariant.withValues(alpha: 0.5)
                    : scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Medication info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isTaken
                        ? scheme.onSurfaceVariant.withValues(alpha: 0.5)
                        : scheme.onSurface,
                    decoration:
                        isTaken ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '${med.dosageAmount} ${med.dosageUnit}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Take button or checkmark
          if (isTaken)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 16,
                color: scheme.onPrimaryContainer,
              ),
            )
          else
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: isTaking ? null : onTake,
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 0,
                ),
                child: isTaking
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Text(
                        'Take',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
