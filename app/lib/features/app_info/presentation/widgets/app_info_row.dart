import 'package:flutter/material.dart';
import '../../../../core/design_system/design_system.dart';

/// Widget that displays an information row with icon, label, and value
class AppInfoRow extends StatelessWidget {
  /// Creates an app info row widget
  const AppInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLong = false,
    super.key,
  });

  /// Icon to display
  final IconData icon;

  /// Label text
  final String label;

  /// Value text
  final String value;

  /// Whether the value text is long and should be displayed in a container
  final bool isLong;

  @override
  Widget build(BuildContext context) => Row(
      crossAxisAlignment: isLong ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: AppIconSize.small,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (isLong)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppBorderRadius.small),
                  ),
                  child: SelectableText(
                    value,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                )
              else
                Text(
                  value,
                  style: AppTextStyles.bodyMedium,
                ),
            ],
          ),
        ),
      ],
    );
}
