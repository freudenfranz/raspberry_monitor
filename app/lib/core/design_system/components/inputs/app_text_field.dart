import 'package:flutter/material.dart';
import '../../spacing/app_spacing.dart';
import '../../typography/app_text_styles.dart';

/// Custom text input that follows the design system
class AppTextField extends StatelessWidget {
  /// Creates a text field with design system styling
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.focusNode,
  });

  /// Controller for the text field
  final TextEditingController? controller;
  /// Label text displayed above the field
  final String? label;
  /// Hint text displayed when field is empty
  final String? hintText;
  /// Helper text displayed below the field
  final String? helperText;
  /// Error text displayed when validation fails
  final String? errorText;
  /// Widget displayed at the beginning of the field
  final Widget? prefixIcon;
  /// Widget displayed at the end of the field
  final Widget? suffixIcon;
  /// Whether the text should be obscured (for passwords)
  final bool obscureText;
  /// Whether the field is enabled for input
  final bool enabled;
  /// Whether the field is read-only
  final bool readOnly;
  /// Maximum number of lines for the input
  final int? maxLines;
  /// Type of keyboard to display
  final TextInputType? keyboardType;
  /// Action button to show on keyboard
  final TextInputAction? textInputAction;
  /// Callback when text changes
  final ValueChanged<String>? onChanged;
  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;
  /// Function to validate the input
  final String? Function(String?)? validator;
  /// Focus node for managing focus
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
        validator: validator,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.textField),
            borderSide: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.38),
            ),
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.md),
        ),
      );
}

/// Custom search input with search icon
class AppSearchField extends StatelessWidget {
  /// Creates a search field with search icon and clear functionality
  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  /// Controller for the search field
  final TextEditingController? controller;
  /// Hint text displayed when field is empty
  final String hintText;
  /// Callback when text changes
  final ValueChanged<String>? onChanged;
  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;
  /// Callback when clear button is pressed
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => AppTextField(
        controller: controller,
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              )
            : null,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.search,
      );
}
