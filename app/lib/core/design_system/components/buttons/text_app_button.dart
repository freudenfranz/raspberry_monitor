import 'package:flutter/material.dart';

/// Text button variant of AppButton
class TextAppButton extends StatelessWidget {
  /// Creates a text app button
  const TextAppButton({
    required this.onPressed,
    required this.isLoading,
    required this.minWidth,
    required this.height,
    required this.horizontalPadding,
    required this.buttonContent,
    super.key,
  });

  /// Callback for button press
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Minimum width of the button
  final double minWidth;

  /// Height of the button
  final double height;

  /// Horizontal padding for the button
  final double horizontalPadding;

  /// Content widget to display in the button
  final Widget buttonContent;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(minWidth, height),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        ),
        child: buttonContent,
      );
}
