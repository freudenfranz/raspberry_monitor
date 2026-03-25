import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/locale_entity.dart';

part 'locale_state.freezed.dart';

/// States for LocaleBloc
@freezed
sealed class LocaleState with _$LocaleState {
  /// Initial state
  const factory LocaleState.initial() = LocaleInitial;

  /// Loading state
  const factory LocaleState.loading() = LocaleLoading;

  /// Loaded state with current locale and supported locales
  const factory LocaleState.loaded({
    /// The current active locale
    required LocaleEntity currentLocale,
    /// List of all supported locales
    required List<LocaleEntity> supportedLocales,
  }) = LocaleLoaded;

  /// Error state
  const factory LocaleState.error({
    /// Error message describing what went wrong
    required String message,
  }) = LocaleError;
}
