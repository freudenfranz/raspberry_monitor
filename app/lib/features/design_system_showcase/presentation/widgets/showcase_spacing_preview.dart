import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays a spacing preview
class ShowcaseSpacingPreview extends StatelessWidget {
  /// Creates a showcase spacing preview widget
  const ShowcaseSpacingPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing spacing information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final size = item.properties['size'] as double?;
    if (size == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${size.toInt()}px',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
