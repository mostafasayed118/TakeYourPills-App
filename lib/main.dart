import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/app.dart';
import 'package:takeyourpills_healthcare_app/core/di/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const TakeYourPillsApp());
}
