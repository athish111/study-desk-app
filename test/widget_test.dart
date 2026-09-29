// Basic smoke test for StudyDesk app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_prototype/main.dart';   // ← matches your pubspec name

void main() {
  testWidgets('StudyDesk app launches and shows login screen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const StudyDeskApp());

    // Verify the login screen shows the welcome text.
    expect(find.text('Welcome Back!'), findsOneWidget);
  });
}