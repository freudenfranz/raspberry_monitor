import 'package:dartz/dartz.dart';
import '/core/error/failures.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';

/// Repository interface for showcase operations
abstract class ShowcaseRepository {
  /// Get all showcase items
  Future<Either<Failure, List<ShowcaseItem>>> getAllItems();
  /// Get showcase items by category
  Future<Either<Failure, List<ShowcaseItem>>> getItemsByCategory(ShowcaseCategory category);
  /// Search showcase items by query
  Future<Either<Failure, List<ShowcaseItem>>> searchItems(String query);
  /// Get all available showcase categories
  Future<Either<Failure, List<ShowcaseCategory>>> getShowcaseCategories();
}
