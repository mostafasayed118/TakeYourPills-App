import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/dosage_unit_dropdown.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/frequency_dropdown.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/section_header.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

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
        repository: context.read<MedicationRepository>(),
        isEditing: isEditing,
        existingMedId: medicationId != null
            ? int.tryParse(medicationId!)
            : null,
      ),
      child: _AddEditMedicationView(isEditing: isEditing),
    );
  }
}

class _AddEditMedicationView extends StatelessWidget {
  final bool isEditing;

  const _AddEditMedicationView({required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationFormCubit, MedicationFormState>(
      listener: (context, state) {
        if (state is MedicationFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        } else if (state is MedicationFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Medication' : 'Add Medication'),
          backgroundColor: AppColors.surface,
          scrolledUnderElevation: 0,
        ),
        body: BlocBuilder<MedicationFormCubit, MedicationFormState>(
          builder: (context, state) {
            if (state is MedicationFormInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MedicationFormEditing) {
              return _buildForm(context, state);
            }
            if (state is MedicationFormError) {
              return _buildErrorView(context, state.message);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Go Back',
              onPressed: () => Navigator.of(context).pop(),
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MedicationFormEditing state) {
    final cubit = context.read<MedicationFormCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Medication Details'),
          const SizedBox(height: 12),
          AppInput(
            key: const Key('medication_name'),
            label: 'Medication Name',
            hint: 'e.g., Lisinopril',
            value: state.name,
            onChanged: cubit.updateName,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Dosage'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AppInput(
                  key: const Key('dosage_amount'),
                  label: 'Amount',
                  hint: '10',
                  value: state.dosageAmount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: cubit.updateDosageAmount,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DosageUnitDropdown(
                  value: state.dosageUnit,
                  onChanged: cubit.updateDosageUnit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Schedule'),
          const SizedBox(height: 12),
          FrequencyDropdown(
            value: state.frequencyType,
            onChanged: cubit.updateFrequencyType,
          ),
          const SizedBox(height: 16),
          if (state.frequencyType == 'specific_days') ...[
            AppInput(
              label: 'Days (0=Mon, 6=Sun)',
              hint: 'e.g., 0,2,4',
              value: state.frequencyDays == '[]' ? '' : state.frequencyDays,
              onChanged: cubit.updateFrequencyDays,
            ),
            const SizedBox(height: 16),
          ],
          AppInput(
            key: const Key('schedule_times'),
            label: 'Schedule Times',
            hint: '08:00, 14:00, 20:00',
            value: state.scheduleTimes,
            onChanged: cubit.updateScheduleTimes,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Enter times in 24h format, separated by commas',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Additional Details'),
          const SizedBox(height: 12),
          AppInput(
            label: 'Instructions',
            hint: 'e.g., Take with food',
            value: state.instructions ?? '',
            onChanged: cubit.updateInstructions,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppInput(
                  label: 'Pills Remaining',
                  hint: '30',
                  value: state.pillsRemaining?.toString() ?? '',
                  keyboardType: const TextInputType.numberWithOptions(),
                  onChanged: (v) => cubit.updatePillsRemaining(int.tryParse(v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppInput(
                  label: 'Refill Alert At',
                  hint: '10',
                  value: state.refillThreshold?.toString() ?? '',
                  keyboardType: const TextInputType.numberWithOptions(),
                  onChanged: (v) =>
                      cubit.updateRefillThreshold(int.tryParse(v)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              'Leave empty to disable pill tracking',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (state.validationError != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 20,
                    color: AppColors.onErrorContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.validationError!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          AppButton(
            text: isEditing ? 'Update Medication' : 'Save Medication',
            onPressed: state.isSaving ? null : cubit.saveMedication,
            isLoading: state.isSaving,
            isPrimary: true,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
