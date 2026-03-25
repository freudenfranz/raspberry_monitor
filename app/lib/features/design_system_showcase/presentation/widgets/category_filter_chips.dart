import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/presentation/bloc/showcase_bloc.dart';

/// Widget displaying horizontal filter chips for showcase categories
class CategoryFilterChips extends StatelessWidget {
  /// Creates category filter chips widget
  const CategoryFilterChips({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<ShowcaseBloc, ShowcaseState>(
      builder: (context, state) {
        ShowcaseCategory? selectedCategory;

        if (state is ShowcaseLoaded) {
          selectedCategory = state.selectedCategory;
        }

        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              // All filter chip
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ShowcaseBloc>().add(const LoadShowcaseItems());
                    }
                  },
                ),
              ),

              // Category filter chips
              ...ShowcaseCategory.values.map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(_getCategoryDisplayName(context, category)),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<ShowcaseBloc>().add(FilterItemsByCategory(category));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

  String _getCategoryDisplayName(BuildContext context, ShowcaseCategory category) {
    final l10n = AppLocalizations.of(context)!;

    switch (category) {
      case ShowcaseCategory.colors:
        return l10n.categoryName('Colors');
      case ShowcaseCategory.typography:
        return l10n.categoryName('Typography');
      case ShowcaseCategory.spacing:
        return l10n.categoryName('Spacing');
      case ShowcaseCategory.buttons:
        return l10n.categoryName('Buttons');
      case ShowcaseCategory.inputs:
        return l10n.categoryName('Inputs');
      case ShowcaseCategory.feedback:
        return l10n.categoryName('Feedback');
      case ShowcaseCategory.navigation:
        return l10n.categoryName('Navigation');
      case ShowcaseCategory.layout:
        return l10n.categoryName('Layout');
      case ShowcaseCategory.dataModels:
        return l10n.categoryName('Data Models');
    }
  }
}
