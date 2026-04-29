import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),
          _buildDots(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, dynamic> page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page['icon'], size: 120, color: AppColors.primary),
          const SizedBox(height: 48),
          Text(page['title'],
              style: AppTextStyles.displayLarge.copyWith(color: AppColors.onBackground)),
          const SizedBox(height: 16),
          Text(page['subtitle'],
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? AppColors.primary : AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
            ),
          if (_currentPage == _pages.length - 1)
            ElevatedButton(
              onPressed: () {
                // TODO: Save onboarding state to preferences
                context.mounted
                    ? GoRouter.of(context).go('/dashboard')
                    : null;
              },
              child: const Text('Get Started'),
            ),
        ],
      ),
    );
  }
}
