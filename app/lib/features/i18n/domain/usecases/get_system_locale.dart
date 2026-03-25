import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/locale_entity.dart';
import '../repositories/locale_repository.dart';

/// Use case for getting the system locale
@lazySingleton
class GetSystemLocale implements UseCase<LocaleEntity, NoParams> {
  /// Creates use case with repository dependency
  const GetSystemLocale(this.repository);

  /// Repository for locale operations
  final LocaleRepository repository;

  @override
  /// Execute the use case to get the system locale
  Future<Either<Failure, LocaleEntity>> call(NoParams params) async => repository.getSystemLocale();
}
