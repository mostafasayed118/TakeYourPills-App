import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/error/result.dart';
import '../../../../data/repositories/medication_repository.dart';
import '../../../../shared/services/data_export_service.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/preference_service.dart';
import '../../../../shared/services/reminder_scheduler_service.dart';

part 'data_management_state.dart';

class DataManagementCubit extends Cubit<DataManagementState> {
  DataManagementCubit({
    required DataExportService exportService,
    required MedicationRepository repository,
    required NotificationService notificationService,
    required ReminderSchedulerService scheduler,
    required PreferenceService preferenceService,
  })  : _exportService = exportService,
        _repository = repository,
        _notificationService = notificationService,
        _scheduler = scheduler,
        _preferenceService = preferenceService,
        super(const DataManagementInitial());

  final DataExportService _exportService;
  final MedicationRepository _repository;
  final NotificationService _notificationService;
  final ReminderSchedulerService _scheduler;
  final PreferenceService _preferenceService;

  Future<void> exportData() async {
    emit(const DataManagementBusy());
    try {
      final result = await _exportService.shareExport();
      final msg = switch (result.status) {
        ShareResultStatus.success => 'Export shared',
        ShareResultStatus.dismissed => 'Share sheet closed',
        ShareResultStatus.unavailable => 'Share is unavailable on this device',
      };
      emit(DataManagementSuccess(message: msg));
    } on Object catch (e) {
      emit(DataManagementError(message: 'Export failed: $e'));
    }
  }

  Future<void> clearAllMedications() async {
    emit(const DataManagementBusy());
    try {
      final listResult = await _repository.getAllMedications();
      final meds = listResult.getOrNull() ?? [];
      for (final med in meds) {
        await _scheduler.cancelAllForMedication(med.id);
        await _repository.deleteMedication(med.id);
      }
      await _notificationService.cancelAllNotifications();
      emit(const DataManagementSuccess(message: 'All medications deleted'));
    } on Object catch (e) {
      emit(DataManagementError(message: 'Failed to clear data: $e'));
    }
  }

  Future<void> resetPreferences() async {
    emit(const DataManagementBusy());
    try {
      await _preferenceService.clear();
      emit(const DataManagementSuccess(message: 'Preferences reset'));
    } on Object catch (e) {
      emit(DataManagementError(message: 'Failed to reset preferences: $e'));
    }
  }
}
