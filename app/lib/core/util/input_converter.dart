import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Utility class for converting and validating input strings
/// Following the ResoCoder Clean Architecture pattern
class InputConverter {
  /// Converts a string to an unsigned integer
  /// Returns [Right] with the integer if successful
  /// Returns [Left] with [InvalidInputFailure] if the string is invalid
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw const FormatException();
      }
      return Right(integer);
    } on FormatException {
      return const Left(InvalidInputFailure());
    }
  }

  /// Validates an email address
  Either<Failure, String> validateEmail(String email) {
    const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    if (RegExp(emailRegex).hasMatch(email)) {
      return Right(email);
    }
    return const Left(InvalidInputFailure());
  }

  /// Validates a non-empty string
  Either<Failure, String> validateNonEmpty(String str) {
    if (str.trim().isEmpty) {
      return const Left(InvalidInputFailure());
    }
    return Right(str);
  }
}
