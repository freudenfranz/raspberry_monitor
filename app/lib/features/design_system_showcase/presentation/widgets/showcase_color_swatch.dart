import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that displays a color swatch preview
class ShowcaseColorSwatch extends StatelessWidget {
  /// Creates a showcase color swatch widget
  const ShowcaseColorSwatch({
    required this.item,
    super.key,
  });

  /// The showcase item containing color information
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) {
    final colorValue = item.properties['color'] as int?;
    if (colorValue == null) {
      return const SizedBox.shrink();
    }

    final color = Color(colorValue);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          '#${colorValue.toRadixString(16).toUpperCase().padLeft(8, '0').substring(2)}',
          style: TextStyle(
            color: _getContrastingTextColor(color),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate perceived brightness using the formula for relative luminance
    final luminance = (0.299 * ((backgroundColor.r * 255.0).round() & 0xff) +
                      0.587 * ((backgroundColor.g * 255.0).round() & 0xff) +
                      0.114 * ((backgroundColor.b * 255.0).round() & 0xff)) / 255;

    // Return white text for dark backgrounds, black text for light backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
