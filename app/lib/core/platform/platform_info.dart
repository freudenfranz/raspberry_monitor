import 'dart:io';

import 'package:flutter/foundation.dart';

/// Utility class for platform detection and information.
class PlatformInfo {
  /// Private constructor to prevent instantiation.
  const PlatformInfo._();

  /// Whether the current platform is iOS.
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Whether the current platform is Android.
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Whether the current platform is Web.
  static bool get isWeb => kIsWeb;

  /// Whether the current platform is macOS.
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Whether the current platform is Windows.
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Whether the current platform is Linux.
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Whether the current platform is a mobile platform (iOS or Android).
  static bool get isMobile => isIOS || isAndroid;

  /// Whether the current platform is a desktop platform.
  static bool get isDesktop => isMacOS || isWindows || isLinux;

  /// Returns the current platform name as a string.
  static String get platformName {
    if (kIsWeb) {
      return 'Web';
    }
    if (Platform.isIOS) {
      return 'iOS';
    }
    if (Platform.isAndroid) {
      return 'Android';
    }
    if (Platform.isMacOS) {
      return 'macOS';
    }
    if (Platform.isWindows) {
      return 'Windows';
    }
    if (Platform.isLinux) {
      return 'Linux';
    }
    return 'Unknown';
  }

  /// Returns the current operating system version.
  static String get operatingSystemVersion {
    if (kIsWeb) {
      return 'Web Platform';
    }
    return Platform.operatingSystemVersion;
  }
}
