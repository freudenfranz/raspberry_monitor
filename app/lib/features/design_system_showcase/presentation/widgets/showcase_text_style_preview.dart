import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays a text style preview
class ShowcaseTextStylePreview extends StatelessWidget {
  /// Creates a showcase text style preview widget
  const ShowcaseTextStylePreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing text style information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final styleName = item.properties['style'] as String?;
    if (styleName == null) {
      return const SizedBox.shrink();
    }

    TextStyle? textStyle;
    switch (styleName) {
      case 'displayLarge':
        textStyle = Theme.of(context).textTheme.displayLarge;
        break;
      case 'headlineLarge':
        textStyle = Theme.of(context).textTheme.headlineLarge;
        break;
      case 'titleLarge':
        textStyle = Theme.of(context).textTheme.titleLarge;
        break;
      case 'bodyLarge':
        textStyle = Theme.of(context).textTheme.bodyLarge;
        break;
      case 'labelLarge':
        textStyle = Theme.of(context).textTheme.labelLarge;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        'Sample Text',
        style: textStyle,
      ),
    );
  }
}
