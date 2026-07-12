import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/service_locator.dart';
import '../../features/calendar/presentation/calendar_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/medication/presentation/add_edit_medication_page.dart';
import '../../features/medication/presentation/detail/medication_detail_page.dart';
import '../../features/medication/presentation/medication_list_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/progress/presentation/progress_page.dart';
import '../../features/settings/presentation/about_page.dart';
import '../../features/settings/presentation/appearance_settings_page.dart';
import '../../features/settings/presentation/data_management_page.dart';
import '../../features/settings/presentation/notification_settings_page.dart';
import '../../features/settings/presentation/privacy_settings_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../services/preference_service.dart';
import 'routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter get router => GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: AppRoutes.root,
      redirect: (context, state) async {
        final preferenceService = getIt<PreferenceService>();
        final onboardingComplete = await preferenceService
            .getOnboardingComplete();
        final isOnboardingRoute = state.matchedLocation == AppRoutes.onboarding;
        if (!onboardingComplete && !isOnboardingRoute) {
          return AppRoutes.onboarding;
        }
        if (onboardingComplete && isOnboardingRoute) {
          return AppRoutes.dashboard;
        }
        return null;
      },
      routes: [
        GoRoute(path: AppRoutes.root, redirect: (_, _) => AppRoutes.dashboard),
        GoRoute(
          path: AppRoutes.onboarding,
          name: 'onboarding',
          pageBuilder: (c, s) =>
              _fadeTransition(c: c, s: s, child: const OnboardingPage()),
        ),
        ShellRoute(
          builder: (c, s, child) => _MainScaffold(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              name: 'dashboard',
              pageBuilder: (c, s) =>
                  _fadeTransition(c: c, s: s, child: const DashboardPage()),
            ),
            GoRoute(
              path: AppRoutes.medications,
              name: 'medications',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const MedicationListPage(),
              ),
            ),
            GoRoute(
              path: '${AppRoutes.addMedication}/:medId',
              name: 'addMedication',
              pageBuilder: (c, s) {
                final medId = s.pathParameters['medId'];
                final isEditing = medId != null && medId != 'new';
                return _fadeTransition(
                  c: c,
                  s: s,
                  child: AddEditMedicationPage(
                    isEditing: isEditing,
                    medicationId: isEditing ? medId : null,
                  ),
                );
              },
            ),
            GoRoute(
              path: '/medication/:id',
              name: 'medicationDetail',
              pageBuilder: (c, s) {
                final medId = int.tryParse(s.pathParameters['id'] ?? '');
                if (medId == null) {
                  return _fadeTransition(
                    c: c,
                    s: s,
                    child: const Scaffold(
                      body: Center(child: Text('Medication not found')),
                    ),
                  );
                }
                return _fadeTransition(
                  c: c,
                  s: s,
                  child: MedicationDetailPage(medicationId: medId),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.calendar,
              name: 'calendar',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const CalendarPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              // History is folded into Progress for MVP.
              redirect: (_, _) => AppRoutes.progress,
            ),
            GoRoute(
              path: AppRoutes.progress,
              name: 'progress',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const ProgressPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              pageBuilder: (c, s) =>
                  _fadeTransition(c: c, s: s, child: const SettingsPage()),
            ),
            GoRoute(
              path: AppRoutes.settingsNotifications,
              name: 'settingsNotifications',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const NotificationSettingsPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.settingsAppearance,
              name: 'settingsAppearance',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const AppearanceSettingsPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.settingsPrivacy,
              name: 'settingsPrivacy',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const PrivacySettingsPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.settingsAbout,
              name: 'settingsAbout',
              pageBuilder: (c, s) =>
                  _fadeTransition(c: c, s: s, child: const AboutPage()),
            ),
            GoRoute(
              path: AppRoutes.settingsData,
              name: 'settingsData',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const DataManagementPage(),
              ),
            ),
            // Provider messaging is intentionally not shipped in MVP.
            GoRoute(
              path: AppRoutes.messaging,
              name: 'messaging',
              redirect: (_, _) => AppRoutes.settings,
            ),
            GoRoute(
              path: AppRoutes.conversation,
              name: 'conversation',
              redirect: (_, _) => AppRoutes.settings,
            ),
            GoRoute(
              path: AppRoutes.composer,
              name: 'composer',
              redirect: (_, _) => AppRoutes.settings,
            ),
          ],
        ),
      ],
      errorBuilder: (c, s) =>
          Scaffold(body: Center(child: Text('Page not found: ${s.error}'))),
    );

  static CustomTransitionPage _fadeTransition({
    required BuildContext c,
    required GoRouterState s,
    required Widget child,
  }) => CustomTransitionPage(
      key: s.pageKey,
      child: child,
      transitionsBuilder: (c, a, sa, ch) =>
          FadeTransition(opacity: a, child: ch),
    );
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(
      context,
    ).routeInformationProvider.value.uri.path;
    final tabRoutes = [
      AppRoutes.dashboard,
      AppRoutes.medications,
      AppRoutes.calendar,
      AppRoutes.progress,
      AppRoutes.settings,
    ];
    // Sub-settings screens hide the bottom bar (back goes to Settings).
    final selectedIndex = tabRoutes.indexWhere((r) => currentPath == r);
    final isTabRoute = selectedIndex != -1;
    final effectiveIndex = isTabRoute ? selectedIndex : 0;

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: child,
      bottomNavigationBar: isTabRoute
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: effectiveIndex,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: colorScheme.onSurfaceVariant,
              backgroundColor: colorScheme.surface,
              elevation: 8,
              onTap: (i) {
                if (i != effectiveIndex) {
                  context.go(tabRoutes[i]);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.medication_outlined),
                  activeIcon: Icon(Icons.medication),
                  label: 'Meds',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today_outlined),
                  activeIcon: Icon(Icons.calendar_today),
                  label: 'Calendar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights_outlined),
                  activeIcon: Icon(Icons.insights),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
