import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:raspberry_monitor/core/error/failures.dart';
import 'package:raspberry_monitor/features/app_info/domain/entities/app_info_entity.dart';
import 'package:raspberry_monitor/features/app_info/domain/usecases/get_app_info.dart';
import 'package:raspberry_monitor/features/app_info/presentation/bloc/app_info_bloc.dart';

// Generate a mock for the UseCase
import 'app_info_bloc_test.mocks.dart';

@GenerateMocks([GetAppInfo])
void main() {
  late AppInfoBloc bloc;
  late MockGetAppInfo mockGetAppInfo;

  setUp(() {
    mockGetAppInfo = MockGetAppInfo();
    bloc = AppInfoBloc(getAppInfo: mockGetAppInfo);
  });

  const tAppInfo = AppInfoEntity(
    appName: 'Test App',
    packageName: 'com.test',
    version: '1.0.0',
    buildNumber: '1',
  );

  group('AppInfoBloc', () {
    test('initial state should be AppInfoInitial', () {
      expect(bloc.state, const AppInfoState.initial());
    });

    blocTest<AppInfoBloc, AppInfoState>(
      'emits [loading, loaded] when LoadAppInfo is added and succeeds',
      build: () {
        when(
          mockGetAppInfo(any),
        ).thenAnswer((_) async => const Right(tAppInfo));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAppInfo()),
      expect: () => [
        const AppInfoState.loading(),
        const AppInfoState.loaded(appInfo: tAppInfo),
      ],
    );

    blocTest<AppInfoBloc, AppInfoState>(
      'emits [loading, error] when LoadAppInfo fails',
      build: () {
        when(mockGetAppInfo(any)).thenAnswer(
          (_) async => const Left(ServerFailure(userMessage: 'Server Error')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadAppInfo()),
      expect: () => [
        const AppInfoState.loading(),
        const AppInfoState.error(message: 'Server Error'),
      ],
    );
  });
}
