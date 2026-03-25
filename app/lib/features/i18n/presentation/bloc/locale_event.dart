import 'package:equatable/equatable.dart';

import '../../domain/entities/locale_entity.dart';

/// Events for LocaleBloc
sealed class LocaleEvent extends Equatable {
  /// Creates a new locale event
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

/// Event dispatched to load the user's currently active locale,
/// typically from local storage or system settings.
final class LoadCurrentLocale extends LocaleEvent {
  /// Creates a new [LoadCurrentLocale] event.
  const LoadCurrentLocale();
}

/// Event to change the current locale
final class ChangeLocale extends LocaleEvent {
  /// Creates change locale event with new locale
  const ChangeLocale(this.locale);

  /// The new locale to change to
  final LocaleEntity locale;

  @override
  List<Object?> get props => [locale];
}

/// Event dispatched to load the list of all supported locales for the app.
final class LoadSupportedLocales extends LocaleEvent {
  /// Creates a new [LoadSupportedLocales] event.
  const LoadSupportedLocales();
}
