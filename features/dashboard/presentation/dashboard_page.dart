import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        title: const Text('TakeYourPills'),
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildGreeting(), const SizedBox(height: 24), _buildAdherenceCard(), const SizedBox(height: 24), _buildNextDoseCard(), const SizedBox(height: 24), _buildUpcomingList()],
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Good Morning, Alex', style: AppTextStyles.headlineMedium),
        Text('Here is your wellness summary for today.', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildAdherenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 4))]),
      child: Column(
        children: [
          Row(
            children: [
              _buildAdherenceRing(),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(6)),
                      child: Text('4 of 5', style: AppTextStyles.titleSmall.copyWith(color: AppColors.onPrimaryContainer)),
                    ),
                    const SizedBox(height: 4),
                    Text('Taken today', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.errorContainer, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                const Icon(Icons.warning, size: 20, color: AppColors.onErrorContainer),
                const SizedBox(width: 8),
                Text('1 Missed', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onErrorContainer)),
                const Spacer(),
                Text('Action needed', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onErrorContainer)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdherenceRing() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(width: 80, height: 80, child: CircularProgressIndicator(value: 0.8, strokeWidth: 8, backgroundColor: AppColors.surfaceContainerHigh, valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary))),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text('80%', style: AppTextStyles.titleSmall),
          Text('Adherence', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
        ]),
      ],
    );
  }

  Widget _buildNextDoseCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryFixed.withOpacity(0.5), borderRadius: BorderRadius.circular(4)), child: Text('10:00 AM • WITH FOOD', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryFixed))),]),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Lisinopril', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onPrimary)), const SizedBox(height: 4), Text('10mg • 1 Pill', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryContainer)),])),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.onPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.medication, color: AppColors.onPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 48, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: AppColors.onPrimary, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Log Taken', style: TextStyle(fontWeight: FontWeight.w600)))),
        ],
      ),
    );
  }

  Widget _buildUpcomingList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Upcoming Today', style: AppTextStyles.titleSmall),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 20, offset: Offset(0, 4))]),
        child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Column(children: [_buildUpcomingItem('Vitamin D3', '2000 IU • 1 Capsule', '1:00 PM', Icons.water_drop), Container(height: 1, color: AppColors.surfaceContainerHighest), _buildUpcomingItem('Atorvastatin', '20mg • 1 Tablet', '8:00 PM', Icons.medication_outlined),])),
      ),
    ]);
  }

  Widget _buildUpcomingItem(String name, String dosage, String time, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        color: AppColors.surfaceContainerLowest,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: AppColors.onSecondaryContainer)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: AppTextStyles.titleSmall), const SizedBox(height: 4), Text(dosage, style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time, style: AppTextStyles.bodySmall),
              const SizedBox(height: 4),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(10)), child: Text('UPCOMING', style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant)),)
            ],)
          ],
        ),
      ),
    );
  }
}
