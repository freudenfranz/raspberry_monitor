import 'package:flutter/material.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';
import '../../../../core/design_system/spacing/app_spacing.dart';
import '../../../../core/design_system/typography/app_text_styles.dart';

/// Widget that displays the features list for the app info page
class AppFeaturesList extends StatelessWidget {
  /// Creates an app features list widget
  const AppFeaturesList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final features = [
      l10n.cleanArchitecture,
      l10n.designSystem,
      l10n.internationalization,
      l10n.dependencyInjection,
      l10n.stateManagement,
      l10n.testStructure,
      l10n.errorHandling,
      l10n.localStorage,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: features.map((feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      feature,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            )).toList(),
        ),
      ),
    );
  }
}
