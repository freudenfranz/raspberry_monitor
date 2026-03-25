import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_info_entity.dart';
import '../../domain/repositories/app_info_repository.dart';
import '../datasources/app_info_remote_data_source.dart';

/// Implementation of AppInfoRepository
@LazySingleton(as: AppInfoRepository)
class AppInfoRepositoryImpl implements AppInfoRepository {
  /// Creates repository with required data source
  const AppInfoRepositoryImpl({
    required this.remoteDataSource,
  });

  /// Remote data source for app information
  final AppInfoRemoteDataSource remoteDataSource;

  @override
  /// Get the application information from remote data source
  /// Catches specific exceptions and maps them to appropriate failures
  Future<Either<Failure, AppInfoEntity>> getAppInfo() async {
    try {
      final appInfo = await remoteDataSource.getAppInfo();
      return Right(appInfo.toEntity());
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          technicalDetails: e.message,
        ),
      );
    } on TimeoutException catch (e) {
      return Left(
        TimeoutFailure(
          technicalDetails: e.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          userMessage: 'Server error (${e.statusCode ?? 'unknown'})',
          technicalDetails: e.message,
        ),
      );
    } on DataParseException catch (e) {
      return Left(
        DataParseFailure(
          technicalDetails: e.message,
        ),
      );
    } on Exception catch (e) {
      return Left(
        ServerFailure(
          userMessage: 'An unexpected error occurred',
          technicalDetails: e.toString(),
        ),
      );
    }
  }
}
