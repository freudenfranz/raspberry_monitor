import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/locale_entity.dart';
import '../repositories/locale_repository.dart';

/// Use case for setting the current locale
@lazySingleton
class SetCurrentLocale implements UseCase<bool, SetCurrentLocaleParams> {
  /// Creates use case with repository dependency
  const SetCurrentLocale(this.repository);

  /// Repository for locale operations
  final LocaleRepository repository;

  @override
  /// Execute the use case to set the current locale
  Future<Either<Failure, bool>> call(SetCurrentLocaleParams params) async => repository.setCurrentLocale(params.locale);
}

/// Parameters for setting the current locale
class SetCurrentLocaleParams extends Equatable {
  /// Creates params with required locale
  const SetCurrentLocaleParams({required this.locale});

  /// The locale to set as current
  final LocaleEntity locale;

  @override
  List<Object> get props => [locale];
}
