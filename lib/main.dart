import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/app.dart';
import 'package:takeyourpills_healthcare_app/core/di/service_locator.dart';
import 'package:takeyourpills_healthcare_app/shared/services/preference_service.dart';
import 'package:takeyourpills_healthcare_app/shared/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<PreferenceService>().init();
  await getIt<NotificationService>().init();
  runApp(const TakeYourPillsApp());
}
