import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/locale_entity.dart';
import '../repositories/locale_repository.dart';

/// Use case for getting all supported locales
@lazySingleton
class GetSupportedLocales implements UseCase<List<LocaleEntity>, NoParams> {
  /// Creates use case with repository dependency
  const GetSupportedLocales(this.repository);

  /// Repository for locale operations
  final LocaleRepository repository;

  @override
  /// Execute the use case to get all supported locales
  Future<Either<Failure, List<LocaleEntity>>> call(NoParams params) async => repository.getSupportedLocales();
}
