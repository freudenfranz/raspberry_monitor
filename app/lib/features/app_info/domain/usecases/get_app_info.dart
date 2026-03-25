import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_info_entity.dart';
import '../repositories/app_info_repository.dart';

/// Use case for getting app information
@lazySingleton
class GetAppInfo implements UseCase<AppInfoEntity, NoParams> {
  /// Creates use case with repository dependency
  const GetAppInfo(this.repository);

  /// Repository for app info operations
  final AppInfoRepository repository;

  @override
  /// Execute the use case to get application information
  Future<Either<Failure, AppInfoEntity>> call(NoParams params) async => repository.getAppInfo();
}
