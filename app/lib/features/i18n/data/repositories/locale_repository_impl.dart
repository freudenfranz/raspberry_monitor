import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/locale_entity.dart';
import '../../domain/repositories/locale_repository.dart';
import '../datasources/locale_local_data_source.dart';
import '../datasources/locale_remote_data_source.dart';
import '../datasources/supported_locales.dart';

/// Implementation of locale repository
@LazySingleton(as: LocaleRepository)
class LocaleRepositoryImpl implements LocaleRepository {
  /// Creates repository with required dependencies
  LocaleRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  /// Local data source for locale operations
  final LocaleLocalDataSource localDataSource;
  /// Remote data source for locale operations
  final LocaleRemoteDataSource remoteDataSource;
  /// Network info service
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, LocaleEntity>> getCurrentLocale() async {
    try {
      // First try to get cached locale
      final cachedLocale = await localDataSource.getCachedLocale();

      if (cachedLocale != null) {
        return Right(cachedLocale.toEntity());
      }

      // If no cached locale, get system locale and cache it
      final systemLocale = await remoteDataSource.getSystemLocale();
      await localDataSource.cacheLocale(systemLocale.toEntity());

      return Right(systemLocale.toEntity());
    } on CacheException {
      return const Left(CacheFailure());
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> setCurrentLocale(LocaleEntity locale) async {
    try {
      await localDataSource.cacheLocale(locale);
      return const Right(true);
    } on CacheException {
      return const Left(CacheFailure());
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<LocaleEntity>>> getSupportedLocales() async {
    try {
      // Return the predefined supported locales (already LocaleEntity objects)
      final supportedLocales = SupportedLocales.all;
      return Right(supportedLocales);
    } on Exception {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LocaleEntity>> getSystemLocale() async {
    try {
      final systemLocale = await remoteDataSource.getSystemLocale();
      return Right(systemLocale.toEntity());
    } on Exception {
      return const Left(ServerFailure());
    }
  }
}
