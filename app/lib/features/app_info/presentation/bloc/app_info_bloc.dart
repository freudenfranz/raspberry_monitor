import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_app_info.dart';




import 'app_info_event.dart';
import 'app_info_state.dart';

export 'app_info_event.dart';
export 'app_info_state.dart';

/// BLoC for managing app information state
@injectable
class AppInfoBloc extends Bloc<AppInfoEvent, AppInfoState> {
  /// Creates bloc with required dependencies
  AppInfoBloc({
    required this.getAppInfo,
  }) : super(const AppInfoInitial()) {
    on<LoadAppInfo>(_onLoadAppInfo);
  }

  /// Use case for getting app information
  final GetAppInfo getAppInfo;

  Future<void> _onLoadAppInfo(
    LoadAppInfo event,
    Emitter<AppInfoState> emit,
  ) async {
    emit(const AppInfoLoading());

    final result = await getAppInfo(NoParams());

    result.fold(
      (failure) => emit(AppInfoError(message: _mapFailureToMessage(failure))),
      (appInfo) => emit(AppInfoLoaded(appInfo: appInfo)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType.toString()) {
      case 'ServerFailure':
        return failure.userMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
