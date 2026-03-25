import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/locale_entity.dart';
import '../models/locale_model.dart';

/// Abstract data source interface for locale persistence
abstract class LocaleLocalDataSource {
  /// Get the cached locale from local storage
  Future<LocaleModel?> getCachedLocale();

  /// Cache the locale to local storage
  Future<void> cacheLocale(LocaleEntity localeEntity);

  /// Clear cached locale
  Future<void> clearCache();
}

/// Implementation of LocaleLocalDataSource using SharedPreferences
@LazySingleton(as: LocaleLocalDataSource)
class LocaleLocalDataSourceImpl implements LocaleLocalDataSource {
  /// Creates a locale local data source with shared preferences
  LocaleLocalDataSourceImpl({required this.sharedPreferences});

  /// Shared preferences instance for data persistence
  final SharedPreferences sharedPreferences;

  /// Key for cached locale storage
  static const String _cachedLocaleKey = 'CACHED_LOCALE';

  @override
  Future<LocaleModel?> getCachedLocale() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedLocaleKey);
      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        // Create entity from JSON and wrap in model
        final entity = LocaleEntity.fromJson(json);
        return LocaleModel.fromEntity(entity);
      }
      return null;
    } on Exception {
      return null;
    }
  }

  @override
  Future<void> cacheLocale(LocaleEntity localeEntity) async {
    final jsonString = jsonEncode(localeEntity.toJson());
    await sharedPreferences.setString(_cachedLocaleKey, jsonString);
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedLocaleKey);
  }
}
