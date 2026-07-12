import 'package:flutter/material.dart';
import '../../../../shared/components/empty_state_widget.dart';

class MedicationListEmptyView extends StatelessWidget {

  const MedicationListEmptyView({required this.onAddPressed, super.key});
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) => EmptyStateWidget(
      title: 'No medications yet',
      subtitle: 'Add your first medication to start tracking your doses',
      icon: const Icon(Icons.medication_outlined, size: 80, color: Colors.grey),
      actionLabel: 'Add Medication',
      onAction: onAddPressed,
    );
}
