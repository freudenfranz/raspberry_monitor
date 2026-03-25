import 'package:flutter/material.dart';

import '../spacing/spacing.dart';
import '../typography/typography.dart';
import 'color_palette.dart';

/// Application theme configuration
/// Creates Material 3 themes using the defined color palette
mixin AppTheme {
  /// Light theme configuration
  static ThemeData light({Color? primaryColor, Color? secondaryColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor ?? AppColorPalette.primary,
      secondary: secondaryColor ?? AppColorPalette.secondary,

      surface: AppColorPalette.surfaceLight,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Poppins',

      // Text Theme
      textTheme: _buildTextTheme(colorScheme),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3.copyWith(color: colorScheme.onSurface),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: const BorderSide(color: AppColorPalette.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        filled: true,
        fillColor: colorScheme.surface,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.card),
        ),
        elevation: 2,
        color: colorScheme.surface,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.chip),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColorPalette.borderLight,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData dark({Color? primaryColor, Color? secondaryColor}) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor ?? AppColorPalette.primary,
      secondary: secondaryColor ?? AppColorPalette.secondary,
      brightness: Brightness.dark,
      surface: AppColorPalette.surfaceDark,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      fontFamily: 'Poppins',

      // Text Theme
      textTheme: _buildTextTheme(colorScheme),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h3.copyWith(color: colorScheme.onSurface),
      ),

      // Button Themes (same as light theme)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: const BorderSide(color: AppColorPalette.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.input),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        filled: true,
        fillColor: colorScheme.surface,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.card),
        ),
        elevation: 2,
        color: colorScheme.surface,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.chip),
        ),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColorPalette.borderDark,
        thickness: 1,
        space: AppSpacing.md,
      ),
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) => TextTheme(
      displayLarge: AppTextStyles.h1.copyWith(color: colorScheme.onSurface),
      displayMedium: AppTextStyles.h2.copyWith(color: colorScheme.onSurface),
      displaySmall: AppTextStyles.h3.copyWith(color: colorScheme.onSurface),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: AppTextStyles.caption.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
}
