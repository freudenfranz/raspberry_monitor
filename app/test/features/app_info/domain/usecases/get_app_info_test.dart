import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:raspberry_monitor/core/error/failures.dart';
import 'package:raspberry_monitor/core/usecases/usecase.dart';
import 'package:raspberry_monitor/features/app_info/domain/entities/app_info_entity.dart';
import 'package:raspberry_monitor/features/app_info/domain/repositories/app_info_repository.dart';
import 'package:raspberry_monitor/features/app_info/domain/usecases/get_app_info.dart';

import 'get_app_info_test.mocks.dart';

@GenerateMocks([AppInfoRepository])
void main() {
  late GetAppInfo usecase;
  late MockAppInfoRepository mockAppInfoRepository;

  setUp(() {
    mockAppInfoRepository = MockAppInfoRepository();
    usecase = GetAppInfo(mockAppInfoRepository);
  });

  const tAppInfoEntity = AppInfoEntity(
    appName: 'Test App',
    packageName: 'com.test.app',
    version: '1.0.0',
    buildNumber: '1',
  );

  test('should get app info from the repository', () async {
    // Arrange
    when(
      mockAppInfoRepository.getAppInfo(),
    ).thenAnswer((_) async => const Right(tAppInfoEntity));

    // Act
    final result = await usecase(NoParams());

    // Assert
    expect(result, const Right(tAppInfoEntity));
    verify(mockAppInfoRepository.getAppInfo());
    verifyNoMoreInteractions(mockAppInfoRepository);
  });

  test(
    'should return a failure when the repository call is unsuccessful',
    () async {
      // Arrange
      when(mockAppInfoRepository.getAppInfo()).thenAnswer(
        (_) async => const Left(ServerFailure(userMessage: 'Server Error')),
      );

      // Act
      final result = await usecase(NoParams());

      // Assert
      expect(result, const Left(ServerFailure(userMessage: 'Server Error')));
      verify(mockAppInfoRepository.getAppInfo());
      verifyNoMoreInteractions(mockAppInfoRepository);
    },
  );
}
