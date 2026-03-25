import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays an input field preview
class ShowcaseInputFieldPreview extends StatelessWidget {
  /// Creates a showcase input field preview widget
  const ShowcaseInputFieldPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing input field information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final inputType = item.properties['type'] as String?;
    if (inputType == null) {
      return const SizedBox.shrink();
    }

    Widget field;
    switch (inputType) {
      case 'text':
        field = const TextField(
          decoration: InputDecoration(
            labelText: 'Sample Input',
            hintText: 'Enter text here',
          ),
        );
        break;
      case 'search':
        field = const TextField(
          decoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search for items...',
            prefixIcon: Icon(Icons.search),
          ),
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return field;
  }
}
