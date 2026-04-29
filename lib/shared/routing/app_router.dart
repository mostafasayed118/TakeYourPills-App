import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/dashboard_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/add_edit_medication_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/detail/medication_detail_page.dart';
import 'package:takeyourpills_healthcare_app/features/medication/presentation/medication_list_page.dart';
import 'package:takeyourpills_healthcare_app/features/settings/presentation/settings_page.dart';
import 'package:takeyourpills_healthcare_app/shared/routing/routes.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/features/onboarding/presentation/onboarding_page.dart';

class AppRouter {
  static GoRouter get router {
    return GoRouter(
      initialLocation: AppRoutes.root,
      redirect: (context, state) {
        // TODO: Read from PreferenceService once implemented
        const onboardingComplete = false;
        final isOnboardingRoute =
            state.matchedLocation == AppRoutes.onboarding;
        if (!onboardingComplete && !isOnboardingRoute) {
          return AppRoutes.onboarding;
        }
        if (onboardingComplete && isOnboardingRoute) {
          return AppRoutes.dashboard;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.root,
          redirect: (_, __) => AppRoutes.dashboard,
        ),
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
            // Add/Edit medication (/:medId is 'new' for create, or a numeric ID for edit)
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
            // Medication detail
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
                child: const Scaffold(
                  body: Center(child: Text('Calendar — Coming Soon')),
                ),
              ),
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const Scaffold(
                  body: Center(child: Text('History — Coming Soon')),
                ),
              ),
            ),
            GoRoute(
              path: AppRoutes.progress,
              name: 'progress',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const Scaffold(
                  body: Center(child: Text('Progress — Coming Soon')),
                ),
              ),
            ),
            GoRoute(
              path: AppRoutes.settings,
              name: 'settings',
              pageBuilder: (c, s) =>
                  _fadeTransition(c: c, s: s, child: const SettingsPage()),
            ),
            GoRoute(
              path: AppRoutes.messaging,
              name: 'messaging',
              pageBuilder: (c, s) => _fadeTransition(
                c: c,
                s: s,
                child: const Scaffold(
                  body: Center(
                    child: Text('Provider Messaging — Coming Soon'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (c, s) => Scaffold(
        body: Center(child: Text('Page not found: ${s.error}')),
      ),
    );
  }

  static CustomTransitionPage _fadeTransition({
    required BuildContext c,
    required GoRouterState s,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: s.pageKey,
      child: child,
      transitionsBuilder: (c, a, sa, ch) =>
          FadeTransition(opacity: a, child: ch),
    );
  }
}

/// Shell scaffold with bottom navigation bar.
class _MainScaffold extends StatelessWidget {
  final Widget child;
  const _MainScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final currentPath =
        GoRouter.of(context).routeInformationProvider.value.uri.path;

    final tabRoutes = [
      AppRoutes.dashboard,
      AppRoutes.medications,
      AppRoutes.calendar,
      AppRoutes.progress,
      AppRoutes.settings,
    ];

    final selectedIndex = tabRoutes.indexWhere((r) => currentPath == r);
    final effectiveIndex = selectedIndex == -1 ? 0 : selectedIndex;

    // Hide bottom nav for non-tab routes
    final isTabRoute = selectedIndex != -1;

    return Scaffold(
      body: child,
      bottomNavigationBar: isTabRoute
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: effectiveIndex,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.onSurfaceVariant,
              backgroundColor: AppColors.surface,
              elevation: 8,
              onTap: (i) {
                if (i != effectiveIndex) context.go(tabRoutes[i]);
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
