import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

import '/features/design_system_showcase/presentation/bloc/showcase_bloc.dart';
import '/features/design_system_showcase/presentation/widgets/category_filter_chips.dart';
import '/features/design_system_showcase/presentation/widgets/showcase_item_card.dart';
import '/injection.dart';

/// Main page for design system showcase
class ShowcasePage extends StatelessWidget {
  /// Creates the showcase page
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<ShowcaseBloc>(
      create: (context) => getIt<ShowcaseBloc>()..add(const LoadShowcaseItems()),
      child: const ShowcaseView(),
    );
}

/// View widget for showcase content
class ShowcaseView extends StatefulWidget {
  /// Creates the showcase view
  const ShowcaseView({super.key});

  @override
  State<ShowcaseView> createState() => _ShowcaseViewState();
}

class _ShowcaseViewState extends State<ShowcaseView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.designSystemShowcase),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search design system components...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ShowcaseBloc>().add(const LoadShowcaseItems());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onChanged: (query) {
                if (query.trim().isEmpty) {
                  context.read<ShowcaseBloc>().add(const LoadShowcaseItems());
                } else {
                  context.read<ShowcaseBloc>().add(SearchShowcaseItems(query.trim()));
                }
              },
            ),
          ),

          // Category Filters
          const CategoryFilterChips(),

          // Showcase Items Grid
          Expanded(
            child: BlocBuilder<ShowcaseBloc, ShowcaseState>(
              builder: (context, state) {
                if (state is ShowcaseInitial) {
                  return Center(
                    child: Text(l10n.designSystemDescription),
                  );
                } else if (state is ShowcaseLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ShowcaseLoaded) {
                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No items found',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or filters',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: _getChildAspectRatio(context),
                    ),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) => ShowcaseItemCard(item: state.items[index]),
                  );
                } else if (state is ShowcaseError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading showcase items',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ShowcaseBloc>().add(const LoadShowcaseItems());
                          },
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      return 4;
    } else if (screenWidth > 800) {
      return 3;
    } else if (screenWidth > 600) {
      return 2;
    } else {
      return 1;
    }
  }

  double _getChildAspectRatio(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 800) {
      return 1.2;
    } else {
      return 1;
    }
  }
}
