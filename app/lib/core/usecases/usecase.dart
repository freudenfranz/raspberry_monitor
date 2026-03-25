import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../error/failures.dart';

/// Base class for all use cases following the ResoCoder Clean Architecture pattern
///
/// Use cases contain business logic and orchestrate the flow of data to and from entities
/// They are independent of any framework or UI concerns
// ignore: one_member_abstracts
abstract class UseCase<T, Params> {
  /// Execute the use case with the given parameters
  Future<Either<Failure, T>> call(Params params);
}

/// Represents the case where a use case doesn't need any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
