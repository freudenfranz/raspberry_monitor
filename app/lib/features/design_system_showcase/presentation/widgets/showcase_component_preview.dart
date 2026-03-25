import 'package:flutter/material.dart';

import '../../domain/entities/showcase_item.dart';
import 'showcase_button_preview.dart';
import 'showcase_card_preview.dart';
import 'showcase_color_swatch.dart';
import 'showcase_error_preview.dart';
import 'showcase_freezed_previews.dart';
import 'showcase_info_preview.dart';
import 'showcase_input_field_preview.dart';
import 'showcase_list_preview.dart';
import 'showcase_loading_preview.dart';
import 'showcase_spacing_preview.dart';
import 'showcase_success_preview.dart';
import 'showcase_text_style_preview.dart';

/// Widget that renders the appropriate preview based on component type
class ShowcaseComponentPreview extends StatelessWidget {
  /// Creates a showcase component preview widget
  const ShowcaseComponentPreview({
    required this.item,
    super.key,
  });

  /// The showcase item to display
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    switch (item.componentType) {
      case ComponentType.colorSwatch:
        return ShowcaseColorSwatch(item: item);
      case ComponentType.textStyle:
        return ShowcaseTextStylePreview(item: item);
      case ComponentType.spacingDemo:
        return ShowcaseSpacingPreview(item: item);
      case ComponentType.primaryButton:
        return ShowcaseButtonPreview(item: item);
      case ComponentType.secondaryButton:
        return ShowcaseButtonPreview(item: item);
      case ComponentType.textButton:
        return ShowcaseButtonPreview(item: item);
      case ComponentType.iconButton:
        return ShowcaseButtonPreview(item: item);
      case ComponentType.textField:
        return ShowcaseInputFieldPreview(item: item);
      case ComponentType.searchField:
        return ShowcaseInputFieldPreview(item: item);
      case ComponentType.card:
        return ShowcaseCardPreview(item: item);
      case ComponentType.loading:
        return ShowcaseLoadingPreview(item: item);
      case ComponentType.error:
        return ShowcaseErrorPreview(item: item);
      case ComponentType.success:
        return const ShowcaseSuccessPreview();
      case ComponentType.info:
        return const ShowcaseInfoPreview();
      case ComponentType.list:
        return const ShowcaseListPreview();
      case ComponentType.freezedEntity:
        return ShowcaseFreezedEntityPreview(item: item);
      case ComponentType.jsonSerialization:
        return ShowcaseJsonSerializationPreview(item: item);
      case ComponentType.entityCopyWith:
        return ShowcaseEntityCopyWithPreview(item: item);
    }
  }
}
