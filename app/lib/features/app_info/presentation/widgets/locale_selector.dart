import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../i18n/domain/entities/locale_entity.dart';
import '../../../i18n/presentation/bloc/locale_bloc.dart';

/// Widget that allows users to select their preferred language
class LocaleSelector extends StatelessWidget {
  /// Creates a locale selector widget
  const LocaleSelector({super.key});

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language_outlined,
                  size: AppIconSize.medium,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Language / Sprache',
                  style: AppTextStyles.h6,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<LocaleBloc, LocaleState>(
              builder: (context, state) {
                if (state is LocaleLoading) {
                  return const AppLoadingIndicator(
                    size: 32,
                    message: 'Loading languages...',
                  );
                }

                if (state is LocaleError) {
                  return AppErrorMessage(
                    message: state.message,
                    onRetry: () {
                      context.read<LocaleBloc>().add(const LoadCurrentLocale());
                    },
                  );
                }

                if (state is LocaleLoaded) {
                  return Column(
                    children: state.supportedLocales.map((locale) {
                      final isSelected = locale.languageCode ==
                          state.currentLocale.languageCode;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs),
                        child: _LocaleOption(
                          locale: locale,
                          isSelected: isSelected,
                          onTap: () {
                            if (!isSelected) {
                              context
                                  .read<LocaleBloc>()
                                  .add(ChangeLocale(locale));
                            }
                          },
                        ),
                      );
                    }).toList(),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
}

/// Private widget for individual locale selection option
class _LocaleOption extends StatelessWidget {
  /// Creates a locale option widget
  const _LocaleOption({
    required this.locale,
    required this.isSelected,
    required this.onTap,
  });

  /// The locale entity to display
  final LocaleEntity locale;
  /// Whether this locale is currently selected
  final bool isSelected;
  /// Callback when the option is tapped
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.medium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: AppIconSize.small,
                color: theme.colorScheme.primary,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                size: AppIconSize.small,
                color: theme.colorScheme.outline,
              ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.nativeName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (locale.displayName != locale.nativeName) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      locale.displayName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                                .withValues(alpha: 0.7)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Text(
              locale.languageCode.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
