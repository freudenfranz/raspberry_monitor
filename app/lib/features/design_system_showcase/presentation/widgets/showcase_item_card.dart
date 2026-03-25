import 'package:flutter/material.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import 'showcase_category_icon.dart';
import 'showcase_component_preview.dart';

/// Widget that displays a showcase item in a card format
class ShowcaseItemCard extends StatelessWidget {

  /// Creates showcase item card with the provided item
  const ShowcaseItemCard({
    required this.item, super.key,
  });
  /// The showcase item to display
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) => Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                ShowcaseCategoryIcon(category: item.category),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              item.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Component Preview
            ShowcaseComponentPreview(item: item),
          ],
        ),
      ),
    );

}
