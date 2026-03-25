import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/app_info_model.dart';

/// Abstract data source interface for app information
// ignore: one_member_abstracts
abstract class AppInfoRemoteDataSource {
  /// Get app information from the platform
  Future<AppInfoModel> getAppInfo();
}

/// Implementation of AppInfoRemoteDataSource using package_info_plus
@LazySingleton(as: AppInfoRemoteDataSource)
class AppInfoRemoteDataSourceImpl implements AppInfoRemoteDataSource {
  @override
  /// Get app information from the platform using package_info_plus
  Future<AppInfoModel> getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return AppInfoModel.fromPlatformData(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      buildSignature: packageInfo.buildSignature.isNotEmpty
          ? packageInfo.buildSignature
          : null,
      installerStore: packageInfo.installerStore?.isNotEmpty == true
          ? packageInfo.installerStore
          : null,
    );
  }
}
