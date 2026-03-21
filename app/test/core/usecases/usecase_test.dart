import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raspberry_monitor/core/error/failures.dart';
import 'package:raspberry_monitor/core/usecases/usecase.dart';


class MockUseCase implements UseCase<String, MockParams> {
  @override
  Future<Either<Failure, String>> call(MockParams params) async => Right('Test result: ${params.value}');
}

class MockParams {
  const MockParams(this.value);
  final String value;
}

void main() {
  group('UseCase', () {
    late MockUseCase useCase;

    setUp(() {
      useCase = MockUseCase();
    });

    test('should call the use case and return result', () async {
      // arrange
      const params = MockParams('test');

      // act
      final result = await useCase(params);

      // assert
      result.fold(
        (failure) => fail('Expected Right, got Left'),
        (value) => expect(value, equals('Test result: test')),
      );
    });
  });

  group('NoParams', () {
    test('should have empty props', () {
      // arrange & act
      final noParams = NoParams();

      // assert
      expect(noParams.props, equals([]));
    });

    test('should be equal to another NoParams instance', () {
      // arrange & act
      final noParams1 = NoParams();
      final noParams2 = NoParams();

      // assert
      expect(noParams1, equals(noParams2));
    });
  });
}
