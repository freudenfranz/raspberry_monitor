import 'package:equatable/equatable.dart';

import '../../domain/entities/showcase_item.dart';

/// Base class for all events related to the ShowcaseBloc.
sealed class ShowcaseEvent extends Equatable {
  /// Creates a new showcase event.
  const ShowcaseEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched to load all available showcase items.
final class LoadShowcaseItems extends ShowcaseEvent {
  /// Creates a new [LoadShowcaseItems] event.
  const LoadShowcaseItems();
}

/// Event dispatched to filter the showcase items by a specific category.
final class FilterItemsByCategory extends ShowcaseEvent {
  /// Creates a new [FilterItemsByCategory] event with the given [category].
  const FilterItemsByCategory(this.category);

  /// The category to filter the showcase items by.
  final ShowcaseCategory category;

  @override
  List<Object?> get props => [category];
}

/// Event dispatched to search for showcase items matching a query string.
final class SearchShowcaseItems extends ShowcaseEvent {
  /// Creates a new [SearchShowcaseItems] event with the given [query].
  const SearchShowcaseItems(this.query);

  /// The text string to search for within the showcase items.
  final String query;

  @override
  List<Object?> get props => [query];
}
