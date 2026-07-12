import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'data/repositories/medication_repository_impl.dart';
import 'shared/routing/app_router.dart';
import 'shared/theme/app_theme.dart';

class TakeYourPillsApp extends StatelessWidget {
  const TakeYourPillsApp({super.key});

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<MedicationRepository>(
        create: (_) => getIt<MedicationRepository>(),
      ),
    ],
    child: Builder(
      builder: (context) => MaterialApp.router(
        title: 'TakeYourPills',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        ),
      ),
    ),
  );
}
