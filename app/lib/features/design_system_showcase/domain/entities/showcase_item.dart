import 'package:freezed_annotation/freezed_annotation.dart';

part 'showcase_item.freezed.dart';
part 'showcase_item.g.dart';

/// A showcase item represents a single element in the design system
@freezed
sealed class ShowcaseItem with _$ShowcaseItem {

  /// Creates a showcase item with the specified properties
  const factory ShowcaseItem({
    required String id,
    required String title,
    required String description,
    required ShowcaseCategory category,
    required ComponentType componentType,
    @Default({}) Map<String, dynamic> properties,
  }) = _ShowcaseItem;
  const ShowcaseItem._();

  /// Creates a ShowcaseItem from JSON
  factory ShowcaseItem.fromJson(Map<String, dynamic> json) => _$ShowcaseItemFromJson(json);
}

/// Categories for organizing design system elements
enum ShowcaseCategory {
  /// Color palette and theming
  colors,
  /// Text styles and typography
  typography,
  /// Spacing and layout constants
  spacing,
  /// Button components
  buttons,
  /// Input components
  inputs,
  /// Feedback components (loading, errors, etc.)
  feedback,
  /// Navigation components
  navigation,
  /// Layout components
  layout,
  /// Data models and entities (Freezed examples)
  dataModels,
}

/// Types of components that can be showcased
enum ComponentType {
  /// Color swatch display
  colorSwatch,
  /// Text style demonstration
  textStyle,
  /// Spacing demonstration
  spacingDemo,
  /// Primary button component
  primaryButton,
  /// Secondary button component
  secondaryButton,
  /// Text button component
  textButton,
  /// Icon button component
  iconButton,
  /// Text input field
  textField,
  /// Search input field
  searchField,
  /// Loading indicator
  loading,
  /// Error message component
  error,
  /// Success message component
  success,
  /// Info message component
  info,
  /// Card component
  card,
  /// List component
  list,
  /// Freezed entity demonstration
  freezedEntity,
  /// JSON serialization example
  jsonSerialization,
  /// Entity copyWith example
  entityCopyWith,
}
