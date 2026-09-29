import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/features/auth/presentation/phone_login_screen.dart';

void main() {
  group('Auth UI Tests', () {
    testWidgets('PhoneLoginScreen displays elements and validates empty input', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PhoneLoginScreen(),
          ),
        ),
      );

      // Verify title and input exist
      expect(find.text('GaamHaul'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);

      // Tap continue without entering phone number
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Expect validation error
      expect(find.text('Enter a phone number'), findsOneWidget);
    });

    testWidgets('PhoneLoginScreen validates length', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: PhoneLoginScreen(),
          ),
        ),
      );

      // Enter short number
      await tester.enterText(find.byType(TextFormField), '12345');
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Expect validation error
      expect(find.text('Enter a valid 10-digit number'), findsOneWidget);
    });
  });
}
