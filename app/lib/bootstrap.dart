import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/core.dart';
import 'injection.dart';

/// Bootstraps the application with the given [environment].
void bootstrap({  required Env environment}) {
  // Set up global error handling
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  // Set up BLoC observer for debugging and monitoring
  Bloc.observer =  AppBlocObserver();

  // Run app in error zone
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // Run the app with async initialization
      runApp(
        App(
          setupFuture: _setupApp(environment: environment),
          minimumLoadingDuration: const Duration(milliseconds: 1500),
        ),
      );
    },
    (exception, stackTrace) async {
      log(exception.toString(), stackTrace: stackTrace);
      // Show error page for unhandled exceptions
      runApp(const MaterialApp(home: InitErrorPage()));
    },
  );
}

/// Sets up the application dependencies and configuration.
Future<void> _setupApp({
  required Env environment,
}) async {
  // Initialize dependency injection
  await configureInjection(environment);

  // Configure system UI
  _setupSystemUI();

  // Set device orientations
  _setupOrientation();

  // Pre-warm SharedPreferences
  await _setupStorage();
}

/// Configures system UI appearance and behavior.
void _setupSystemUI() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ),
  );

  // Enable edge-to-edge display
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top,
    ],
  );
}

/// Sets preferred device orientations.
void _setupOrientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

/// Pre-initializes storage services.
Future<void> _setupStorage() async {
  // Ensure SharedPreferences is ready
  await SharedPreferences.getInstance();
}
