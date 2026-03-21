import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raspberry_monitor/app.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App starts and displays correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(App(setupFuture: Future.value()));

      // Wait for async initialization
      await tester.pumpAndSettle();

      // Verify that the app starts without crashing
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('MaterialApp has correct title', (WidgetTester tester) async {
      await tester.pumpWidget(App(setupFuture: Future.value()));

      // Wait for async initialization
      await tester.pumpAndSettle();

      final MaterialApp materialApp = tester.widget(find.byType(MaterialApp));
      expect(materialApp.title, 'raspberry_monitor');
    });

    testWidgets('App uses Material3', (WidgetTester tester) async {
      await tester.pumpWidget(App(setupFuture: Future.value()));

      // Wait for async initialization
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.useMaterial3, isTrue);
    });
  });
}
