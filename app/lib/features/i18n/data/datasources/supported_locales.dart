import '../../domain/entities/locale_entity.dart';

/// Pre-configured locale entities for common locales
class SupportedLocales {
  SupportedLocales._();

  /// List of all supported locales
  static List<LocaleEntity> get all => [
        english,
        german, // Both languages available, default determined by base_language
      ];

  /// English locale configuration
  static const LocaleEntity english = LocaleEntity(
    languageCode: 'en',
    countryCode: 'US',
    displayName: 'English (United States)',
    nativeName: 'English',
  );

  /// German locale configuration
  static const LocaleEntity german = LocaleEntity(
    languageCode: 'de',
    countryCode: 'DE',
    displayName: 'German (Germany)',
    nativeName: 'Deutsch',
  );

  /// Get locale by language code
  static LocaleEntity? getByLanguageCode(String languageCode) {
    try {
      return all.firstWhere(
        (locale) => locale.languageCode == languageCode,
      );
    } on Exception {
      return null;
    }
  }

  /// Get the default locale based on base_language configuration
  static LocaleEntity get defaultLocale => 'en' == 'de' ? german : english;
}
