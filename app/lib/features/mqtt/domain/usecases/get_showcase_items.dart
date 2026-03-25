import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '/core/error/failures.dart';
import '/core/usecases/usecase.dart';
import '/features/design_system_showcase/domain/entities/showcase_item.dart';
import '/features/design_system_showcase/domain/repositories/showcase_repository.dart';

/// Use case for getting all showcase items
@lazySingleton
class GetShowcaseItems implements UseCase<List<ShowcaseItem>, NoParams> {

  /// Creates use case with required repository
  GetShowcaseItems({required this.repository});
  /// Repository for showcase operations
  final ShowcaseRepository repository;

  @override
  /// Execute the use case to get all showcase items
  Future<Either<Failure, List<ShowcaseItem>>> call([NoParams? params]) async => repository.getAllItems();
}
