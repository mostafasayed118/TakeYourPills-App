import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_form_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_input.dart';

/// Shared Add/Edit medication screen.
///
/// When [isEditing] is true and [medicationId] is provided,
/// loads the existing medication for editing. Otherwise creates new.
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
    final cubit = context.read<MedicationFormCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section: Medication Identity ─────────────────────
          _SectionHeader(title: 'Medication Details'),
          const SizedBox(height: 12),
          AppInput(
            label: 'Medication Name',
            hint: 'e.g., Lisinopril',
            value: state.name,
            onChanged: cubit.updateName,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),

          // ── Section: Dosage ──────────────────────────────────
          _SectionHeader(title: 'Dosage'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: AppInput(
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
                child: _DosageUnitDropdown(
                  value: state.dosageUnit,
                  onChanged: cubit.updateDosageUnit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Section: Schedule ────────────────────────────────
          _SectionHeader(title: 'Schedule'),
          const SizedBox(height: 12),
          _FrequencyDropdown(
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

          // ── Section: Optional Details ────────────────────────
          _SectionHeader(title: 'Additional Details'),
          const SizedBox(height: 12),
          AppInput(
            label: 'Instructions',
            hint: 'e.g., Take with food',
            value: state.instructions ?? '',
            onChanged: cubit.updateInstructions,
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Pills tracking
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

          // ── Validation Error ─────────────────────────────────
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

          // ── Save Button ──────────────────────────────────────
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

// ── Reusable sub-widgets ─────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.titleSmall.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DosageUnitDropdown extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;

  const _DosageUnitDropdown({required this.value, required this.onChanged});

  static const _units = [
    'mg',
    'ml',
    'g',
    'mcg',
    'IU',
    'tablet',
    'capsule',
    'drop',
    'patch',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _units.contains(value) ? value : _units.first,
              isExpanded: true,
              items: _units
                  .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              style: AppTextStyles.bodyMedium,
              dropdownColor: AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}

class _FrequencyDropdown extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;

  const _FrequencyDropdown({required this.value, required this.onChanged});

  static const _frequencies = {
    'daily': 'Every day',
    'weekly': 'Weekly',
    'specific_days': 'Specific days',
    'as_needed': 'As needed',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequency',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _frequencies.containsKey(value)
                  ? value
                  : _frequencies.keys.first,
              isExpanded: true,
              items: _frequencies.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
              style: AppTextStyles.bodyMedium,
              dropdownColor: AppColors.surface,
            ),
          ),
        ),
      ],
    );
  }
}
