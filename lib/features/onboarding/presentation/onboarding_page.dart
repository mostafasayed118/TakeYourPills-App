import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/routing/routes.dart';
import '../../../shared/services/notification_service.dart';
import '../../../shared/services/preference_service.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_text_styles.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Take Your Meds',
      'subtitle': 'Never miss a dose with gentle, reliable reminders.',
      'icon': Icons.medication,
    },
    {
      'title': 'Track Your Progress',
      'subtitle': 'See your adherence and celebrate your consistency.',
      'icon': Icons.insights,
    },
    {
      'title': 'Stay Organized',
      'subtitle': 'Manage refills and keep everything in one place.',
      'icon': Icons.calendar_today,
    },
  ];
  @override
  Widget build(BuildContext context) => PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, index) => _buildPage(_pages[index]),
              ),
            ),
            _buildDots(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );

  Widget _buildPage(Map<String, dynamic> p) => Padding(
    padding: const EdgeInsets.all(32),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(p['icon'], size: 120, color: AppColors.primary),
        const SizedBox(height: 48),
        Text(
          p['title'],
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          p['subtitle'],
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
  Widget _buildDots() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(
      _pages.length,
      (i) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: _currentPage == i ? 24 : 8,
        height: 8,
        decoration: BoxDecoration(
          color: _currentPage == i
              ? AppColors.primary
              : AppColors.outlineVariant,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
  Widget _buildBottomButtons() => Padding(
    padding: const EdgeInsets.all(24),
    child: Row(
      children: [
        if (_currentPage > 0)
          TextButton(
            onPressed: () => _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text('Back'),
          ),
        const Spacer(),
        if (_currentPage < _pages.length - 1)
          TextButton(
            onPressed: () => _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            child: const Text('Next'),
          )
        else
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () async {
                // Request notification + exact-alarm permissions before
                // entering the main app so dose reminders can fire.
                try {
                  await GetIt.instance<NotificationService>()
                      .requestPermission();
                } on Object {
                  // User may deny; app still works without reminders.
                }
                await GetIt.instance<PreferenceService>().setOnboardingComplete(
                  true,
                );
                if (mounted) {
                  context.go(AppRoutes.dashboard);
                }
              },
              child: const Text('Get Started'),
            ),
          ),
      ],
    ),
  );
}
