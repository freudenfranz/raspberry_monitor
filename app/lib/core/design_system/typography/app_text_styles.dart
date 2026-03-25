import 'package:flutter/material.dart';

/// Typography styles for the application
/// Based on Material 3 design system with custom adjustments
class AppTextStyles {
  // Display styles (headings)
  /// Largest heading style (32px, bold)
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  /// Second largest heading style (28px, bold)
  static const TextStyle h2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    height: 1.2,
  );

  /// Third heading style (24px, semibold)
  static const TextStyle h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  /// Fourth heading style (20px, semibold)
  static const TextStyle h4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.3,
  );

  /// Fifth heading style (18px, semibold)
  static const TextStyle h5 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  /// Smallest heading style (16px, semibold)
  static const TextStyle h6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Body styles
  /// Large body text style (16px, normal)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.15,
    height: 1.5,
  );

  /// Medium body text style (14px, normal)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.4,
  );

  /// Small body text style (12px, normal)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.3,
  );

  // Label styles (for buttons, form labels)
  /// Large label style (14px, medium)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  /// Medium label style (12px, medium)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  /// Small label style (11px, medium)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  // Caption and overline
  /// Caption text style (12px, normal)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.3,
  );

  /// Overline text style (10px, medium)
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.6,
  );

  // Button text styles
  /// Button text style (14px, medium)
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
    height: 1.4,
  );
}

/// Font weights used throughout the application
class AppFontWeights {
  /// Thin font weight (100)
  static const FontWeight thin = FontWeight.w100;
  /// Extra light font weight (200)
  static const FontWeight extraLight = FontWeight.w200;
  /// Light font weight (300)
  static const FontWeight light = FontWeight.w300;
  /// Regular font weight (400)
  static const FontWeight regular = FontWeight.w400;
  /// Medium font weight (500)
  static const FontWeight medium = FontWeight.w500;
  /// Semi bold font weight (600)
  static const FontWeight semiBold = FontWeight.w600;
  /// Bold font weight (700)
  static const FontWeight bold = FontWeight.w700;
  /// Extra bold font weight (800)
  static const FontWeight extraBold = FontWeight.w800;
  /// Black font weight (900)
  static const FontWeight black = FontWeight.w900;
}
