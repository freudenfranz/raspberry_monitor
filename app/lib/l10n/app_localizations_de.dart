// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Meine App';

  @override
  String get loading => 'Laden...';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Schließen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get previous => 'Zurück';

  @override
  String get submit => 'Senden';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get remove => 'Entfernen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get somethingWentWrong => 'Etwas ist schief gelaufen';

  @override
  String get appFailedToStart => 'App konnte nicht gestartet werden';

  @override
  String get appFailedToStartMessage =>
      'Während der Initialisierung ist ein Fehler aufgetreten. Bitte versuchen Sie, die App neu zu starten.';

  @override
  String get restartApp => 'App neu starten';

  @override
  String welcomeMessage(String appName) {
    return 'Willkommen bei $appName';
  }

  @override
  String get chooseOption => 'Wählen Sie eine Option zum Erkunden:';

  @override
  String get designSystemShowcase => 'Design-System-Präsentation';

  @override
  String get designSystemDescription =>
      'Erkunden Sie die Design-System-Komponenten, Farben, Typografie und mehr.';

  @override
  String get mqttShowcase => 'Test MQTT';

  @override
  String get mqttShowcaseDescription => 'Sieh dir an wie du MQTT nutzen kannst';

  @override
  String get appInformation => 'App-Informationen';

  @override
  String get appInfoDescription =>
      'Sehen Sie App-Version, Build-Informationen und andere Details.';

  @override
  String welcomeTitle(String appName) {
    return 'Willkommen bei $appName!';
  }

  @override
  String get appInfoShortDescription =>
      'Dies ist ein Flutter-Grundlagenprojekt, das mit Mason-Ziegeln erstellt wurde und den Clean-Architecture-Prinzipien folgt.';

  @override
  String get applicationInformation => 'Anwendungsinformationen';

  @override
  String get version => 'Version';

  @override
  String get buildSignature => 'Build-Signatur';

  @override
  String get installerStore => 'Installer Store';

  @override
  String get loadingAppInfo => 'App-Informationen werden geladen...';

  @override
  String get includedFeatures => 'Enthaltene Funktionen';

  @override
  String get cleanArchitecture => '📱 Clean Architecture (ResoCoder-Muster)';

  @override
  String get designSystem =>
      '🎨 benutzerdefiniertes Design-System mit Material 3';

  @override
  String get internationalization =>
      '🌍 Internationalisierungsunterstützung (i18n)';

  @override
  String get dependencyInjection => '🔧 Dependency Injection mit GetIt';

  @override
  String get stateManagement => '📦 State Management mit BLoC';

  @override
  String get testStructure => '🧪 Umfassende Teststruktur';

  @override
  String get errorHandling => '🎯 Fehlerbehandlung mit Either-Muster';

  @override
  String get localStorage => '💾 Lokale Speicherung mit SharedPreferences';

  @override
  String get languageSettings => 'Spracheinstellungen';

  @override
  String get language => 'Sprache / Language';

  @override
  String get english => 'English';

  @override
  String get german => 'Deutsch';

  @override
  String get sampleButton => 'Beispiel-Schaltfläche';

  @override
  String categoryName(String category) {
    return '$category';
  }

  @override
  String get telemetryStatus => 'Status';

  @override
  String get telemetryUptime => 'Up time';

  @override
  String get telemetryCpuTemp => 'CPU Temperatur';
}
