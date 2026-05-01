import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/components/empty_state_widget.dart';

class MedicationListEmptyView extends StatelessWidget {
  final VoidCallback onAddPressed;

  const MedicationListEmptyView({required this.onAddPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      title: 'No medications yet',
      subtitle: 'Add your first medication to start tracking your doses',
      icon: const Icon(Icons.medication_outlined, size: 80, color: Colors.grey),
      actionLabel: 'Add Medication',
      onAction: onAddPressed,
    );
  }
}
