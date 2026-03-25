import 'package:flutter/material.dart';

import '../../spacing/app_spacing.dart';
import '../../typography/app_text_styles.dart';
import 'app_button_content.dart';
import 'elevated_app_button.dart';
import 'outlined_app_button.dart';
import 'text_app_button.dart';

/// Custom button that follows the design system
class AppButton extends StatelessWidget {
  /// Creates an app button with the given configuration
  const AppButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.fullWidth = false,
  });

  /// The text displayed on the button
  final String text;
  /// Callback function when button is pressed
  final VoidCallback? onPressed;
  /// Whether the button is in loading state
  final bool isLoading;
  /// The visual type of the button
  final AppButtonType type;
  /// The size of the button
  final AppButtonSize size;
  /// Optional icon to display in the button
  final IconData? icon;
  /// Whether the button should take full width
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {

    Widget button;
    final buttonContent = AppButtonContent(
      isLoading: isLoading,
      icon: icon,
      text: text,
      iconSize: _getIconSize(),
      textStyle: _getTextStyle(),
    );

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedAppButton(
          onPressed: onPressed,
          isLoading: isLoading,
          minWidth: _getMinWidth(),
          height: _getHeight(),
          horizontalPadding: _getHorizontalPadding(),
          buttonContent: buttonContent,
        );
        break;
      case AppButtonType.secondary:
        button = OutlinedAppButton(
          onPressed: onPressed,
          isLoading: isLoading,
          minWidth: _getMinWidth(),
          height: _getHeight(),
          horizontalPadding: _getHorizontalPadding(),
          buttonContent: buttonContent,
        );
        break;
      case AppButtonType.tertiary:
        button = TextAppButton(
          onPressed: onPressed,
          isLoading: isLoading,
          minWidth: _getMinWidth(),
          height: _getHeight(),
          horizontalPadding: _getHorizontalPadding(),
          buttonContent: buttonContent,
        );
        break;
    }

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 32;
      case AppButtonSize.medium:
        return 40;
      case AppButtonSize.large:
        return 48;
    }
  }

  double _getMinWidth() {
    switch (size) {
      case AppButtonSize.small:
        return 48;
      case AppButtonSize.medium:
        return 64;
      case AppButtonSize.large:
        return 80;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case AppButtonSize.small:
        return AppSpacing.sm;
      case AppButtonSize.medium:
        return AppSpacing.md;
      case AppButtonSize.large:
        return AppSpacing.lg;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppIconSize.small;
      case AppButtonSize.medium:
        return AppIconSize.medium;
      case AppButtonSize.large:
        return AppIconSize.large;
    }
  }

  TextStyle? _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.labelSmall;
      case AppButtonSize.medium:
        return AppTextStyles.labelMedium;
      case AppButtonSize.large:
        return AppTextStyles.labelLarge;
    }
  }
}

/// Button type variants
enum AppButtonType {
  /// Primary button style
  primary,
  /// Secondary button style
  secondary,
  /// Tertiary button style
  tertiary
}

/// Button size variants
enum AppButtonSize {
  /// Small button size
  small,
  /// Medium button size
  medium,
  /// Large button size
  large
}
