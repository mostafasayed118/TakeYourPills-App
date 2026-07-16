import 'package:flutter/material.dart';
import '../theme/app_text_styles.dart';

/// Primary action button with loading state and visual feedback.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isPrimary = true,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isLoading;
  final Widget? icon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = ElevatedButton.styleFrom(
      backgroundColor: widget.isPrimary
          ? theme.colorScheme.primary
          : Colors.transparent,
      foregroundColor: widget.isPrimary
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.primary,
      disabledBackgroundColor: widget.isPrimary
          ? theme.colorScheme.primary.withValues(alpha: 0.38)
          : theme.colorScheme.surfaceContainerLow,
      disabledForegroundColor: widget.isPrimary
          ? theme.colorScheme.onPrimary.withValues(alpha: 0.38)
          : theme.colorScheme.onSurfaceVariant,
      elevation: 0,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(0, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: widget.isPrimary
            ? BorderSide.none
            : BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
    );

    final child = widget.isLoading
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: widget.isPrimary
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
              Text('Saving...', style: AppTextStyles.titleSmall),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[widget.icon!, const SizedBox(width: 8)],
              Text(widget.text, style: AppTextStyles.titleSmall),
            ],
          );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? (_) => _controller.forward() : null,
        onTapUp: widget.onPressed != null ? (_) => _controller.reverse() : null,
        onTapCancel: widget.onPressed != null ? () => _controller.reverse() : null,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: style,
          child: child,
        ),
      ),
    );
  }
}
