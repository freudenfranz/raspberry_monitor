import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays a loading preview
class ShowcaseLoadingPreview extends StatelessWidget {
  /// Creates a showcase loading preview widget
  const ShowcaseLoadingPreview({
    required this.item,
    super.key,
  });

  /// The showcase item containing loading information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final loadingType = item.properties['type'] as String?;
    if (loadingType == null) {
      return const SizedBox.shrink();
    }

    Widget loading;
    switch (loadingType) {
      case 'circular':
        loading = const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        );
        break;
      case 'linear':
        loading = const LinearProgressIndicator();
        break;
      default:
        return const SizedBox.shrink();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: loading,
      ),
    );
  }
}
