import 'package:flutter/material.dart';

/// Widget that displays a success preview
class ShowcaseSuccessPreview extends StatelessWidget {
  /// Creates a showcase success preview widget
  const ShowcaseSuccessPreview({super.key});

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 4),
          Text('Success', style: TextStyle(color: Colors.green)),
        ],
      ),
    );
}
