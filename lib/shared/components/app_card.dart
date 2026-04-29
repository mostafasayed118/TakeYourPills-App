import 'package:flutter/material.dart';
import 'package:takeyourpills_healthcare_app/shared/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        child: card,
      );
    }
    return card;
  }
}
