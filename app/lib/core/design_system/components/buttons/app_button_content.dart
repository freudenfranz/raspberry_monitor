import 'package:flutter/material.dart';
import '../../spacing/app_spacing.dart';

/// Content widget for AppButton variants
class AppButtonContent extends StatelessWidget {
  /// Creates app button content
  const AppButtonContent({
    required this.isLoading,
    required this.icon,
    required this.text,
    required this.iconSize,
    required this.textStyle,
    super.key,
  });

  /// Whether the button is in loading state
  final bool isLoading;

  /// Optional icon to display
  final IconData? icon;

  /// Text to display
  final String text;

  /// Size of the icon
  final double iconSize;

  /// Style for the text
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: iconSize,
        width: iconSize,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: textStyle),
        ],
      );
    }

    return Text(text, style: textStyle);
  }
}
