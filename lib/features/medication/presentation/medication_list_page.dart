import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/core/entities/medication.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/cubit/medication_list_cubit.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/medication_card.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/medication_list_error_view.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/widgets/medication_list_empty_view.dart';

/// Displays the user's medication list with real data from Drift.
class MedicationListPage extends StatelessWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MedicationListCubit(context.read<MedicationRepository>())
            ..loadMedications(),
      child: const MedicationListView(),
    );
  }
}

class MedicationListView extends StatelessWidget {
  const MedicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MedicationListCubit, MedicationListState>(
      listener: _handleStateChanges,
      child: const Scaffold(
        appBar: MedicationListAppBar(),
        floatingActionButton: MedicationListFab(),
        body: MedicationListBody(),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, MedicationListState state) {
    if (state is MedicationListError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

class MedicationListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MedicationListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Medications'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MedicationListFab extends StatelessWidget {
  const MedicationListFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToAddMedication(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      icon: const Icon(Icons.add),
      label: const Text('Add'),
    );
  }

  Future<void> _navigateToAddMedication(BuildContext context) async {
    await context.push('/add-medication/new');
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }
}

class MedicationListBody extends StatelessWidget {
  const MedicationListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicationListCubit, MedicationListState>(
      builder: (context, state) {
        return switch (state) {
          MedicationListLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          MedicationListInitial() => const Center(
            child: CircularProgressIndicator(),
          ),
          MedicationListError(:final message) => MedicationListErrorView(
            message: message,
            onRetry: () =>
                context.read<MedicationListCubit>().loadMedications(),
          ),
          MedicationListEmpty() => MedicationListEmptyView(
            onAddPressed: () => _navigateToAddMedication(context),
          ),
          MedicationListLoaded(:final medications) => MedicationListContent(
            medications: medications,
          ),
          MedicationListState() => const SizedBox.shrink(),
        };
      },
    );
  }

  Future<void> _navigateToAddMedication(BuildContext context) async {
    await context.push('/add-medication/new');
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }
}

class MedicationListContent extends StatelessWidget {
  final List<Medication> medications;

  const MedicationListContent({required this.medications, super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<MedicationListCubit>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return MedicationCard(
            medication: medication,
            onTap: () => _handleTap(context, medication),
            onEdit: () => _handleEdit(context, medication),
            onPauseChanged: (isPaused) => context
                .read<MedicationListCubit>()
                .pauseMedication(medication.id, isPaused),
            onDelete: () => _confirmDelete(context, medication),
          );
        },
      ),
    );
  }

  Future<void> _handleTap(BuildContext context, Medication medication) async {
    await context.push('/medication/${medication.id}');
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }

  Future<void> _handleEdit(BuildContext context, Medication medication) async {
    await context.push('/add-medication/${medication.id}');
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }

  void _confirmDelete(BuildContext context, Medication medication) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medication'),
        content: Text(
          'Are you sure you want to delete "${medication.name}"?\n'
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
              context.read<MedicationListCubit>().deleteMedication(
                medication.id,
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
