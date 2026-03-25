import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '/core/usecases/usecase.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/domain/usecases/get_items_by_category.dart';
import '/features/design_system_showcase/domain/usecases/get_showcase_items.dart';
import '/features/design_system_showcase/domain/usecases/search_items.dart';
import 'showcase_event.dart';

export 'showcase_event.dart';
part 'showcase_bloc.freezed.dart';
part 'showcase_state.dart';

/// BLoC for managing showcase state and operations
@injectable
class ShowcaseBloc extends Bloc<ShowcaseEvent, ShowcaseState> {

  /// Creates bloc with required use case dependencies
  ShowcaseBloc({
    required this.getShowcaseItems,
    required this.getItemsByCategory,
    required this.searchItems,
  }) : super(const ShowcaseState.initial()) {
    on<LoadShowcaseItems>(_onLoadShowcaseItems);
    on<FilterItemsByCategory>(_onFilterItemsByCategory);
    on<SearchShowcaseItems>(_onSearchShowcaseItems);
  }
  /// Use case for getting all showcase items
  final GetShowcaseItems getShowcaseItems;
  /// Use case for filtering items by category
  final GetItemsByCategory getItemsByCategory;
  /// Use case for searching items
  final SearchItems searchItems;

  Future<void> _onLoadShowcaseItems(
    LoadShowcaseItems event,
    Emitter<ShowcaseState> emit,
  ) async {
    emit(const ShowcaseState.loading());

    try {
      final result = await getShowcaseItems(NoParams());
      result.fold(
        (failure) => emit(ShowcaseState.error(failure.userMessage)),
        (items) => emit(ShowcaseState.loaded(items: items)),
      );
    } on Exception catch (e) {
      emit(ShowcaseState.error(e.toString()));
    }
  }

  Future<void> _onFilterItemsByCategory(
    FilterItemsByCategory event,
    Emitter<ShowcaseState> emit,
  ) async {
    emit(const ShowcaseState.loading());

    try {
      final result = await getItemsByCategory(CategoryParams(category: event.category));
      result.fold(
        (failure) => emit(ShowcaseState.error(failure.userMessage)),
        (items) => emit(ShowcaseState.loaded(items: items, selectedCategory: event.category)),
      );
    } on Exception catch (e) {
      emit(ShowcaseState.error(e.toString()));
    }
  }

  Future<void> _onSearchShowcaseItems(
    SearchShowcaseItems event,
    Emitter<ShowcaseState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      add(const LoadShowcaseItems());
      return;
    }

    emit(const ShowcaseState.loading());

    try {
      final result = await searchItems(SearchParams(query: event.query));
      result.fold(
        (failure) => emit(ShowcaseState.error(failure.userMessage)),
        (items) => emit(ShowcaseState.loaded(items: items)),
      );
    } on Exception catch (e) {
      emit(ShowcaseState.error(e.toString()));
    }
  }
}
