/// Spacing and sizing constants for consistent design
class AppSpacing {
  // Base spacing unit (8dp system)
  /// Extra small spacing (4dp)
  static const double xs = 4;
  /// Small spacing (8dp)
  static const double sm = 8;
  /// Medium spacing (16dp)
  static const double md = 16;
  /// Large spacing (24dp)
  static const double lg = 24;
  /// Extra large spacing (32dp)
  static const double xl = 32;
  /// Double extra large spacing (48dp)
  static const double xxl = 48;
  /// Triple extra large spacing (64dp)
  static const double xxxl = 64;

  // Specific use case spacing
  /// Small padding value
  static const double paddingSmall = sm;
  /// Medium padding value
  static const double paddingMedium = md;
  /// Large padding value
  static const double paddingLarge = lg;

  /// Small margin value
  static const double marginSmall = sm;
  /// Medium margin value
  static const double marginMedium = md;
  /// Large margin value
  static const double marginLarge = lg;

  // Component specific spacing
  /// Standard button padding
  static const double buttonPadding = md;
  /// Standard card padding
  static const double cardPadding = md;
  /// Standard list item padding
  static const double listItemPadding = md;

  // Layout spacing
  /// Spacing between sections
  static const double sectionSpacing = lg;
  /// Spacing between items
  static const double itemSpacing = md;
  /// Spacing between elements
  static const double elementSpacing = sm;
}

/// Border radius constants for consistent design
class AppBorderRadius {
  /// Small border radius (4dp)
  static const double small = 4;
  /// Medium border radius (8dp)
  static const double medium = 8;
  /// Large border radius (12dp)
  static const double large = 12;
  /// Extra large border radius (16dp)
  static const double extraLarge = 16;

  // Component specific radius
  /// Border radius for buttons
  static const double button = medium;
  /// Border radius for cards
  static const double card = large;
  /// Border radius for dialogs
  static const double dialog = extraLarge;
  /// Border radius for text fields
  static const double textField = medium;
  /// Border radius for input fields
  static const double input = medium;  // Added missing property
  /// Border radius for chips
  static const double chip = medium;   // Added missing property

  // Circular radius for circular elements
  /// Circular border radius
  static const double circular = 50;
}

/// Elevation levels for Material Design
class AppElevation {
  /// No shadow elevation
  static const double level0 = 0;  // No shadow
  /// Cards at rest elevation
  static const double level1 = 1;  // Cards at rest
  /// Cards raised elevation
  static const double level2 = 3;  // Cards raised
  /// Navigation drawer, modal bottom sheet elevation
  static const double level3 = 6;  // Navigation drawer, modal bottom sheet
  /// Navigation drawer modal elevation
  static const double level4 = 8;  // Navigation drawer modal
  /// App bar, bottom app bar elevation
  static const double level5 = 12; // App bar, bottom app bar
}

/// Icon sizes for consistent iconography
class AppIconSize {
  /// Small icon size (16dp)
  static const double small = 16;
  /// Medium icon size (24dp)
  static const double medium = 24;
  /// Large icon size (32dp)
  static const double large = 32;
  /// Extra large icon size (48dp)
  static const double extraLarge = 48;
}


/// Animation durations for consistent motion
class AppAnimationDuration {
  /// Fast animation duration (150ms)
  static const Duration fast = Duration(milliseconds: 150);
  /// Medium animation duration (300ms)
  static const Duration medium = Duration(milliseconds: 300);
  /// Slow animation duration (500ms)
  static const Duration slow = Duration(milliseconds: 500);
}
