/// App-wide constants used throughout the application
class AppConstants {
  // Storage keys
  /// Storage key for user's selected locale preference
  static const String localeStorageKey = 'app_locale';
  /// Storage key for user's selected theme preference
  static const String themeStorageKey = 'app_theme';
  /// Cache key for app info data
  static const String appInfoCacheKey = 'app_info_cache';

  // Network
  /// Network connection timeout in milliseconds
  static const int connectionTimeout = 30000;
  /// Network receive timeout in milliseconds
  static const int receiveTimeout = 30000;

  // Cache
  /// Maximum cache age in milliseconds (24 hours)
  static const int cacheMaxAge = 86400000; // 24 hours in milliseconds

  // Retry
  /// Maximum number of retry attempts for failed operations
  static const int maxRetryAttempts = 3;
  /// Delay between retry attempts in milliseconds
  static const int retryDelay = 1000; // milliseconds

  // Error messages
  /// Standard server failure message
  static const String serverFailureMessage = 'Server Failure';
  /// Standard cache failure message
  static const String cacheFailureMessage = 'Cache Failure';
  /// Standard network failure message
  static const String networkFailureMessage = 'Network Failure';
  /// Standard invalid input failure message
  static const String invalidInputFailureMessage = 'Invalid Input - Please check your input and try again';

  // Success messages
  /// Standard data update success message
  static const String dataUpdatedMessage = 'Data updated successfully';
  /// Standard settings save success message
  static const String settingsSavedMessage = 'Settings saved successfully';
}
