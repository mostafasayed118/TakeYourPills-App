import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/components/empty_state_widget.dart';

/// Displays the user's medication list with real data from Drift.
class MedicationListPage extends StatelessWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicationListCubit(
        context.read<MedicationRepository>(),
      )..loadMedications(),
      child: const _MedicationListView(),
    );
  }
}

class _MedicationListView extends StatelessWidget {
  const _MedicationListView();

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
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await context.push('/add-medication/new');
            // Reload after returning from add screen
            if (context.mounted) {
              context.read<MedicationListCubit>().loadMedications();
            }
          },
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          icon: const Icon(Icons.add),
          label: const Text('Add'),
        ),
        body: BlocBuilder<MedicationListCubit, MedicationListState>(
          builder: (context, state) {
            if (state is MedicationListLoading ||
                state is MedicationListInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MedicationListError) {
              return _buildErrorState(context, state.message);
            }
            if (state is MedicationListEmpty) {
              return EmptyStateWidget(
                title: 'No medications yet',
                subtitle:
                    'Add your first medication to start tracking your doses',
                icon: const Icon(
                  Icons.medication_outlined,
                  size: 80,
                  color: AppColors.surfaceContainerHigh,
                ),
                actionLabel: 'Add Medication',
                onAction: () async {
                  await context.push('/add-medication/new');
                  if (context.mounted) {
                    context.read<MedicationListCubit>().loadMedications();
                  }
                },
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              child: AppButton(
                text: 'Retry',
                onPressed: () =>
                    context.read<MedicationListCubit>().loadMedications(),
                isPrimary: true,
              ),
            ),
          ],
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
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          return _MedicationCard(
            medication: medications[index],
            onTap: () async {
              await context.push(
                '/medication/${medications[index].id}',
              );
              if (context.mounted) {
                context.read<MedicationListCubit>().loadMedications();
              }
            },
            onEdit: () async {
              await context.push(
                '/add-medication/${medications[index].id}',
              );
              if (context.mounted) {
                context.read<MedicationListCubit>().loadMedications();
              }
            },
            onPause: (isPaused) => context
                .read<MedicationListCubit>()
                .pauseMedication(medications[index].id, isPaused),
            onDelete: () => _confirmDelete(
              context,
              medications[index],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, Medication med) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text(
          'Are you sure you want to delete "${med.name}"?\n'
          'This will also remove all associated schedules and logs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MedicationListCubit>().deleteMedication(med.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual medication card with premium design.
class _MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final void Function(bool) onPause;
  final VoidCallback onDelete;

  const _MedicationCard({
    required this.medication,
    required this.onTap,
    required this.onEdit,
    required this.onPause,
    required this.onDelete,
  });

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
              // Icon
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
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication.name,
                      style: AppTextStyles.titleSmall.copyWith(
                        color: isPaused
                            ? AppColors.onSurfaceVariant
                            : AppColors.onSurface,
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
                    if (isPaused) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                    ],
                    if (medication.pillsRemaining != null) ...[
                      const SizedBox(height: 4),
                      _buildPillsIndicator(),
                    ],
                  ],
                ),
              ),
              // Menu
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppColors.onSurfaceVariant,
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'pause':
                      onPause(true);
                    case 'resume':
                      onPause(false);
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(
                    value: medication.isPaused ? 'resume' : 'pause',
                    child:
                        Text(medication.isPaused ? 'Resume' : 'Pause'),
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

  String _formatFrequency(String type) {
    switch (type) {
      case 'daily':
        return 'Every day';
      case 'weekly':
        return 'Weekly';
      case 'as_needed':
        return 'As needed';
      case 'specific_days':
        return 'Specific days';
      default:
        return type;
    }
  }
}
