import 'package:flutter/material.dart';

/// Elevated button variant of AppButton
class ElevatedAppButton extends StatelessWidget {
  /// Creates an elevated app button
  const ElevatedAppButton({
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
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(minWidth, height),
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        ),
        child: buttonContent,
      );
}
