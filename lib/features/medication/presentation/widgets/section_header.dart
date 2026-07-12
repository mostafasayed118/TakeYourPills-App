import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {

  const SectionHeader({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) => Text(
      title,
      style: AppTextStyles.titleSmall.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
}
