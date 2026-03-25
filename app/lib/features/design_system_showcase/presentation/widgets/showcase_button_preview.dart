import 'package:flutter/material.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

import '../../domain/entities/showcase_item.dart';

/// Widget that displays a button preview
class ShowcaseButtonPreview extends StatelessWidget {
  /// Creates a showcase button preview widget
  const ShowcaseButtonPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing button information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final buttonType = item.properties['type'] as String?;
    if (buttonType == null) {
      return const SizedBox.shrink();
    }

    Widget button;
    switch (buttonType) {
      case 'elevated':
        button = ElevatedButton(
          onPressed: () {},
          child: Text(l10n.sampleButton),
        );
        break;
      case 'outlined':
        button = OutlinedButton(
          onPressed: () {},
          child: Text(l10n.sampleButton),
        );
        break;
      case 'text':
        button = TextButton(
          onPressed: () {},
          child: Text(l10n.sampleButton),
        );
        break;
      default:
        return const SizedBox.shrink();
    }

    return Center(child: button);
  }
}
