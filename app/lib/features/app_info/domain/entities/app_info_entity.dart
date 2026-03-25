import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_info_entity.freezed.dart';
part 'app_info_entity.g.dart';

/// Entity representing application information
@freezed
sealed class AppInfoEntity with _$AppInfoEntity {

  /// Creates an app info entity with required parameters
  const factory AppInfoEntity({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
    String? buildSignature,
    String? installerStore,
  }) = _AppInfoEntity;

  /// Factory constructor from platform data
  factory AppInfoEntity.fromPlatformData({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
    String? buildSignature,
    String? installerStore,
  }) => AppInfoEntity(
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
        buildSignature: buildSignature,
        installerStore: installerStore,
      );

  /// Creates an AppInfoEntity from JSON
  factory AppInfoEntity.fromJson(Map<String, dynamic> json) => _$AppInfoEntityFromJson(json);
  const AppInfoEntity._();

  /// Full version display string
  String get fullVersion => '$version ($buildNumber)';
}
