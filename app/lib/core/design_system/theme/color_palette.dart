import 'package:flutter/material.dart';

/// Color palette for the application
/// Uses the user-defined primary and secondary colors as base
class AppColorPalette {
  // Primary Colors (customizable via brick variables)
  /// Primary brand color - customizable via brick template
  static const Color primary = Color(0xFFcd2355);
  /// Primary color variant for visual hierarchy
  static const Color primaryVariant = Color(0xFF1976D2);

  // Secondary Colors (customizable via brick variables)
  /// Secondary brand color - customizable via brick template
  static const Color secondary = Color(0xFF46af4b);
  /// Secondary color variant for visual hierarchy
  static const Color secondaryVariant = Color(0xFFF57C00);

  // Semantic Colors
  /// Success state color (green)
  static const Color success = Color(0xFF4CAF50);
  /// Warning state color (amber)
  static const Color warning = Color(0xFFFFC107);
  /// Error state color (red)
  static const Color error = Color(0xFFF44336);
  /// Info state color (cyan)
  static const Color info = Color(0xFF00BCD4);

  // Neutral Colors - Light Theme
  /// Light theme background color
  static const Color backgroundLight = Color(0xFFFAFAFA);
  /// Light theme surface color
  static const Color surfaceLight = Color(0xFFFFFFFF);
  /// Text color on light background
  static const Color onBackgroundLight = Color(0xFF212121);
  /// Text color on light surface
  static const Color onSurfaceLight = Color(0xFF424242);

  // Neutral Colors - Dark Theme
  /// Dark theme background color
  static const Color backgroundDark = Color(0xFF121212);
  /// Dark theme surface color
  static const Color surfaceDark = Color(0xFF1E1E1E);
  /// Text color on dark background
  static const Color onBackgroundDark = Color(0xFFE0E0E0);
  /// Text color on dark surface
  static const Color onSurfaceDark = Color(0xFFBDBDBD);

  // Text Colors - Light Theme
  /// Primary text color for light theme
  static const Color textPrimaryLight = Color(0xFF212121);
  /// Secondary text color for light theme
  static const Color textSecondaryLight = Color(0xFF757575);
  /// Disabled text color for light theme
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  // Text Colors - Dark Theme
  /// Primary text color for dark theme
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  /// Secondary text color for dark theme
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  /// Disabled text color for dark theme
  static const Color textDisabledDark = Color(0xFF616161);

  // Border Colors
  /// Border color for light theme
  static const Color borderLight = Color(0xFFE0E0E0);
  /// Border color for dark theme
  static const Color borderDark = Color(0xFF424242);

  // Disabled Colors
  /// Disabled element color for light theme
  static const Color disabledLight = Color(0xFFE0E0E0);
  /// Disabled element color for dark theme
  static const Color disabledDark = Color(0xFF424242);
}
