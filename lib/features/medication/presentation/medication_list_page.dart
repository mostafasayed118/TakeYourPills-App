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
import 'package:takeyourpills_healthcare_app/shared/components/empty_state_widget.dart';

class MedicationListPage extends StatelessWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MedicationListCubit(context.read())..loadMedications(),
      child: const MedicationListView(),
    );
  }
}

class MedicationListView extends StatelessWidget {
  const MedicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationListCubit, MedicationListState>(
      listener: (context, state) {
        if (state is MedicationListError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Medications'),
          backgroundColor: AppColors.surface,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                // Navigate to add page, passing no medId means create new
                context.go('/add-medication/new');
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: BlocBuilder<MedicationListCubit, MedicationListState>(
          builder: (context, state) {
            if (state is MedicationListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MedicationListError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 60, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      text: 'Retry',
                      onPressed: () =>
                          context.read<MedicationListCubit>().loadMedications(),
                      isPrimary: true,
                    ),
                  ],
                ),
              );
            }
            if (state is MedicationListEmpty) {
              return EmptyStateWidget(
                title: 'No medications yet',
                subtitle: 'Add your first medication to get started',
                icon: const Icon(
                  Icons.medication,
                  size: 80,
                  color: AppColors.surfaceContainerHigh,
                ),
                actionLabel: 'Add Medication',
                onAction: () => context.go('/add-medication/new'),
              );
            }
            if (state is MedicationListLoaded) {
              return _buildMedicationList(context, state.medications);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMedicationList(
    BuildContext context,
    List<Medication> medications,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<MedicationListCubit>().refresh(),
      child: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final med = medications[index];
          return _buildMedicationCard(context, med);
        },
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medication med) {
    final isPaused = med.isPaused;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/medication-details/${med.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
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
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med.name, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${med.dosageAmount} ${med.dosageUnit}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${med.scheduleTimes} • ${med.frequencyType}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (isPaused)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'PAUSED',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 9,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    if (med.pillsRemaining != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${med.pillsRemaining} pills remaining',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.onSurfaceVariant,
                ),
                onSelected: (value) => _handleMenuAction(context, med, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: med.isPaused ? 'resume' : 'pause',
                    child: Text(med.isPaused ? 'Resume' : 'Pause'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, Medication med, String value) {
    final cubit = context.read<MedicationListCubit>();
    switch (value) {
      case 'edit':
        context.go('/add-medication/${med.id}');
        break;
      case 'pause':
        cubit.pauseMedication(med.id, true);
        break;
      case 'resume':
        cubit.pauseMedication(med.id, false);
        break;
      case 'delete':
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Medication'),
            content: Text(
              'Are you sure you want to delete ${med.name}? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cubit.deleteMedication(med.id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        );
        break;
    }
  }
}
