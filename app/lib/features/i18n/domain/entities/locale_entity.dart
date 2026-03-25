import 'package:freezed_annotation/freezed_annotation.dart';

part 'locale_entity.freezed.dart';
part 'locale_entity.g.dart';

/// Entity representing a locale/language configuration
@freezed
sealed class LocaleEntity with _$LocaleEntity {

  /// Creates a locale entity with required parameters
  const factory LocaleEntity({
    required String languageCode,
    required String displayName,
    required String nativeName,
    String? countryCode,
    @Default(false) bool isRTL,
  }) = _LocaleEntity;

  /// Creates a LocaleEntity from JSON
  factory LocaleEntity.fromJson(Map<String, dynamic> json) => _$LocaleEntityFromJson(json);
  const LocaleEntity._();

  /// Returns the locale identifier (e.g., 'en_US', 'de_DE')
  String get localeId {
    if (countryCode != null) {
      return '${languageCode}_$countryCode';
    }
    return languageCode;
  }
}
