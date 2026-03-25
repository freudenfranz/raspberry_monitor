import 'package:flutter/material.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/app_text_styles.dart';
import '../buttons/app_button.dart';

/// Error display widget for full screen error states
class AppErrorWidget extends StatelessWidget {
  /// Creates an error widget with customizable message and retry functionality
  const AppErrorWidget({
    required this.message,
    super.key,
    this.title = 'Something went wrong',
    this.onRetry,
    this.retryText = 'Try Again',
    this.icon = Icons.error_outline,
  });

  /// The error message to display
  final String message;
  /// The title text to display above the message
  final String title;
  /// Callback function when retry button is pressed
  final VoidCallback? onRetry;
  /// Text displayed on the retry button
  final String retryText;
  /// Icon to display at the top of the error
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                text: retryText,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Compact error message widget for inline use
class AppErrorMessage extends StatelessWidget {
  /// Creates a compact error message widget
  const AppErrorMessage({
    required this.message,
    super.key,
    this.onRetry,
    this.retryText = 'Retry',
  });

  /// The error message to display
  final String message;
  /// Callback function when retry button is pressed
  final VoidCallback? onRetry;
  /// Text displayed on the retry button
  final String retryText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: AppIconSize.small,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                retryText,
                style: AppTextStyles.labelSmall.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
