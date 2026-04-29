import 'package:get_it/get_it.dart';

import 'package:takeyourpills_healthcare_app/data/database/app_database.dart';
import 'package:takeyourpills_healthcare_app/data/datasources/medication_local_datasource.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/services/preference_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/reminder_scheduler_impl.dart';

final getIt = GetIt.instance;

/// Register all dependencies for the application.
///
/// Called once from main() before runApp().
void setupServiceLocator() {
  // Database (singleton — single connection for the whole app lifecycle)
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Datasources
  getIt.registerLazySingleton<MedicationLocalDatasource>(
    () => MedicationLocalDatasource(getIt<AppDatabase>()),
  );

  // Repositories (register both abstract and concrete for flexibility)
  getIt.registerLazySingleton<MedicationRepositoryImpl>(
    () => MedicationRepositoryImpl(getIt<MedicationLocalDatasource>()),
  );
  getIt.registerLazySingleton<MedicationRepository>(
    () => getIt<MedicationRepositoryImpl>(),
  );

  // Services
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationServiceImpl(),
  );
  getIt.registerLazySingleton<ReminderSchedulerService>(
    () => ReminderSchedulerImpl(
      notificationService: getIt<NotificationService>(),
    ),
  );
  getIt.registerLazySingleton<PreferenceService>(() => PreferenceServiceImpl());
}
