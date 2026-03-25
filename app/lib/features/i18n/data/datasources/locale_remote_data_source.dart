import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../domain/entities/locale_entity.dart';
import '../models/locale_model.dart';

/// Abstract data source interface for system locale
// ignore: one_member_abstracts
abstract class LocaleRemoteDataSource {
  /// Get the system locale from the device
  Future<LocaleModel> getSystemLocale();
}

/// Implementation of LocaleRemoteDataSource using platform methods
@LazySingleton(as: LocaleRemoteDataSource)
class LocaleRemoteDataSourceImpl implements LocaleRemoteDataSource {
  /// Creates a system locale data source
  const LocaleRemoteDataSourceImpl();

  @override
  /// Get the system locale from the device using platform methods
  Future<LocaleModel> getSystemLocale() async {
    try {
      // Get the system locale from the platform
      final systemLocale = Platform.localeName;
      final parts = systemLocale.split('_');

      final languageCode = parts.isNotEmpty ? parts[0] : 'en';
      final countryCode = parts.length > 1 ? parts[1] : null;

      // Create a locale model from system data
      return LocaleModel(
        entity: LocaleEntity(
          languageCode: languageCode,
          countryCode: countryCode,
          displayName: _getDisplayName(languageCode, countryCode),
          nativeName: _getNativeName(languageCode),
        ),
      );
    } on Exception {
      // Fallback to default English locale if system locale detection fails
      return const LocaleModel(
        entity: LocaleEntity(
          languageCode: 'en',
          countryCode: 'US',
          displayName: 'English (United States)',
          nativeName: 'English',
        ),
      );

    }
  }

  /// Get display name for locale
  String _getDisplayName(String languageCode, String? countryCode) {
    switch (languageCode) {
      case 'en':
        return countryCode == 'GB' ? 'English (United Kingdom)' : 'English (United States)';
      case 'de':
        return 'German (Germany)';
      case 'es':
        return 'Spanish (Spain)';
      case 'fr':
        return 'French (France)';
      default:
        return 'Unknown';
    }
  }

  /// Get native name for language
  String _getNativeName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return 'Unknown';
    }
  }
}
