import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'data/repositories/medication_repository.dart';
import 'shared/services/crash_reporting_service.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/preference_service.dart';
import 'shared/services/reminder_scheduler_service.dart';
import 'shared/theme/theme_controller.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      setupServiceLocator();

      final crash = getIt<CrashReportingService>();
      await crash.init();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        unawaited(crash.recordFlutterError(details));
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        unawaited(crash.recordError(error, stack, fatal: true));
        return true;
      };

      // Preferences are required for routing; fail hard if they cannot load.
      await getIt<PreferenceService>().init();
      await getIt<ThemeController>().load();

      // Notifications are best-effort — app remains usable offline without them.
      try {
        await getIt<NotificationService>().init();
        await getIt<ReminderSchedulerService>().rebuildFromRepository(
          getIt<MedicationRepository>(),
        );
      } on Object catch (e, st) {
        await crash.recordError(e, st, context: 'notification_init');
      }

      runApp(const TakeYourPillsApp());
    },
    (error, stack) {
      // Zone may fire before DI is ready; fail soft.
      if (getIt.isRegistered<CrashReportingService>()) {
        unawaited(
          getIt<CrashReportingService>().recordError(
            error,
            stack,
            fatal: true,
            context: 'zone',
          ),
        );
      } else if (kDebugMode) {
        debugPrint('Zone error (pre-DI): $error\n$stack');
      }
    },
  );
}
