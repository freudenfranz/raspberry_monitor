import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_info_entity.dart';

part 'app_info_model.freezed.dart';
part 'app_info_model.g.dart';

/// Data model for AppInfoEntity with Freezed
/// Handles serialization/deserialization and platform data conversion
@freezed
sealed class AppInfoModel with _$AppInfoModel {
  /// Creates an app info model from an entity
  const factory AppInfoModel({
    required AppInfoEntity entity,
  }) = _AppInfoModel;

  const AppInfoModel._();

  /// Factory constructor from JSON
  factory AppInfoModel.fromJson(Map<String, dynamic> json) => _$AppInfoModelFromJson(json);

  /// Factory constructor from platform data
  factory AppInfoModel.fromPlatformData({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
    String? buildSignature,
    String? installerStore,
  }) => AppInfoModel(
      entity: AppInfoEntity.fromPlatformData(
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
        buildSignature: buildSignature,
        installerStore: installerStore,
      ),
    );

  /// Convert to entity
  AppInfoEntity toEntity() => entity;
}
