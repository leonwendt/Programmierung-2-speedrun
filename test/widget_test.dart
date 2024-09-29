// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:programmierung_2/main.dart';

void main() {
  testWidgets('Currency Converter app test', (WidgetTester tester) async {
    // Widget erstellen
    await tester.pumpWidget(const CurrencyConverterApp()); // Ändere MyApp zu CurrencyConverterApp

    // Hier kannst du deine Tests durchführen, z.B. auf Widgets prüfen
    expect(find.byType(TextField), findsNWidgets(2)); // Beispiel-Assertion
  });
}
