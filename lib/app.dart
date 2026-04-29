import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takeyourpills_healthcare_app/core/di/service_locator.dart';
import 'package:takeyourpills_healthcare_app/data/repositories/medication_repository_impl.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_theme.dart';
import 'package:takeyourpills_healthcare_app/shared/routing/app_router.dart';

class TakeYourPillsApp extends StatelessWidget {
  const TakeYourPillsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MedicationRepository>(
          create: (_) => getIt<MedicationRepository>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.router;
          return MaterialApp.router(
            title: 'TakeYourPills',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: router,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.noScaling,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
