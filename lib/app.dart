import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/domain/dashboard_domain_service.dart';
import 'data/repositories/medication_repository.dart';
import 'features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'shared/routing/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_controller.dart';

class TakeYourPillsApp extends StatefulWidget {
  const TakeYourPillsApp({super.key});

  @override
  State<TakeYourPillsApp> createState() => _TakeYourPillsAppState();
}

class _TakeYourPillsAppState extends State<TakeYourPillsApp> {
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _themeController = getIt<ThemeController>();
    _themeController.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = getIt<MedicationRepository>();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MedicationRepository>.value(value: repository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DashboardCubit>(
            create: (_) => DashboardCubit(
              repository: repository,
              domainService: DashboardDomainService(),
            )..watchMedications(),
          ),
        ],
        child: MaterialApp.router(
          title: 'TakeYourPills',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.mode,
          routerConfig: AppRouter.router,
          builder: (context, child) {
            final media = MediaQuery.of(context);
            final scale = media.textScaler.scale(1).clamp(0.85, 1.4);
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
