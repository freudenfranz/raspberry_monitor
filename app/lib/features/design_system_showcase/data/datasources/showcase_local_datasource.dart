import 'package:injectable/injectable.dart';

import '/features/design_system_showcase/domain/entities/showcase_item.dart';

/// Abstract interface for accessing showcase data locally
abstract class ShowcaseLocalDataSource {
  /// Get all available showcase items
  Future<List<ShowcaseItem>> getAllItems();
  /// Get showcase items filtered by category
  Future<List<ShowcaseItem>> getItemsByCategory(ShowcaseCategory category);
  /// Search showcase items by query string
  Future<List<ShowcaseItem>> searchItems(String query);
}

/// Implementation of showcase local data source with static data
@LazySingleton(as: ShowcaseLocalDataSource)
class ShowcaseLocalDataSourceImpl implements ShowcaseLocalDataSource {
  static final List<ShowcaseItem> _showcaseItems = [
    // Colors
    const ShowcaseItem(
      id: 'primary_color',
      title: 'Primary Color',
      description: 'Main brand color used for primary actions and key UI elements',
      category: ShowcaseCategory.colors,
      componentType: ComponentType.colorSwatch,
      properties: {'color': 0xFFcd2355},
    ),
    const ShowcaseItem(
      id: 'secondary_color',
      title: 'Secondary Color',
      description: 'Complementary color for secondary actions and accent elements',
      category: ShowcaseCategory.colors,
      componentType: ComponentType.colorSwatch,
      properties: {'color': 0xFF46af4b},
    ),
    const ShowcaseItem(
      id: 'surface_color',
      title: 'Surface Color',
      description: 'Background color for cards, sheets, and elevated surfaces',
      category: ShowcaseCategory.colors,
      componentType: ComponentType.colorSwatch,
      properties: {'color': 0xFFFFFFFF},
    ),
    const ShowcaseItem(
      id: 'error_color',
      title: 'Error Color',
      description: 'Color used for error states and destructive actions',
      category: ShowcaseCategory.colors,
      componentType: ComponentType.colorSwatch,
      properties: {'color': 0xFFD32F2F},
    ),

    // Typography
    const ShowcaseItem(
      id: 'display_large',
      title: 'Display Large',
      description: 'The largest display text style',
      category: ShowcaseCategory.typography,
      componentType: ComponentType.textStyle,
      properties: {'style': 'displayLarge'},
    ),
    const ShowcaseItem(
      id: 'headline_large',
      title: 'Headline Large',
      description: 'Large headlines for screen titles',
      category: ShowcaseCategory.typography,
      componentType: ComponentType.textStyle,
      properties: {'style': 'headlineLarge'},
    ),
    const ShowcaseItem(
      id: 'title_large',
      title: 'Title Large',
      description: 'Large title text for prominent content',
      category: ShowcaseCategory.typography,
      componentType: ComponentType.textStyle,
      properties: {'style': 'titleLarge'},
    ),
    const ShowcaseItem(
      id: 'body_large',
      title: 'Body Large',
      description: 'Large body text for extended reading',
      category: ShowcaseCategory.typography,
      componentType: ComponentType.textStyle,
      properties: {'style': 'bodyLarge'},
    ),
    const ShowcaseItem(
      id: 'label_large',
      title: 'Label Large',
      description: 'Large labels for buttons and navigation',
      category: ShowcaseCategory.typography,
      componentType: ComponentType.textStyle,
      properties: {'style': 'labelLarge'},
    ),

    // Spacing
    const ShowcaseItem(
      id: 'spacing_xs',
      title: 'Extra Small Spacing',
      description: '4.0 pixels - Minimal spacing for tight layouts',
      category: ShowcaseCategory.spacing,
      componentType: ComponentType.spacingDemo,
      properties: {'size': 4.0},
    ),
    const ShowcaseItem(
      id: 'spacing_sm',
      title: 'Small Spacing',
      description: '8.0 pixels - Small margins and padding',
      category: ShowcaseCategory.spacing,
      componentType: ComponentType.spacingDemo,
      properties: {'size': 8.0},
    ),
    const ShowcaseItem(
      id: 'spacing_md',
      title: 'Medium Spacing',
      description: '16.0 pixels - Standard spacing between elements',
      category: ShowcaseCategory.spacing,
      componentType: ComponentType.spacingDemo,
      properties: {'size': 16.0},
    ),
    const ShowcaseItem(
      id: 'spacing_lg',
      title: 'Large Spacing',
      description: '24.0 pixels - Large gaps between sections',
      category: ShowcaseCategory.spacing,
      componentType: ComponentType.spacingDemo,
      properties: {'size': 24.0},
    ),
    const ShowcaseItem(
      id: 'spacing_xl',
      title: 'Extra Large Spacing',
      description: '32.0 pixels - Extra large margins for major sections',
      category: ShowcaseCategory.spacing,
      componentType: ComponentType.spacingDemo,
      properties: {'size': 32.0},
    ),

    // Components - Buttons
    const ShowcaseItem(
      id: 'elevated_button',
      title: 'Elevated Button',
      description: 'Primary action button with elevation and shadow',
      category: ShowcaseCategory.buttons,
      componentType: ComponentType.primaryButton,
      properties: {'type': 'elevated'},
    ),
    const ShowcaseItem(
      id: 'outlined_button',
      title: 'Outlined Button',
      description: 'Secondary action button with border outline',
      category: ShowcaseCategory.buttons,
      componentType: ComponentType.secondaryButton,
      properties: {'type': 'outlined'},
    ),
    const ShowcaseItem(
      id: 'text_button',
      title: 'Text Button',
      description: 'Tertiary action button with minimal styling',
      category: ShowcaseCategory.buttons,
      componentType: ComponentType.textButton,
      properties: {'type': 'text'},
    ),

    // Components - Input Fields
    const ShowcaseItem(
      id: 'text_field',
      title: 'Text Field',
      description: 'Standard text input field for user data entry',
      category: ShowcaseCategory.inputs,
      componentType: ComponentType.textField,
      properties: {'type': 'text'},
    ),
    const ShowcaseItem(
      id: 'search_field',
      title: 'Search Field',
      description: 'Text input field optimized for search functionality',
      category: ShowcaseCategory.inputs,
      componentType: ComponentType.searchField,
      properties: {'type': 'search'},
    ),

    // Components - Cards
    const ShowcaseItem(
      id: 'card_basic',
      title: 'Basic Card',
      description: 'Simple card container for content grouping',
      category: ShowcaseCategory.layout,
      componentType: ComponentType.card,
      properties: {'type': 'basic'},
    ),
    const ShowcaseItem(
      id: 'card_elevated',
      title: 'Elevated Card',
      description: 'Card with elevation shadow for prominent content',
      category: ShowcaseCategory.layout,
      componentType: ComponentType.card,
      properties: {'type': 'elevated'},
    ),

    // Components - Loading & Feedback
    const ShowcaseItem(
      id: 'circular_progress',
      title: 'Circular Progress Indicator',
      description: 'Circular loading indicator for ongoing processes',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.loading,
      properties: {'type': 'circular'},
    ),
    const ShowcaseItem(
      id: 'linear_progress',
      title: 'Linear Progress Indicator',
      description: 'Linear loading indicator showing completion progress',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.loading,
      properties: {'type': 'linear'},
    ),
    const ShowcaseItem(
      id: 'snack_bar',
      title: 'Snack Bar',
      description: 'Brief message display for user feedback',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.info,
      properties: {'type': 'snackbar'},
    ),

    // Error States
    const ShowcaseItem(
      id: 'error_basic',
      title: 'Basic Error',
      description: 'Standard error message display',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.error,
      properties: {'type': 'basic'},
    ),
    const ShowcaseItem(
      id: 'error_network',
      title: 'Network Error',
      description: 'Error display for network connectivity issues',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.error,
      properties: {'type': 'network'},
    ),
    const ShowcaseItem(
      id: 'error_validation',
      title: 'Validation Error',
      description: 'Error display for form validation failures',
      category: ShowcaseCategory.feedback,
      componentType: ComponentType.error,
      properties: {'type': 'validation'},
    ),

    // Data Models & Freezed Examples
    const ShowcaseItem(
      id: 'freezed_entity',
      title: 'Freezed Entity',
      description: 'Demonstrates Freezed entity with immutability and code generation',
      category: ShowcaseCategory.dataModels,
      componentType: ComponentType.freezedEntity,
      properties: {'entityType': 'showcase'},
    ),
    const ShowcaseItem(
      id: 'json_serialization',
      title: 'JSON Serialization',
      description: 'Shows automatic JSON serialization with Freezed entities',
      category: ShowcaseCategory.dataModels,
      componentType: ComponentType.jsonSerialization,
      properties: {'entityType': 'appInfo'},
    ),
    const ShowcaseItem(
      id: 'copy_with_example',
      title: 'CopyWith Method',
      description: 'Demonstrates immutable updates using copyWith method',
      category: ShowcaseCategory.dataModels,
      componentType: ComponentType.entityCopyWith,
      properties: {'entityType': 'locale'},
    ),
  ];

  @override
  Future<List<ShowcaseItem>> getAllItems() async => _showcaseItems;

  @override
  Future<List<ShowcaseItem>> getItemsByCategory(ShowcaseCategory category) async => _showcaseItems.where((item) => item.category == category).toList();

  @override
  Future<List<ShowcaseItem>> searchItems(String query) async {
    final lowercaseQuery = query.toLowerCase();
    return _showcaseItems.where((item) => item.title.toLowerCase().contains(lowercaseQuery) ||
          item.description.toLowerCase().contains(lowercaseQuery) ||
          item.id.toLowerCase().contains(lowercaseQuery)).toList();
  }
}
