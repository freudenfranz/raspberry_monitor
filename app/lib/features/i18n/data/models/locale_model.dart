import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/locale_entity.dart';

part 'locale_model.freezed.dart';
part 'locale_model.g.dart';

/// Data model for LocaleEntity with Freezed
@freezed
sealed class LocaleModel with _$LocaleModel {
  /// Creates a locale model from an entity
  const factory LocaleModel({
    required LocaleEntity entity,
  }) = _LocaleModel;

  const LocaleModel._();

  /// Factory constructor from JSON
  factory LocaleModel.fromJson(Map<String, dynamic> json) => _$LocaleModelFromJson(json);

  /// Factory constructor from entity
  factory LocaleModel.fromEntity(LocaleEntity entity) => LocaleModel(entity: entity);

  /// Convert to entity
  LocaleEntity toEntity() => entity;

  // Delegate properties to the entity
  /// The language code (e.g., 'en')
  String get languageCode => entity.languageCode;

  /// The country code (e.g., 'US')
  String? get countryCode => entity.countryCode;

  /// The display name in English
  String get displayName => entity.displayName;

  /// The native name in the language itself
  String get nativeName => entity.nativeName;

  /// Whether this is a right-to-left language
  bool get isRTL => entity.isRTL;

  /// The combined locale ID (e.g., 'en_US')
  String get localeId => entity.localeId;
}
