import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adnabbit/main.dart';

void main() {
  testWidgets('AdNabbit app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AdNabbitApp());

    // Verify that the login screen loads
    expect(find.text('Welcome to AdNabbit'), findsOneWidget);
  });
}