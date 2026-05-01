import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/widgets/adherence_ring.dart';
import 'package:takeyourpills_healthcare_app/features/dashboard/presentation/widgets/upcoming_item.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        title: const Text('TakeYourPills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(),
            const SizedBox(height: 24),
            _buildAdherenceCard(),
            const SizedBox(height: 24),
            _buildNextDoseCard(),
            const SizedBox(height: 24),
            _buildUpcomingList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good Morning, Alex', style: AppTextStyles.headlineMedium),
        Text(
          'Here is your wellness summary for today.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAdherenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const AdherenceRing(value: 0.8),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '4 of 5',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Taken today',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.warning,
                  size: 20,
                  color: AppColors.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  '1 Missed',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onErrorContainer,
                  ),
                ),
                const Spacer(),
                Text(
                  'Action needed',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDoseCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryFixed.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '10:00 AM • WITH FOOD',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primaryFixed,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lisinopril',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '10mg • 1 Pill',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medication, color: AppColors.onPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.onPrimary,
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Log Taken',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming Today', style: AppTextStyles.titleSmall),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                UpcomingItem(
                  name: 'Vitamin D3',
                  dosage: '2000 IU • 1 Capsule',
                  time: '1:00 PM',
                  icon: Icons.water_drop,
                ),
                Container(height: 1, color: AppColors.surfaceContainerHighest),
                UpcomingItem(
                  name: 'Atorvastatin',
                  dosage: '20mg • 1 Tablet',
                  time: '8:00 PM',
                  icon: Icons.medication_outlined,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
