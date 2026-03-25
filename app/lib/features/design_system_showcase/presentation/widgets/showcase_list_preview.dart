import 'package:flutter/material.dart';

/// Widget that displays a list preview
class ShowcaseListPreview extends StatelessWidget {
  /// Creates a showcase list preview widget
  const ShowcaseListPreview({super.key});

  @override
  Widget build(BuildContext context) => Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 6),
              SizedBox(width: 8),
              Text('List Item 1', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Row(
            children: [
              Icon(Icons.circle, size: 6),
              SizedBox(width: 8),
              Text('List Item 2', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
}
