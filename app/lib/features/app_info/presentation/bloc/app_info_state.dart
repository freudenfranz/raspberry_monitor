import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/app_info_entity.dart';

part 'app_info_state.freezed.dart';

/// States for AppInfoBloc
@freezed
sealed class AppInfoState with _$AppInfoState {
  /// Initial state
  const factory AppInfoState.initial() = AppInfoInitial;

  /// Loading state
  const factory AppInfoState.loading() = AppInfoLoading;

  /// Loaded state with app information
  const factory AppInfoState.loaded({
    /// The loaded app information
    required AppInfoEntity appInfo,
  }) = AppInfoLoaded;

  /// Error state
  const factory AppInfoState.error({
    /// Error message describing what went wrong
    required String message,
  }) = AppInfoError;
}
