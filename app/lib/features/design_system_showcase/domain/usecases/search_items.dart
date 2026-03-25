import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/domain/repositories/showcase_repository.dart';

/// Use case for searching showcase items by query
@lazySingleton
class SearchItems implements UseCase<List<ShowcaseItem>, SearchParams> {

  /// Creates use case with required repository
  SearchItems({required this.repository});
  /// Repository for showcase operations
  final ShowcaseRepository repository;

  @override
  /// Execute the use case to search for showcase items
  Future<Either<Failure, List<ShowcaseItem>>> call([SearchParams? params]) async {
    if (params == null) {
      return const Left(InvalidInputFailure());
    }
    return repository.searchItems(params.query);
  }
}

/// Parameters for search-based item retrieval
class SearchParams extends Equatable {

  /// Creates params with required search query
  const SearchParams({required this.query});
  /// The search query string
  final String query;

  @override
  List<Object> get props => [query];
}
