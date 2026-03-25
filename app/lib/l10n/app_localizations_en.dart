// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My App';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Back';

  @override
  String get submit => 'Submit';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get retry => 'Retry';

  @override
  String get tryAgain => 'Try again';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get appFailedToStart => 'App failed to start';

  @override
  String get appFailedToStartMessage =>
      'An error occurred during initialization. Please try restarting the app.';

  @override
  String get restartApp => 'Restart app';

  @override
  String welcomeMessage(String appName) {
    return 'Welcome to $appName';
  }

  @override
  String get chooseOption => 'Choose an option to explore:';

  @override
  String get designSystemShowcase => 'Design System Showcase';

  @override
  String get designSystemDescription =>
      'Explore the design system components, colors, typography, and more.';

  @override
  String get mqttShowcase => 'Test MQTT';

  @override
  String get mqttShowcaseDescription => 'Explore how to use MQTT';

  @override
  String get appInformation => 'App Information';

  @override
  String get appInfoDescription =>
      'View app version, build information, and other details.';

  @override
  String welcomeTitle(String appName) {
    return 'Welcome to $appName!';
  }

  @override
  String get appInfoShortDescription =>
      'This is a Flutter fundamentals project created with Mason bricks and following Clean Architecture principles.';

  @override
  String get applicationInformation => 'Application Information';

  @override
  String get version => 'Version';

  @override
  String get buildSignature => 'Build Signature';

  @override
  String get installerStore => 'Installer Store';

  @override
  String get loadingAppInfo => 'Loading app information...';

  @override
  String get includedFeatures => 'Included Features';

  @override
  String get cleanArchitecture => '📱 Clean Architecture (ResoCoder pattern)';

  @override
  String get designSystem => '🎨 Custom design system with Material 3';

  @override
  String get internationalization => '🌍 Internationalization support (i18n)';

  @override
  String get dependencyInjection => '🔧 Dependency Injection with GetIt';

  @override
  String get stateManagement => '📦 State management with BLoC';

  @override
  String get testStructure => '🧪 Comprehensive test structure';

  @override
  String get errorHandling => '🎯 Error handling with Either pattern';

  @override
  String get localStorage => '💾 Local storage with SharedPreferences';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get language => 'Language / Sprache';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get sampleButton => 'Sample Button';

  @override
  String categoryName(String category) {
    return '$category';
  }

  @override
  String get telemetryStatus => 'Status';

  @override
  String get telemetryUptime => 'Up time';

  @override
  String get telemetryCpuTemp => 'CPU Temperature';
}
