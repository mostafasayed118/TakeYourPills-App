import 'package:get_it/get_it.dart';

import '../../data/database/app_database.dart';
import '../../data/datasources/medication_local_datasource.dart';
import '../../data/repositories/medication_repository_impl.dart';
import '../../shared/services/crash_reporting_service.dart';
import '../../shared/services/data_export_service.dart';
import '../../shared/services/device_reliability_service.dart';
import '../../shared/services/notification_service.dart';
import '../../shared/services/notification_service_impl.dart';
import '../../shared/services/preference_service.dart';
import '../../shared/services/reminder_scheduler_impl.dart';
import '../../shared/services/reminder_scheduler_service.dart';
import '../../shared/theme/theme_controller.dart';

final getIt = GetIt.instance;

/// Register all dependencies for the application.
///
/// Called once from main() before runApp().
void setupServiceLocator() {
  // Database (singleton — single connection for the whole app lifecycle)
  getIt
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    // Datasources
    ..registerLazySingleton<MedicationLocalDatasource>(
      () => MedicationLocalDatasource(getIt()),
    )
    // Repositories
    ..registerLazySingleton<MedicationRepository>(
      () => MedicationRepositoryImpl(getIt()),
    )
    // Services
    ..registerLazySingleton<PreferenceService>(PreferenceServiceImpl.new)
    ..registerLazySingleton<ThemeController>(
      () => ThemeController(getIt()),
    )
    ..registerLazySingleton<CrashReportingService>(
      createCrashReportingService,
    )
    ..registerLazySingleton<NotificationService>(NotificationServiceImpl.new)
    ..registerLazySingleton<ReminderSchedulerService>(
      () => ReminderSchedulerImpl(notificationService: getIt()),
    )
    ..registerLazySingleton<DeviceReliabilityService>(
      () => DeviceReliabilityService(notificationService: getIt()),
    )
    ..registerLazySingleton<DataExportService>(
      () => DataExportService(repository: getIt()),
    );
}
