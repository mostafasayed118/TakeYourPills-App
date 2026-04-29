import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_state.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';

class MedicationDetailPage extends StatelessWidget {
  final int medicationId;

  const MedicationDetailPage({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    // This page needs medication data. We have two options:
    // 1. Accept full Medication as constructor param (requires router to pass data)
    // 2. Load via MedicationListCubit using medicationId
    // Using option 2 for proper integration with state management
    return BlocBuilder<MedicationListCubit, MedicationListState>(
      builder: (context, state) {
        if (state is MedicationListLoaded) {
          try {
            final medication = state.medications.firstWhere(
              (m) => m.id == medicationId,
            );
            return _buildDetailScaffold(context, medication);
          } catch (e) {
            return _buildNotFound(context);
          }
        }
        // Loading or error
        return Scaffold(
          appBar: AppBar(
            title: const Text('Medication Details'),
            backgroundColor: AppColors.surface,
            scrolledUnderElevation: 0,
          ),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Not Found'),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Medication not found', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            AppButton(
              text: 'Back to List',
              onPressed: () => context.go('/medications'),
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailScaffold(BuildContext context, Medication medication) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/add-medication/${medication.id}'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(medication),
            const SizedBox(height: 24),
            _buildInfoCard(medication),
            const SizedBox(height: 16),
            _buildScheduleCard(medication),
            const SizedBox(height: 16),
            _buildInstructionsCard(medication),
            if (medication.pillsRemaining != null) ...[
              const SizedBox(height: 16),
              _buildRefillCard(medication),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Medication medication) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: medication.isPaused
                ? AppColors.surfaceContainerLow
                : AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.medication,
            size: 40,
            color: medication.isPaused
                ? AppColors.onSurfaceVariant
                : AppColors.onSecondaryContainer,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(medication.name, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text(
                '${medication.dosageAmount} ${medication.dosageUnit}',
                style: AppTextStyles.bodyMedium,
              ),
              if (medication.isPaused)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'PAUSED',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Medication medication) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Basic Info', style: AppTextStyles.titleSmall),
          const SizedBox(height: 16),
          _buildInfoRow('Frequency', medication.frequencyType),
          _buildInfoRow('Schedule', medication.scheduleTimes),
          if (medication.startDate != null)
            _buildInfoRow('Start Date', medication.startDate!),
          if (medication.endDate != null)
            _buildInfoRow('End Date', medication.endDate!),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(Medication medication) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule', style: AppTextStyles.titleSmall),
          const SizedBox(height: 16),
          Text(medication.scheduleTimes, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          Text(
            '(Times in 24-hour format)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard(Medication medication) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Instructions', style: AppTextStyles.titleSmall),
          const SizedBox(height: 16),
          if (medication.instructions != null &&
              medication.instructions!.isNotEmpty)
            Text(medication.instructions!, style: AppTextStyles.bodyMedium)
          else
            Text(
              'No instructions provided',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRefillCard(Medication medication) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Inventory', style: AppTextStyles.titleSmall),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Remaining',
                  '${medication.pillsRemaining}',
                  'pills',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Refill At',
                  medication.refillThreshold != null
                      ? '${medication.refillThreshold}'
                      : '—',
                  'pills',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.headlineMedium),
          Text(
            unit,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
