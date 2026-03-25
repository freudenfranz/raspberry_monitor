import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays a card preview
class ShowcaseCardPreview extends StatelessWidget {
  /// Creates a showcase card preview widget
  const ShowcaseCardPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing card information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final cardType = item.properties['type'] as String?;
    if (cardType == null) {
      return const SizedBox.shrink();
    }

    Widget card;
    switch (cardType) {
      case 'basic':
        card = const Card(
          elevation: 1,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Basic Card Content'),
          ),
        );
        break;
      case 'elevated':
        card = const Card(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Elevated Card Content'),
          ),
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return card;
  }
}
