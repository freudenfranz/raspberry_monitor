import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_info_entity.dart';

/// Repository interface for app information
// ignore: one_member_abstracts
abstract class AppInfoRepository {
  /// Get the application information
  Future<Either<Failure, AppInfoEntity>> getAppInfo();
}
