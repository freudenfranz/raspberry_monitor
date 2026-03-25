import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Meine App'**
  String get appTitle;

  /// No description provided for @loading.
  ///
  /// In de, this message translates to:
  /// **'Laden...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In de, this message translates to:
  /// **'Fehler'**
  String get error;

  /// No description provided for @success.
  ///
  /// In de, this message translates to:
  /// **'Erfolg'**
  String get success;

  /// No description provided for @cancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @close.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get close;

  /// No description provided for @back.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get back;

  /// No description provided for @next.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get previous;

  /// No description provided for @submit.
  ///
  /// In de, this message translates to:
  /// **'Senden'**
  String get submit;

  /// No description provided for @save.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get remove;

  /// No description provided for @retry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get retry;

  /// No description provided for @tryAgain.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get tryAgain;

  /// No description provided for @somethingWentWrong.
  ///
  /// In de, this message translates to:
  /// **'Etwas ist schief gelaufen'**
  String get somethingWentWrong;

  /// No description provided for @appFailedToStart.
  ///
  /// In de, this message translates to:
  /// **'App konnte nicht gestartet werden'**
  String get appFailedToStart;

  /// No description provided for @appFailedToStartMessage.
  ///
  /// In de, this message translates to:
  /// **'Während der Initialisierung ist ein Fehler aufgetreten. Bitte versuchen Sie, die App neu zu starten.'**
  String get appFailedToStartMessage;

  /// No description provided for @restartApp.
  ///
  /// In de, this message translates to:
  /// **'App neu starten'**
  String get restartApp;

  /// Willkommensnachricht auf der Startseite
  ///
  /// In de, this message translates to:
  /// **'Willkommen bei {appName}'**
  String welcomeMessage(String appName);

  /// No description provided for @chooseOption.
  ///
  /// In de, this message translates to:
  /// **'Wählen Sie eine Option zum Erkunden:'**
  String get chooseOption;

  /// No description provided for @designSystemShowcase.
  ///
  /// In de, this message translates to:
  /// **'Design-System-Präsentation'**
  String get designSystemShowcase;

  /// No description provided for @designSystemDescription.
  ///
  /// In de, this message translates to:
  /// **'Erkunden Sie die Design-System-Komponenten, Farben, Typografie und mehr.'**
  String get designSystemDescription;

  /// No description provided for @mqttShowcase.
  ///
  /// In de, this message translates to:
  /// **'Test MQTT'**
  String get mqttShowcase;

  /// No description provided for @mqttShowcaseDescription.
  ///
  /// In de, this message translates to:
  /// **'Sieh dir an wie du MQTT nutzen kannst'**
  String get mqttShowcaseDescription;

  /// No description provided for @appInformation.
  ///
  /// In de, this message translates to:
  /// **'App-Informationen'**
  String get appInformation;

  /// No description provided for @appInfoDescription.
  ///
  /// In de, this message translates to:
  /// **'Sehen Sie App-Version, Build-Informationen und andere Details.'**
  String get appInfoDescription;

  /// Willkommensnachricht auf der App-Info-Seite
  ///
  /// In de, this message translates to:
  /// **'Willkommen bei {appName}!'**
  String welcomeTitle(String appName);

  /// No description provided for @appInfoShortDescription.
  ///
  /// In de, this message translates to:
  /// **'Dies ist ein Flutter-Grundlagenprojekt, das mit Mason-Ziegeln erstellt wurde und den Clean-Architecture-Prinzipien folgt.'**
  String get appInfoShortDescription;

  /// No description provided for @applicationInformation.
  ///
  /// In de, this message translates to:
  /// **'Anwendungsinformationen'**
  String get applicationInformation;

  /// No description provided for @version.
  ///
  /// In de, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildSignature.
  ///
  /// In de, this message translates to:
  /// **'Build-Signatur'**
  String get buildSignature;

  /// No description provided for @installerStore.
  ///
  /// In de, this message translates to:
  /// **'Installer Store'**
  String get installerStore;

  /// No description provided for @loadingAppInfo.
  ///
  /// In de, this message translates to:
  /// **'App-Informationen werden geladen...'**
  String get loadingAppInfo;

  /// No description provided for @includedFeatures.
  ///
  /// In de, this message translates to:
  /// **'Enthaltene Funktionen'**
  String get includedFeatures;

  /// No description provided for @cleanArchitecture.
  ///
  /// In de, this message translates to:
  /// **'📱 Clean Architecture (ResoCoder-Muster)'**
  String get cleanArchitecture;

  /// No description provided for @designSystem.
  ///
  /// In de, this message translates to:
  /// **'🎨 benutzerdefiniertes Design-System mit Material 3'**
  String get designSystem;

  /// No description provided for @internationalization.
  ///
  /// In de, this message translates to:
  /// **'🌍 Internationalisierungsunterstützung (i18n)'**
  String get internationalization;

  /// No description provided for @dependencyInjection.
  ///
  /// In de, this message translates to:
  /// **'🔧 Dependency Injection mit GetIt'**
  String get dependencyInjection;

  /// No description provided for @stateManagement.
  ///
  /// In de, this message translates to:
  /// **'📦 State Management mit BLoC'**
  String get stateManagement;

  /// No description provided for @testStructure.
  ///
  /// In de, this message translates to:
  /// **'🧪 Umfassende Teststruktur'**
  String get testStructure;

  /// No description provided for @errorHandling.
  ///
  /// In de, this message translates to:
  /// **'🎯 Fehlerbehandlung mit Either-Muster'**
  String get errorHandling;

  /// No description provided for @localStorage.
  ///
  /// In de, this message translates to:
  /// **'💾 Lokale Speicherung mit SharedPreferences'**
  String get localStorage;

  /// No description provided for @languageSettings.
  ///
  /// In de, this message translates to:
  /// **'Spracheinstellungen'**
  String get languageSettings;

  /// No description provided for @language.
  ///
  /// In de, this message translates to:
  /// **'Sprache / Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In de, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @sampleButton.
  ///
  /// In de, this message translates to:
  /// **'Beispiel-Schaltfläche'**
  String get sampleButton;

  /// Display name for showcase category
  ///
  /// In de, this message translates to:
  /// **'{category}'**
  String categoryName(String category);

  /// No description provided for @telemetryStatus.
  ///
  /// In de, this message translates to:
  /// **'Status'**
  String get telemetryStatus;

  /// No description provided for @telemetryUptime.
  ///
  /// In de, this message translates to:
  /// **'Up time'**
  String get telemetryUptime;

  /// No description provided for @telemetryCpuTemp.
  ///
  /// In de, this message translates to:
  /// **'CPU Temperatur'**
  String get telemetryCpuTemp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
