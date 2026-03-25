import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/domain/repositories/showcase_repository.dart';

/// Use case for getting showcase items filtered by category
@lazySingleton
class GetItemsByCategory implements UseCase<List<ShowcaseItem>, CategoryParams> {

  /// Creates use case with required repository
  GetItemsByCategory({required this.repository});
  /// Repository for showcase operations
  final ShowcaseRepository repository;

  @override
  /// Execute the use case to get showcase items filtered by category
  Future<Either<Failure, List<ShowcaseItem>>> call([CategoryParams? params]) async {
    if (params == null) {
      return const Left(InvalidInputFailure());
    }
    return repository.getItemsByCategory(params.category);
  }
}

/// Parameters for category-based item retrieval
class CategoryParams extends Equatable {

  /// Creates params with required category
  const CategoryParams({required this.category});
  /// The category to filter by
  final ShowcaseCategory category;

  @override
  List<Object> get props => [category];
}
