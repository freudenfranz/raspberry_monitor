import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays an error preview
class ShowcaseErrorPreview extends StatelessWidget {
  /// Creates a showcase error preview widget
  const ShowcaseErrorPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing error information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final errorType = item.properties['type'] as String?;
    String message = 'An error occurred';
    IconData icon = Icons.error_outline;

    switch (errorType) {
      case 'network':
        message = 'Network connection error';
        icon = Icons.wifi_off;
        break;
      case 'validation':
        message = 'Validation failed';
        icon = Icons.warning_amber_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
