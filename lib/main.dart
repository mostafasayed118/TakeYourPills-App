import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/service_locator.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/preference_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<PreferenceService>().init();
  await getIt<NotificationService>().init();
  runApp(const TakeYourPillsApp());
}
