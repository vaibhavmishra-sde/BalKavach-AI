// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

    import 'package:provider/provider.dart';
    import 'package:balkavach/app.dart';
    import 'package:balkavach/providers/auth_provider.dart';
    import 'package:balkavach/providers/theme_provider.dart';

void main() {
      testWidgets('shows the login screen when signed out', (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: const BalKavachApp(),
          ),
        );

        expect(find.text('BalKavach'), findsOneWidget);
        expect(find.text('AI child security platform'), findsOneWidget);
        expect(find.text('Login'), findsOneWidget);
  });
}
