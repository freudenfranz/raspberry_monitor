import 'dart:io';

/// Utility mixin for getting platform-specific information
mixin DeviceInfo {
  /// Returns true if running on Android
  static bool get isAndroid => Platform.isAndroid;

  /// Returns true if running on iOS
  static bool get isIOS => Platform.isIOS;

  /// Returns true if running on web
  static bool get isWeb => Platform.environment.containsKey('FLUTTER_TEST');

  /// Returns true if running on desktop (Windows, macOS, Linux)
  static bool get isDesktop => Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// Returns true if running on mobile (Android or iOS)
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Returns the current platform name
  static String get platformName {
    if (Platform.isAndroid) {
      return 'Android';
    }
    if (Platform.isIOS) {
      return 'iOS';
    }
    if (Platform.isWindows) {
      return 'Windows';
    }
    if (Platform.isMacOS) {
      return 'macOS';
    }
    if (Platform.isLinux) {
      return 'Linux';
    }
    return 'Unknown';
  }
}
