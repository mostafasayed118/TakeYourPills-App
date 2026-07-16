import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../data/repositories/medication_repository.dart';
import '../../../shared/components/app_button.dart';
import '../../../shared/components/app_input.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/services/reminder_scheduler_service.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'cubit/medication_form_cubit.dart';
import 'widgets/dosage_unit_dropdown.dart';
import 'widgets/frequency_days_selector.dart';
import 'widgets/frequency_dropdown.dart';
import 'widgets/schedule_time_picker.dart';
import 'widgets/section_header.dart';

class AddEditMedicationPage extends StatelessWidget {

  const AddEditMedicationPage({
    super.key,
    this.isEditing = false,
    this.medicationId,
  });
  final bool isEditing;
  final String? medicationId;

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => MedicationFormCubit(
        repository: context.read<MedicationRepository>(),
        scheduler: GetIt.instance<ReminderSchedulerService>(),
        isEditing: isEditing,
        existingMedId: medicationId != null
            ? int.tryParse(medicationId!)
            : null,
      ),
      child: _AddEditMedicationView(isEditing: isEditing),
    );
}

class _AddEditMedicationView extends StatelessWidget {

  const _AddEditMedicationView({required this.isEditing});
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<MedicationFormCubit, MedicationFormState>(
      listener: (context, state) {
        if (state is MedicationFormSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          safePop(context, AppRoutes.medications);
        } else if (state is MedicationFormError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Medication' : 'Add Medication'),
          backgroundColor: colorScheme.surface,
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
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: AppTextStyles.headlineMedium.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            AppButton(
              text: 'Go Back',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, MedicationFormEditing state) {
    final cubit = context.read<MedicationFormCubit>();
    final colorScheme = Theme.of(context).colorScheme;

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
            FrequencyDaysSelector(
              initialDays: state.frequencyDays,
              onChanged: cubit.updateFrequencyDays,
            ),
            const SizedBox(height: 16),
          ],
          ScheduleTimePicker(
            initialTimes: state.scheduleTimes,
            onChanged: cubit.updateScheduleTimes,
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
                  keyboardType: TextInputType.number,
                  onChanged: (v) => cubit.updatePillsRemaining(int.tryParse(v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppInput(
                  label: 'Refill Alert At',
                  hint: '10',
                  value: state.refillThreshold?.toString() ?? '',
                  keyboardType: TextInputType.number,
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
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (state.validationError != null)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 20,
                    color: colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.validationError!,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: colorScheme.onErrorContainer,
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
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
