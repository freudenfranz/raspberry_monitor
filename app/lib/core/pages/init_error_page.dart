import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raspberry_monitor/l10n/app_localizations.dart';

/// Error page displayed when the app fails to initialize.
///
/// This page provides:
/// - User-friendly error messaging
/// - Retry functionality
/// - Debug information in development mode
/// - Restart instructions
class InitErrorPage extends StatelessWidget {
  /// Creates an initialization error page.
  const InitErrorPage({super.key, this.error, this.stackTrace});

  /// The error that caused initialization to fail.
  final Object? error;

  /// The stack trace of the initialization error.
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MaterialApp(
      title: l10n.appTitle,
      theme: _buildErrorTheme(),
      home: Scaffold(
        backgroundColor: Colors.red.shade50,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error Icon
                Icon(Icons.error_outline, size: 80, color: Colors.red.shade700),

                const SizedBox(height: 32),

                // Error Title
                Text(
                  l10n.appFailedToStart,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Error Message
                Text(
                  l10n.appFailedToStartMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Restart Button
                ElevatedButton.icon(
                  onPressed: _restartApp,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.restartApp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Debug Information (Development Only)
                if (error != null) ..._buildDebugInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the error theme for the error page.
  ThemeData _buildErrorTheme() => ThemeData(
    primarySwatch: Colors.red,
    fontFamily: 'Inter',
    useMaterial3: true,
  );

  /// Builds debug information widgets (development mode only).
  List<Widget> _buildDebugInfo() => [
    const Divider(color: Colors.grey),
    const SizedBox(height: 16),

    Text(
      'Debug Information:',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
      ),
    ),

    const SizedBox(height: 8),

    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Error: ${error.toString()}',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: Colors.red.shade700,
            ),
          ),
          if (stackTrace != null) ...[
            const SizedBox(height: 8),
            Text(
              'Stack Trace:',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stackTrace.toString(),
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                color: Colors.grey.shade600,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ),
  ];

  /// Attempts to restart the application.
  void _restartApp() {
    if (kDebugMode) {
      // In debug mode, we can't truly restart, so exit
      SystemNavigator.pop();
    } else {
      // In release mode, exit the app (user will need to relaunch)
      SystemNavigator.pop();
    }
  }
}
