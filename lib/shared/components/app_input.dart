import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_text_styles.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry? contentPadding;

  const AppInput({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          readOnly: readOnly,
          maxLines: maxLines,
          textCapitalization: textCapitalization,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.outlineVariant),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: AppColors.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHigh),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.surfaceContainerHigh),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
