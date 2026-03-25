import 'package:flutter/material.dart';
import '../../domain/entities/showcase_item.dart';

/// Widget that demonstrates Freezed entity functionality
class ShowcaseFreezedEntityPreview extends StatelessWidget {
  /// Creates a ShowcaseFreezedEntityPreview
  const ShowcaseFreezedEntityPreview({
    required this.item,
    super.key,
  });

  /// The showcase item being demonstrated
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Freezed Entity',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Immutable entities with value equality and copy functionality'),
        ],
      ),
    ),
  );
}

/// Widget that demonstrates JSON serialization with Freezed
class ShowcaseJsonSerializationPreview extends StatelessWidget {
  /// Creates a ShowcaseJsonSerializationPreview
  const ShowcaseJsonSerializationPreview({
    required this.item,
    super.key,
  });

  /// The showcase item being demonstrated
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'JSON Serialization',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Automatic toJson/fromJson generation with json_serializable'),
        ],
      ),
    ),
  );
}

/// Widget that demonstrates copyWith functionality
class ShowcaseEntityCopyWithPreview extends StatelessWidget {
  /// Creates a ShowcaseEntityCopyWithPreview
  const ShowcaseEntityCopyWithPreview({
    required this.item,
    super.key,
  });

  /// The showcase item being demonstrated
  final ShowcaseItem item;

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entity CopyWith',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Immutable updates with copyWith method'),
        ],
      ),
    ),
  );
}