import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/core/utils/schedule_parser.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_detail_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/detail/widgets/detail_card.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/detail/widgets/info_row.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/detail/widgets/stat_chip.dart';
import 'package:takeyourpills_healthcare_app/shared/components/app_button.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class MedicationDetailPage extends StatelessWidget {
  final int medicationId;

  const MedicationDetailPage({super.key, required this.medicationId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicationDetailCubit(
        repository: context.read<MedicationRepository>(),
        medicationId: medicationId,
      ),
      child: const _MedicationDetailView(),
    );
  }
}

class _MedicationDetailView extends StatelessWidget {
  const _MedicationDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationDetailCubit, MedicationDetailState>(
      listener: (context, state) {
        if (state is MedicationDetailDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medication deleted'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop();
        }
      },
      child: BlocBuilder<MedicationDetailCubit, MedicationDetailState>(
        builder: (context, state) {
          if (state is MedicationDetailLoading) {
            return _buildScaffold(
              context,
              const Center(child: CircularProgressIndicator()),
            );
          }
          if (state is MedicationDetailError) {
            return _buildErrorScreen(context, state.message);
          }
          if (state is MedicationDetailLoaded) {
            return _buildDetailScreen(context, state.medication);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, Widget body) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: body,
    );
  }

  Widget _buildErrorScreen(BuildContext context, String message) {
    return _buildScaffold(
      context,
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 160,
                child: AppButton(
                  text: 'Go Back',
                  onPressed: () => context.pop(),
                  isPrimary: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailScreen(BuildContext context, Medication medication) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Details'),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () async {
              await context.push('/add-medication/${medication.id}');
              if (context.mounted) {
                context.read<MedicationDetailCubit>().loadMedication();
              }
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'toggle_pause':
                  context.read<MedicationDetailCubit>().togglePause();
                case 'delete':
                  _confirmDelete(context, medication);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'toggle_pause',
                child: Text(medication.isPaused ? 'Resume' : 'Pause'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: AppColors.error)),
              ),
            ],
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
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Medication medication) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text(
          'Are you sure you want to delete "${medication.name}"?\n\n'
          'This will permanently remove the medication and all '
          'associated schedules and dose logs.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<MedicationDetailCubit>().deleteMedication();
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

  Widget _buildHeader(Medication medication) {
    final isPaused = medication.isPaused;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isPaused
                ? AppColors.surfaceContainerLow
                : AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.medication,
            size: 40,
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
              Text(medication.name, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text(
                '${medication.dosageAmount} ${medication.dosageUnit}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              if (isPaused) ...[
                const SizedBox(height: 6),
                Container(
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
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Medication medication) {
    return DetailCard(
      title: 'Basic Info',
      children: [
        InfoRow(
          label: 'Frequency',
          value: _formatFrequency(medication.frequencyType),
        ),
        if (medication.startDate != null)
          InfoRow(label: 'Start Date', value: medication.startDate!),
        if (medication.endDate != null)
          InfoRow(label: 'End Date', value: medication.endDate!)
        else
          const InfoRow(label: 'Duration', value: 'Ongoing'),
      ],
    );
  }

  Widget _buildScheduleCard(Medication medication) {
    final times = parseScheduleTimes(medication.scheduleTimes)
        .map(
          (t) =>
              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
        )
        .toList();

    return DetailCard(
      title: 'Schedule Times',
      children: [
        if (times.isEmpty)
          Text(
            'No times configured',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: times.map((time) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  time,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildInstructionsCard(Medication medication) {
    final hasInstructions =
        medication.instructions != null && medication.instructions!.isNotEmpty;

    return DetailCard(
      title: 'Instructions',
      children: [
        Text(
          hasInstructions
              ? medication.instructions!
              : 'No instructions provided',
          style: hasInstructions
              ? AppTextStyles.bodyMedium
              : AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
        ),
      ],
    );
  }

  Widget _buildRefillCard(Medication medication) {
    final remaining = medication.pillsRemaining!;
    final threshold = medication.refillThreshold ?? 0;
    final isLow = threshold > 0 && remaining <= threshold;

    return DetailCard(
      title: 'Inventory',
      children: [
        Row(
          children: [
            Expanded(
              child: StatChip(
                label: 'Remaining',
                value: '$remaining',
                unit: 'pills',
                isWarning: isLow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatChip(
                label: 'Refill At',
                value: threshold > 0 ? '$threshold' : '—',
                unit: 'pills',
                isWarning: false,
              ),
            ),
          ],
        ),
        if (isLow) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.onErrorContainer,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Running low — consider refilling soon',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
