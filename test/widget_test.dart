// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:call_log_exporter/main.dart';
import 'package:call_log_exporter/providers/call_log_provider.dart';

void main() {
  testWidgets('Call Log Exporter smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CallLogProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that our app title is displayed.
    expect(find.text('Call Log Exporter'), findsOneWidget);

    // Verify that load button exists.
    expect(find.text('Load Call Logs'), findsOneWidget);

    // Verify that export button exists.
    expect(find.text('Export CSV'), findsOneWidget);

    // Verify that share button exists.
    expect(find.text('Share File'), findsOneWidget);
  });
}
