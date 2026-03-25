part of 'showcase_bloc.dart';

/// States for ShowcaseBloc
@freezed
class ShowcaseState with _$ShowcaseState {
  /// Initial state
  const factory ShowcaseState.initial() = ShowcaseInitial;

  /// Loading state
  const factory ShowcaseState.loading() = ShowcaseLoading;

  /// Loaded state with showcase items
  const factory ShowcaseState.loaded({
    required List<ShowcaseItem> items,
    ShowcaseCategory? selectedCategory,
  }) = ShowcaseLoaded;

  /// Error state with user-facing message
  const factory ShowcaseState.error(String message) = ShowcaseError;
}
