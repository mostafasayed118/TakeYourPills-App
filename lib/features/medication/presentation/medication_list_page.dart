import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../core/entities/medication.dart';
import '../../../data/repositories/medication_repository.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/services/reminder_scheduler_service.dart';
import '../../../shared/theme/app_text_styles.dart';
import 'cubit/medication_list_cubit.dart';
import 'widgets/medication_card.dart';
import 'widgets/medication_list_empty_view.dart';
import 'widgets/medication_list_error_view.dart';

/// Displays the user's medication list with search, filter, and sort.
class MedicationListPage extends StatelessWidget {
  const MedicationListPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
      create: (context) => MedicationListCubit(
        context.read<MedicationRepository>(),
        scheduler: GetIt.instance<ReminderSchedulerService>(),
      )..loadMedications(),
      child: const MedicationListView(),
    );
}

class MedicationListView extends StatelessWidget {
  const MedicationListView({super.key});

  @override
  Widget build(BuildContext context) => BlocListener<MedicationListCubit, MedicationListState>(
      listener: _handleStateChanges,
      child: Scaffold(
        appBar: const MedicationListAppBar(),
        floatingActionButton: const MedicationListFab(),
        body: const MedicationListBody(),
      ),
    );

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
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      title: const Text('My Medications'),
      backgroundColor: scheme.surface,
      scrolledUnderElevation: 0,
      actions: [
        PopupMenuButton<MedicationSort>(
          icon: const Icon(Icons.sort),
          tooltip: 'Sort',
          onSelected: (sort) =>
              context.read<MedicationListCubit>().updateSort(sort),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: MedicationSort.recentlyAdded,
              child: Text('Recently added'),
            ),
            const PopupMenuItem(
              value: MedicationSort.name,
              child: Text('Name A-Z'),
            ),
            const PopupMenuItem(
              value: MedicationSort.nextDose,
              child: Text('Next dose'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class MedicationListFab extends StatelessWidget {
  const MedicationListFab({super.key});

  @override
  Widget build(BuildContext context) => FloatingActionButton.extended(
      onPressed: () => _navigateToAddMedication(context),
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      icon: const Icon(Icons.add),
      label: const Text('Add'),
    );

  Future<void> _navigateToAddMedication(BuildContext context) async {
    await context.push(AppRoutes.addMedicationForId('new'));
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }
}

class MedicationListBody extends StatefulWidget {
  const MedicationListBody({super.key});

  @override
  State<MedicationListBody> createState() => _MedicationListBodyState();
}

class _MedicationListBodyState extends State<MedicationListBody> {
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // ── Search bar ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _showSearch
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (q) =>
                          context.read<MedicationListCubit>().updateSearch(q),
                      decoration: InputDecoration(
                        hintText: 'Search medications...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            context
                                .read<MedicationListCubit>()
                                .updateSearch('');
                            setState(() => _showSearch = false);
                          },
                        ),
                        filled: true,
                        fillColor: scheme.surfaceContainerLow,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),

        // ── Filter chips ───────────────────────────────────────────
        BlocBuilder<MedicationListCubit, MedicationListState>(
          buildWhen: (prev, curr) =>
              curr is MedicationListLoaded &&
              (prev is! MedicationListLoaded || prev.filter != curr.filter),
          builder: (context, state) {
            final currentFilter = state is MedicationListLoaded
                ? state.filter
                : MedicationFilter.all;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _showSearch ? Icons.search_off : Icons.search,
                      size: 20,
                    ),
                    tooltip: _showSearch ? 'Close search' : 'Search',
                    onPressed: () {
                      setState(() => _showSearch = !_showSearch);
                      if (!_showSearch) {
                        _searchController.clear();
                        context
                            .read<MedicationListCubit>()
                            .updateSearch('');
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  _FilterChip(
                    label: 'All',
                    isSelected: currentFilter == MedicationFilter.all,
                    onTap: () => context
                        .read<MedicationListCubit>()
                        .updateFilter(MedicationFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Active',
                    isSelected: currentFilter == MedicationFilter.active,
                    onTap: () => context
                        .read<MedicationListCubit>()
                        .updateFilter(MedicationFilter.active),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Paused',
                    isSelected: currentFilter == MedicationFilter.paused,
                    onTap: () => context
                        .read<MedicationListCubit>()
                        .updateFilter(MedicationFilter.paused),
                  ),
                ],
              ),
            );
          },
        ),

        // ── List ───────────────────────────────────────────────────
        Expanded(
          child: BlocBuilder<MedicationListCubit, MedicationListState>(
            builder: (context, state) => switch (state) {
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
              MedicationListLoaded(:final filteredMedications) =>
                filteredMedications.isEmpty
                    ? Center(
                        child: Text(
                          'No medications match your filter',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : _MedicationList(medications: filteredMedications),
              MedicationListState() => const SizedBox.shrink(),
            },
          ),
        ),
      ],
    );
  }

  Future<void> _navigateToAddMedication(BuildContext context) async {
    await context.push(AppRoutes.addMedicationForId('new'));
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }
}

class _MedicationList extends StatelessWidget {
  const _MedicationList({required this.medications});

  final List<Medication> medications;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
      onRefresh: () => context.read<MedicationListCubit>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return _SwipeToDelete(
            medication: medication,
            child: MedicationCard(
              medication: medication,
              onTap: () => _handleTap(context, medication),
              onEdit: () => _handleEdit(context, medication),
              onPauseChanged: (isPaused) => context
                  .read<MedicationListCubit>()
                  .pauseMedication(medication.id, isPaused),
              onDelete: () => _confirmDelete(context, medication),
            ),
          );
        },
      ),
    );

  Future<void> _handleTap(BuildContext context, Medication medication) async {
    await context.push(AppRoutes.medicationById(medication.id));
    if (context.mounted) {
      context.read<MedicationListCubit>().loadMedications();
    }
  }

  Future<void> _handleEdit(
      BuildContext context, Medication medication) async {
    await context.push(AppRoutes.addMedicationForId('${medication.id}'));
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
              context
                  .read<MedicationListCubit>()
                  .deleteMedication(medication.id);
            },
            child: Text(
              'Delete',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

/// Swipe-to-delete wrapper for medication cards.
class _SwipeToDelete extends StatelessWidget {
  const _SwipeToDelete({required this.medication, required this.child});

  final Medication medication;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey('med_${medication.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Icons.delete_outline,
          color: scheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete Medication'),
            content: Text(
              'Delete "${medication.name}"?\n'
              'This will remove all schedules and logs.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: scheme.error),
                ),
              ),
            ],
          ),
        );
        return confirmed ?? false;
      },
      onDismissed: (_) {
        context.read<MedicationListCubit>().deleteMedication(medication.id);
      },
      child: child,
    );
  }
}

/// Filter chip widget.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: scheme.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
