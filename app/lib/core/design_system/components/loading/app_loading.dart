import 'package:flutter/material.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/app_text_styles.dart';

/// Loading indicator for full screen loading states
class AppLoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator with optional message
  const AppLoadingIndicator({
    super.key,
    this.size = 48,
    this.message,
  });

  /// Size of the loading spinner
  final double size;
  /// Optional message to display below the spinner
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: size,
              width: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
}

/// Small loading indicator for buttons or inline use
class AppLoadingSpinner extends StatelessWidget {
  /// Creates a small loading spinner
  const AppLoadingSpinner({
    super.key,
    this.size = AppIconSize.small,
    this.strokeWidth = 2,
    this.color,
  });

  /// Size of the spinner
  final double size;
  /// Width of the spinner stroke
  final double strokeWidth;
  /// Color of the spinner
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
      );
}

/// Loading overlay that can be placed over content
class AppLoadingOverlay extends StatelessWidget {
  /// Creates a loading overlay with optional message
  const AppLoadingOverlay({
    required this.isLoading,
    required this.child,
    super.key,
    this.message,
  });

  /// Whether to show the loading overlay
  final bool isLoading;
  /// The widget to overlay
  final Widget child;
  /// Optional message to display in the loading indicator
  final String? message;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          if (isLoading)
            Container(
              color: Theme.of(context)
                  .colorScheme
                  .surface
                  .withValues(alpha: 0.8),
              child: AppLoadingIndicator(message: message),
            ),
        ],
      );
}
