import 'package:flutter/material.dart';

/// Widget that displays an info preview
class ShowcaseInfoPreview extends StatelessWidget {
  /// Creates a showcase info preview widget
  const ShowcaseInfoPreview({super.key});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.blue),
      ),
      child: const Row(
        children: [
          Icon(Icons.info, color: Colors.blue, size: 16),
          SizedBox(width: 4),
          Text('Info', style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
}
