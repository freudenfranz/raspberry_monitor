import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_current_locale.dart';
import '../../domain/usecases/get_supported_locales.dart';
import '../../domain/usecases/set_current_locale.dart';

import 'locale_event.dart';
import 'locale_state.dart';

export 'locale_event.dart';
export 'locale_state.dart';

/// BLoC for managing locale/internationalization state
@injectable
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  /// Creates locale bloc with required dependencies
  LocaleBloc({
    required this.getCurrentLocale,
    required this.setCurrentLocale,
    required this.getSupportedLocales,
  }) : super(const LocaleInitial()) {
    on<LoadCurrentLocale>(_onLoadCurrentLocale);
    on<ChangeLocale>(_onChangeLocale);
    on<LoadSupportedLocales>(_onLoadSupportedLocales);
  }

  /// Use case for getting current locale
  final GetCurrentLocale getCurrentLocale;
  /// Use case for setting current locale
  final SetCurrentLocale setCurrentLocale;
  /// Use case for getting supported locales
  final GetSupportedLocales getSupportedLocales;

  Future<void> _onLoadCurrentLocale(
    LoadCurrentLocale event,
    Emitter<LocaleState> emit,
  ) async {
    emit(const LocaleLoading());

    final currentLocaleResult = await getCurrentLocale(NoParams());
    final supportedLocalesResult = await getSupportedLocales(NoParams());

    currentLocaleResult.fold(
      (failure) => emit(LocaleError(message: _mapFailureToMessage(failure))),
      (currentLocale) {
        supportedLocalesResult.fold(
          (failure) => emit(LocaleError(message: _mapFailureToMessage(failure))),
          (supportedLocales) => emit(
            LocaleLoaded(
              currentLocale: currentLocale,
              supportedLocales: supportedLocales,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onChangeLocale(
    ChangeLocale event,
    Emitter<LocaleState> emit,
  ) async {
    if (state is LocaleLoaded) {
      final currentState = state as LocaleLoaded;
      emit(const LocaleLoading());

      final result = await setCurrentLocale(
        SetCurrentLocaleParams(locale: event.locale),
      );

      result.fold(
        (failure) => emit(LocaleError(message: _mapFailureToMessage(failure))),
        (_) => emit(
          currentState.copyWith(currentLocale: event.locale),
        ),
      );
    }
  }

  Future<void> _onLoadSupportedLocales(
    LoadSupportedLocales event,
    Emitter<LocaleState> emit,
  ) async {
    final result = await getSupportedLocales(NoParams());

    result.fold(
      (failure) => emit(LocaleError(message: _mapFailureToMessage(failure))),
      (supportedLocales) {
        if (state is LocaleLoaded) {
          final currentState = state as LocaleLoaded;
          emit(currentState.copyWith(supportedLocales: supportedLocales));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case CacheFailure _:
        return 'Cache Failure';
      case ServerFailure _:
        return 'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
