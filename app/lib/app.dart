import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:raspberry_monitor/app_router.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

import 'core/core.dart';
import 'features/i18n/presentation/bloc/locale_bloc.dart';
import 'injection.dart';

/// The main application widget with async initialization support.
///
/// This widget handles:
/// - Async app initialization
/// - Loading states during startup
/// - Error handling for initialization failures
/// - Minimum loading duration for smooth UX
class App extends StatelessWidget {
  /// Creates the main app widget.
  const App({
    required this.setupFuture,
    super.key,
    this.minimumLoadingDuration = const Duration(milliseconds: 1000),
  });

  /// Future that completes when app initialization is done.
  final Future<void> setupFuture;

  /// Minimum duration to show loading screen for smooth UX.
  final Duration minimumLoadingDuration;

  @override
  Widget build(BuildContext context) => FutureBuilder<void>(
    future: Future.wait([
      setupFuture,
      Future<void>.delayed(minimumLoadingDuration),
    ]),
    builder: (context, snapshot) {
      // Show loading screen during initialization
      if (snapshot.connectionState != ConnectionState.done) {
        return const AppLoadingPage();
      }

      // Show error screen if initialization failed
      if (snapshot.hasError) {
        return InitErrorPage(
          error: snapshot.error,
          stackTrace: snapshot.stackTrace,
        );
      }

      // App is ready - show main app
      return const _MainApp();
    },
  );
}

/// The main application widget once initialization is complete.
class _MainApp extends StatelessWidget {
  const _MainApp();

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt<LocaleBloc>()..add(const LoadCurrentLocale()),
        child: BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, state) {
            Locale locale = const Locale('en');

            if (state is LocaleLoaded) {
              locale = Locale(
                state.currentLocale.languageCode,
                state.currentLocale.countryCode,
              );
            }

            return MaterialApp.router(
              title: 'raspberry_monitor',
              debugShowCheckedModeBanner: false,

              // Theme configuration
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),

              // Localization configuration
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,

              // Routing configuration
              routerConfig: router,
            );
          },
        ),
      );
}
