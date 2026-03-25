import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '/core/error/exceptions.dart';
import '/core/error/failures.dart';
import '/features/design_system_showcase/data/datasources/showcase_local_datasource.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/domain/repositories/showcase_repository.dart';

/// Implementation of showcase repository using local data source
@LazySingleton(as: ShowcaseRepository)
class ShowcaseRepositoryImpl implements ShowcaseRepository {

  /// Creates repository with required local data source
  ShowcaseRepositoryImpl({
    required this.localDataSource,
  });
  /// Local data source for showcase items
  final ShowcaseLocalDataSource localDataSource;

  @override
  Future<Either<Failure, List<ShowcaseItem>>> getAllItems() async {
    try {
      final items = await localDataSource.getAllItems();
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShowcaseItem>>> getItemsByCategory(
    ShowcaseCategory category,
  ) async {
    try {
      final items = await localDataSource.getItemsByCategory(category);
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShowcaseItem>>> searchItems(String query) async {
    try {
      final items = await localDataSource.searchItems(query);
      return Right(items);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<ShowcaseCategory>>> getShowcaseCategories() async {
    try {
      final items = await localDataSource.getAllItems();
      final categories = items.map((item) => item.category).toSet().toList();
      return Right(categories);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
