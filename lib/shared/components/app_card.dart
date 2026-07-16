import 'package:flutter/material.dart';

/// Reusable card component with consistent styling.
///
/// Uses theme tokens for colors, borders, and border radius.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
  });

  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = borderRadius ?? 16;

    final card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      );
    }
    return card;
  }
}
