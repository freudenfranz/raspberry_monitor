import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays the category icon for a showcase item
class ShowcaseCategoryIcon extends StatelessWidget {
  /// Creates a showcase category icon widget
  const ShowcaseCategoryIcon({
    required this.category,
    super.key,
  });

  /// The showcase category to get the icon for
  final ShowcaseCategory category;

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    final Color iconColor = Theme.of(context).colorScheme.primary;

    switch (category) {
      case ShowcaseCategory.colors:
        iconData = Icons.palette;
        break;
      case ShowcaseCategory.typography:
        iconData = Icons.text_fields;
        break;
      case ShowcaseCategory.spacing:
        iconData = Icons.space_bar;
        break;
      case ShowcaseCategory.buttons:
        iconData = Icons.smart_button;
        break;
      case ShowcaseCategory.inputs:
        iconData = Icons.input;
        break;
      case ShowcaseCategory.feedback:
        iconData = Icons.feedback;
        break;
      case ShowcaseCategory.navigation:
        iconData = Icons.navigation;
        break;
      case ShowcaseCategory.layout:
        iconData = Icons.view_module;
        break;
      case ShowcaseCategory.dataModels:
        iconData = Icons.data_object;
        break;
    }

    return Icon(
      iconData,
      size: 20,
      color: iconColor,
    );
  }
}
