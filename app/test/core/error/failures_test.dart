import 'package:flutter_test/flutter_test.dart';
import 'package:raspberry_monitor/core/error/failures.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('should be a subclass of Failure', () {
        // arrange & act
        const failure = ServerFailure();

        // assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props', () {
        // arrange & act
        const failure = ServerFailure(
          userMessage: 'uMsg',
          technicalDetails: 'techDetails',
        );

        // assert
        expect(failure.props, equals(['uMsg', 'techDetails']));
      });
    });

    group('CacheFailure', () {
      test('should be a subclass of Failure', () {
        // arrange & act
        const failure = CacheFailure();

        // assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props', () {
        // arrange & act
        const failure = CacheFailure(
          userMessage: 'uMsg',
          technicalDetails: 'techDetails',
        );

        // assert
        expect(failure.props, equals(['uMsg', 'techDetails']));
      });
    });

    group('NetworkFailure', () {
      test('should be a subclass of Failure', () {
        // arrange & act
        const failure = NetworkFailure();

        // assert
        expect(failure, isA<Failure>());
      });

      test('should have correct props', () {
        // arrange & act
        const failure = NetworkFailure(
          userMessage: 'uMsg',
          technicalDetails: 'techDetails',
        );

        // assert
        expect(failure.props, equals(['uMsg', 'techDetails']));
      });
    });
  });
}
