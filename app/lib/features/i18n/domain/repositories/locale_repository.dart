import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/locale_entity.dart';

/// Repository interface for locale management
abstract class LocaleRepository {
  /// Get the currently selected locale
  Future<Either<Failure, LocaleEntity>> getCurrentLocale();

  /// Set the current locale
  Future<Either<Failure, bool>> setCurrentLocale(LocaleEntity locale);

  /// Get all supported locales
  Future<Either<Failure, List<LocaleEntity>>> getSupportedLocales();

  /// Get the system/device locale
  Future<Either<Failure, LocaleEntity>> getSystemLocale();
}
