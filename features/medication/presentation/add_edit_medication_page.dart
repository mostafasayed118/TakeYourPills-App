import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_state.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';

class AddEditMedicationPage extends StatelessWidget {
  final bool isEditing;
  final String? medicationId;

  const AddEditMedicationPage({
    super.key,
    this.isEditing = false,
    this.medicationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicationFormCubit(
        repository: context.read(),
        isEditing: isEditing,
        existingMedId: medicationId != null ? int.tryParse(medicationId!) : null,
      ),
      child: const AddEditMedicationView(),
    );
  }
}

class AddEditMedicationView extends StatelessWidget {
  const AddEditMedicationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationFormCubit, MedicationFormState>(
      listener: (context, state) {
        if (state is MedicationFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.primary),
          );
          context.pop();
        } else if (state is MedicationFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Medication'),
          backgroundColor: AppColors.surface,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<MedicationFormCubit, MedicationFormState>(
          builder: (context, state) {
            if (state is! MedicationFormEditing) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildForm(context, state);
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MedicationFormEditing state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Medication Details', style: AppTextStyles.headlineMedium),
          const SizedBox(height: 20),

          _buildSectionHeader('Medication Name'),
          AppInput(
            label: 'Name',
            hint: 'e.g., Lisinopril',
            onChanged: (v) => context.read<MedicationFormCubit>().updateName(v),
            value: state.name,
          ),
          const SizedBox(height: 16),

          _buildSectionHeader('Dosage'),
          Row(children: [
            Expanded(
              child: AppInput(
                label: 'Amount',
                hint: '10',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => context.read<MedicationFormCubit>().updateDosageAmount(v),
                value: state.dosageAmount,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppInput(
                label: 'Unit',
                hint: 'mg',
                onChanged: (v) => context.read<MedicationFormCubit>().updateDosageUnit(v),
                value: state.dosageUnit,
              ),
            ),
          ]),
          const SizedBox(height: 16),

          _buildSectionHeader('Schedule Times'),
          AppInput(
            label: 'Times (HH:MM, comma-separated)',
            hint: '08:00, 20:00',
            onChanged: (v) => context.read<MedicationFormCubit>().updateScheduleTimes(v),
            value: state.scheduleTimes,
          ),
          const SizedBox(height: 8),
          Text('Example: 08:00, 14:00, 20:00',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 16),

          AppInput(
            label: 'Frequency',
            hint: 'daily, weekly, as_needed, specific_days',
            onChanged: (v) => context.read<MedicationFormCubit>().updateFrequencyType(v),
            value: state.frequencyType,
          ),
          const SizedBox(height: 16),

          if (state.frequencyType == 'specific_days')
            AppInput(
              label: 'Days (0=Mon,6=Sun), e.g., [0,2,4]',
              onChanged: (v) => context.read<MedicationFormCubit>().updateFrequencyDays(v),
              value: state.frequencyDays,
            ),
          if (state.frequencyType == 'specific_days') const SizedBox(height: 16),

          _buildSectionHeader('Optional'),
          AppInput(
            label: 'Instructions',
            hint: 'Take with food',
            onChanged: (v) => context.read<MedicationFormCubit>().updateInstructions(v),
            value: state.instructions ?? '',
          ),
          const SizedBox(height: 16),

          Row(children: [
            Expanded(
              child: AppInput(
                label: 'Pills Remaining',
                hint: '30',
                keyboardType: const TextInputType.numberWithOptions(),
                onChanged: (v) => context.read<MedicationFormCubit>().updatePillsRemaining(int.tryParse(v)),
                value: state.pillsRemaining?.toString() ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppInput(
                label: 'Refill Alert At',
                hint: '10',
                keyboardType: const TextInputType.numberWithOptions(),
                onChanged: (v) => context.read<MedicationFormCubit>().updateRefillThreshold(int.tryParse(v)),
                value: state.refillThreshold?.toString() ?? '',
              ),
            ),
          ]),
          const SizedBox(height: 8),
          Text('Leave pills field empty to disable tracking',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 24),

          if (state.validationError != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, size: 20, color: AppColors.onErrorContainer),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(state.validationError!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.onErrorContainer)),
                  ),
                ],
              ),
            ),

          AppButton(
            text: state.isSaving ? 'Saving...' : 'Save Medication',
            onPressed: state.isSaving ? null : () => context.read<MedicationFormCubit>().saveMedication(),
            isLoading: state.isSaving,
            isPrimary: true,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
    );
  }
}
